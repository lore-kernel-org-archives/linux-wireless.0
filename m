Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2EB6C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 14:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CD132192D
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 14:46:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FshRcVH5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437220AbfBOOqU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 09:46:20 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32797 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395136AbfBOOqT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 09:46:19 -0500
Received: by mail-lf1-f68.google.com with SMTP id q12so7411821lfm.0
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2019 06:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T7LbnX30prZmdENppywVVOwhOr2bF0pejDx7zHOe/eU=;
        b=FshRcVH5i4itoVMGu8NiLmbBrQIh43155MdvToSt8oORbAGbQfW37rhnNQeu1O/97u
         DWYZW64WUScCghw4Hq2Ped5aW6FJUKeX5t6EXf9N0s5JaiVZs0u76rks+dkD8CrKp/bN
         zxoVrwmxDSdlnqwtQeOZ+PCkuCTjC6356JrXUiQAdSNUc9woxXmeI24O1evUf9c/VMBp
         L+Wf6Wx3NGFEw175gXXP4eDe4G+CfAHiSikYr4nyuRGxkn3lDemD+iFtInPtLztLkII4
         IgctS54kGeUc5gTHGfKPhvBbCG4XtapEeOeJHocMo5NfC0O4sizE+pX4ege/9JCo5q8T
         Mbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T7LbnX30prZmdENppywVVOwhOr2bF0pejDx7zHOe/eU=;
        b=ZHyjbfhglNBeS5yG7bqTSwj6pvK9IRUi4xPkO2RmUl8fk0o4fiZQTk9Q/3ciFKh0b0
         13aZDfCmEwk8TpwZUqJKUoqNhxblw7mw6SLuMk416bn+dr2sNJBNUE+HjxgcDZnLMysG
         G5yjrLWkmwCCQn2Bmgghy5cRZBYqlMIohh/75FYLTEZJcWD1BatFEJ8PzxgIcc18C2tM
         rO2iX9N8fy5OvJrZcNBYUEqEDCgfejOr3TcRQ3u8BAXjvKXNlx0dohblNeSLgz2TE0Ki
         qog+Bj31LYLOqMgcuBmSMWXtVtd+J9BP1Lfj7yitasvBxFpRMBe3BRUwB1n59kYs4qH8
         gYEQ==
X-Gm-Message-State: AHQUAubaDggPLi/1r8ZVC/PW3NVbXVEvHYRzgGGHta8S00oi04t8qmEJ
        jVvlSzRWEflIJF5IC26r1fw=
X-Google-Smtp-Source: AHgI3IbAI2vUK4qE4KOaCgWi1KwgIAxFqQUCQ6mjfO/XwLJeQydTh3Uxg4FFtkyUj46JN5S7cTgohg==
X-Received: by 2002:a19:41cd:: with SMTP id o196mr5721623lfa.82.1550241973003;
        Fri, 15 Feb 2019 06:46:13 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id m18sm1327025lfh.43.2019.02.15.06.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Feb 2019 06:46:11 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: rework bphy_err() to take struct brcmf_pub argument
Date:   Fri, 15 Feb 2019 15:45:54 +0100
Message-Id: <20190215144554.6860-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This macro will be used in more places not just the cfg80211.c. It makes
sense to pass some common struct to it as "struct wiphy" is mostly
referenced in cfg80211 code only.

A very common one (used above the bus abstraction layer) is struct
brcmf_pub. Many functions already keep reference to it which will make
using bphy_err() simpler. It should also allow extending that macro's
logic if it's ever needed.

This improves code recently added in the commit 3ef005b82e2a ("brcmfmac:
add bphy_err() and use it in the cfg80211.c").

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
While working on the:
[PATCH] brcmfmac: use bphy_err() in all wiphy-related code
[PATCH V2] brcmfmac: use bphy_err() in all wiphy-related code
[PATCH V3] brcmfmac: use bphy_err() in all wiphy-related code

I realized it would be:
1) Simpler for the rest of the code
2) More consistent with driver's design
to make bphy_err() take brcmfmac's internal & generic struct as
argument.

So I put above work on hold & I decided to modify bphy_err() to sth more
generic before we start using it all around.
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 510 ++++++++++--------
 .../broadcom/brcm80211/brcmfmac/debug.h       |   4 +-
 2 files changed, 281 insertions(+), 233 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index fa752ec04f22..60b5fb29e5f3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -457,7 +457,7 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 static int
 send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	int err;
 	struct brcmf_wsec_key_le key_le;
 
@@ -469,7 +469,7 @@ send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 					sizeof(key_le));
 
 	if (err)
-		bphy_err(wiphy, "wsec_key error (%d)\n", err);
+		bphy_err(drvr, "wsec_key error (%d)\n", err);
 	return err;
 }
 
@@ -509,7 +509,7 @@ static int brcmf_get_first_free_bsscfgidx(struct brcmf_pub *drvr)
 
 static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_mbss_ssid_le mbss_ssid_le;
 	int bsscfgidx;
 	int err;
@@ -526,7 +526,7 @@ static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
 	err = brcmf_fil_bsscfg_data_set(ifp, "bsscfg:ssid", &mbss_ssid_le,
 					sizeof(mbss_ssid_le));
 	if (err < 0)
-		bphy_err(wiphy, "setting ssid failed %d\n", err);
+		bphy_err(drvr, "setting ssid failed %d\n", err);
 
 	return err;
 }
@@ -544,6 +544,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	int err;
 
@@ -569,7 +570,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
-		bphy_err(wiphy, "timeout occurred\n");
+		bphy_err(drvr, "timeout occurred\n");
 		err = -EIO;
 		goto fail;
 	}
@@ -577,7 +578,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	/* interface created in firmware */
 	ifp = vif->ifp;
 	if (!ifp) {
-		bphy_err(wiphy, "no if pointer provided\n");
+		bphy_err(drvr, "no if pointer provided\n");
 		err = -ENOENT;
 		goto fail;
 	}
@@ -585,7 +586,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
-		bphy_err(wiphy, "Registering netdevice failed\n");
+		bphy_err(drvr, "Registering netdevice failed\n");
 		free_netdev(ifp->ndev);
 		goto fail;
 	}
@@ -616,13 +617,15 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     enum nl80211_iftype type,
 						     struct vif_params *params)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct wireless_dev *wdev;
 	int err;
 
 	brcmf_dbg(TRACE, "enter: %s type %d\n", name, type);
 	err = brcmf_vif_add_validate(wiphy_to_cfg(wiphy), type);
 	if (err) {
-		bphy_err(wiphy, "iface validation failed: err=%d\n", err);
+		bphy_err(drvr, "iface validation failed: err=%d\n", err);
 		return ERR_PTR(err);
 	}
 	switch (type) {
@@ -647,7 +650,7 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	}
 
 	if (IS_ERR(wdev))
-		bphy_err(wiphy, "add iface %s type %d failed: err=%d\n", name,
+		bphy_err(drvr, "add iface %s type %d failed: err=%d\n", name,
 			 type, (int)PTR_ERR(wdev));
 	else
 		brcmf_cfg80211_update_proto_addr_mode(wdev);
@@ -663,13 +666,13 @@ static void brcmf_scan_config_mpc(struct brcmf_if *ifp, int mpc)
 
 void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err = 0;
 
 	if (check_vif_up(ifp->vif)) {
 		err = brcmf_fil_iovar_int_set(ifp, "mpc", mpc);
 		if (err) {
-			bphy_err(wiphy, "fail to set mpc\n");
+			bphy_err(drvr, "fail to set mpc\n");
 			return;
 		}
 		brcmf_dbg(INFO, "MPC : %d\n", mpc);
@@ -680,7 +683,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				struct brcmf_if *ifp, bool aborted,
 				bool fw_abort)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_scan_params_le params_le;
 	struct cfg80211_scan_request *scan_request;
 	u64 reqid;
@@ -715,7 +718,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
 					     &params_le, sizeof(params_le));
 		if (err)
-			bphy_err(wiphy, "Scan abort failed\n");
+			bphy_err(drvr, "Scan abort failed\n");
 	}
 
 	brcmf_scan_config_mpc(ifp, 1);
@@ -760,6 +763,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = wdev->netdev;
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 	int ret;
 	int err;
 
@@ -767,7 +771,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 
 	err = brcmf_fil_bsscfg_data_set(ifp, "interface_remove", NULL, 0);
 	if (err) {
-		bphy_err(wiphy, "interface_remove failed %d\n", err);
+		bphy_err(drvr, "interface_remove failed %d\n", err);
 		goto err_unarm;
 	}
 
@@ -775,7 +779,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 	ret = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_DEL,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	if (!ret) {
-		bphy_err(wiphy, "timeout occurred\n");
+		bphy_err(drvr, "timeout occurred\n");
 		err = -EIO;
 		goto err_unarm;
 	}
@@ -838,6 +842,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 infra = 0;
 	s32 ap = 0;
 	s32 err = 0;
@@ -877,13 +882,13 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 	err = brcmf_vif_change_validate(wiphy_to_cfg(wiphy), vif, type);
 	if (err) {
-		bphy_err(wiphy, "iface validation failed: err=%d\n", err);
+		bphy_err(drvr, "iface validation failed: err=%d\n", err);
 		return err;
 	}
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_WDS:
-		bphy_err(wiphy, "type (%d) : currently we do not support this type\n",
+		bphy_err(drvr, "type (%d) : currently we do not support this type\n",
 			 type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
@@ -912,7 +917,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	} else {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, infra);
 		if (err) {
-			bphy_err(wiphy, "WLC_SET_INFRA error (%d)\n", err);
+			bphy_err(drvr, "WLC_SET_INFRA error (%d)\n", err);
 			err = -EAGAIN;
 			goto done;
 		}
@@ -1003,7 +1008,7 @@ static s32
 brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		struct cfg80211_scan_request *request)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
 			  offsetof(struct brcmf_escan_params_le, params_le);
 	struct brcmf_escan_params_le *params;
@@ -1035,7 +1040,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		if (err == -EBUSY)
 			brcmf_dbg(INFO, "system busy : escan canceled\n");
 		else
-			bphy_err(wiphy, "error (%d)\n", err);
+			bphy_err(drvr, "error (%d)\n", err);
 	}
 
 	kfree(params);
@@ -1072,6 +1077,7 @@ static s32
 brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
 
@@ -1081,22 +1087,22 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		return -EIO;
 
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		bphy_err(wiphy, "Scanning already: status (%lu)\n",
+		bphy_err(drvr, "Scanning already: status (%lu)\n",
 			 cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status)) {
-		bphy_err(wiphy, "Scanning being aborted: status (%lu)\n",
+		bphy_err(drvr, "Scanning being aborted: status (%lu)\n",
 			 cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
-		bphy_err(wiphy, "Scanning suppressed: status (%lu)\n",
+		bphy_err(drvr, "Scanning suppressed: status (%lu)\n",
 			 cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state)) {
-		bphy_err(wiphy, "Connecting: status (%lu)\n", vif->sme_state);
+		bphy_err(drvr, "Connecting: status (%lu)\n", vif->sme_state);
 		return -EAGAIN;
 	}
 
@@ -1130,7 +1136,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	return 0;
 
 scan_out:
-	bphy_err(wiphy, "scan error (%d)\n", err);
+	bphy_err(drvr, "scan error (%d)\n", err);
 	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	cfg->scan_request = NULL;
 	return err;
@@ -1139,12 +1145,12 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err = 0;
 
 	err = brcmf_fil_iovar_int_set(ifp, "rtsthresh", rts_threshold);
 	if (err)
-		bphy_err(wiphy, "Error (%d)\n", err);
+		bphy_err(drvr, "Error (%d)\n", err);
 
 	return err;
 }
@@ -1152,13 +1158,13 @@ static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err = 0;
 
 	err = brcmf_fil_iovar_int_set(ifp, "fragthresh",
 				      frag_threshold);
 	if (err)
-		bphy_err(wiphy, "Error (%d)\n", err);
+		bphy_err(drvr, "Error (%d)\n", err);
 
 	return err;
 }
@@ -1166,13 +1172,13 @@ static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err = 0;
 	u32 cmd = (l ? BRCMF_C_SET_LRL : BRCMF_C_SET_SRL);
 
 	err = brcmf_fil_cmd_int_set(ifp, cmd, retry);
 	if (err) {
-		bphy_err(wiphy, "cmd (%d) , error (%d)\n", cmd, err);
+		bphy_err(drvr, "cmd (%d) , error (%d)\n", cmd, err);
 		return err;
 	}
 	return err;
@@ -1248,7 +1254,7 @@ static u16 brcmf_map_fw_linkdown_reason(const struct brcmf_event_msg *e)
 
 static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_wsec_pmk_le pmk;
 	int i, err;
 
@@ -1262,7 +1268,7 @@ static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
 				     &pmk, sizeof(pmk));
 	if (err < 0)
-		bphy_err(wiphy, "failed to change PSK in firmware (len=%u)\n",
+		bphy_err(drvr, "failed to change PSK in firmware (len=%u)\n",
 			 pmk_len);
 
 	return err;
@@ -1271,7 +1277,7 @@ static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(vif->wdev.wiphy);
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1281,7 +1287,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 		err = brcmf_fil_cmd_data_set(vif->ifp,
 					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err) {
-			bphy_err(wiphy, "WLC_DISASSOC failed (%d)\n", err);
+			bphy_err(drvr, "WLC_DISASSOC failed (%d)\n", err);
 		}
 		if ((vif->wdev.iftype == NL80211_IFTYPE_STATION) ||
 		    (vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT))
@@ -1305,6 +1311,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_join_params join_params;
 	size_t join_params_size = 0;
 	s32 err = 0;
@@ -1369,7 +1376,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_iovar_int_set(ifp, "wsec", wsec);
 	if (err) {
-		bphy_err(wiphy, "wsec failed (%d)\n", err);
+		bphy_err(drvr, "wsec failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1381,7 +1388,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD, bcnprd);
 	if (err) {
-		bphy_err(wiphy, "WLC_SET_BCNPRD failed (%d)\n", err);
+		bphy_err(drvr, "WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1426,7 +1433,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_CHANNEL,
 					    target_channel);
 		if (err) {
-			bphy_err(wiphy, "WLC_SET_CHANNEL failed (%d)\n", err);
+			bphy_err(drvr, "WLC_SET_CHANNEL failed (%d)\n", err);
 			goto done;
 		}
 	} else
@@ -1438,7 +1445,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err) {
-		bphy_err(wiphy, "WLC_SET_SSID failed (%d)\n", err);
+		bphy_err(drvr, "WLC_SET_SSID failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1475,8 +1482,8 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 				 struct cfg80211_connect_params *sme)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1490,7 +1497,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 	brcmf_dbg(CONN, "setting wpa_auth to 0x%0x\n", val);
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", val);
 	if (err) {
-		bphy_err(wiphy, "set wpa_auth failed (%d)\n", err);
+		bphy_err(drvr, "set wpa_auth failed (%d)\n", err);
 		return err;
 	}
 	sec = &profile->sec;
@@ -1502,8 +1509,8 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 			       struct cfg80211_connect_params *sme)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
 	s32 err = 0;
@@ -1525,7 +1532,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", val);
 	if (err) {
-		bphy_err(wiphy, "set auth failed (%d)\n", err);
+		bphy_err(drvr, "set auth failed (%d)\n", err);
 		return err;
 	}
 	sec = &profile->sec;
@@ -1538,8 +1545,8 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
 	s32 gval = 0;
@@ -1562,7 +1569,7 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 			pval = AES_ENABLED;
 			break;
 		default:
-			bphy_err(wiphy, "invalid cipher pairwise (%d)\n",
+			bphy_err(drvr, "invalid cipher pairwise (%d)\n",
 				 sme->crypto.ciphers_pairwise[0]);
 			return -EINVAL;
 		}
@@ -1583,7 +1590,7 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 			gval = AES_ENABLED;
 			break;
 		default:
-			bphy_err(wiphy, "invalid cipher group (%d)\n",
+			bphy_err(drvr, "invalid cipher group (%d)\n",
 				 sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1599,7 +1606,7 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 	wsec = pval | gval;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err) {
-		bphy_err(wiphy, "error (%d)\n", err);
+		bphy_err(drvr, "error (%d)\n", err);
 		return err;
 	}
 
@@ -1614,8 +1621,8 @@ static s32
 brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 val;
 	s32 err;
 	const struct brcmf_tlv *rsn_ie;
@@ -1633,7 +1640,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 
 	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wpa_auth", &val);
 	if (err) {
-		bphy_err(wiphy, "could not get wpa_auth (%d)\n", err);
+		bphy_err(drvr, "could not get wpa_auth (%d)\n", err);
 		return err;
 	}
 	if (val & (WPA_AUTH_PSK | WPA_AUTH_UNSPECIFIED)) {
@@ -1647,7 +1654,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			val = WPA_AUTH_PSK;
 			break;
 		default:
-			bphy_err(wiphy, "invalid cipher group (%d)\n",
+			bphy_err(drvr, "invalid cipher group (%d)\n",
 				 sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1678,7 +1685,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			val = WPA2_AUTH_PSK | WPA2_AUTH_FT;
 			break;
 		default:
-			bphy_err(wiphy, "invalid cipher group (%d)\n",
+			bphy_err(drvr, "invalid cipher group (%d)\n",
 				 sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1725,7 +1732,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 	brcmf_dbg(CONN, "setting wpa_auth to %d\n", val);
 	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wpa_auth", val);
 	if (err) {
-		bphy_err(wiphy, "could not set wpa_auth (%d)\n", err);
+		bphy_err(drvr, "could not set wpa_auth (%d)\n", err);
 		return err;
 	}
 
@@ -1737,7 +1744,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
@@ -1764,7 +1771,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	key.len = (u32) sme->key_len;
 	key.index = (u32) sme->key_idx;
 	if (key.len > sizeof(key.data)) {
-		bphy_err(wiphy, "Too long key length (%u)\n", key.len);
+		bphy_err(drvr, "Too long key length (%u)\n", key.len);
 		return -EINVAL;
 	}
 	memcpy(key.data, sme->key, key.len);
@@ -1777,7 +1784,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		key.algo = CRYPTO_ALGO_WEP128;
 		break;
 	default:
-		bphy_err(wiphy, "Invalid algorithm (%d)\n",
+		bphy_err(drvr, "Invalid algorithm (%d)\n",
 			 sme->crypto.ciphers_pairwise[0]);
 		return -EINVAL;
 	}
@@ -1794,7 +1801,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		val = WL_AUTH_SHARED_KEY;	/* shared key */
 		err = brcmf_fil_bsscfg_int_set(ifp, "auth", val);
 		if (err)
-			bphy_err(wiphy, "set auth failed (%d)\n", err);
+			bphy_err(drvr, "set auth failed (%d)\n", err);
 	}
 	return err;
 }
@@ -1814,7 +1821,7 @@ enum nl80211_auth_type brcmf_war_auth_type(struct brcmf_if *ifp,
 static void brcmf_set_join_pref(struct brcmf_if *ifp,
 				struct cfg80211_bss_selection *bss_select)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_join_pref_params join_pref_params[2];
 	enum nl80211_band band;
 	int err, i = 0;
@@ -1853,7 +1860,7 @@ static void brcmf_set_join_pref(struct brcmf_if *ifp,
 	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
 				       sizeof(join_pref_params));
 	if (err)
-		bphy_err(wiphy, "Set join_pref error (%d)\n", err);
+		bphy_err(drvr, "Set join_pref error (%d)\n", err);
 }
 
 static s32
@@ -1864,6 +1871,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct ieee80211_channel *chan = sme->channel;
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_join_params join_params;
 	size_t join_params_size;
 	const struct brcmf_tlv *rsn_ie;
@@ -1880,7 +1888,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	if (!sme->ssid) {
-		bphy_err(wiphy, "Invalid ssid\n");
+		bphy_err(drvr, "Invalid ssid\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -1909,7 +1917,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
 				    sme->ie, sme->ie_len);
 	if (err)
-		bphy_err(wiphy, "Set Assoc REQ IE Failed\n");
+		bphy_err(drvr, "Set Assoc REQ IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc request\n");
 
@@ -1930,32 +1938,32 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_set_wpa_version(ndev, sme);
 	if (err) {
-		bphy_err(wiphy, "wl_set_wpa_version failed (%d)\n", err);
+		bphy_err(drvr, "wl_set_wpa_version failed (%d)\n", err);
 		goto done;
 	}
 
 	sme->auth_type = brcmf_war_auth_type(ifp, sme->auth_type);
 	err = brcmf_set_auth_type(ndev, sme);
 	if (err) {
-		bphy_err(wiphy, "wl_set_auth_type failed (%d)\n", err);
+		bphy_err(drvr, "wl_set_auth_type failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_wsec_mode(ndev, sme);
 	if (err) {
-		bphy_err(wiphy, "wl_set_set_cipher failed (%d)\n", err);
+		bphy_err(drvr, "wl_set_set_cipher failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_key_mgmt(ndev, sme);
 	if (err) {
-		bphy_err(wiphy, "wl_set_key_mgmt failed (%d)\n", err);
+		bphy_err(drvr, "wl_set_key_mgmt failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_sharedkey(ndev, sme);
 	if (err) {
-		bphy_err(wiphy, "brcmf_set_sharedkey failed (%d)\n", err);
+		bphy_err(drvr, "brcmf_set_sharedkey failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1972,7 +1980,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		/* enable firmware supplicant for this interface */
 		err = brcmf_fil_iovar_int_set(ifp, "sup_wpa", 1);
 		if (err < 0) {
-			bphy_err(wiphy, "failed to enable fw supplicant\n");
+			bphy_err(drvr, "failed to enable fw supplicant\n");
 			goto done;
 		}
 	}
@@ -2067,7 +2075,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err)
-		bphy_err(wiphy, "BRCMF_C_SET_SSID failed (%d)\n", err);
+		bphy_err(drvr, "BRCMF_C_SET_SSID failed (%d)\n", err);
 
 done:
 	if (err)
@@ -2080,8 +2088,10 @@ static s32
 brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		       u16 reason_code)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_scb_val_le scbval;
 	s32 err = 0;
 
@@ -2098,7 +2108,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_DISASSOC,
 				     &scbval, sizeof(scbval));
 	if (err)
-		bphy_err(wiphy, "error (%d)\n", err);
+		bphy_err(drvr, "error (%d)\n", err);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -2111,6 +2121,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 err;
 	s32 disable;
 	u32 qdbm = 127;
@@ -2125,7 +2136,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_TX_POWER_LIMITED:
 	case NL80211_TX_POWER_FIXED:
 		if (mbm < 0) {
-			bphy_err(wiphy, "TX_POWER_FIXED - dbm is negative\n");
+			bphy_err(drvr, "TX_POWER_FIXED - dbm is negative\n");
 			err = -EINVAL;
 			goto done;
 		}
@@ -2135,7 +2146,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 		qdbm |= WL_TXPWR_OVERRIDE;
 		break;
 	default:
-		bphy_err(wiphy, "Unsupported type %d\n", type);
+		bphy_err(drvr, "Unsupported type %d\n", type);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2143,11 +2154,11 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	disable = WL_RADIO_SW_DISABLE << 16;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_RADIO, disable);
 	if (err)
-		bphy_err(wiphy, "WLC_SET_RADIO error (%d)\n", err);
+		bphy_err(drvr, "WLC_SET_RADIO error (%d)\n", err);
 
 	err = brcmf_fil_iovar_int_set(ifp, "qtxpower", qdbm);
 	if (err)
-		bphy_err(wiphy, "qtxpower error (%d)\n", err);
+		bphy_err(drvr, "qtxpower error (%d)\n", err);
 
 done:
 	brcmf_dbg(TRACE, "Exit %d (qdbm)\n", qdbm & ~WL_TXPWR_OVERRIDE);
@@ -2158,7 +2169,9 @@ static s32
 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 			    s32 *dbm)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_cfg80211_vif *vif = wdev_to_vif(wdev);
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 qdbm = 0;
 	s32 err;
 
@@ -2168,7 +2181,7 @@ brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	err = brcmf_fil_iovar_int_get(vif->ifp, "qtxpower", &qdbm);
 	if (err) {
-		bphy_err(wiphy, "error (%d)\n", err);
+		bphy_err(drvr, "error (%d)\n", err);
 		goto done;
 	}
 	*dbm = (qdbm & ~WL_TXPWR_OVERRIDE) / 4;
@@ -2183,6 +2196,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 				  u8 key_idx, bool unicast, bool multicast)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = ifp->drvr;
 	u32 index;
 	u32 wsec;
 	s32 err = 0;
@@ -2194,7 +2208,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		bphy_err(wiphy, "WLC_GET_WSEC error (%d)\n", err);
+		bphy_err(drvr, "WLC_GET_WSEC error (%d)\n", err);
 		goto done;
 	}
 
@@ -2204,7 +2218,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp,
 					    BRCMF_C_SET_KEY_PRIMARY, index);
 		if (err)
-			bphy_err(wiphy, "error (%d)\n", err);
+			bphy_err(drvr, "error (%d)\n", err);
 	}
 done:
 	brcmf_dbg(TRACE, "Exit\n");
@@ -2253,7 +2267,9 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		       u8 key_idx, bool pairwise, const u8 *mac_addr,
 		       struct key_params *params)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_wsec_key *key;
 	s32 val;
 	s32 wsec;
@@ -2268,7 +2284,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (key_idx >= BRCMF_MAX_DEFAULT_KEYS) {
 		/* we ignore this key index in this case */
-		bphy_err(wiphy, "invalid key index (%d)\n", key_idx);
+		bphy_err(drvr, "invalid key index (%d)\n", key_idx);
 		return -EINVAL;
 	}
 
@@ -2277,7 +2293,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 					      mac_addr);
 
 	if (params->key_len > sizeof(key->data)) {
-		bphy_err(wiphy, "Too long key length (%u)\n", params->key_len);
+		bphy_err(drvr, "Too long key length (%u)\n", params->key_len);
 		return -EINVAL;
 	}
 
@@ -2331,7 +2347,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_CCMP\n");
 		break;
 	default:
-		bphy_err(wiphy, "Invalid cipher (0x%x)\n", params->cipher);
+		bphy_err(drvr, "Invalid cipher (0x%x)\n", params->cipher);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2342,13 +2358,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		bphy_err(wiphy, "get wsec error (%d)\n", err);
+		bphy_err(drvr, "get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec |= val;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err) {
-		bphy_err(wiphy, "set wsec error (%d)\n", err);
+		bphy_err(drvr, "set wsec error (%d)\n", err);
 		goto done;
 	}
 
@@ -2363,9 +2379,11 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 		       void (*callback)(void *cookie,
 					struct key_params *params))
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct key_params params;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
 	s32 err = 0;
@@ -2379,7 +2397,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		bphy_err(wiphy, "WLC_GET_WSEC error (%d)\n", err);
+		bphy_err(drvr, "WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
 		goto done;
@@ -2400,7 +2418,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 		params.cipher = WLAN_CIPHER_SUITE_AES_CMAC;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
 	} else  {
-		bphy_err(wiphy, "Invalid algo (0x%x)\n", wsec);
+		bphy_err(drvr, "Invalid algo (0x%x)\n", wsec);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2430,7 +2448,7 @@ brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 static void
 brcmf_cfg80211_reconfigure_wep(struct brcmf_if *ifp)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 	u8 key_idx;
 	struct brcmf_wsec_key *key;
@@ -2447,18 +2465,18 @@ brcmf_cfg80211_reconfigure_wep(struct brcmf_if *ifp)
 
 	err = send_key_to_dongle(ifp, key);
 	if (err) {
-		bphy_err(wiphy, "Setting WEP key failed (%d)\n", err);
+		bphy_err(drvr, "Setting WEP key failed (%d)\n", err);
 		return;
 	}
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		bphy_err(wiphy, "get wsec error (%d)\n", err);
+		bphy_err(drvr, "get wsec error (%d)\n", err);
 		return;
 	}
 	wsec |= WEP_ENABLED;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err)
-		bphy_err(wiphy, "set wsec error (%d)\n", err);
+		bphy_err(drvr, "set wsec error (%d)\n", err);
 }
 
 static void brcmf_convert_sta_flags(u32 fw_sta_flags, struct station_info *si)
@@ -2484,7 +2502,7 @@ static void brcmf_convert_sta_flags(u32 fw_sta_flags, struct station_info *si)
 
 static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct {
 		__le32 len;
 		struct brcmf_bss_info_le bss_le;
@@ -2500,7 +2518,7 @@ static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO, buf,
 				     WL_BSS_INFO_MAX);
 	if (err) {
-		bphy_err(wiphy, "Failed to get bss info (%d)\n", err);
+		bphy_err(drvr, "Failed to get bss info (%d)\n", err);
 		goto out_kfree;
 	}
 	si->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
@@ -2522,7 +2540,7 @@ static s32
 brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 				struct station_info *sinfo)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_pktcnt_le pktcnt;
 	s32 err;
@@ -2532,7 +2550,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	/* Get the current tx rate */
 	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_RATE, &rate);
 	if (err < 0) {
-		bphy_err(wiphy, "BRCMF_C_GET_RATE error (%d)\n", err);
+		bphy_err(drvr, "BRCMF_C_GET_RATE error (%d)\n", err);
 		return err;
 	}
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
@@ -2542,7 +2560,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI, &scbval,
 				     sizeof(scbval));
 	if (err) {
-		bphy_err(wiphy, "BRCMF_C_GET_RSSI error (%d)\n", err);
+		bphy_err(drvr, "BRCMF_C_GET_RSSI error (%d)\n", err);
 		return err;
 	}
 	rssi = le32_to_cpu(scbval.val);
@@ -2552,7 +2570,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_GET_PKTCNTS, &pktcnt,
 				     sizeof(pktcnt));
 	if (err) {
-		bphy_err(wiphy, "BRCMF_C_GET_GET_PKTCNTS error (%d)\n", err);
+		bphy_err(drvr, "BRCMF_C_GET_GET_PKTCNTS error (%d)\n", err);
 		return err;
 	}
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS) |
@@ -2571,7 +2589,9 @@ static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   const u8 *mac, struct station_info *sinfo)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_scb_val_le scb_val;
 	s32 err = 0;
 	struct brcmf_sta_info_le sta_info_le;
@@ -2600,7 +2620,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 					       &sta_info_le,
 					       sizeof(sta_info_le));
 		if (err < 0) {
-			bphy_err(wiphy, "GET STA INFO failed, %d\n", err);
+			bphy_err(drvr, "GET STA INFO failed, %d\n", err);
 			goto done;
 		}
 	}
@@ -2669,7 +2689,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
 						     &scb_val, sizeof(scb_val));
 			if (err) {
-				bphy_err(wiphy, "Could not get rssi (%d)\n",
+				bphy_err(drvr, "Could not get rssi (%d)\n",
 					 err);
 				goto done;
 			} else {
@@ -2691,6 +2711,7 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 err;
 
 	brcmf_dbg(TRACE, "Enter, idx %d\n", idx);
@@ -2701,7 +2722,7 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 					     &cfg->assoclist,
 					     sizeof(cfg->assoclist));
 		if (err) {
-			bphy_err(wiphy, "BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
+			bphy_err(drvr, "BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
 				 err);
 			cfg->assoclist.count = 0;
 			return -EOPNOTSUPP;
@@ -2722,6 +2743,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	s32 err = 0;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -2750,9 +2772,9 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, pm);
 	if (err) {
 		if (err == -ENODEV)
-			bphy_err(wiphy, "net_device is not ready yet\n");
+			bphy_err(drvr, "net_device is not ready yet\n");
 		else
-			bphy_err(wiphy, "error (%d)\n", err);
+			bphy_err(drvr, "error (%d)\n", err);
 	}
 done:
 	brcmf_dbg(TRACE, "Exit\n");
@@ -2763,6 +2785,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 				   struct brcmf_bss_info_le *bi)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct cfg80211_bss *bss;
 	enum nl80211_band band;
 	struct brcmu_chan ch;
@@ -2775,7 +2798,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	struct cfg80211_inform_bss bss_data = {};
 
 	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
-		bphy_err(wiphy, "Bss info is larger than buffer. Discarding\n");
+		bphy_err(drvr, "Bss info is larger than buffer. Discarding\n");
 		return 0;
 	}
 
@@ -2834,7 +2857,7 @@ next_bss_le(struct brcmf_scan_results *list, struct brcmf_bss_info_le *bss)
 
 static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_scan_results *bss_list;
 	struct brcmf_bss_info_le *bi = NULL;	/* must be initialized */
 	s32 err = 0;
@@ -2843,7 +2866,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 	bss_list = (struct brcmf_scan_results *)cfg->escan_info.escan_buf;
 	if (bss_list->count != 0 &&
 	    bss_list->version != BRCMF_BSS_INFO_VERSION) {
-		bphy_err(wiphy, "Version %d != WL_BSS_INFO_VERSION\n",
+		bphy_err(drvr, "Version %d != WL_BSS_INFO_VERSION\n",
 			 bss_list->version);
 		return -EOPNOTSUPP;
 	}
@@ -2861,6 +2884,7 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 			     struct net_device *ndev, const u8 *bssid)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct ieee80211_channel *notify_channel;
 	struct brcmf_bss_info_le *bi = NULL;
 	struct ieee80211_supported_band *band;
@@ -2888,7 +2912,7 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_BSS_INFO,
 				     buf, WL_BSS_INFO_MAX);
 	if (err) {
-		bphy_err(wiphy, "WLC_GET_BSS_INFO failed: %d\n", err);
+		bphy_err(drvr, "WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
 	}
 
@@ -2942,7 +2966,7 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 				 struct brcmf_if *ifp)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_bss_info_le *bi;
 	const struct brcmf_tlv *tim;
 	u16 beacon_interval;
@@ -2959,7 +2983,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO,
 				     cfg->extra_buf, WL_EXTRA_BUF_MAX);
 	if (err) {
-		bphy_err(wiphy, "Could not get bss info %d\n", err);
+		bphy_err(drvr, "Could not get bss info %d\n", err);
 		goto update_bss_info_out;
 	}
 
@@ -2984,7 +3008,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 		u32 var;
 		err = brcmf_fil_iovar_int_get(ifp, "dtim_assoc", &var);
 		if (err) {
-			bphy_err(wiphy, "wl dtim_assoc failed (%d)\n", err);
+			bphy_err(drvr, "wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
 		}
 		dtim_period = (u8)var;
@@ -3022,10 +3046,10 @@ static void brcmf_escan_timeout(struct timer_list *t)
 {
 	struct brcmf_cfg80211_info *cfg =
 			from_timer(cfg, t, escan_timeout);
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 
 	if (cfg->int_escan_map || cfg->scan_request) {
-		bphy_err(wiphy, "timer expired\n");
+		bphy_err(drvr, "timer expired\n");
 		schedule_work(&cfg->escan_timeout_work);
 	}
 }
@@ -3073,8 +3097,8 @@ static s32
 brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			     const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_cfg80211_info *cfg = drvr->config;
 	s32 status;
 	struct brcmf_escan_result_le *escan_result_le;
 	u32 escan_buflen;
@@ -3091,7 +3115,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		goto exit;
 
 	if (!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		bphy_err(wiphy, "scan not ready, bsscfgidx=%d\n",
+		bphy_err(drvr, "scan not ready, bsscfgidx=%d\n",
 			 ifp->bsscfgidx);
 		return -EPERM;
 	}
@@ -3099,24 +3123,24 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 	if (status == BRCMF_E_STATUS_PARTIAL) {
 		brcmf_dbg(SCAN, "ESCAN Partial result\n");
 		if (e->datalen < sizeof(*escan_result_le)) {
-			bphy_err(wiphy, "invalid event data length\n");
+			bphy_err(drvr, "invalid event data length\n");
 			goto exit;
 		}
 		escan_result_le = (struct brcmf_escan_result_le *) data;
 		if (!escan_result_le) {
-			bphy_err(wiphy, "Invalid escan result (NULL pointer)\n");
+			bphy_err(drvr, "Invalid escan result (NULL pointer)\n");
 			goto exit;
 		}
 		escan_buflen = le32_to_cpu(escan_result_le->buflen);
 		if (escan_buflen > BRCMF_ESCAN_BUF_SIZE ||
 		    escan_buflen > e->datalen ||
 		    escan_buflen < sizeof(*escan_result_le)) {
-			bphy_err(wiphy, "Invalid escan buffer length: %d\n",
+			bphy_err(drvr, "Invalid escan buffer length: %d\n",
 				 escan_buflen);
 			goto exit;
 		}
 		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
-			bphy_err(wiphy, "Invalid bss_count %d: ignoring\n",
+			bphy_err(drvr, "Invalid bss_count %d: ignoring\n",
 				 escan_result_le->bss_count);
 			goto exit;
 		}
@@ -3132,7 +3156,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 
 		bi_length = le32_to_cpu(bss_info_le->length);
 		if (bi_length != escan_buflen -	WL_ESCAN_RESULTS_FIXED_SIZE) {
-			bphy_err(wiphy, "Ignoring invalid bss_info length: %d\n",
+			bphy_err(drvr, "Ignoring invalid bss_info length: %d\n",
 				 bi_length);
 			goto exit;
 		}
@@ -3141,7 +3165,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 					BIT(NL80211_IFTYPE_ADHOC))) {
 			if (le16_to_cpu(bss_info_le->capability) &
 						WLAN_CAPABILITY_IBSS) {
-				bphy_err(wiphy, "Ignoring IBSS result\n");
+				bphy_err(drvr, "Ignoring IBSS result\n");
 				goto exit;
 			}
 		}
@@ -3149,7 +3173,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		list = (struct brcmf_scan_results *)
 				cfg->escan_info.escan_buf;
 		if (bi_length > BRCMF_ESCAN_BUF_SIZE - list->buflen) {
-			bphy_err(wiphy, "Buffer is too small: ignoring\n");
+			bphy_err(drvr, "Buffer is too small: ignoring\n");
 			goto exit;
 		}
 
@@ -3308,7 +3332,8 @@ static s32
 brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 				const struct brcmf_event_msg *e, void *data)
 {
-	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_cfg80211_info *cfg = drvr->config;
 	struct brcmf_pno_net_info_le *netinfo, *netinfo_start;
 	struct cfg80211_scan_request *request = NULL;
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
@@ -3341,14 +3366,14 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	WARN_ON(status != BRCMF_PNO_SCAN_COMPLETE);
 	brcmf_dbg(SCAN, "PFN NET FOUND event. count: %d\n", result_count);
 	if (!result_count) {
-		bphy_err(wiphy, "FALSE PNO Event. (pfn_count == 0)\n");
+		bphy_err(drvr, "FALSE PNO Event. (pfn_count == 0)\n");
 		goto out_err;
 	}
 
 	netinfo_start = brcmf_get_netinfo_array(pfn_result);
 	datalen = e->datalen - ((void *)netinfo_start - (void *)pfn_result);
 	if (datalen < result_count * sizeof(*netinfo)) {
-		bphy_err(wiphy, "insufficient event data\n");
+		bphy_err(drvr, "insufficient event data\n");
 		goto out_err;
 	}
 
@@ -3395,14 +3420,15 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 				struct net_device *ndev,
 				struct cfg80211_sched_scan_request *req)
 {
-	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 
 	brcmf_dbg(SCAN, "Enter: n_match_sets=%d n_ssids=%d\n",
 		  req->n_match_sets, req->n_ssids);
 
 	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
-		bphy_err(wiphy, "Scanning suppressed: status=%lu\n",
+		bphy_err(drvr, "Scanning suppressed: status=%lu\n",
 			 cfg->scan_status);
 		return -EAGAIN;
 	}
@@ -3481,8 +3507,8 @@ static s32
 brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 		      void *data)
 {
-	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_cfg80211_info *cfg = drvr->config;
 	struct brcmf_pno_scanresults_le *pfn_result;
 	struct brcmf_pno_net_info_le *netinfo;
 
@@ -3501,7 +3527,7 @@ brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 	}
 
 	if (le32_to_cpu(pfn_result->count) < 1) {
-		bphy_err(wiphy, "Invalid result count, expected 1 (%d)\n",
+		bphy_err(drvr, "Invalid result count, expected 1 (%d)\n",
 			 le32_to_cpu(pfn_result->count));
 		return -EINVAL;
 	}
@@ -3529,6 +3555,7 @@ brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_wowl_wakeind_le wake_ind_le;
 	struct cfg80211_wowlan_wakeup wakeup_data;
 	struct cfg80211_wowlan_wakeup *wakeup;
@@ -3539,7 +3566,7 @@ static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "wowl_wakeind", &wake_ind_le,
 				       sizeof(wake_ind_le));
 	if (err) {
-		bphy_err(wiphy, "Get wowl_wakeind failed, err = %d\n", err);
+		bphy_err(drvr, "Get wowl_wakeind failed, err = %d\n", err);
 		return;
 	}
 
@@ -3580,7 +3607,7 @@ static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 				cfg->wowl.nd_data_completed,
 				BRCMF_ND_INFO_TIMEOUT);
 			if (!timeout)
-				bphy_err(wiphy, "No result for wowl net detect\n");
+				bphy_err(drvr, "No result for wowl net detect\n");
 			else
 				wakeup_data.net_detect = cfg->wowl.nd_info;
 		}
@@ -3769,6 +3796,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 err;
 	u32 npmk, i;
 
@@ -3788,7 +3816,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			cfg->pmk_list.npmk = cpu_to_le32(npmk);
 		}
 	} else {
-		bphy_err(wiphy, "Too many PMKSA entries cached %d\n", npmk);
+		bphy_err(drvr, "Too many PMKSA entries cached %d\n", npmk);
 		return -EINVAL;
 	}
 
@@ -3811,6 +3839,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 err;
 	u32 npmk, i;
 
@@ -3834,7 +3863,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 		memset(&pmk[i], 0, sizeof(*pmk));
 		cfg->pmk_list.npmk = cpu_to_le32(npmk - 1);
 	} else {
-		bphy_err(wiphy, "Cache entry not found\n");
+		bphy_err(drvr, "Cache entry not found\n");
 		return -EINVAL;
 	}
 
@@ -3866,20 +3895,20 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 
 static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 	s32 wpa_val;
 
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", 0);
 	if (err < 0) {
-		bphy_err(wiphy, "auth error %d\n", err);
+		bphy_err(drvr, "auth error %d\n", err);
 		return err;
 	}
 	/* set wsec */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", 0);
 	if (err < 0) {
-		bphy_err(wiphy, "wsec error %d\n", err);
+		bphy_err(drvr, "wsec error %d\n", err);
 		return err;
 	}
 	/* set upper-layer auth */
@@ -3889,7 +3918,7 @@ static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 		wpa_val = WPA_AUTH_DISABLED;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_val);
 	if (err < 0) {
-		bphy_err(wiphy, "wpa_auth error %d\n", err);
+		bphy_err(drvr, "wpa_auth error %d\n", err);
 		return err;
 	}
 
@@ -3909,7 +3938,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		      const struct brcmf_vs_tlv *wpa_ie,
 		      bool is_rsn_ie)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	u32 auth = 0; /* d11 open authentication */
 	u16 count;
 	s32 err = 0;
@@ -3940,13 +3969,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* check for multicast cipher suite */
 	if (offset + WPA_IE_MIN_OUI_LEN > len) {
 		err = -EINVAL;
-		bphy_err(wiphy, "no multicast cipher suite\n");
+		bphy_err(drvr, "no multicast cipher suite\n");
 		goto exit;
 	}
 
 	if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 		err = -EINVAL;
-		bphy_err(wiphy, "ivalid OUI\n");
+		bphy_err(drvr, "ivalid OUI\n");
 		goto exit;
 	}
 	offset += TLV_OUI_LEN;
@@ -3968,7 +3997,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		break;
 	default:
 		err = -EINVAL;
-		bphy_err(wiphy, "Invalid multi cast cipher info\n");
+		bphy_err(drvr, "Invalid multi cast cipher info\n");
 		goto exit;
 	}
 
@@ -3979,13 +4008,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* Check for unicast suite(s) */
 	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
 		err = -EINVAL;
-		bphy_err(wiphy, "no unicast cipher suite\n");
+		bphy_err(drvr, "no unicast cipher suite\n");
 		goto exit;
 	}
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			bphy_err(wiphy, "ivalid OUI\n");
+			bphy_err(drvr, "ivalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -4003,7 +4032,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 			pval |= AES_ENABLED;
 			break;
 		default:
-			bphy_err(wiphy, "Invalid unicast security info\n");
+			bphy_err(drvr, "Invalid unicast security info\n");
 		}
 		offset++;
 	}
@@ -4013,13 +4042,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* Check for auth key management suite(s) */
 	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
 		err = -EINVAL;
-		bphy_err(wiphy, "no auth key mgmt suite\n");
+		bphy_err(drvr, "no auth key mgmt suite\n");
 		goto exit;
 	}
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			bphy_err(wiphy, "ivalid OUI\n");
+			bphy_err(drvr, "ivalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -4047,7 +4076,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 			wpa_auth |= WPA2_AUTH_1X_SHA256;
 			break;
 		default:
-			bphy_err(wiphy, "Invalid key mgmt info\n");
+			bphy_err(drvr, "Invalid key mgmt info\n");
 		}
 		offset++;
 	}
@@ -4089,7 +4118,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		err = brcmf_fil_bsscfg_int_set(ifp, "wme_bss_disable",
 					       wme_bss_disable);
 		if (err < 0) {
-			bphy_err(wiphy, "wme_bss_disable error %d\n", err);
+			bphy_err(drvr, "wme_bss_disable error %d\n", err);
 			goto exit;
 		}
 
@@ -4103,7 +4132,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 							&data[offset],
 							WPA_IE_MIN_OUI_LEN);
 			if (err < 0) {
-				bphy_err(wiphy, "bip error %d\n", err);
+				bphy_err(drvr, "bip error %d\n", err);
 				goto exit;
 			}
 		}
@@ -4114,13 +4143,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", auth);
 	if (err < 0) {
-		bphy_err(wiphy, "auth error %d\n", err);
+		bphy_err(drvr, "auth error %d\n", err);
 		goto exit;
 	}
 	/* set wsec */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err < 0) {
-		bphy_err(wiphy, "wsec error %d\n", err);
+		bphy_err(drvr, "wsec error %d\n", err);
 		goto exit;
 	}
 	/* Configure MFP, this needs to go after wsec otherwise the wsec command
@@ -4129,14 +4158,14 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MFP)) {
 		err = brcmf_fil_bsscfg_int_set(ifp, "mfp", mfp);
 		if (err < 0) {
-			bphy_err(wiphy, "mfp error %d\n", err);
+			bphy_err(drvr, "mfp error %d\n", err);
 			goto exit;
 		}
 	}
 	/* set upper-layer auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_auth);
 	if (err < 0) {
-		bphy_err(wiphy, "wpa_auth error %d\n", err);
+		bphy_err(drvr, "wpa_auth error %d\n", err);
 		goto exit;
 	}
 
@@ -4222,8 +4251,8 @@ brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
+	struct brcmf_pub *drvr;
 	struct brcmf_if *ifp;
-	struct wiphy *wiphy;
 	struct vif_saved_ie *saved_ie;
 	s32 err = 0;
 	u8  *iovar_ie_buf;
@@ -4244,7 +4273,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 	if (!vif)
 		return -ENODEV;
 	ifp = vif->ifp;
-	wiphy = ifp->drvr->wiphy;
+	drvr = ifp->drvr;
 	saved_ie = &vif->saved_ie;
 
 	brcmf_dbg(TRACE, "bsscfgidx %d, pktflag : 0x%02X\n", ifp->bsscfgidx,
@@ -4276,13 +4305,13 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		break;
 	default:
 		err = -EPERM;
-		bphy_err(wiphy, "not suitable type\n");
+		bphy_err(drvr, "not suitable type\n");
 		goto exit;
 	}
 
 	if (vndr_ie_len > mgmt_ie_buf_len) {
 		err = -ENOMEM;
-		bphy_err(wiphy, "extra IE size too big\n");
+		bphy_err(drvr, "extra IE size too big\n");
 		goto exit;
 	}
 
@@ -4343,7 +4372,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			/* verify remained buf size before copy data */
 			if (remained_buf_len < (vndrie_info->vndrie.len +
 							VNDR_IE_VSIE_OFFSET)) {
-				bphy_err(wiphy, "no space in mgmt_ie_buf: len left %d",
+				bphy_err(drvr, "no space in mgmt_ie_buf: len left %d",
 					 remained_buf_len);
 				break;
 			}
@@ -4375,7 +4404,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		err  = brcmf_fil_bsscfg_data_set(ifp, "vndr_ie", iovar_ie_buf,
 						 total_ie_buf_len);
 		if (err)
-			bphy_err(wiphy, "vndr ie set error : %d\n", err);
+			bphy_err(drvr, "vndr ie set error : %d\n", err);
 	}
 
 exit:
@@ -4403,14 +4432,14 @@ static s32
 brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 			struct cfg80211_beacon_data *beacon)
 {
-	struct wiphy *wiphy = vif->ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = vif->ifp->drvr;
 	s32 err;
 
 	/* Set Beacon IEs to FW */
 	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_BEACON_FLAG,
 				    beacon->tail, beacon->tail_len);
 	if (err) {
-		bphy_err(wiphy, "Set Beacon IE Failed\n");
+		bphy_err(drvr, "Set Beacon IE Failed\n");
 		return err;
 	}
 	brcmf_dbg(TRACE, "Applied Vndr IEs for Beacon\n");
@@ -4420,7 +4449,7 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 				    beacon->proberesp_ies,
 				    beacon->proberesp_ies_len);
 	if (err)
-		bphy_err(wiphy, "Set Probe Resp IE Failed\n");
+		bphy_err(drvr, "Set Probe Resp IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Probe Resp\n");
 
@@ -4434,6 +4463,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	s32 ie_offset;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 	const struct brcmf_tlv *ssid_ie;
 	const struct brcmf_tlv *country_ie;
 	struct brcmf_ssid_le ssid_le;
@@ -4529,7 +4559,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
 						    is_11d);
 			if (err < 0) {
-				bphy_err(wiphy, "Regulatory Set Error, %d\n",
+				bphy_err(drvr, "Regulatory Set Error, %d\n",
 					 err);
 				goto exit;
 			}
@@ -4538,7 +4568,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
 						    settings->beacon_interval);
 			if (err < 0) {
-				bphy_err(wiphy, "Beacon Interval Set Error, %d\n",
+				bphy_err(drvr, "Beacon Interval Set Error, %d\n",
 					 err);
 				goto exit;
 			}
@@ -4547,7 +4577,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_DTIMPRD,
 						    settings->dtim_period);
 			if (err < 0) {
-				bphy_err(wiphy, "DTIM Interval Set Error, %d\n",
+				bphy_err(drvr, "DTIM Interval Set Error, %d\n",
 					 err);
 				goto exit;
 			}
@@ -4558,7 +4588,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		     !brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RSDB))) {
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 			if (err < 0) {
-				bphy_err(wiphy, "BRCMF_C_DOWN error %d\n",
+				bphy_err(drvr, "BRCMF_C_DOWN error %d\n",
 					 err);
 				goto exit;
 			}
@@ -4567,7 +4597,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
 		if (err < 0) {
-			bphy_err(wiphy, "SET INFRA error %d\n", err);
+			bphy_err(drvr, "SET INFRA error %d\n", err);
 			goto exit;
 		}
 	} else if (WARN_ON(supports_11d && (is_11d != ifp->vif->is_11d))) {
@@ -4583,7 +4613,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
 		if (err < 0) {
-			bphy_err(wiphy, "setting AP mode failed %d\n",
+			bphy_err(drvr, "setting AP mode failed %d\n",
 				 err);
 			goto exit;
 		}
@@ -4593,14 +4623,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			 */
 			err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 			if (err < 0) {
-				bphy_err(wiphy, "Set Channel failed: chspec=%d, %d\n",
+				bphy_err(drvr, "Set Channel failed: chspec=%d, %d\n",
 					 chanspec, err);
 				goto exit;
 			}
 		}
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0) {
-			bphy_err(wiphy, "BRCMF_C_UP error (%d)\n", err);
+			bphy_err(drvr, "BRCMF_C_UP error (%d)\n", err);
 			goto exit;
 		}
 		/* On DOWN the firmware removes the WEP keys, reconfigure
@@ -4615,14 +4645,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 					     &join_params, sizeof(join_params));
 		if (err < 0) {
-			bphy_err(wiphy, "SET SSID error (%d)\n", err);
+			bphy_err(drvr, "SET SSID error (%d)\n", err);
 			goto exit;
 		}
 
 		if (settings->hidden_ssid) {
 			err = brcmf_fil_iovar_int_set(ifp, "closednet", 1);
 			if (err) {
-				bphy_err(wiphy, "closednet error (%d)\n", err);
+				bphy_err(drvr, "closednet error (%d)\n", err);
 				goto exit;
 			}
 		}
@@ -4631,14 +4661,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	} else if (dev_role == NL80211_IFTYPE_P2P_GO) {
 		err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 		if (err < 0) {
-			bphy_err(wiphy, "Set Channel failed: chspec=%d, %d\n",
+			bphy_err(drvr, "Set Channel failed: chspec=%d, %d\n",
 				 chanspec, err);
 			goto exit;
 		}
 		err = brcmf_fil_bsscfg_data_set(ifp, "ssid", &ssid_le,
 						sizeof(ssid_le));
 		if (err < 0) {
-			bphy_err(wiphy, "setting ssid failed %d\n", err);
+			bphy_err(drvr, "setting ssid failed %d\n", err);
 			goto exit;
 		}
 		bss_enable.bsscfgidx = cpu_to_le32(ifp->bsscfgidx);
@@ -4646,7 +4676,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
 					       sizeof(bss_enable));
 		if (err < 0) {
-			bphy_err(wiphy, "bss_enable config failed %d\n", err);
+			bphy_err(drvr, "bss_enable config failed %d\n", err);
 			goto exit;
 		}
 
@@ -4669,7 +4699,9 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = cfg->pub;
 	s32 err;
 	struct brcmf_fil_bss_enable_le bss_enable;
 	struct brcmf_join_params join_params;
@@ -4694,13 +4726,13 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 					     &join_params, sizeof(join_params));
 		if (err < 0)
-			bphy_err(wiphy, "SET SSID error (%d)\n", err);
+			bphy_err(drvr, "SET SSID error (%d)\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 		if (err < 0)
-			bphy_err(wiphy, "BRCMF_C_DOWN error %d\n", err);
+			bphy_err(drvr, "BRCMF_C_DOWN error %d\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
 		if (err < 0)
-			bphy_err(wiphy, "setting AP mode failed %d\n", err);
+			bphy_err(drvr, "setting AP mode failed %d\n", err);
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
 			brcmf_fil_iovar_int_set(ifp, "mbss", 0);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
@@ -4708,7 +4740,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		/* Bring device back up so it can be used again */
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0)
-			bphy_err(wiphy, "BRCMF_C_UP error %d\n", err);
+			bphy_err(drvr, "BRCMF_C_UP error %d\n", err);
 
 		brcmf_vif_clear_mgmt_ies(ifp->vif);
 	} else {
@@ -4717,7 +4749,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
 					       sizeof(bss_enable));
 		if (err < 0)
-			bphy_err(wiphy, "bss_enable config failed %d\n", err);
+			bphy_err(drvr, "bss_enable config failed %d\n", err);
 	}
 	brcmf_set_mpc(ifp, 1);
 	brcmf_configure_arp_nd_offload(ifp, true);
@@ -4746,6 +4778,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 			   struct station_del_parameters *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
@@ -4765,7 +4798,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
 				     &scbval, sizeof(scbval));
 	if (err)
-		bphy_err(wiphy, "SCB_DEAUTHENTICATE_FOR_REASON failed %d\n",
+		bphy_err(drvr, "SCB_DEAUTHENTICATE_FOR_REASON failed %d\n",
 			 err);
 
 	brcmf_dbg(TRACE, "Exit\n");
@@ -4776,6 +4809,8 @@ static int
 brcmf_cfg80211_change_station(struct wiphy *wiphy, struct net_device *ndev,
 			      const u8 *mac, struct station_parameters *params)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
@@ -4796,7 +4831,7 @@ brcmf_cfg80211_change_station(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SCB_DEAUTHORIZE,
 					     (void *)mac, ETH_ALEN);
 	if (err < 0)
-		bphy_err(wiphy, "Setting SCB (de-)authorize failed, %d\n", err);
+		bphy_err(drvr, "Setting SCB (de-)authorize failed, %d\n", err);
 
 	return err;
 }
@@ -4826,6 +4861,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct ieee80211_channel *chan = params->chan;
+	struct brcmf_pub *drvr = cfg->pub;
 	const u8 *buf = params->buf;
 	size_t len = params->len;
 	const struct ieee80211_mgmt *mgmt;
@@ -4846,7 +4882,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
 	if (!ieee80211_is_mgmt(mgmt->frame_control)) {
-		bphy_err(wiphy, "Driver only allows MGMT packet type\n");
+		bphy_err(drvr, "Driver only allows MGMT packet type\n");
 		return -EPERM;
 	}
 
@@ -4877,13 +4913,13 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 					GFP_KERNEL);
 	} else if (ieee80211_is_action(mgmt->frame_control)) {
 		if (len > BRCMF_FIL_ACTION_FRAME_SIZE + DOT11_MGMT_HDR_LEN) {
-			bphy_err(wiphy, "invalid action frame length\n");
+			bphy_err(drvr, "invalid action frame length\n");
 			err = -EINVAL;
 			goto exit;
 		}
 		af_params = kzalloc(sizeof(*af_params), GFP_KERNEL);
 		if (af_params == NULL) {
-			bphy_err(wiphy, "unable to allocate frame\n");
+			bphy_err(drvr, "unable to allocate frame\n");
 			err = -ENOMEM;
 			goto exit;
 		}
@@ -4934,6 +4970,7 @@ brcmf_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
 					u64 cookie)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_cfg80211_vif *vif;
 	int err = 0;
 
@@ -4941,7 +4978,7 @@ brcmf_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
 
 	vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (vif == NULL) {
-		bphy_err(wiphy, "No p2p device available for probe response\n");
+		bphy_err(drvr, "No p2p device available for probe response\n");
 		err = -ENODEV;
 		goto exit;
 	}
@@ -4956,6 +4993,7 @@ static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct net_device *ndev = wdev->netdev;
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_if *ifp;
 	struct brcmu_chan ch;
 	enum nl80211_band band = 0;
@@ -4969,7 +5007,7 @@ static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_int_get(ifp, "chanspec", &chanspec);
 	if (err) {
-		bphy_err(wiphy, "chanspec failed (%d)\n", err);
+		bphy_err(drvr, "chanspec failed (%d)\n", err);
 		return err;
 	}
 
@@ -5091,6 +5129,8 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 				    struct net_device *ndev, const u8 *peer,
 				    enum nl80211_tdls_operation oper)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_if *ifp;
 	struct brcmf_tdls_iovar_le info;
 	int ret = 0;
@@ -5108,7 +5148,7 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	ret = brcmf_fil_iovar_data_set(ifp, "tdls_endpoint",
 				       &info, sizeof(info));
 	if (ret < 0)
-		bphy_err(wiphy, "tdls_endpoint iovar failed: ret=%d\n", ret);
+		bphy_err(drvr, "tdls_endpoint iovar failed: ret=%d\n", ret);
 
 	return ret;
 }
@@ -5119,6 +5159,8 @@ brcmf_cfg80211_update_conn_params(struct wiphy *wiphy,
 				  struct cfg80211_connect_params *sme,
 				  u32 changed)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_if *ifp;
 	int err;
 
@@ -5129,7 +5171,7 @@ brcmf_cfg80211_update_conn_params(struct wiphy *wiphy,
 	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
 				    sme->ie, sme->ie_len);
 	if (err)
-		bphy_err(wiphy, "Set Assoc REQ IE Failed\n");
+		bphy_err(drvr, "Set Assoc REQ IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc request\n");
 
@@ -5141,6 +5183,8 @@ static int
 brcmf_cfg80211_set_rekey_data(struct wiphy *wiphy, struct net_device *ndev,
 			      struct cfg80211_gtk_rekey_data *gtk)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_gtk_keyinfo_le gtk_le;
 	int ret;
@@ -5155,7 +5199,7 @@ brcmf_cfg80211_set_rekey_data(struct wiphy *wiphy, struct net_device *ndev,
 	ret = brcmf_fil_iovar_data_set(ifp, "gtk_key_info", &gtk_le,
 				       sizeof(gtk_le));
 	if (ret < 0)
-		bphy_err(wiphy, "gtk_key_info iovar failed: ret=%d\n", ret);
+		bphy_err(drvr, "gtk_key_info iovar failed: ret=%d\n", ret);
 
 	return ret;
 }
@@ -5387,7 +5431,7 @@ static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_info *cfg)
 static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 			       struct brcmf_if *ifp)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_cfg80211_assoc_ielen_le *assoc_info;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	u32 req_len;
@@ -5399,7 +5443,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_iovar_data_get(ifp, "assoc_info",
 				       cfg->extra_buf, WL_ASSOC_INFO_MAX);
 	if (err) {
-		bphy_err(wiphy, "could not get assoc info (%d)\n", err);
+		bphy_err(drvr, "could not get assoc info (%d)\n", err);
 		return err;
 	}
 	assoc_info =
@@ -5411,7 +5455,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
-			bphy_err(wiphy, "could not get assoc req (%d)\n", err);
+			bphy_err(drvr, "could not get assoc req (%d)\n", err);
 			return err;
 		}
 		conn_info->req_ie_len = req_len;
@@ -5427,7 +5471,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
-			bphy_err(wiphy, "could not get assoc resp (%d)\n", err);
+			bphy_err(drvr, "could not get assoc resp (%d)\n", err);
 			return err;
 		}
 		conn_info->resp_ie_len = resp_len;
@@ -5554,7 +5598,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 			       struct net_device *ndev,
 			       const struct brcmf_event_msg *e, void *data)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	static int generation;
 	u32 event = e->event_code;
 	u32 reason = e->reason;
@@ -5572,7 +5616,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	if (((event == BRCMF_E_ASSOC_IND) || (event == BRCMF_E_REASSOC_IND)) &&
 	    (reason == BRCMF_E_STATUS_SUCCESS)) {
 		if (!data) {
-			bphy_err(wiphy, "No IEs present in ASSOC/REASSOC_IND\n");
+			bphy_err(drvr, "No IEs present in ASSOC/REASSOC_IND\n");
 			return -EINVAL;
 		}
 
@@ -5864,7 +5908,7 @@ static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
 
 static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err;
 	u32 bcn_timeout;
 	__le32 roamtrigger[2];
@@ -5877,7 +5921,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 		bcn_timeout = BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_ON;
 	err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout", bcn_timeout);
 	if (err) {
-		bphy_err(wiphy, "bcn_timeout error (%d)\n", err);
+		bphy_err(drvr, "bcn_timeout error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5889,7 +5933,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_int_set(ifp, "roam_off",
 				      ifp->drvr->settings->roamoff);
 	if (err) {
-		bphy_err(wiphy, "roam_off error (%d)\n", err);
+		bphy_err(drvr, "roam_off error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5898,7 +5942,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_TRIGGER,
 				     (void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
-		bphy_err(wiphy, "WLC_SET_ROAM_TRIGGER error (%d)\n", err);
+		bphy_err(drvr, "WLC_SET_ROAM_TRIGGER error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5907,7 +5951,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_DELTA,
 				     (void *)roam_delta, sizeof(roam_delta));
 	if (err) {
-		bphy_err(wiphy, "WLC_SET_ROAM_DELTA error (%d)\n", err);
+		bphy_err(drvr, "WLC_SET_ROAM_DELTA error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5918,26 +5962,26 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 static s32
 brcmf_dongle_scantime(struct brcmf_if *ifp)
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	s32 err = 0;
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 				    BRCMF_SCAN_CHANNEL_TIME);
 	if (err) {
-		bphy_err(wiphy, "Scan assoc time error (%d)\n", err);
+		bphy_err(drvr, "Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 				    BRCMF_SCAN_UNASSOC_TIME);
 	if (err) {
-		bphy_err(wiphy, "Scan unassoc time error (%d)\n", err);
+		bphy_err(drvr, "Scan unassoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_PASSIVE_TIME,
 				    BRCMF_SCAN_PASSIVE_TIME);
 	if (err) {
-		bphy_err(wiphy, "Scan passive time error (%d)\n", err);
+		bphy_err(drvr, "Scan passive time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
@@ -5970,7 +6014,8 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 				    u32 bw_cap[])
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
-	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
+	struct brcmf_pub *drvr = cfg->pub;
+	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
 	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *channel;
 	struct brcmf_chanspec_list *list;
@@ -5991,7 +6036,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_iovar_data_get(ifp, "chanspecs", pbuf,
 				       BRCMF_DCMD_MEDLEN);
 	if (err) {
-		bphy_err(wiphy, "get chanspecs error (%d)\n", err);
+		bphy_err(drvr, "get chanspecs error (%d)\n", err);
 		goto fail_pbuf;
 	}
 
@@ -6014,7 +6059,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 		} else if (ch.band == BRCMU_CHAN_BAND_5G) {
 			band = wiphy->bands[NL80211_BAND_5GHZ];
 		} else {
-			bphy_err(wiphy, "Invalid channel Spec. 0x%x.\n",
+			bphy_err(drvr, "Invalid channel Spec. 0x%x.\n",
 				 ch.chspec);
 			continue;
 		}
@@ -6038,7 +6083,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 			/* It seems firmware supports some channel we never
 			 * considered. Something new in IEEE standard?
 			 */
-			bphy_err(wiphy, "Ignoring unexpected firmware channel %d\n",
+			bphy_err(drvr, "Ignoring unexpected firmware channel %d\n",
 				 ch.control_ch_num);
 			continue;
 		}
@@ -6092,8 +6137,8 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 
 static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
-	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
+	struct brcmf_pub *drvr = cfg->pub;
+	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
 	struct ieee80211_supported_band *band;
 	struct brcmf_fil_bwcap_le band_bwcap;
 	struct brcmf_chanspec_list *list;
@@ -6139,7 +6184,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 		err = brcmf_fil_iovar_data_get(ifp, "chanspecs", pbuf,
 					       BRCMF_DCMD_MEDLEN);
 		if (err) {
-			bphy_err(wiphy, "get chanspecs error (%d)\n", err);
+			bphy_err(drvr, "get chanspecs error (%d)\n", err);
 			kfree(pbuf);
 			return err;
 		}
@@ -6170,7 +6215,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 
 static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 {
-	struct wiphy *wiphy = ifp->drvr->wiphy;
+	struct brcmf_pub *drvr = ifp->drvr;
 	u32 band, mimo_bwcap;
 	int err;
 
@@ -6206,7 +6251,7 @@ static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 		bw_cap[NL80211_BAND_5GHZ] |= WLC_BW_20MHZ_BIT;
 		break;
 	default:
-		bphy_err(wiphy, "invalid mimo_bw_cap value\n");
+		bphy_err(drvr, "invalid mimo_bw_cap value\n");
 	}
 }
 
@@ -6281,7 +6326,8 @@ static void brcmf_update_vht_cap(struct ieee80211_supported_band *band,
 
 static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 {
-	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
+	struct brcmf_pub *drvr = cfg->pub;
+	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	u32 nmode = 0;
 	u32 vhtmode = 0;
@@ -6298,7 +6344,7 @@ static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 	(void)brcmf_fil_iovar_int_get(ifp, "vhtmode", &vhtmode);
 	err = brcmf_fil_iovar_int_get(ifp, "nmode", &nmode);
 	if (err) {
-		bphy_err(wiphy, "nmode error (%d)\n", err);
+		bphy_err(drvr, "nmode error (%d)\n", err);
 	} else {
 		brcmf_get_bwcap(ifp, bw_cap);
 	}
@@ -6308,7 +6354,7 @@ static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 
 	err = brcmf_fil_iovar_int_get(ifp, "rxchain", &rxchain);
 	if (err) {
-		bphy_err(wiphy, "rxchain error (%d)\n", err);
+		bphy_err(drvr, "rxchain error (%d)\n", err);
 		nchain = 1;
 	} else {
 		for (nchain = 0; rxchain; nchain++)
@@ -6318,7 +6364,7 @@ static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 
 	err = brcmf_construct_chaninfo(cfg, bw_cap);
 	if (err) {
-		bphy_err(wiphy, "brcmf_construct_chaninfo failed (%d)\n", err);
+		bphy_err(drvr, "brcmf_construct_chaninfo failed (%d)\n", err);
 		return err;
 	}
 
@@ -6525,12 +6571,13 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 #ifdef CONFIG_PM
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct wiphy_wowlan_support *wowl;
 
 	wowl = kmemdup(&brcmf_wowlan_support, sizeof(brcmf_wowlan_support),
 		       GFP_KERNEL);
 	if (!wowl) {
-		bphy_err(wiphy, "only support basic wowlan features\n");
+		bphy_err(drvr, "only support basic wowlan features\n");
 		wiphy->wowlan = &brcmf_wowlan_support;
 		return;
 	}
@@ -6627,7 +6674,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BANDLIST, &bandlist,
 				     sizeof(bandlist));
 	if (err) {
-		bphy_err(wiphy, "could not obtain band info: err=%d\n", err);
+		bphy_err(drvr, "could not obtain band info: err=%d\n", err);
 		return err;
 	}
 	/* first entry in bandlist is number of bands */
@@ -6676,7 +6723,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 
 static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
 	struct brcmf_if *ifp;
@@ -6714,7 +6761,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_FAKEFRAG, 1);
 	if (err) {
-		bphy_err(wiphy, "failed to set frameburst mode\n");
+		bphy_err(drvr, "failed to set frameburst mode\n");
 		goto default_conf_out;
 	}
 
@@ -6895,6 +6942,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
+	struct brcmf_pub *drvr = cfg->pub;
 	struct brcmf_fil_country_le ccreq;
 	s32 err;
 	int i;
@@ -6906,7 +6954,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 	/* ignore non-ISO3166 country codes */
 	for (i = 0; i < 2; i++)
 		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
-			bphy_err(wiphy, "not an ISO3166 code (0x%02x 0x%02x)\n",
+			bphy_err(drvr, "not an ISO3166 code (0x%02x 0x%02x)\n",
 				 req->alpha2[0], req->alpha2[1]);
 			return;
 		}
@@ -6916,7 +6964,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_data_get(ifp, "country", &ccreq, sizeof(ccreq));
 	if (err) {
-		bphy_err(wiphy, "Country code iovar returned err = %d\n", err);
+		bphy_err(drvr, "Country code iovar returned err = %d\n", err);
 		return;
 	}
 
@@ -6926,7 +6974,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_data_set(ifp, "country", &ccreq, sizeof(ccreq));
 	if (err) {
-		bphy_err(wiphy, "Firmware rejected country setting\n");
+		bphy_err(drvr, "Firmware rejected country setting\n");
 		return;
 	}
 	brcmf_setup_wiphybands(cfg);
@@ -6972,13 +7020,13 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	u16 *cap = NULL;
 
 	if (!ndev) {
-		bphy_err(wiphy, "ndev is invalid\n");
+		bphy_err(drvr, "ndev is invalid\n");
 		return NULL;
 	}
 
 	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
 	if (!cfg) {
-		bphy_err(wiphy, "Could not allocate wiphy device\n");
+		bphy_err(drvr, "Could not allocate wiphy device\n");
 		return NULL;
 	}
 
@@ -6999,7 +7047,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 
 	err = wl_init_priv(cfg);
 	if (err) {
-		bphy_err(wiphy, "Failed to init iwm_priv (%d)\n", err);
+		bphy_err(drvr, "Failed to init iwm_priv (%d)\n", err);
 		brcmf_free_vif(vif);
 		goto wiphy_out;
 	}
@@ -7008,7 +7056,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	/* determine d11 io type before wiphy setup */
 	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &io_type);
 	if (err) {
-		bphy_err(wiphy, "Failed to get D11 version (%d)\n", err);
+		bphy_err(drvr, "Failed to get D11 version (%d)\n", err);
 		goto priv_out;
 	}
 	cfg->d11inf.io_type = (u8)io_type;
@@ -7042,13 +7090,13 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 #endif
 	err = wiphy_register(wiphy);
 	if (err < 0) {
-		bphy_err(wiphy, "Could not register wiphy device (%d)\n", err);
+		bphy_err(drvr, "Could not register wiphy device (%d)\n", err);
 		goto priv_out;
 	}
 
 	err = brcmf_setup_wiphybands(cfg);
 	if (err) {
-		bphy_err(wiphy, "Setting wiphy bands failed (%d)\n", err);
+		bphy_err(drvr, "Setting wiphy bands failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 
@@ -7066,24 +7114,24 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 
 	err = brcmf_fweh_activate_events(ifp);
 	if (err) {
-		bphy_err(wiphy, "FWEH activation failed (%d)\n", err);
+		bphy_err(drvr, "FWEH activation failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 
 	err = brcmf_p2p_attach(cfg, p2pdev_forced);
 	if (err) {
-		bphy_err(wiphy, "P2P initialisation failed (%d)\n", err);
+		bphy_err(drvr, "P2P initialisation failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 	err = brcmf_btcoex_attach(cfg);
 	if (err) {
-		bphy_err(wiphy, "BT-coex initialisation failed (%d)\n", err);
+		bphy_err(drvr, "BT-coex initialisation failed (%d)\n", err);
 		brcmf_p2p_detach(&cfg->p2p);
 		goto wiphy_unreg_out;
 	}
 	err = brcmf_pno_attach(cfg);
 	if (err) {
-		bphy_err(wiphy, "PNO initialisation failed (%d)\n", err);
+		bphy_err(drvr, "PNO initialisation failed (%d)\n", err);
 		brcmf_btcoex_detach(cfg);
 		brcmf_p2p_detach(&cfg->p2p);
 		goto wiphy_unreg_out;
@@ -7103,7 +7151,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	/* (re-) activate FWEH event handling */
 	err = brcmf_fweh_activate_events(ifp);
 	if (err) {
-		bphy_err(wiphy, "FWEH activation failed (%d)\n", err);
+		bphy_err(drvr, "FWEH activation failed (%d)\n", err);
 		goto detach;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 3cf853c84a9e..2998726b62c3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -62,12 +62,12 @@ void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 	} while (0)
 #endif
 
-#define bphy_err(wiphy, fmt, ...)					\
+#define bphy_err(drvr, fmt, ...)					\
 	do {								\
 		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
 		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
 		    net_ratelimit())					\
-			wiphy_err(wiphy, "%s: " fmt, __func__,		\
+			wiphy_err((drvr)->wiphy, "%s: " fmt, __func__,	\
 				  ##__VA_ARGS__);			\
 	} while (0)
 
-- 
2.20.1

