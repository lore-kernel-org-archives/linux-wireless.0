Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:44194 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZFHTQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 15:16:36 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 1/3] Staging: stlc45xx: sync with gitorious git tree
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Jun 2009 22:09:01 +0300
Message-ID: <20090608190901.25081.26264.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Sync up with stlc45xx repository in gitorious.org from commit
bb8675d6e59c34b43618970d37d56d724a5e3d96.

Kalle Valo (17):
      Add mac80211 hw power save flags
      Remove power save code from stlc45xx
      Use changed flag for power save
      Fix warnings in stlc45xx_tx_psm()
      Remove stlc45xx_tx_pspoll() and stlc45xx_tx_nullfunc()
      Implement add/remove interface properly
      Implement tx rate handling properly
      implement tx rate feedback
      Remove commented out debug levels
      Use parenthesis in debug level
      Remove MAC2STR()
      Cancel all workqueues in stop()
      Add short preamble, rts/cts and cts-to-self support
      Report correct rate and preamble status in rx path
      stlc45xx: add beacon filtering support
      Add short slot support

Max Filippov (6):
      Add hardware TSF into rx_status, required for IBSS merging.
      Extract common data-tx code into separate function
      Use different queues and flags for data/management frames.
      Introduce frames with unlimited lifetime in tx buffer.
      Introduce cached beacon.
      Introduce current interface mode.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/staging/stlc45xx/stlc45xx.c |  736 ++++++++++++++++++-----------------
 drivers/staging/stlc45xx/stlc45xx.h |   19 -
 2 files changed, 380 insertions(+), 375 deletions(-)

diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index cfdaac9..172eb54 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -413,8 +413,6 @@ static void stlc45xx_tx_edcf(struct stlc45xx *stlc);
 static void stlc45xx_tx_setup(struct stlc45xx *stlc);
 static void stlc45xx_tx_scan(struct stlc45xx *stlc);
 static void stlc45xx_tx_psm(struct stlc45xx *stlc, bool enable);
-static int stlc45xx_tx_nullfunc(struct stlc45xx *stlc, bool powersave);
-static int stlc45xx_tx_pspoll(struct stlc45xx *stlc, bool powersave);
 
 static ssize_t stlc45xx_sysfs_show_cal_rssi(struct device *dev,
 					    struct device_attribute *attr,
@@ -950,21 +948,28 @@ static int stlc45xx_upload_firmware(struct stlc45xx *stlc)
 }
 
 /* caller must hold tx_lock */
-static void stlc45xx_check_txsent(struct stlc45xx *stlc)
+static int stlc45xx_check_txsent(struct stlc45xx *stlc)
 {
+	int n_mortal = 0;
 	struct txbuffer *entry, *n;
 
 	list_for_each_entry_safe(entry, n, &stlc->tx_sent, tx_list) {
-		if (time_after(jiffies, entry->lifetime)) {
-			if (net_ratelimit())
-				stlc45xx_warning("frame 0x%x lifetime exceeded",
-						 entry->start);
-			list_del(&entry->tx_list);
-			skb_pull(entry->skb, entry->header_len);
-			ieee80211_tx_status(stlc->hw, entry->skb);
-			stlc45xx_txbuffer_free(stlc, entry);
+		if (entry->lifetime) {
+			if (time_after(jiffies, entry->lifetime)) {
+				if (net_ratelimit())
+					stlc45xx_warning("frame 0x%x lifetime exceeded",
+							 entry->start);
+				list_del(&entry->tx_list);
+				if (entry->status_needed) {
+					skb_pull(entry->skb, entry->header_len);
+					ieee80211_tx_status(stlc->hw, entry->skb);
+				}
+				stlc45xx_txbuffer_free(stlc, entry);
+			} else
+				++n_mortal;
 		}
 	}
+	return n_mortal;
 }
 
 static void stlc45xx_power_off(struct stlc45xx *stlc)
@@ -998,6 +1003,8 @@ static void stlc45xx_flush_queues(struct stlc45xx *stlc)
 		stlc45xx_txbuffer_free(stlc, entry);
 	}
 
+	stlc->cached_beacon = NULL;
+
 	WARN_ON(!list_empty(&stlc->tx_sent));
 
 	while (!list_empty(&stlc->tx_pending)) {
@@ -1147,11 +1154,12 @@ static void stlc45xx_int_ready(struct stlc45xx *stlc)
 
 static int stlc45xx_rx_txack(struct stlc45xx *stlc, struct sk_buff *skb)
 {
+	struct ieee80211_tx_rate *tx_rate;
 	struct ieee80211_tx_info *info;
 	struct s_lm_control *control;
 	struct s_lmo_tx *tx;
 	struct txbuffer *entry;
-	int found = 0;
+	int found = 0, tries, i;
 
 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
 
@@ -1183,11 +1191,45 @@ static int stlc45xx_rx_txack(struct stlc45xx *stlc, struct sk_buff *skb)
 
 	if (entry->status_needed) {
 		info = IEEE80211_SKB_CB(entry->skb);
-
-		if (!(tx->flags & LM_TX_FAILED)) {
+		
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
+		    !(tx->flags & LM_TX_FAILED)) {
 			/* frame was acked */
 			info->flags |= IEEE80211_TX_STAT_ACK;
-			info->status.ack_signal = tx->rcpi / 2 - 110;
+		}
+		info->status.ack_signal = tx->rcpi / 2 - 110;
+
+		/*
+		 * tx->retries is actually the number of transmissions, not
+		 * the number of retries. For example, with one successful
+		 * tranmission without no retranmission on the air
+		 * tx->retries would contain value one. Better name would
+		 * transmissions or tries. Praise for the logical
+		 * terminology (not).
+		 */
+		tries = tx->retries;
+
+		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+			tx_rate = &info->control.rates[i];
+
+			if (tx_rate->idx < 0)
+				break;
+
+			if (tries == 0) {
+				tx_rate->idx = -1;
+				tx_rate->count = 0;
+				continue;
+			}
+			
+			if (tries > tx_rate->count)
+				tries -= tx_rate->count;
+			else if (tries == tx_rate->count) {
+				tx_rate->count = tries;
+				tries = 0;
+			} else {
+				tx_rate->count = tries;
+				tries = 0;
+			}
 		}
 
 		skb_pull(entry->skb, entry->header_len);
@@ -1197,10 +1239,12 @@ static int stlc45xx_rx_txack(struct stlc45xx *stlc, struct sk_buff *skb)
 
 	list_del(&entry->tx_list);
 
-	stlc45xx_check_txsent(stlc);
-	if (list_empty(&stlc->tx_sent))
-		/* there are no pending frames, we can stop the tx timeout
-		 * timer */
+	if (entry == stlc->cached_beacon)
+		stlc->cached_beacon = NULL;
+
+	if (0 == stlc45xx_check_txsent(stlc))
+		/* there are no pending frames with limited lifetime,
+		 * we can stop the tx timeout timer */
 		cancel_delayed_work(&stlc->work_tx_timeout);
 
 	spin_lock_bh(&stlc->tx_lock);
@@ -1219,6 +1263,28 @@ static int stlc45xx_rx_txack(struct stlc45xx *stlc, struct sk_buff *skb)
 	return 0;
 }
 
+static int stlc45xx_rx_trap(struct stlc45xx *stlc, struct sk_buff *skb)
+{
+	struct s_lm_control *control;
+	struct s_lmo_trap *trap;
+
+	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+
+	control = (struct s_lm_control *) skb->data;
+	trap = (struct s_lmo_trap *) (control + 1);
+
+	switch (trap->event) {
+	case LM_TRAP_NO_BEACON:
+		ieee80211_beacon_loss(stlc->vif);
+		break;
+	default:
+		stlc45xx_warning("unhandled trap: %d\n", trap->event);
+		break;
+	}
+	
+	return 0;
+}
+
 static int stlc45xx_rx_control(struct stlc45xx *stlc, struct sk_buff *skb)
 {
 	struct s_lm_control *control;
@@ -1232,9 +1298,11 @@ static int stlc45xx_rx_control(struct stlc45xx *stlc, struct sk_buff *skb)
 	case LM_OID_TX:
 		ret = stlc45xx_rx_txack(stlc, skb);
 		break;
+	case LM_OID_TRAP:
+		ret = stlc45xx_rx_trap(stlc, skb);
+		break;
 	case LM_OID_SETUP:
 	case LM_OID_SCAN:
-	case LM_OID_TRAP:
 	case LM_OID_EDCF:
 	case LM_OID_KEYCACHE:
 	case LM_OID_PSM:
@@ -1251,133 +1319,6 @@ static int stlc45xx_rx_control(struct stlc45xx *stlc, struct sk_buff *skb)
 	return ret;
 }
 
-/* copied from mac80211 */
-static void stlc45xx_parse_elems(u8 *start, size_t len,
-				 struct stlc45xx_ie_tim **tim,
-				 size_t *tim_len)
-{
-	size_t left = len;
-	u8 *pos = start;
-
-	while (left >= 2) {
-		u8 id, elen;
-
-		id = *pos++;
-		elen = *pos++;
-		left -= 2;
-
-		if (elen > left)
-			return;
-
-		switch (id) {
-		case WLAN_EID_TIM:
-			*tim = (struct stlc45xx_ie_tim *) pos;
-			*tim_len = elen;
-			break;
-		default:
-			break;
-		}
-
-		left -= elen;
-		pos += elen;
-	}
-}
-
-/*
- * mac80211 doesn't have support for asking frames with PS-Poll, so let's
- * implement in the driver for now. We have to add support to mac80211
- * later.
- */
-static int stlc45xx_check_more_data(struct stlc45xx *stlc, struct sk_buff *skb)
-{
-	struct s_lm_data_in *data = (struct s_lm_data_in *) skb->data;
-	struct ieee80211_hdr *hdr;
-	size_t len;
-	u16 fc;
-
-	hdr = (void *) skb->data + sizeof(*data);
-	len = skb->len - sizeof(*data);
-
-	/* minimum frame length is the null frame length 24 bytes */
-	if (len < 24) {
-		stlc45xx_warning("invalid frame length when checking for "
-				 "more data");
-		return -EINVAL;
-	}
-
-	fc = le16_to_cpu(hdr->frame_control);
-	if (!(fc & IEEE80211_FCTL_FROMDS))
-		/* this is not from DS */
-		return 0;
-
-	if (compare_ether_addr(hdr->addr1, stlc->mac_addr) != 0)
-		/* the frame was not for us */
-		return 0;
-
-	if (!(fc & IEEE80211_FCTL_MOREDATA)) {
-		/* AP has no more frames buffered for us */
-		stlc45xx_debug(DEBUG_PSM, "all buffered frames retrieved");
-		stlc->pspolling = false;
-		return 0;
-	}
-
-	/* MOREDATA bit is set, let's ask for a new frame from the AP */
-	stlc45xx_tx_pspoll(stlc, stlc->psm);
-
-	return 0;
-}
-
-/*
- * mac80211 cannot read TIM from beacons, so let's add a hack to the
- * driver. We have to add support to mac80211 later.
- */
-static int stlc45xx_rx_data_beacon(struct stlc45xx *stlc, struct sk_buff *skb)
-{
-	struct s_lm_data_in *data = (struct s_lm_data_in *) skb->data;
-	size_t len = skb->len, tim_len = 0, baselen, pvbmap_len;
-	struct ieee80211_mgmt *mgmt;
-	struct stlc45xx_ie_tim *tim = NULL;
-	int bmap_offset, index, aid_bit;
-
-	mgmt = (void *) skb->data + sizeof(*data);
-
-	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
-	if (baselen > len) {
-		stlc45xx_warning("invalid baselen in beacon");
-		return -EINVAL;
-	}
-
-	stlc45xx_parse_elems(mgmt->u.beacon.variable, len - baselen, &tim,
-			     &tim_len);
-
-	if (!tim) {
-		stlc45xx_warning("didn't find tim from a beacon");
-		return -EINVAL;
-	}
-
-	bmap_offset = tim->bmap_control & 0xfe;
-	index = stlc->aid / 8 - bmap_offset;
-
-	pvbmap_len = tim_len - 3;
-	if (index > pvbmap_len)
-		return -EINVAL;
-
-	aid_bit = !!(tim->pvbmap[index] & (1 << stlc->aid % 8));
-
-	stlc45xx_debug(DEBUG_PSM, "fc 0x%x duration %d seq %d dtim %u "
-		       "bmap_control 0x%x aid_bit %d",
-		       mgmt->frame_control, mgmt->duration, mgmt->seq_ctrl >> 4,
-		       tim->dtim_count, tim->bmap_control, aid_bit);
-
-	if (!aid_bit)
-		return 0;
-
-	stlc->pspolling = true;
-	stlc45xx_tx_pspoll(stlc, stlc->psm);
-
-	return 0;
-}
-
 static int stlc45xx_rx_data(struct stlc45xx *stlc, struct sk_buff *skb)
 {
 	struct ieee80211_rx_status status;
@@ -1388,15 +1329,18 @@ static int stlc45xx_rx_data(struct stlc45xx *stlc, struct sk_buff *skb)
 
 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
 
-	if (stlc->psm) {
-		if (data->flags & LM_IN_BEACON)
-			stlc45xx_rx_data_beacon(stlc, skb);
-		else if (stlc->pspolling && (data->flags & LM_IN_DATA))
-			stlc45xx_check_more_data(stlc, skb);
-	}
-
 	memset(&status, 0, sizeof(status));
 
+	if (!(data->flags & LM_IN_FCS_GOOD))
+		status.flag |= RX_FLAG_FAILED_FCS_CRC;
+	/*
+	 * FIXME: mactime wants TSF at the beginning of frame,
+	 * clock is TSF at the end of frame
+	 */
+	stlc45xx_debug(DEBUG_FUNC, "data->clock: %08x:%08x",
+		data->clock[1], data->clock[0]);
+	memcpy(&status.mactime, data->clock, sizeof(status.mactime));
+	status.flag |= RX_FLAG_TSFT;
 	status.freq = data->frequency;
 	status.signal = data->rcpi / 2 - 110;
 
@@ -1404,12 +1348,10 @@ static int stlc45xx_rx_data(struct stlc45xx *stlc, struct sk_buff *skb)
 	status.qual = data->rcpi * 100 / 140;
 
 	status.band = IEEE80211_BAND_2GHZ;
+	status.rate_idx = data->rate & LM_ALOFT_RATE;
 
-	/*
-	 * FIXME: this gives warning from __ieee80211_rx()
-	 *
-	 * status.rate_idx = data->rate;
-	 */
+	if (data->rate & LM_ALOFT_SP)
+		status.flag |= RX_FLAG_SHORTPRE;
 
 	len = data->length;
 
@@ -1649,7 +1591,7 @@ static void stlc45xx_tx_edcf(struct stlc45xx *stlc)
 	control->length = edcf_len;
 	control->oid = LM_OID_EDCF;
 
-	edcf->slottime = 0x14;
+	edcf->slottime = stlc->slottime;
 	edcf->sifs = 10;
 	edcf->eofpad = 6;
 	edcf->maxburst = 1500;
@@ -1700,7 +1642,7 @@ static void stlc45xx_tx_edcf(struct stlc45xx *stlc)
 	kfree(control);
 }
 
-static void stlc45xx_tx_setup(struct stlc45xx *stlc)
+static void stlc45xx_setup_mac(struct stlc45xx *stlc,u16 mode,const u8 *bssid)
 {
 	struct s_lm_control *control;
 	struct s_lmo_setup *setup;
@@ -1717,13 +1659,13 @@ static void stlc45xx_tx_setup(struct stlc45xx *stlc)
 	control->length = setup_len;
 	control->oid = LM_OID_SETUP;
 
-	setup->flags = LM_SETUP_INFRA;
+	setup->flags = mode;
 	setup->antenna = 2;
 	setup->rx_align = 0;
 	setup->rx_buffer = FIRMWARE_RXBUFFER_START;
 	setup->rx_mtu = FIRMWARE_MTU;
 	setup->frontend = 5;
-	setup->timeout = 0;
+	setup->timeout = 2;
 	setup->truncate = 48896;
 	setup->bratemask = 0xffffffff;
 	setup->ref_clock = 644245094;
@@ -1731,13 +1673,30 @@ static void stlc45xx_tx_setup(struct stlc45xx *stlc)
 	setup->osc_start_delay = 65535;
 
 	memcpy(setup->macaddr, stlc->mac_addr, ETH_ALEN);
-	memcpy(setup->bssid, stlc->bssid, ETH_ALEN);
+	if (bssid)
+		memcpy(setup->bssid, bssid, ETH_ALEN);
+	else
+		memset(setup->bssid, ~0, ETH_ALEN);
 
 	stlc45xx_tx_frame(stlc, FIRMWARE_CONFIG_START, control, len);
 
 	kfree(control);
 }
 
+static void stlc45xx_tx_setup(struct stlc45xx *stlc)
+{
+	u16 mode = LM_SETUP_PROMISCUOUS;
+	switch (stlc->mode) {
+	case NL80211_IFTYPE_STATION:
+		mode = LM_SETUP_INFRA;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		mode = LM_SETUP_IBSS;
+		break;
+	}
+	stlc45xx_setup_mac(stlc,mode,stlc->bssid);
+}
+
 static void stlc45xx_tx_scan(struct stlc45xx *stlc)
 {
 	struct s_lm_control *control;
@@ -1781,40 +1740,14 @@ static void stlc45xx_tx_scan(struct stlc45xx *stlc)
 /*
  * caller must hold mutex
  */
-static int stlc45xx_tx_pspoll(struct stlc45xx *stlc, bool powersave)
+static int stlc45xx_alloc_and_tx_frame(struct stlc45xx *stlc,
+	struct sk_buff *skb, struct txbuffer **tx_entry,
+	u16 flags, u8 queue, bool use_lifetime)
 {
-	struct ieee80211_hdr *pspoll;
 	int payload_len, padding, i;
 	struct s_lm_data_out *data;
 	struct txbuffer *entry;
-	struct sk_buff *skb;
 	char *payload;
-	u16 fc;
-
-	skb = dev_alloc_skb(stlc->hw->extra_tx_headroom + 16);
-	if (!skb) {
-		stlc45xx_warning("failed to allocate pspoll frame");
-		return -ENOMEM;
-	}
-	skb_reserve(skb, stlc->hw->extra_tx_headroom);
-
-	pspoll = (struct ieee80211_hdr *) skb_put(skb, 16);
-	memset(pspoll, 0, 16);
-	fc = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL;
-	if (powersave)
-		fc |= IEEE80211_FCTL_PM;
-	pspoll->frame_control = cpu_to_le16(fc);
-	pspoll->duration_id = cpu_to_le16(stlc->aid);
-
-	/* aid in PS-Poll has its two MSBs each set to 1 */
-	pspoll->duration_id |= cpu_to_le16(1 << 15) | cpu_to_le16(1 << 14);
-
-	memcpy(pspoll->addr1, stlc->bssid, ETH_ALEN);
-	memcpy(pspoll->addr2, stlc->mac_addr, ETH_ALEN);
-
-	stlc45xx_debug(DEBUG_PSM, "sending PS-Poll frame to %pM (powersave %d, "
-		       "fc 0x%x, aid %d)", pspoll->addr1,
-		       powersave, fc, stlc->aid);
 
 	spin_lock_bh(&stlc->tx_lock);
 
@@ -1831,8 +1764,7 @@ static int stlc45xx_tx_pspoll(struct stlc45xx *stlc, bool powersave)
 		 * But I'm too lazy and omit it for now.
 		 */
 		if (net_ratelimit())
-			stlc45xx_warning("firmware tx buffer full is full "
-					 "for null frame");
+			stlc45xx_warning("firmware tx buffer full is full");
 		return -ENOSPC;
 	}
 
@@ -1844,120 +1776,10 @@ static int stlc45xx_tx_pspoll(struct stlc45xx *stlc, bool powersave)
 	entry->skb = skb;
 	entry->status_needed = false;
 	entry->handle = (u32) skb;
-	entry->lifetime = jiffies + msecs_to_jiffies(TX_FRAME_LIFETIME);
-
-	stlc45xx_debug(DEBUG_TX, "tx data 0x%x (0x%p payload %d B "
-		       "padding %d header_len %d)",
-		       entry->handle, payload, payload_len, padding,
-		       entry->header_len);
-	stlc45xx_dump(DEBUG_TX_CONTENT, payload, payload_len);
-
-	data = (struct s_lm_data_out *) skb_push(skb, entry->header_len);
-
-	memset(data, 0, entry->header_len);
-
-	if (padding)
-		data->flags = LM_FLAG_ALIGN;
-
-	data->flags = LM_OUT_BURST;
-	data->length = payload_len;
-	data->handle = entry->handle;
-	data->aid = 1;
-	data->rts_retries = 7;
-	data->retries = 7;
-	data->aloft_ctrl = 0;
-	data->crypt_offset = 58;
-	data->keytype = 0;
-	data->keylen = 0;
-	data->queue = LM_QUEUE_DATA3;
-	data->backlog = 32;
-	data->antenna = 2;
-	data->cts = 3;
-	data->power = 127;
-
-	for (i = 0; i < 8; i++)
-		data->aloft[i] = 0;
-
-	/*
-	 * check if there's enough space in tx buffer
-	 *
-	 * FIXME: ignored for now
-	 */
-
-	stlc45xx_tx_frame(stlc, entry->start, skb->data, skb->len);
-
-	list_add(&entry->tx_list, &stlc->tx_sent);
-
-	return 0;
-}
-
-/*
- * caller must hold mutex
- *
- * shamelessly stolen from mac80211/ieee80211_send_nullfunc
- */
-static int stlc45xx_tx_nullfunc(struct stlc45xx *stlc, bool powersave)
-{
-	struct ieee80211_hdr *nullfunc;
-	int payload_len, padding, i;
-	struct s_lm_data_out *data;
-	struct txbuffer *entry;
-	struct sk_buff *skb;
-	char *payload;
-	u16 fc;
-
-	skb = dev_alloc_skb(stlc->hw->extra_tx_headroom + 24);
-	if (!skb) {
-		stlc45xx_warning("failed to allocate buffer for null frame\n");
-		return -ENOMEM;
-	}
-	skb_reserve(skb, stlc->hw->extra_tx_headroom);
-
-	nullfunc = (struct ieee80211_hdr *) skb_put(skb, 24);
-	memset(nullfunc, 0, 24);
-	fc = IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC |
-	     IEEE80211_FCTL_TODS;
-
-	if (powersave)
-		fc |= IEEE80211_FCTL_PM;
-
-	nullfunc->frame_control = cpu_to_le16(fc);
-	memcpy(nullfunc->addr1, stlc->bssid, ETH_ALEN);
-	memcpy(nullfunc->addr2, stlc->mac_addr, ETH_ALEN);
-	memcpy(nullfunc->addr3, stlc->bssid, ETH_ALEN);
-
-	stlc45xx_debug(DEBUG_PSM, "sending Null frame to %pM (powersave %d, "
-		       "fc 0x%x)", nullfunc->addr1, powersave, fc);
-
-	spin_lock_bh(&stlc->tx_lock);
-
-	entry = stlc45xx_txbuffer_alloc(stlc, skb->len);
-
-	spin_unlock_bh(&stlc->tx_lock);
-
-	if (!entry) {
-		/*
-		 * The queue should be stopped before the firmware buffer
-		 * is full, so firmware buffer should always have enough
-		 * space.
-		 *
-		 * But I'm too lazy and omit it for now.
-		 */
-		if (net_ratelimit())
-			stlc45xx_warning("firmware tx buffer full is full "
-					 "for null frame");
-		return -ENOSPC;
-	}
-
-	payload = skb->data;
-	payload_len = skb->len;
-	padding = (int) (skb->data - sizeof(*data)) & 3;
-	entry->header_len = sizeof(*data) + padding;
-
-	entry->skb = skb;
-	entry->status_needed = false;
-	entry->handle = (u32) skb;
-	entry->lifetime = jiffies + msecs_to_jiffies(TX_FRAME_LIFETIME);
+	if (use_lifetime)
+		entry->lifetime = jiffies + msecs_to_jiffies(TX_FRAME_LIFETIME);
+	else
+		entry->lifetime = 0;
 
 	stlc45xx_debug(DEBUG_TX, "tx data 0x%x (0x%p payload %d B "
 		       "padding %d header_len %d)",
@@ -1970,9 +1792,9 @@ static int stlc45xx_tx_nullfunc(struct stlc45xx *stlc, bool powersave)
 	memset(data, 0, entry->header_len);
 
 	if (padding)
-		data->flags = LM_FLAG_ALIGN;
+		flags |= LM_FLAG_ALIGN;
 
-	data->flags = LM_OUT_BURST;
+	data->flags = flags;
 	data->length = payload_len;
 	data->handle = entry->handle;
 	data->aid = 1;
@@ -1982,7 +1804,7 @@ static int stlc45xx_tx_nullfunc(struct stlc45xx *stlc, bool powersave)
 	data->crypt_offset = 58;
 	data->keytype = 0;
 	data->keylen = 0;
-	data->queue = LM_QUEUE_DATA3;
+	data->queue = queue;
 	data->backlog = 32;
 	data->antenna = 2;
 	data->cts = 3;
@@ -2011,9 +1833,8 @@ static void stlc45xx_tx_psm(struct stlc45xx *stlc, bool enable)
 	struct s_lmo_psm *psm;
 	size_t len, psm_len;
 
-	WARN_ON(!stlc->associated);
-	WARN_ON(stlc->aid < 1);
-	WARN_ON(stlc->aid > 2007);
+	WARN_ON(enable && !stlc->associated);
+	WARN_ON(enable && (stlc->aid < 1 || stlc->aid > 2007));
 
 	psm_len = sizeof(*psm);
 	len = sizeof(*control) + psm_len;
@@ -2025,11 +1846,13 @@ static void stlc45xx_tx_psm(struct stlc45xx *stlc, bool enable)
 	control->oid = LM_OID_PSM;
 
 	if (enable)
-		psm->flags |= LM_PSM;
+		psm->flags |= LM_PSM | LM_PSM_MCBC |
+			LM_PSM_CHECKSUM | LM_PSM_BEACON_TIMEOUT;
 
 	psm->aid = stlc->aid;
 
-	psm->beacon_rcpi_skip_max = 60;
+	psm->beacon_rcpi_skip_max = 200;
+	psm->rcpi_delta_threshold = 0;
 
 	psm->intervals[0].interval = 1;
 	psm->intervals[0].periods = 1;
@@ -2040,7 +1863,7 @@ static void stlc45xx_tx_psm(struct stlc45xx *stlc, bool enable)
 	psm->intervals[3].interval = 1;
 	psm->intervals[3].periods = 1;
 
-	psm->nr = 0;
+	psm->nr = 10;
 	psm->exclude[0] = 0;
 
 	stlc45xx_debug(DEBUG_PSM, "sending LM_OID_PSM (aid %d, interval %d)",
@@ -2051,15 +1874,111 @@ static void stlc45xx_tx_psm(struct stlc45xx *stlc, bool enable)
 	kfree(control);
 }
 
+static int stlc45xx_tx_cancel(struct stlc45xx *stlc,
+	struct txbuffer *entry)
+{
+	struct s_lm_control *control;
+	struct s_lmo_txcancel *txc;
+	size_t len;
+
+	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+
+	len = sizeof(*control) + sizeof(*txc);
+	control = kzalloc(len, GFP_KERNEL);
+	txc = (struct s_lmo_txcancel *) (control + 1);
+
+	control->flags = LM_FLAG_CONTROL | LM_CTRL_OPSET;
+	control->length = sizeof(*txc);
+	control->oid = LM_OID_TXCANCEL;
+
+	txc->address[0] = entry->start;
+
+	stlc45xx_tx_frame(stlc, FIRMWARE_CONFIG_START, control, len);
+
+	kfree(control);
+	return 0;
+}
+
+static int stlc45xx_tx_beacon(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif)
+{
+	struct stlc45xx *stlc = hw->priv;
+	struct sk_buff *beacon;
+
+	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+
+	if (stlc->cached_beacon) {
+		stlc45xx_tx_cancel(stlc, stlc->cached_beacon);
+		msleep(10);
+	}
+
+	beacon = ieee80211_beacon_get(hw, vif);
+	if (!beacon)
+		return -ENOMEM;
+
+	return stlc45xx_alloc_and_tx_frame(stlc, beacon, &stlc->cached_beacon,
+		/*LM_OUT_TIMESTAMP*/0, LM_QUEUE_BEACON, false);
+}
+
+static void stlc45xx_tx_set_flags(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
+		struct s_lm_data_out *data)
+{
+	struct stlc45xx *stlc = hw->priv;
+
+	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+	
+	switch (stlc->mode) {
+	case NL80211_IFTYPE_STATION:
+		break;
+
+	case NL80211_IFTYPE_ADHOC:
+		if (ieee80211_is_mgmt(hdr->frame_control)) {
+			data->queue = LM_QUEUE_MGT;
+			if (ieee80211_is_probe_resp(hdr->frame_control))
+				data->flags |= LM_OUT_TIMESTAMP;
+			if (ieee80211_is_beacon(hdr->frame_control)) {
+				data->queue = LM_QUEUE_BEACON;
+			}
+		} else
+			data->queue = LM_QUEUE_DATA;
+		break;
+	}
+	stlc45xx_debug(DEBUG_TX, "queue: %d, flags: %x",data->queue,data->flags);
+}
+
+static u8 stlc45xx_get_tx_rate(const struct ieee80211_hw *hw,
+			       const struct ieee80211_tx_info *info,
+			       const struct ieee80211_tx_rate *tx_rate)
+{
+	struct ieee80211_supported_band *band;
+	struct ieee80211_rate *rate;
+	int result;
+
+	band = hw->wiphy->bands[info->band];
+	rate = &band->bitrates[tx_rate->idx];
+
+	result = rate->hw_value;
+
+	if (tx_rate->flags & IEEE80211_TX_RC_USE_RTS_CTS)
+		result |= LM_ALOFT_RTS;
+	if (tx_rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
+		result |= LM_ALOFT_CTS;
+	if (tx_rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+		result |= LM_ALOFT_SP;
+
+	return result;
+}
+
 static int stlc45xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
+	struct ieee80211_tx_rate *tx_rate;
 	struct stlc45xx *stlc = hw->priv;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_rate *rate;
-	int payload_len, padding, i;
+	int payload_len, padding, aloft_index, i, j;
 	struct s_lm_data_out *data;
 	struct txbuffer *entry;
 	char *payload;
+	u8 hw_rate;
 
 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
 
@@ -2084,7 +2003,7 @@ static int stlc45xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	entry->header_len = sizeof(*data) + padding;
 
 	entry->skb = skb;
-	entry->status_needed = true;
+	entry->status_needed = (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) != 0;
 	entry->handle = (u32) skb;
 	entry->lifetime = jiffies + msecs_to_jiffies(TX_FRAME_LIFETIME);
 
@@ -2104,24 +2023,44 @@ static int stlc45xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	data->flags = LM_OUT_BURST;
 	data->length = payload_len;
 	data->handle = entry->handle;
-	data->aid = 1;
-	data->rts_retries = 7;
-	data->retries = 7;
-	data->aloft_ctrl = 0;
-	data->crypt_offset = 58;
-	data->keytype = 0;
-	data->keylen = 0;
-	data->queue = 2;
-	data->backlog = 32;
-	data->antenna = 2;
-	data->cts = 3;
-	data->power = 127;
 
-	for (i = 0; i < 8; i++) {
-		rate = ieee80211_get_tx_rate(stlc->hw, info);
-		data->aloft[i] = rate->hw_value;
+	data->queue = LM_QUEUE_DATA;
+
+	aloft_index = 0;
+
+	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+		tx_rate = &info->control.rates[i];
+		if (tx_rate->idx < 0)
+			break;
+
+		hw_rate = stlc45xx_get_tx_rate(hw, info, tx_rate);
+		
+		for (j = 0; j < tx_rate->count; j++) {
+			if (aloft_index > sizeof(data->aloft))
+				/* FIXME: should break both loops */
+				continue;
+
+			data->aloft[aloft_index++] = hw_rate;
+		}
 	}
 
+	/*
+	 * Really maximum number of transmissions for the frame, not just
+	 * retries.
+	 */
+	data->retries = aloft_index + 1;
+
+	/* maximum number of RTS retries for each transmission attempt */
+	data->rts_retries = 0;
+
+	/* index to data->aloft for initial RTS or CTS-to-self frames */
+	data->aloft_ctrl = 0;
+
+	/* cts rate */
+	data->cts = 1;
+	
+	stlc45xx_tx_set_flags(hw, (struct ieee80211_hdr *) payload, data);
+
 	list_add_tail(&entry->tx_list, &stlc->tx_pending);
 
 	/* check if there's enough space in tx buffer */
@@ -2180,6 +2119,9 @@ static int stlc45xx_op_start(struct ieee80211_hw *hw)
 
 	WARN_ON(stlc->fw_state != FW_STATE_READY);
 
+	stlc->mode = NL80211_IFTYPE_MONITOR;
+	stlc45xx_setup_mac(stlc,LM_SETUP_PROMISCUOUS,NULL);
+
 out_unlock:
 	mutex_unlock(&stlc->mutex);
 
@@ -2196,16 +2138,22 @@ static void stlc45xx_op_stop(struct ieee80211_hw *hw)
 	mutex_lock(&stlc->mutex);
 
 	WARN_ON(stlc->fw_state != FW_STATE_READY);
-
+	stlc->fw_state = FW_STATE_OFF;
 	stlc45xx_power_off(stlc);
 
-	/* FIXME: make sure that all work_structs have completed */
+	mutex_unlock(&stlc->mutex);
+
+	cancel_work_sync(&stlc->work);
+	cancel_work_sync(&stlc->work_reset);
+	cancel_delayed_work_sync(&stlc->work_tx_timeout);
+
+	mutex_lock(&stlc->mutex);
 
 	spin_lock_bh(&stlc->tx_lock);
 	stlc45xx_flush_queues(stlc);
 	spin_unlock_bh(&stlc->tx_lock);
 
-	stlc->fw_state = FW_STATE_OFF;
+	stlc->mode = NL80211_IFTYPE_UNSPECIFIED;
 
 	mutex_unlock(&stlc->mutex);
 }
@@ -2214,25 +2162,58 @@ static int stlc45xx_op_add_interface(struct ieee80211_hw *hw,
 				     struct ieee80211_if_init_conf *conf)
 {
 	struct stlc45xx *stlc = hw->priv;
+	u16 setup;
+	int ret = 0;
 
-	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+	stlc45xx_debug(DEBUG_FUNC, "%s conf->type: %d", __func__,conf->type);
+
+	mutex_lock(&stlc->mutex);
+
+	if (stlc->vif) {
+		/* can support only one interface at a time */
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
+		setup = LM_SETUP_INFRA;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		setup = LM_SETUP_IBSS;
 		break;
 	default:
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto out;
 	}
 
 	memcpy(stlc->mac_addr, conf->mac_addr, ETH_ALEN);
+	stlc->mode = conf->type;
+	stlc->vif = conf->vif;
 
-	return 0;
+	stlc45xx_setup_mac(stlc, setup, NULL);
+
+out:
+	mutex_unlock(&stlc->mutex);
+	return ret;
 }
 
 static void stlc45xx_op_remove_interface(struct ieee80211_hw *hw,
 					 struct ieee80211_if_init_conf *conf)
 {
+	struct stlc45xx *stlc = hw->priv;
+
 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+
+	mutex_lock(&stlc->mutex);
+
+	memset(stlc->mac_addr, 0xff , ETH_ALEN);
+	stlc->mode = NL80211_IFTYPE_MONITOR;
+	stlc->vif = NULL;
+
+	stlc45xx_setup_mac(stlc, LM_SETUP_PROMISCUOUS, NULL);
+
+	mutex_unlock(&stlc->mutex);
 }
 
 static int stlc45xx_op_config_interface(struct ieee80211_hw *hw,
@@ -2245,8 +2226,17 @@ static int stlc45xx_op_config_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&stlc->mutex);
 
-	memcpy(stlc->bssid, conf->bssid, ETH_ALEN);
-	stlc45xx_tx_setup(stlc);
+	if (conf->changed & IEEE80211_IFCC_BSSID) {
+		memcpy(stlc->bssid, conf->bssid, ETH_ALEN);
+		stlc45xx_tx_setup(stlc);
+	}
+
+	if (conf->changed & IEEE80211_IFCC_BEACON) {
+		stlc45xx_debug(DEBUG_FUNC, "BEACON!");
+		stlc45xx_tx_scan(stlc);
+		stlc45xx_tx_beacon(hw,vif);
+		stlc45xx_tx_edcf(stlc);
+	}
 
 	mutex_unlock(&stlc->mutex);
 
@@ -2266,12 +2256,11 @@ static int stlc45xx_op_config(struct ieee80211_hw *hw, u32 changed)
 	stlc45xx_tx_setup(stlc);
 	stlc45xx_tx_edcf(stlc);
 
-	if ((hw->conf.flags & IEEE80211_CONF_PS) != stlc->psm) {
+	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		stlc->psm = hw->conf.flags & IEEE80211_CONF_PS;
-		if (stlc->associated) {
-			stlc45xx_tx_psm(stlc, stlc->psm);
-			stlc45xx_tx_nullfunc(stlc, stlc->psm);
-		}
+		stlc45xx_debug(DEBUG_PSM, "psm %s",
+			       stlc->psm ? "enabled" : "disabled");
+		stlc45xx_tx_psm(stlc, stlc->psm);
 	}
 
 	mutex_unlock(&stlc->mutex);
@@ -2301,29 +2290,36 @@ static void stlc45xx_op_bss_info_changed(struct ieee80211_hw *hw,
 			stlc->aid = info->aid;
 		else
 			stlc->aid = -1;
+	}
 
-		if (stlc->psm) {
-			stlc45xx_tx_psm(stlc, stlc->psm);
-			stlc45xx_tx_nullfunc(stlc, stlc->psm);
-		}
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		if (info->use_short_slot)
+			stlc->slottime = SHORT_SLOT_TIME;
+		else
+			stlc->slottime = LONG_SLOT_TIME;
+		
+		stlc45xx_tx_edcf(stlc);
 	}
 }
 
 
 /* can't be const, mac80211 writes to this */
 static struct ieee80211_rate stlc45xx_rates[] = {
-	{ .bitrate = 10,  .hw_value = 0,    .hw_value_short = 0, },
-	{ .bitrate = 20,  .hw_value = 1,    .hw_value_short = 1, },
-	{ .bitrate = 55,  .hw_value = 2,    .hw_value_short = 2, },
-	{ .bitrate = 110, .hw_value = 3,    .hw_value_short = 3, },
-	{ .bitrate = 60,  .hw_value = 4,    .hw_value_short = 4, },
-	{ .bitrate = 90,  .hw_value = 5,    .hw_value_short = 5, },
-	{ .bitrate = 120, .hw_value = 6,    .hw_value_short = 6, },
-	{ .bitrate = 180, .hw_value = 7,    .hw_value_short = 7, },
-	{ .bitrate = 240, .hw_value = 8,    .hw_value_short = 8, },
-	{ .bitrate = 360, .hw_value = 9,    .hw_value_short = 9, },
-	{ .bitrate = 480, .hw_value = 10,   .hw_value_short = 10, },
-	{ .bitrate = 540, .hw_value = 11,   .hw_value_short = 11, },
+	{ .bitrate = 10,  .hw_value = 0,    },
+	{ .bitrate = 20,  .hw_value = 1,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE  },
+	{ .bitrate = 55,  .hw_value = 2,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE  },
+	{ .bitrate = 110, .hw_value = 3,
+	  .flags = IEEE80211_RATE_SHORT_PREAMBLE  },
+	{ .bitrate = 60,  .hw_value = 4,    },
+	{ .bitrate = 90,  .hw_value = 5,    },
+	{ .bitrate = 120, .hw_value = 6,    },
+	{ .bitrate = 180, .hw_value = 7,    },
+	{ .bitrate = 240, .hw_value = 8,    },
+	{ .bitrate = 360, .hw_value = 9,    },
+	{ .bitrate = 480, .hw_value = 10,   },
+	{ .bitrate = 540, .hw_value = 11,   },
 };
 
 /* can't be const, mac80211 writes to this */
@@ -2417,6 +2413,7 @@ static int __devinit stlc45xx_probe(struct spi_device *spi)
 	/* mac80211 clears hw->priv */
 	stlc = hw->priv;
 
+	stlc->mode = NL80211_IFTYPE_UNSPECIFIED;
 	stlc->hw = hw;
 	dev_set_drvdata(&spi->dev, stlc);
 	stlc->spi = spi;
@@ -2474,13 +2471,20 @@ static int __devinit stlc45xx_probe(struct spi_device *spi)
 
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
 		IEEE80211_HW_SIGNAL_DBM |
-		IEEE80211_HW_NOISE_DBM;
+		IEEE80211_HW_NOISE_DBM |
+		IEEE80211_HW_SUPPORTS_PS |
+		IEEE80211_HW_PS_NULLFUNC_STACK |
+		IEEE80211_HW_BEACON_FILTER;
+
 	/* four bytes for padding */
 	hw->extra_tx_headroom = sizeof(struct s_lm_data_out) + 4;
 
 	/* unit us */
 	hw->channel_change_time = 1000;
 
+	hw->max_rates = 4;
+	hw->max_rate_tries = 7;
+
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &stlc45xx_band_2ghz;
 
diff --git a/drivers/staging/stlc45xx/stlc45xx.h b/drivers/staging/stlc45xx/stlc45xx.h
index ac96bbb..19e129b 100644
--- a/drivers/staging/stlc45xx/stlc45xx.h
+++ b/drivers/staging/stlc45xx/stlc45xx.h
@@ -48,11 +48,7 @@ enum {
 	DEBUG_ALL = ~0,
 };
 
-#define DEBUG_LEVEL DEBUG_NONE
-/* #define DEBUG_LEVEL DEBUG_ALL */
-/* #define DEBUG_LEVEL (DEBUG_TX | DEBUG_RX | DEBUG_IRQ) */
-/* #define DEBUG_LEVEL (DEBUG_TX | DEBUG_MEMREGION | DEBUG_QUEUE) */
-/* #define DEBUG_LEVEL (DEBUG_MEMREGION | DEBUG_QUEUE) */
+#define DEBUG_LEVEL (DEBUG_NONE)
 
 #define stlc45xx_error(fmt, arg...) \
 	printk(KERN_ERR DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
@@ -76,9 +72,6 @@ enum {
 				       16, 1, buf, len, 1);		\
 	} while (0)
 
-#define MAC2STR(a) ((a)[0], (a)[1], (a)[2], (a)[3], (a)[4], (a)[5])
-#define MACSTR "%02x:%02x:%02x:%02x:%02x:%02x"
-
 /* Bit 15 is read/write bit; ON = READ, OFF = WRITE */
 #define ADDR_READ_BIT_15  0x8000
 
@@ -181,6 +174,9 @@ enum {
 #define TX_FRAME_LIFETIME 2000
 #define TX_TIMEOUT 4000
 
+#define SHORT_SLOT_TIME 9
+#define LONG_SLOT_TIME 20
+
 #define SUPPORTED_CHANNELS 13
 
 /* FIXME */
@@ -245,9 +241,10 @@ struct stlc45xx {
 	struct mutex mutex;
 	struct completion fw_comp;
 
-
+	int mode;
 	u8 bssid[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
+	struct ieee80211_vif *vif;
 	int channel;
 
 	u8 *cal_rssi;
@@ -278,6 +275,10 @@ struct stlc45xx {
 	bool associated;
 	int aid;
 	bool pspolling;
+
+	struct txbuffer *cached_beacon;
+
+	u8 slottime;
 };
 
 

