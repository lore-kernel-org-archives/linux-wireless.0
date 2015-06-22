Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56463 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933010AbbFVIHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:07:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M7xsAR015567
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:20 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v55hgut7p-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:07:19 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 07/17] mwifiex: enable tdls channel switch ext_cap
Date: Mon, 22 Jun 2015 19:06:13 +0530
Message-ID: <1434980183-2901-8-git-send-email-patila@marvell.com> (sfid-20150622_100723_540854_4950CF02)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch enable tdls channel switch ext capability in tdls action
frame, and also configure basic tdls channel switch parameters while
tdls setup completed and tdls link is enabled..

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/tdls.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 03eabd7..f862ca6 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -355,6 +355,7 @@ static void mwifiex_tdls_add_ext_capab(struct mwifiex_private *priv,
 	extcap->ieee_hdr.len = 8;
 	memset(extcap->ext_capab, 0, 8);
 	extcap->ext_capab[4] |= WLAN_EXT_CAPA5_TDLS_ENABLED;
+	extcap->ext_capab[3] |= WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH;
 
 	if (priv->adapter->is_hw_11ac_capable)
 		extcap->ext_capab[7] |= WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED;
@@ -1071,6 +1072,11 @@ mwifiex_tdls_process_enable_link(struct mwifiex_private *priv, const u8 *peer)
 			for (i = 0; i < MAX_NUM_TID; i++)
 				sta_ptr->ampdu_sta[i] = BA_STREAM_NOT_ALLOWED;
 		}
+		if (sta_ptr->tdls_cap.extcap.ext_capab[3] &
+		    WLAN_EXT_CAPA4_TDLS_CHAN_SWITCH) {
+			mwifiex_config_tdls_enable(priv);
+			mwifiex_config_tdls_cs_params(priv);
+		}
 
 		memset(sta_ptr->rx_seq, 0xff, sizeof(sta_ptr->rx_seq));
 		mwifiex_restore_tdls_packets(priv, peer, TDLS_SETUP_COMPLETE);
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
