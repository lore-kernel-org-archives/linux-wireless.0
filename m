Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:42837 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab3ACA4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 19:56:21 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: use correct htcapinfo for HT20 ibss network
Date: Wed,  2 Jan 2013 16:56:00 -0800
Message-Id: <1357174561-28898-1-git-send-email-bzhao@marvell.com> (sfid-20130103_015629_977988_BE77871C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

It is observed that same htcapinfo ie is included in beacon for
HT20, HT40+ and HT40- ibss networks. This patch makes sure that
we will not advertise 40Mhz flags while creating/joining ibss
network in HT20 mode.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c  |    4 +++-
 drivers/net/wireless/mwifiex/join.c |   10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 245a371..9cd6216 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -53,7 +53,9 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
 	       sizeof(sband->ht_cap.mcs));
 
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
-	    sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+	    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 &&
+	     (priv->adapter->sec_chan_offset !=
+					IEEE80211_HT_PARAM_CHA_SEC_NONE)))
 		/* Set MCS32 for infra mode or ad-hoc mode with 40MHz support */
 		SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 88664ae..3c7cabe 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -969,6 +969,16 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 					priv->adapter->config_bands);
 		mwifiex_fill_cap_info(priv, radio_type, ht_cap);
 
+		if (adapter->sec_chan_offset ==
+					IEEE80211_HT_PARAM_CHA_SEC_NONE) {
+			u16 tmp_ht_cap;
+
+			tmp_ht_cap = le16_to_cpu(ht_cap->ht_cap.cap_info);
+			tmp_ht_cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			tmp_ht_cap &= ~IEEE80211_HT_CAP_SGI_40;
+			ht_cap->ht_cap.cap_info = cpu_to_le16(tmp_ht_cap);
+		}
+
 		pos += sizeof(struct mwifiex_ie_types_htcap);
 		cmd_append_size += sizeof(struct mwifiex_ie_types_htcap);
 
-- 
1.7.0.2

