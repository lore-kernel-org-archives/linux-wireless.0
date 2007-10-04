Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:24649 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755306AbXJDLfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 07:35:18 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: More complete configure_filter implementation
Message-Id: <20071004113509.E5FF29D502B@zog.reactivated.net> (sfid-20071004_123541_661229_9AE2F345)
Date: Thu,  4 Oct 2007 12:35:09 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch extends the configure_filter implementation and fixes the
structures around it.

The mac80211 configure_filter work also clarified handling of our own mac
address. We now program it in add_interface and remove it in
remove_interface. We also no longer need to keep it in the zd_mac structure.

With the recent mac80211 changes, has_monitor_interfaces() always returns
FALSE because the driver is not directly told about monitor interfaces.
I've removed this function and corrected the logic elsewhere.

The sniffer is no longer enabled in monitor mode. This is somewhat
guesswork, but I think by default we are given frames that have a bad FCS,
and enabling the sniffer also passes us frames that have a bad PLCP
checksum. However, when the sniffer is enabled, the device stops telling us
which frames failed FCS checks, and also does not indicate which frames
failed PLCP checks. So, it's best that we disable this functionality for now
and only pass good and known-failed-FCS frames to the stack.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/zd1211rw-mac80211/zd_chip.c |   23 ++--
 drivers/net/wireless/zd1211rw-mac80211/zd_chip.h |   26 ++++-
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.c  |  153 ++++++++++++----------
 drivers/net/wireless/zd1211rw-mac80211/zd_mac.h  |   13 ++-
 4 files changed, 131 insertions(+), 84 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
index 801556e..c902cbf 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.c
@@ -50,7 +50,7 @@ void zd_chip_clear(struct zd_chip *chip)
 
 static int scnprint_mac_oui(struct zd_chip *chip, char *buffer, size_t size)
 {
-	u8 *addr = zd_chip_to_mac(chip)->hwaddr;
+	u8 *addr = zd_mac_get_perm_addr(zd_chip_to_mac(chip));
 	return scnprintf(buffer, size, "%02x-%02x-%02x",
 		         addr[0], addr[1], addr[2]);
 }
@@ -377,15 +377,18 @@ int zd_write_mac_addr(struct zd_chip *chip, const u8 *mac_addr)
 		[1] = { .addr = CR_MAC_ADDR_P2 },
 	};
 
-	reqs[0].value = (mac_addr[3] << 24)
-		      | (mac_addr[2] << 16)
-		      | (mac_addr[1] <<  8)
-		      |  mac_addr[0];
-	reqs[1].value = (mac_addr[5] <<  8)
-		      |  mac_addr[4];
-
-	dev_dbg_f(zd_chip_dev(chip),
-		"mac addr " MAC_FMT "\n", MAC_ARG(mac_addr));
+	if (mac_addr) {
+		reqs[0].value = (mac_addr[3] << 24)
+			      | (mac_addr[2] << 16)
+			      | (mac_addr[1] <<  8)
+			      |  mac_addr[0];
+		reqs[1].value = (mac_addr[5] <<  8)
+			      |  mac_addr[4];
+		dev_dbg_f(zd_chip_dev(chip),
+			"mac addr " MAC_FMT "\n", MAC_ARG(mac_addr));
+	} else {
+		dev_dbg_f(zd_chip_dev(chip), "set NULL mac\n");
+	}
 
 	mutex_lock(&chip->mutex);
 	r = zd_iowrite32a_locked(chip, reqs, ARRAY_SIZE(reqs));
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
index 96c48bb..a88a569 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_chip.h
@@ -510,15 +510,37 @@ enum {
 #define CR_UNDERRUN_CNT			CTL_REG(0x0688)
 
 #define CR_RX_FILTER			CTL_REG(0x068c)
+#define RX_FILTER_ASSOC_REQUEST		(1 <<  0)
 #define RX_FILTER_ASSOC_RESPONSE	(1 <<  1)
+#define RX_FILTER_REASSOC_REQUEST	(1 <<  2)
 #define RX_FILTER_REASSOC_RESPONSE	(1 <<  3)
+#define RX_FILTER_PROBE_REQUEST		(1 <<  4)
 #define RX_FILTER_PROBE_RESPONSE	(1 <<  5)
+/* bits 6 and 7 reserved */
 #define RX_FILTER_BEACON		(1 <<  8)
+#define RX_FILTER_ATIM			(1 <<  9)
 #define RX_FILTER_DISASSOC		(1 << 10)
 #define RX_FILTER_AUTH			(1 << 11)
+#define RX_FILTER_DEAUTH		(1 << 12)
+#define RX_FILTER_PSPOLL		(1 << 26)
+#define RX_FILTER_RTS			(1 << 27)
+#define RX_FILTER_CTS			(1 << 28)
 #define RX_FILTER_ACK			(1 << 29)
-#define AP_RX_FILTER			0x0400feff
-#define STA_RX_FILTER			0x2000ffff
+#define RX_FILTER_CFEND			(1 << 30)
+#define RX_FILTER_CFACK			(1 << 31)
+
+/* Enable bits for all frames you are interested in. */
+#define STA_RX_FILTER	(RX_FILTER_ASSOC_REQUEST | RX_FILTER_ASSOC_RESPONSE | \
+	RX_FILTER_REASSOC_REQUEST | RX_FILTER_REASSOC_RESPONSE | \
+	RX_FILTER_PROBE_REQUEST | RX_FILTER_PROBE_RESPONSE | \
+	(0x3 << 6) /* vendor driver sets these reserved bits */ | \
+	RX_FILTER_BEACON | RX_FILTER_ATIM | RX_FILTER_DISASSOC | \
+	RX_FILTER_AUTH | RX_FILTER_DEAUTH | \
+	(0x7 << 13) /* vendor driver sets these reserved bits */ | \
+	RX_FILTER_PSPOLL | RX_FILTER_ACK) /* 0x2400ffff */
+
+#define RX_FILTER_CTRL (RX_FILTER_RTS | RX_FILTER_CTS | \
+	RX_FILTER_CFEND | RX_FILTER_CFACK)
 
 /* Monitor mode sets filter to 0xfffff */
 
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
index 6288823..5ae60a5 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.c
@@ -117,10 +117,7 @@ int zd_mac_preinit_hw(struct ieee80211_hw *hw)
 	if (r)
 		return r;
 
-	spin_lock_irq(&mac->lock);
 	SET_IEEE80211_PERM_ADDR(hw, addr);
-	memcpy(mac->hwaddr, addr, ETH_ALEN);
-	spin_unlock_irq(&mac->lock);
 
 	return 0;
 }
@@ -171,39 +168,23 @@ void zd_mac_clear(struct zd_mac *mac)
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
 }
 
-/**
- * has_monitor_interfaces - have monitor interfaces been enabled?
- * @mac: the struct zd_mac pointer
- *
- * The function returns, whether the device has monitor interfaces attached.
- */
-static int has_monitor_interfaces(struct zd_mac *mac)
-{
-	return mac->type == IEEE80211_IF_TYPE_MNTR;
-}
-
 static int set_rx_filter(struct zd_mac *mac)
 {
-	u32 filter = has_monitor_interfaces(mac) ? ~0 : STA_RX_FILTER;
+	unsigned long flags;
+	u32 filter = STA_RX_FILTER;
 
-	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
-}
+	spin_lock_irqsave(&mac->lock, flags);
+	if (mac->pass_ctrl)
+		filter |= RX_FILTER_CTRL;
+	spin_unlock_irqrestore(&mac->lock, flags);
 
-static int set_sniffer(struct zd_mac *mac)
-{
-	return zd_iowrite32(&mac->chip, CR_SNIFFER_ON,
-		has_monitor_interfaces(mac) ? 1 : 0);
-	return 0;
+	return zd_iowrite32(&mac->chip, CR_RX_FILTER, filter);
 }
 
 static int set_mc_hash(struct zd_mac *mac)
 {
 	struct zd_mc_hash hash;
-
 	zd_mc_clear(&hash);
-	if (has_monitor_interfaces(mac))
-		zd_mc_add_all(&hash);
-
 	return zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
@@ -224,18 +205,12 @@ static int zd_op_start(struct ieee80211_hw *hw)
 	if (r < 0)
 		goto out;
 
-	r = zd_write_mac_addr(chip, mac->hwaddr);
-	if (r)
-		goto disable_int;
 	r = zd_chip_set_basic_rates(chip, CR_RATES_80211B | CR_RATES_80211G);
 	if (r < 0)
 		goto disable_int;
 	r = set_rx_filter(mac);
 	if (r)
 		goto disable_int;
-	r = set_sniffer(mac);
-	if (r)
-		goto disable_int;
 	r = set_mc_hash(mac);
 	if (r)
 		goto disable_int;
@@ -601,32 +576,6 @@ static int zd_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	return 0;
 }
 
-static int fill_rx_stats(struct ieee80211_rx_status *stats,
-	                 const struct rx_status **pstatus,
-		         struct zd_mac *mac,
-			 const u8 *buffer, unsigned int length)
-{
-	const struct rx_status *status;
-
-	/* Caller has to ensure that length >= sizeof(struct rx_status). */
-	*pstatus = status = (struct rx_status *)
-		(buffer + (length - sizeof(struct rx_status)));
-	if (status->frame_status & ZD_RX_ERROR)
-		return -EINVAL; /* FIXME: stats update */
-	memset(stats, 0, sizeof(*stats));
-
-	stats->channel = _zd_chip_get_channel(&mac->chip);
-	stats->freq = zd_channels[stats->channel - 1].freq;
-	stats->phymode = MODE_IEEE80211G;
-	stats->ssi = status->signal_strength;
-	stats->signal = zd_rx_qual_percent(buffer,
-		                          length - sizeof(struct rx_status),
-		                          status);
-	stats->rate = zd_rx_rate(buffer, status);
-
-	return 0;
-}
-
 /**
  * filter_ack - filters incoming packets for acknowledgements
  * @dev: the mac80211 device
@@ -638,6 +587,8 @@ static int fill_rx_stats(struct ieee80211_rx_status *stats,
  * the upper layers is informed about the successful transmission. If
  * mac80211 queues have been stopped and the number of frames still to be
  * transmitted is low the queues will be opened again.
+ *
+ * Returns 1 if the frame was an ACK, 0 if it was ignored.
  */
 static int filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
 		      struct ieee80211_rx_status *stats)
@@ -674,25 +625,60 @@ out:
 
 int zd_mac_rx(struct ieee80211_hw *hw, const u8 *buffer, unsigned int length)
 {
-	int r;
 	struct zd_mac *mac = zd_hw_mac(hw);
 	struct ieee80211_rx_status stats;
 	const struct rx_status *status;
 	struct sk_buff *skb;
+	int bad_frame = 0;
 
 	if (length < ZD_PLCP_HEADER_SIZE + 10 /* IEEE80211_1ADDR_LEN */ +
 	             FCS_LEN + sizeof(struct rx_status))
 		return -EINVAL;
 
-	r = fill_rx_stats(&stats, &status, mac, buffer, length);
-	if (r)
-		return r;
+	memset(&stats, 0, sizeof(stats));
+
+	/* Note about pass_failed_fcs and pass_ctrl access below:
+	 * mac locking intentionally omitted here, as this is the only unlocked
+	 * reader and the only writer is configure_filter. Plus, if there were
+	 * any races accessing these variables, it wouldn't really matter.
+	 * If mac80211 ever provides a way for us to access filter flags
+	 * from outside configure_filter, we could improve on this. Also, this
+	 * situation may change once we implement some kind of DMA-into-skb
+	 * RX path. */
+
+	/* Caller has to ensure that length >= sizeof(struct rx_status). */
+	status = (struct rx_status *)
+		(buffer + (length - sizeof(struct rx_status)));
+	if (status->frame_status & ZD_RX_ERROR) {
+		if (mac->pass_failed_fcs &&
+				(status->frame_status & ZD_RX_CRC32_ERROR)) {
+			stats.flag |= RX_FLAG_FAILED_FCS_CRC;
+			bad_frame = 1;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	stats.channel = _zd_chip_get_channel(&mac->chip);
+	stats.freq = zd_channels[stats.channel - 1].freq;
+	stats.phymode = MODE_IEEE80211G;
+	stats.ssi = status->signal_strength;
+	stats.signal = zd_rx_qual_percent(buffer,
+		                          length - sizeof(struct rx_status),
+		                          status);
+	stats.rate = zd_rx_rate(buffer, status);
 
 	length -= ZD_PLCP_HEADER_SIZE + sizeof(struct rx_status);
 	buffer += ZD_PLCP_HEADER_SIZE;
 
-	if (filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
-	    !has_monitor_interfaces(mac))
+	/* Except for bad frames, filter each frame to see if it is an ACK, in
+	 * which case our internal TX tracking is updated. Normally we then
+	 * bail here as there's no need to pass ACKs on up to the stack, but
+	 * there is also the case where the stack has requested us to pass
+	 * control frames on up (pass_ctrl) which we must consider. */
+	if (!bad_frame &&
+			filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats)
+			&& !mac->pass_ctrl)
 		return 0;
 
 	skb = dev_alloc_skb(length);
@@ -722,9 +708,7 @@ static int zd_op_add_interface(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;
 	}
 
-	mac->hwaddr = conf->mac_addr;
-
-	return 0;
+	return zd_write_mac_addr(&mac->chip, conf->mac_addr);
 }
 
 static void zd_op_remove_interface(struct ieee80211_hw *hw,
@@ -732,6 +716,7 @@ static void zd_op_remove_interface(struct ieee80211_hw *hw,
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
 	mac->type = IEEE80211_IF_TYPE_MGMT;
+	zd_write_mac_addr(&mac->chip, NULL);
 }
 
 static int zd_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
@@ -766,8 +751,21 @@ static void set_multicast_hash_handler(struct work_struct *work)
 	zd_chip_set_multicast_hash(&mac->chip, &hash);
 }
 
+static void set_rx_filter_handler(struct work_struct *work)
+{
+	struct zd_mac *mac =
+		container_of(work, struct zd_mac, set_rx_filter_work);
+	int r;
+
+	dev_dbg_f(zd_mac_dev(mac), "\n");
+	r = set_rx_filter(mac);
+	if (r)
+		dev_err(zd_mac_dev(mac), "set_rx_filter_handler error %d\n", r);
+}
+
 #define SUPPORTED_FIF_FLAGS \
-	FIF_PROMISC_IN_BSS | FIF_ALLMULTI
+	(FIF_PROMISC_IN_BSS | FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
+	FIF_OTHER_BSS)
 static void zd_op_configure_filter(struct ieee80211_hw *hw,
 			unsigned int changed_flags,
 			unsigned int *new_flags,
@@ -788,8 +786,7 @@ static void zd_op_configure_filter(struct ieee80211_hw *hw,
 	if (!changed_flags)
 		return;
 
-	if ((*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)) ||
-	     has_monitor_interfaces(mac)) {
+	if (*new_flags & (FIF_PROMISC_IN_BSS | FIF_ALLMULTI)) {
 		zd_mc_add_all(&hash);
 	} else {
 		zd_mc_clear(&hash);
@@ -804,9 +801,23 @@ static void zd_op_configure_filter(struct ieee80211_hw *hw,
 	}
 
 	spin_lock_irqsave(&mac->lock, flags);
+	mac->pass_failed_fcs = !!(*new_flags & FIF_FCSFAIL);
+	mac->pass_ctrl = !!(*new_flags & FIF_CONTROL);
 	mac->multicast_hash = hash;
 	spin_unlock_irqrestore(&mac->lock, flags);
 	queue_work(zd_workqueue, &mac->set_multicast_hash_work);
+
+	if (changed_flags & FIF_CONTROL)
+		queue_work(zd_workqueue, &mac->set_rx_filter_work);
+
+	/* no handling required for FIF_OTHER_BSS as we don't currently
+	 * do BSSID filtering */
+	/* FIXME: in future it would be nice to enable the probe response
+	 * filter (so that the driver doesn't see them) until
+	 * FIF_BCN_PRBRESP_PROMISC is set. however due to atomicity here, we'd
+	 * have to schedule work to enable prbresp reception, which might
+	 * happen too late. For now we'll just listen and forward them all the
+	 * time. */
 }
 
 static void set_rts_cts_work(struct work_struct *work)
@@ -879,7 +890,6 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	mac->hw = hw;
 
 	mac->type = IEEE80211_IF_TYPE_MGMT;
-	mac->hwaddr = hw->wiphy->perm_addr;
 
 	memcpy(mac->channels, zd_channels, sizeof(zd_channels));
 	memcpy(mac->rates, zd_rates, sizeof(zd_rates));
@@ -916,6 +926,7 @@ struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)
 	housekeeping_init(mac);
 	INIT_WORK(&mac->set_multicast_hash_work, set_multicast_hash_handler);
 	INIT_WORK(&mac->set_rts_cts_work, set_rts_cts_work);
+	INIT_WORK(&mac->set_rx_filter_work, set_rx_filter_handler);
 
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	return hw;
diff --git a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
index a60b10c..ed5417c 100644
--- a/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
+++ b/drivers/net/wireless/zd1211rw-mac80211/zd_mac.h
@@ -173,12 +173,12 @@ struct zd_mac {
 	struct housekeeping housekeeping;
 	struct work_struct set_multicast_hash_work;
 	struct work_struct set_rts_cts_work;
+	struct work_struct set_rx_filter_work;
 	struct zd_mc_hash multicast_hash;
 	u8 regdomain;
 	u8 default_regdomain;
 	int type;
 	int associated;
-	u8 *hwaddr;
 	struct sk_buff_head ack_wait_queue;
 	struct ieee80211_channel channels[14];
 	struct ieee80211_rate rates[12];
@@ -189,6 +189,12 @@ struct zd_mac {
 
 	/* flags to indicate update in progress */
 	unsigned int updating_rts_rate:1;
+
+	/* whether to pass frames with CRC errors to stack */
+	unsigned int pass_failed_fcs:1;
+
+	/* whether to pass control frames to stack */
+	unsigned int pass_ctrl:1;
 };
 
 static inline struct zd_mac *zd_hw_mac(struct ieee80211_hw *hw)
@@ -206,6 +212,11 @@ static inline struct zd_mac *zd_usb_to_mac(struct zd_usb *usb)
 	return zd_chip_to_mac(zd_usb_to_chip(usb));
 }
 
+static inline u8 *zd_mac_get_perm_addr(struct zd_mac *mac)
+{
+	return mac->hw->wiphy->perm_addr;
+}
+
 #define zd_mac_dev(mac) (zd_chip_dev(&(mac)->chip))
 
 struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf);
-- 
1.5.3.3

