Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59340 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751249AbeCISU2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 13:20:28 -0500
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 2/3] mwifiex: fix incorrect ht capability problem
Date: Fri, 9 Mar 2018 23:45:25 +0530
Message-ID: <1520619326-14888-3-git-send-email-gbhat@marvell.com> (sfid-20180309_192037_417668_91E9A0F8)
In-Reply-To: <1520619326-14888-1-git-send-email-gbhat@marvell.com>
References: <1520619326-14888-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE80211_CHAN_NO_HT40PLUS and IEEE80211_CHAN_NO_HT40PLUS channel
flags tell if HT40 operation is allowed on a channel or not.

This patch ensures ht_capability information is modified
accordingly so that we don't end up creating a HT40 connection
when it's not allowed for current regulatory domain.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index 8772e39..feebfdc 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -341,6 +341,36 @@ int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
 		       le16_to_cpu(ht_cap->header.len));
 
 		mwifiex_fill_cap_info(priv, radio_type, &ht_cap->ht_cap);
+		/* Update HT40 capability from current channel information */
+		if (bss_desc->bcn_ht_oper) {
+			u8 ht_param = bss_desc->bcn_ht_oper->ht_param;
+			u8 radio =
+			mwifiex_band_to_radio_type(bss_desc->bss_band);
+			int freq =
+			ieee80211_channel_to_frequency(bss_desc->channel,
+						       radio);
+			struct ieee80211_channel *chan =
+			ieee80211_get_channel(priv->adapter->wiphy, freq);
+
+			switch (ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+				if (chan->flags & IEEE80211_CHAN_NO_HT40PLUS) {
+					ht_cap->ht_cap.cap_info &=
+					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+					ht_cap->ht_cap.cap_info &=
+					~IEEE80211_HT_CAP_SGI_40;
+				}
+				break;
+			case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+				if (chan->flags & IEEE80211_CHAN_NO_HT40MINUS) {
+					ht_cap->ht_cap.cap_info &=
+					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+					ht_cap->ht_cap.cap_info &=
+					~IEEE80211_HT_CAP_SGI_40;
+				}
+				break;
+			}
+		}
 
 		*buffer += sizeof(struct mwifiex_ie_types_htcap);
 		ret_len += sizeof(struct mwifiex_ie_types_htcap);
-- 
1.9.1
