Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:43995 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZAKHEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2009 02:04:00 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [RFC PATCH v1 2/2] mac80211: use ps-poll to request frames in power
	save mode
To: johannes@sipsolutions.net, vivek.natraj@gmail.com
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Jan 2009 09:03:54 +0200
Message-ID: <20090111070353.3849.5303.stgit@tikku> (sfid-20090111_080404_578486_FF8B5834)
In-Reply-To: <20090111070148.3849.10799.stgit@tikku>
References: <20090111070148.3849.10799.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a directed tim bit is set, mac80211 currently disables power save
ands sends a null frame to the AP. But if dynamic power save is
disabled, mac80211 will not enable power save again. Fix this by
adding ps-poll functionality to mac80211. When a directed tim bit is
set, mac80211 sends a ps-poll frame to the AP and checks for the more
data bit in the returned data frames. Power save mode is not disabled
during ps-polling, the assumption is that firmware still receives
responses to the ps-poll frame.

Using ps-poll is slower than waking up with null frame, but I
recommend using dynamic power save in cases where throughput is
important. User space can enable it with 'iwconfig wlan0 power timeout
<value>'.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/mlme.c        |   40 +++++++++++++++++++++++++++++++++++++---
 net/mac80211/rx.c          |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c9ffadb..76814e9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -710,6 +710,7 @@ struct ieee80211_local {
 	unsigned int wmm_acm; /* bit field of ACM bits (BIT(802.1D tag)) */
 
 	bool powersave;
+	bool pspolling;
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
@@ -902,6 +903,8 @@ u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    enum ieee80211_band band);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      u8 *ssid, size_t ssid_len);
+void ieee80211_send_pspoll(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c7e61e2..c8778f3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -475,6 +475,41 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb, ifsta->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
+void ieee80211_send_pspoll(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_pspoll *pspoll;
+	struct sk_buff *skb;
+	u16 fc;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*pspoll));
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for "
+		       "pspoll frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	pspoll = (struct ieee80211_pspoll *) skb_put(skb, sizeof(*pspoll));
+	memset(pspoll, 0, sizeof(*pspoll));
+	fc = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL;
+	pspoll->frame_control = cpu_to_le16(fc);
+	pspoll->aid = cpu_to_le16(ifsta->aid);
+
+	/* aid in PS-Poll has its two MSBs each set to 1 */
+	pspoll->aid |= cpu_to_le16(1 << 15 | 1 << 14);
+
+	memcpy(pspoll->bssid, ifsta->bssid, ETH_ALEN);
+	memcpy(pspoll->ta, sdata->dev->dev_addr, ETH_ALEN);
+
+	printk(KERN_DEBUG "sending ps-poll");
+
+	ieee80211_tx_skb(sdata, skb, 0);
+
+	return;
+}
+
 /* MLME */
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_bss *bss)
@@ -1816,9 +1851,8 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		directed_tim = ieee80211_check_tim(&elems, ifsta->aid);
 
 		if (directed_tim) {
-			local->hw.conf.flags &= ~IEEE80211_CONF_PS;
-			ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
-			ieee80211_send_nullfunc(local, sdata, 0);
+			local->pspolling = true;
+			ieee80211_send_pspoll(local, sdata);
 		}
 	}
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9fd9d21..7d24dde 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -740,6 +740,40 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	return result;
 }
 
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
+{
+	struct ieee80211_local *local;
+	struct ieee80211_hdr *hdr;
+	struct sk_buff *skb;
+
+	local = rx->local;
+	skb = rx->skb;
+	hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (!local->pspolling)
+		return RX_CONTINUE;
+
+	if (!ieee80211_has_fromds(hdr->frame_control))
+		/* this is not from AP */
+		return RX_CONTINUE;
+
+	if (!ieee80211_is_data(hdr->frame_control))
+		return RX_CONTINUE;
+
+	if (!ieee80211_has_moredata(hdr->frame_control)) {
+		/* AP has no more frames buffered for us */
+		printk(KERN_DEBUG "no more data");
+		local->pspolling = false;
+		return RX_CONTINUE;
+	}
+
+	/* more data bit is set, let's request a new frame from the AP */
+	ieee80211_send_pspoll(local, rx->sdata);
+
+	return 0;
+}
+
 static void ap_sta_ps_start(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -2006,6 +2040,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 	CALL_RXH(ieee80211_rx_h_passive_scan)
 	CALL_RXH(ieee80211_rx_h_check)
 	CALL_RXH(ieee80211_rx_h_decrypt)
+	CALL_RXH(ieee80211_rx_h_check_more_data)
 	CALL_RXH(ieee80211_rx_h_sta_process)
 	CALL_RXH(ieee80211_rx_h_defragment)
 	CALL_RXH(ieee80211_rx_h_ps_poll)

