Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9215 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751058AbbAMGJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 01:09:17 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0D69H36011036
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:17 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rubhvwnv4-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:17 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/8] mwifiex: set wiphy params only once
Date: Tue, 13 Jan 2015 17:08:44 +0530
Message-ID: <1421149130-5889-3-git-send-email-patila@marvell.com> (sfid-20150113_070921_898320_53F75F3E)
In-Reply-To: <1421149130-5889-1-git-send-email-patila@marvell.com>
References: <1421149130-5889-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RTS threshold, fragmentation threshold are per device properties.
Setting them on any interface would be reflected for all other
interfaces as well. This patch removes unnesessary command download
per interface.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 111 ++++++++++++++------------------
 1 file changed, 48 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6227734..98dd135 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -590,77 +590,62 @@ mwifiex_cfg80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	struct mwifiex_adapter *adapter = mwifiex_cfg80211_get_adapter(wiphy);
 	struct mwifiex_private *priv;
 	struct mwifiex_uap_bss_param *bss_cfg;
-	int ret, bss_started, i;
-
-	for (i = 0; i < adapter->priv_num; i++) {
-		priv = adapter->priv[i];
-
-		switch (priv->bss_role) {
-		case MWIFIEX_BSS_ROLE_UAP:
-			bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param),
-					  GFP_KERNEL);
-			if (!bss_cfg)
-				return -ENOMEM;
-
-			mwifiex_set_sys_config_invalid_data(bss_cfg);
-
-			if (changed & WIPHY_PARAM_RTS_THRESHOLD)
-				bss_cfg->rts_threshold = wiphy->rts_threshold;
-			if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
-				bss_cfg->frag_threshold = wiphy->frag_threshold;
-			if (changed & WIPHY_PARAM_RETRY_LONG)
-				bss_cfg->retry_limit = wiphy->retry_long;
-
-			bss_started = priv->bss_started;
-
-			ret = mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
-					       HostCmd_ACT_GEN_SET, 0,
-					       NULL, true);
-			if (ret) {
-				wiphy_err(wiphy, "Failed to stop the BSS\n");
-				kfree(bss_cfg);
-				return ret;
-			}
+	int ret;
 
-			ret = mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
-					       HostCmd_ACT_GEN_SET,
-					       UAP_BSS_PARAMS_I, bss_cfg,
-					       false);
+	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 
-			kfree(bss_cfg);
+	switch (priv->bss_role) {
+	case MWIFIEX_BSS_ROLE_UAP:
+		if (priv->bss_started) {
+			dev_err(adapter->dev,
+				"cannot change wiphy params when bss started");
+			return -EINVAL;
+		}
 
-			if (ret) {
-				wiphy_err(wiphy, "Failed to set bss config\n");
-				return ret;
-			}
+		bss_cfg = kzalloc(sizeof(*bss_cfg), GFP_KERNEL);
+		if (!bss_cfg)
+			return -ENOMEM;
 
-			if (!bss_started)
-				break;
+		mwifiex_set_sys_config_invalid_data(bss_cfg);
 
-			ret = mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
-					       HostCmd_ACT_GEN_SET, 0,
-					       NULL, false);
-			if (ret) {
-				wiphy_err(wiphy, "Failed to start BSS\n");
-				return ret;
-			}
+		if (changed & WIPHY_PARAM_RTS_THRESHOLD)
+			bss_cfg->rts_threshold = wiphy->rts_threshold;
+		if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
+			bss_cfg->frag_threshold = wiphy->frag_threshold;
+		if (changed & WIPHY_PARAM_RETRY_LONG)
+			bss_cfg->retry_limit = wiphy->retry_long;
+
+		ret = mwifiex_send_cmd(priv, HostCmd_CMD_UAP_SYS_CONFIG,
+				       HostCmd_ACT_GEN_SET,
+				       UAP_BSS_PARAMS_I, bss_cfg,
+				       false);
+
+		kfree(bss_cfg);
+		if (ret) {
+			wiphy_err(wiphy, "Failed to set wiphy phy params\n");
+			return ret;
+		}
+		break;
 
-			break;
 		case MWIFIEX_BSS_ROLE_STA:
-			if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
-				ret = mwifiex_set_rts(priv,
-						      wiphy->rts_threshold);
-				if (ret)
-					return ret;
-			}
-			if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
-				ret = mwifiex_set_frag(priv,
-						       wiphy->frag_threshold);
-				if (ret)
-					return ret;
-			}
-			break;
+		if (priv->media_connected) {
+			dev_err(adapter->dev,
+				"cannot change wiphy params when connected");
+			return -EINVAL;
+		}
+		if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+			ret = mwifiex_set_rts(priv,
+					      wiphy->rts_threshold);
+			if (ret)
+				return ret;
 		}
+		if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+			ret = mwifiex_set_frag(priv,
+					       wiphy->frag_threshold);
+			if (ret)
+				return ret;
+		}
+		break;
 	}
 
 	return 0;
-- 
1.8.1.4

