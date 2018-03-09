Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59334 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932165AbeCISUZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 13:20:25 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 1/3] Revert "mwifiex: fix incorrect ht capability problem"
Date: Fri, 9 Mar 2018 23:45:24 +0530
Message-ID: <1520619326-14888-2-git-send-email-gbhat@marvell.com> (sfid-20180309_192047_646839_7A7C82E3)
In-Reply-To: <1520619326-14888-1-git-send-email-gbhat@marvell.com>
References: <1520619326-14888-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit bcc920e8f08336cbbdcdba7c4449c27137e6b4b9.

Drivers gets hardware info and updates ht_cap field of
wiphy->bands during initialization. Once updated during init,
ht_cap must not be modified as it reflects the capability
supported by hardwawre. Above patch tries to modify the ht_cap
field and this results in wrongly advertising capabilities during
association.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 44 +-----------------------
 1 file changed, 1 insertion(+), 43 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index a6077ab..ed66f12 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -146,7 +146,6 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	size_t beacon_ie_len;
 	struct mwifiex_bss_priv *bss_priv = (void *)bss->priv;
 	const struct cfg80211_bss_ies *ies;
-	int ret;
 
 	rcu_read_lock();
 	ies = rcu_dereference(bss->ies);
@@ -190,48 +189,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_SPECTRUM_MGMT)
 		bss_desc->sensed_11h = true;
 
-	ret = mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
-	if (ret)
-		return ret;
-
-	/* Update HT40 capability based on current channel information */
-	if (bss_desc->bcn_ht_oper && bss_desc->bcn_ht_cap) {
-		u8 ht_param = bss_desc->bcn_ht_oper->ht_param;
-		u8 radio = mwifiex_band_to_radio_type(bss_desc->bss_band);
-		struct ieee80211_supported_band *sband =
-						priv->wdev.wiphy->bands[radio];
-		int freq = ieee80211_channel_to_frequency(bss_desc->channel,
-							  radio);
-		struct ieee80211_channel *chan =
-			ieee80211_get_channel(priv->adapter->wiphy, freq);
-
-		switch (ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-			if (chan->flags & IEEE80211_CHAN_NO_HT40PLUS) {
-				sband->ht_cap.cap &=
-					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-				sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
-			} else {
-				sband->ht_cap.cap |=
-					IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-					IEEE80211_HT_CAP_SGI_40;
-			}
-			break;
-		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-			if (chan->flags & IEEE80211_CHAN_NO_HT40MINUS) {
-				sband->ht_cap.cap &=
-					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-				sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
-			} else {
-				sband->ht_cap.cap |=
-					IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
-					IEEE80211_HT_CAP_SGI_40;
-			}
-			break;
-		}
-	}
-
-	return 0;
+	return mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
 }
 
 void mwifiex_dnld_txpwr_table(struct mwifiex_private *priv)
-- 
1.9.1
