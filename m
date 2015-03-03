Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32351 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540AbbCCMXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 07:23:50 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [RFC 2/2] mac80211: store low ack threshold in bss config
Date: Tue, 3 Mar 2015 17:53:03 +0530
Message-ID: <1425385383-25482-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150303_132414_408422_0D5F0F3D)
In-Reply-To: <1425385383-25482-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1425385383-25482-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store the low ack threshold configured by user in BSS config.
This will be used by driver for triggering low ack event whenever
the station is not ACKing the number of frames mentioned in
threshold.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 include/net/mac80211.h | 3 +++
 net/mac80211/cfg.c     | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d52914b..ec769dd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -383,6 +383,8 @@ enum ieee80211_rssi_event {
  *	userspace), whereas TPC is disabled if %txpower_type is set to
  *	NL80211_TX_POWER_FIXED (use value configured from userspace)
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
+ * @low_ack_threshold: Number of consecutive packet loss to trigger low ack
+ *	event by driver.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -419,6 +421,7 @@ struct ieee80211_bss_conf {
 	int txpower;
 	enum nl80211_tx_power_setting txpower_type;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
+	int low_ack_threshold;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dd4ff36..514d3ab 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -772,6 +772,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = params->dtim_period;
 	sdata->vif.bss_conf.enable_beacon = true;
+	sdata->vif.bss_conf.low_ack_threshold = params->low_ack_threshold;
 
 	sdata->vif.bss_conf.ssid_len = params->ssid_len;
 	if (params->ssid_len)
-- 
2.3.1

