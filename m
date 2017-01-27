Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:37857 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932757AbdA0M14 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:27:56 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 5/5] brcmfmac: add .update_connect_params() callback
Date: Fri, 27 Jan 2017 12:27:48 +0000
Message-Id: <1485520068-5807-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170127_133143_998294_3899FD2A)
In-Reply-To: <1485520068-5807-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1485520068-5807-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for the .update_connect_params() callback for roaming
or subsequent (re)association.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index ab1f9f2..0e28d07 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5067,6 +5067,29 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	return ret;
 }
 
+static int
+brcmf_cfg80211_update_conn_params(struct wiphy *wiphy,
+				  struct net_device *ndev,
+				  struct cfg80211_connect_params *sme,
+				  u32 changed)
+{
+	struct brcmf_if *ifp;
+	int err;
+
+	if (!(changed & UPDATE_ASSOC_IES))
+		return 0;
+
+	ifp = netdev_priv(ndev);
+	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
+				    sme->ie, sme->ie_len);
+	if (err)
+		brcmf_err("Set Assoc REQ IE Failed\n");
+	else
+		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc request\n");
+
+	return err;
+}
+
 #ifdef CONFIG_PM
 static int
 brcmf_cfg80211_set_rekey_data(struct wiphy *wiphy, struct net_device *ndev,
@@ -5134,6 +5157,7 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	.crit_proto_start = brcmf_cfg80211_crit_proto_start,
 	.crit_proto_stop = brcmf_cfg80211_crit_proto_stop,
 	.tdls_oper = brcmf_cfg80211_tdls_oper,
+	.update_connect_params = brcmf_cfg80211_update_conn_params,
 };
 
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
-- 
1.9.1
