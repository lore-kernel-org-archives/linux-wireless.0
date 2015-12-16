Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8727 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933377AbbLPMXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 07:23:52 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBGCN12P029745
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 04:23:50 -0800
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yu7wpr02h-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 04:23:50 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/4] mwifiex: fix potential integer truncation
Date: Wed, 16 Dec 2015 04:21:42 -0800
Message-ID: <1450268505-2682-1-git-send-email-akarwar@marvell.com> (sfid-20151216_132355_308062_4E09EC1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

At some places, ie length is truncated from u16 to u8 while
storing it to driver's internal variable. This patch fixes
the problem.

Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.h      | 6 +++---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 0fa1d8e..2f7f478 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -564,14 +564,14 @@ struct mwifiex_private {
 	struct mwifiex_wep_key wep_key[NUM_WEP_KEYS];
 	u16 wep_key_curr_index;
 	u8 wpa_ie[256];
-	u8 wpa_ie_len;
+	u16 wpa_ie_len;
 	u8 wpa_is_gtk_set;
 	struct host_cmd_ds_802_11_key_material aes_key;
 	struct host_cmd_ds_802_11_key_material_v2 aes_key_v2;
 	u8 wapi_ie[256];
-	u8 wapi_ie_len;
+	u16 wapi_ie_len;
 	u8 *wps_ie;
-	u8 wps_ie_len;
+	u16 wps_ie_len;
 	u8 wmm_required;
 	u8 wmm_enabled;
 	u8 wmm_qosinfo;
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 439e73f..6a4fc5d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -759,7 +759,7 @@ static int mwifiex_set_wpa_ie_helper(struct mwifiex_private *priv,
 			return -1;
 		}
 		memcpy(priv->wpa_ie, ie_data_ptr, ie_len);
-		priv->wpa_ie_len = (u8) ie_len;
+		priv->wpa_ie_len = ie_len;
 		mwifiex_dbg(priv->adapter, CMD,
 			    "cmd: Set Wpa_ie_len=%d IE=%#x\n",
 			    priv->wpa_ie_len, priv->wpa_ie[0]);
-- 
1.8.1.4

