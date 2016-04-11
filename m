Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31787 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbcDKOxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 10:53:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3BEpSDa016293
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:22 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 226y3kdqvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 07:53:22 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/5] mwifiex: fix incorrect ht capability problem
Date: Mon, 11 Apr 2016 07:52:41 -0700
Message-ID: <1460386361-29918-5-git-send-email-akarwar@marvell.com> (sfid-20160411_165401_959763_704A2E3F)
In-Reply-To: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
References: <1460386361-29918-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_CHAN_NO_HT40PLUS and IEEE80211_CHAN_NO_HT40PLUS channel
flags tell if HT40 operation is allowed on a channel or not.

This patch ensures ht_capability information is modified
accordingly so that we don't end up creating a HT40 connection
when it's not allowed for current regulatory domain.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 44 +++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index d8de432..8e08626 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -146,6 +146,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	size_t beacon_ie_len;
 	struct mwifiex_bss_priv *bss_priv = (void *)bss->priv;
 	const struct cfg80211_bss_ies *ies;
+	int ret;
 
 	rcu_read_lock();
 	ies = rcu_dereference(bss->ies);
@@ -189,7 +190,48 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_SPECTRUM_MGMT)
 		bss_desc->sensed_11h = true;
 
-	return mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
+	ret = mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
+	if (ret)
+		return ret;
+
+	/* Update HT40 capability based on current channel information */
+	if (bss_desc->bcn_ht_oper && bss_desc->bcn_ht_cap) {
+		u8 ht_param = bss_desc->bcn_ht_oper->ht_param;
+		u8 radio = mwifiex_band_to_radio_type(bss_desc->bss_band);
+		struct ieee80211_supported_band *sband =
+						priv->wdev.wiphy->bands[radio];
+		int freq = ieee80211_channel_to_frequency(bss_desc->channel,
+							  radio);
+		struct ieee80211_channel *chan =
+			ieee80211_get_channel(priv->adapter->wiphy, freq);
+
+		switch (ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+			if (chan->flags & IEEE80211_CHAN_NO_HT40PLUS) {
+				sband->ht_cap.cap &=
+					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+				sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
+			} else {
+				sband->ht_cap.cap |=
+					IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+					IEEE80211_HT_CAP_SGI_40;
+			}
+			break;
+		case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+			if (chan->flags & IEEE80211_CHAN_NO_HT40MINUS) {
+				sband->ht_cap.cap &=
+					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+				sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
+			} else {
+				sband->ht_cap.cap |=
+					IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+					IEEE80211_HT_CAP_SGI_40;
+			}
+			break;
+		}
+	}
+
+	return 0;
 }
 
 void mwifiex_dnld_txpwr_table(struct mwifiex_private *priv)
-- 
1.8.1.4

