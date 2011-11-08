Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:33934 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750957Ab1KHFld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 00:41:33 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/7] mwifiex: fix ht_cap_info in ibss beacons
Date: Mon,  7 Nov 2011 21:41:06 -0800
Message-Id: <1320730872-25619-2-git-send-email-bzhao@marvell.com> (sfid-20111108_064135_513219_B65E4E79)
In-Reply-To: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
References: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

A local variable is used to calculate ht_cap_info.
Erroneously ht_cap.cap_info isn't updated in the ibss beacons
after the calculation. This patch fixes it.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 62b4c29..062716c 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -922,15 +922,15 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 				cpu_to_le16(WLAN_EID_HT_CAPABILITY);
 			ht_cap->header.len =
 			       cpu_to_le16(sizeof(struct ieee80211_ht_cap));
-			ht_cap_info = le16_to_cpu(ht_cap->ht_cap.cap_info);
 
-			ht_cap_info |= IEEE80211_HT_CAP_SGI_20;
+			ht_cap_info = IEEE80211_HT_CAP_SGI_20;
 			if (adapter->chan_offset) {
 				ht_cap_info |= IEEE80211_HT_CAP_SGI_40;
 				ht_cap_info |= IEEE80211_HT_CAP_DSSSCCK40;
 				ht_cap_info |= IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 				SETHT_MCS32(ht_cap->ht_cap.mcs.rx_mask);
 			}
+			ht_cap->ht_cap.cap_info = cpu_to_le16(ht_cap_info);
 
 			ht_cap->ht_cap.ampdu_params_info
 					= IEEE80211_HT_MAX_AMPDU_64K;
-- 
1.7.0.2

