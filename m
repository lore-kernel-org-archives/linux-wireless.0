Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:64897 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161852Ab3DEOqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 10:46:33 -0400
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] mac80211: provide SSID for IBSS vif
Date: Fri, 5 Apr 2013 16:46:21 +0200
Message-ID: <1365173181-5142-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20130405_164638_122551_9E474C01)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers need SSID in AP and IBSS mode. AP SSID is provided
through BSS_CHANGED_SSID notification. There was no easy way
to do the same for IBSS. In IBSS mode SSID is known but was
not stored in BSS configuration. This patch provides functionality
which stores IBSS ssid in BSS conf and expands BSS_CHANGED_SSID
notification to cover also IBSS mode.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---
 include/net/mac80211.h |    4 ++--
 net/mac80211/ibss.c    |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dd73b8c..68330f3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -209,7 +209,7 @@ struct ieee80211_chanctx_conf {
  * @BSS_CHANGED_QOS: QoS for this association was enabled/disabled. Note
  *	that it is only ever disabled for station mode.
  * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
- * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
+ * @BSS_CHANGED_SSID: SSID changed for this BSS (AP and IBSS mode)
  * @BSS_CHANGED_AP_PROBE_RESP: Probe Response changed for this BSS (AP mode)
  * @BSS_CHANGED_PS: PS changed for this BSS (STA mode)
  * @BSS_CHANGED_TXPOWER: TX power setting changed for this interface
@@ -326,7 +326,7 @@ enum ieee80211_rssi_event {
  *	your driver/device needs to do.
  * @ps: power-save mode (STA only). This flag is NOT affected by
  *	offchannel/dynamic_ps operations.
- * @ssid: The SSID of the current vif. Only valid in AP-mode.
+ * @ssid: The SSID of the current vif. Valid in AP and IBSS mode.
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
  * @txpower: TX power in dBm
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 539d4a1..dd86ef7 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -194,6 +194,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.beacon_int = beacon_int;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
+	sdata->vif.bss_conf.ssid_len = ifibss->ssid_len;
+	memcpy(sdata->vif.bss_conf.ssid, ifibss->ssid, ifibss->ssid_len);
 	bss_change = BSS_CHANGED_BEACON_INT;
 	bss_change |= ieee80211_reset_erp_info(sdata);
 	bss_change |= BSS_CHANGED_BSSID;
@@ -202,6 +204,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_BASIC_RATES;
 	bss_change |= BSS_CHANGED_HT;
 	bss_change |= BSS_CHANGED_IBSS;
+	bss_change |= BSS_CHANGED_SSID;
 
 	/*
 	 * In 5 GHz/802.11a, we can always use short slot time.
-- 
1.7.0.4

