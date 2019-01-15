Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF029C43612
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 06:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5905C2085A
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 06:22:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KnD9zS1T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfAOGVL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 01:21:11 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45293 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfAOGVK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 01:21:10 -0500
Received: by mail-lj1-f193.google.com with SMTP id s5-v6so1262829ljd.12
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 22:21:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hkztmPx3HEz5FOj3EWvKJ5omxelLjNzomsG1t+/IMBA=;
        b=KnD9zS1TNrUkDew7xVBRxmmA4zE8syRGq2zKOgk7KxFZ8nYqPPDqnk7V4CqZAXybFo
         TXbroH9mVz/lmv6dNNayuuTuo+786XcoVbPUGKvktXGNFu86sv+xAwamVp6xoCCx/8lH
         9vkaAMpZbDMSY/W2fr8AgbL5rQHcRw4+hNcyWCQZjGlIQiXDSIZWZdxOYQTxUR7aBLnh
         N9eaeKTWX2AXM92DAIxVHd3tkdKl4ME78Drmq1t0BodYiTYSCKcnkLuKA5UWcacryjUW
         AHsg6XsjoeCxQsJZISP5BX8A7EdPGTTZ0MDk31V8HFm17N2O2JN6aCRDS/wVLm87ZgG6
         tA0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hkztmPx3HEz5FOj3EWvKJ5omxelLjNzomsG1t+/IMBA=;
        b=b5tjOcN0xQLygngm+2pOuqqrAYQDVw6zKn243SP+wgnEdAQrA2YpoachEjkvIPL80n
         yfiy+kQNkH0M6sypGVFVjtD8cgvMagxCxbzjPBHlw+EvkZ76+PdN8+4Ju5zS6IHhAfeZ
         awOrD9V6uZV2XKzTtO6Cod6LEcmFnY7wSe9QT5W0VgVEsJUxiE4Sl1ni/AeNsCBGemsI
         veCtIWFCnfSYfc4J5FJpaB4qfr8I9kpQBniLRcJGbtRPreJ5CyDrDKBfJTxIFxG9vFJc
         OQacqlYpaah6kTWjycpxVwWksXq+VBjul5L66sDbp+nfpEqnIrK0/OA6SLWahtCvoFb1
         Rf4Q==
X-Gm-Message-State: AJcUukfGKtKeJ1mLWDypGSj8zyQLZJACrwWpqzJ5NpSQMe/QCMpwupT2
        PncfpbIfb2kCh5Ug0zqd0NU=
X-Google-Smtp-Source: ALg8bN53WV9jho/PKTzpc3DEK0KCq0RS0jw+4V317vVWlzRyWcUZa/up9+H70caNgmMeHzmqrSgG7A==
X-Received: by 2002:a2e:9457:: with SMTP id o23-v6mr1653933ljh.7.1547533262710;
        Mon, 14 Jan 2019 22:21:02 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id x204sm446227lfa.5.2019.01.14.22.21.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 22:21:01 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/2] brcmfmac: pass bus to the __brcmf_err() in cfg80211.c
Date:   Tue, 15 Jan 2019 07:20:56 +0100
Message-Id: <20190115062056.27384-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190115061949.27260-1-zajec5@gmail.com>
References: <20190115061949.27260-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This enables dev_err() usage (instead of pr_err()) in the __brcmf_err().
It makes error messages more meaningful and is important for debugging
errors/bugs on systems with multiple brcmfmac supported devices.

All other files should follow & get updated similarly (soon).

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Ideally all files should get updated at the same time but I'm reluctant
to work on that until I see my changes accepted. There are over 500
occurrences of brcmf_err() and I'll loose hours again if someone nacks
this.

Thus the safe way - updating a single file only as for now. I promise to
work on the rest of the code as soon as it hits the Kalle's tree. Sounds
acceptable?
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 502 +++++++++++-------
 .../broadcom/brcm80211/brcmfmac/debug.h       |   2 +
 2 files changed, 305 insertions(+), 199 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 35301237d435..da04c2a2cc59 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -23,6 +23,15 @@
 #include <net/cfg80211.h>
 #include <net/netlink.h>
 
+/* Custom brcmf_err() that takes bus arg and passes it further */
+#define brcmf_err(bus, fmt, ...)					\
+	do {								\
+		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
+		    IS_ENABLED(CONFIG_BRCM_TRACING) ||			\
+		    net_ratelimit())					\
+			__brcmf_err(bus, __func__, fmt, ##__VA_ARGS__);	\
+	} while (0)
+
 #include <brcmu_utils.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
@@ -457,6 +466,7 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 static int
 send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	int err;
 	struct brcmf_wsec_key_le key_le;
 
@@ -468,7 +478,7 @@ send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 					sizeof(key_le));
 
 	if (err)
-		brcmf_err("wsec_key error (%d)\n", err);
+		brcmf_err(bus, "wsec_key error (%d)\n", err);
 	return err;
 }
 
@@ -508,6 +518,7 @@ static int brcmf_get_first_free_bsscfgidx(struct brcmf_pub *drvr)
 
 static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_mbss_ssid_le mbss_ssid_le;
 	int bsscfgidx;
 	int err;
@@ -524,7 +535,7 @@ static int brcmf_cfg80211_request_ap_if(struct brcmf_if *ifp)
 	err = brcmf_fil_bsscfg_data_set(ifp, "bsscfg:ssid", &mbss_ssid_le,
 					sizeof(mbss_ssid_le));
 	if (err < 0)
-		brcmf_err("setting ssid failed %d\n", err);
+		brcmf_err(bus, "setting ssid failed %d\n", err);
 
 	return err;
 }
@@ -541,6 +552,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 				      struct vif_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(cfg_to_ndev(cfg));
 	struct brcmf_cfg80211_vif *vif;
 	int err;
@@ -567,7 +579,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
-		brcmf_err("timeout occurred\n");
+		brcmf_err(bus, "timeout occurred\n");
 		err = -EIO;
 		goto fail;
 	}
@@ -575,7 +587,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	/* interface created in firmware */
 	ifp = vif->ifp;
 	if (!ifp) {
-		brcmf_err("no if pointer provided\n");
+		brcmf_err(bus, "no if pointer provided\n");
 		err = -ENOENT;
 		goto fail;
 	}
@@ -583,7 +595,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
-		brcmf_err("Registering netdevice failed\n");
+		brcmf_err(bus, "Registering netdevice failed\n");
 		free_netdev(ifp->ndev);
 		goto fail;
 	}
@@ -614,13 +626,15 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     enum nl80211_iftype type,
 						     struct vif_params *params)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct wireless_dev *wdev;
 	int err;
 
 	brcmf_dbg(TRACE, "enter: %s type %d\n", name, type);
 	err = brcmf_vif_add_validate(wiphy_to_cfg(wiphy), type);
 	if (err) {
-		brcmf_err("iface validation failed: err=%d\n", err);
+		brcmf_err(bus, "iface validation failed: err=%d\n", err);
 		return ERR_PTR(err);
 	}
 	switch (type) {
@@ -645,7 +659,7 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	}
 
 	if (IS_ERR(wdev))
-		brcmf_err("add iface %s type %d failed: err=%d\n",
+		brcmf_err(bus, "add iface %s type %d failed: err=%d\n",
 			  name, type, (int)PTR_ERR(wdev));
 	else
 		brcmf_cfg80211_update_proto_addr_mode(wdev);
@@ -661,12 +675,13 @@ static void brcmf_scan_config_mpc(struct brcmf_if *ifp, int mpc)
 
 void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	s32 err = 0;
 
 	if (check_vif_up(ifp->vif)) {
 		err = brcmf_fil_iovar_int_set(ifp, "mpc", mpc);
 		if (err) {
-			brcmf_err("fail to set mpc\n");
+			brcmf_err(bus, "fail to set mpc\n");
 			return;
 		}
 		brcmf_dbg(INFO, "MPC : %d\n", mpc);
@@ -677,6 +692,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				struct brcmf_if *ifp, bool aborted,
 				bool fw_abort)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_scan_params_le params_le;
 	struct cfg80211_scan_request *scan_request;
 	u64 reqid;
@@ -711,7 +727,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
 					     &params_le, sizeof(params_le));
 		if (err)
-			brcmf_err("Scan abort failed\n");
+			brcmf_err(bus, "Scan abort failed\n");
 	}
 
 	brcmf_scan_config_mpc(ifp, 1);
@@ -754,6 +770,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 				       struct wireless_dev *wdev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct net_device *ndev = wdev->netdev;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	int ret;
@@ -763,7 +780,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 
 	err = brcmf_fil_bsscfg_data_set(ifp, "interface_remove", NULL, 0);
 	if (err) {
-		brcmf_err("interface_remove failed %d\n", err);
+		brcmf_err(bus, "interface_remove failed %d\n", err);
 		goto err_unarm;
 	}
 
@@ -771,7 +788,7 @@ static int brcmf_cfg80211_del_ap_iface(struct wiphy *wiphy,
 	ret = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_DEL,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	if (!ret) {
-		brcmf_err("timeout occurred\n");
+		brcmf_err(bus, "timeout occurred\n");
 		err = -EIO;
 		goto err_unarm;
 	}
@@ -832,6 +849,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 struct vif_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	s32 infra = 0;
@@ -873,13 +891,13 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 	err = brcmf_vif_change_validate(wiphy_to_cfg(wiphy), vif, type);
 	if (err) {
-		brcmf_err("iface validation failed: err=%d\n", err);
+		brcmf_err(bus, "iface validation failed: err=%d\n", err);
 		return err;
 	}
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_WDS:
-		brcmf_err("type (%d) : currently we do not support this type\n",
+		brcmf_err(bus, "type (%d) : currently we do not support this type\n",
 			  type);
 		return -EOPNOTSUPP;
 	case NL80211_IFTYPE_ADHOC:
@@ -908,7 +926,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	} else {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, infra);
 		if (err) {
-			brcmf_err("WLC_SET_INFRA error (%d)\n", err);
+			brcmf_err(bus, "WLC_SET_INFRA error (%d)\n", err);
 			err = -EAGAIN;
 			goto done;
 		}
@@ -999,6 +1017,7 @@ static s32
 brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		struct cfg80211_scan_request *request)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	s32 params_size = BRCMF_SCAN_PARAMS_FIXED_SIZE +
 			  offsetof(struct brcmf_escan_params_le, params_le);
 	struct brcmf_escan_params_le *params;
@@ -1030,7 +1049,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp,
 		if (err == -EBUSY)
 			brcmf_dbg(INFO, "system busy : escan canceled\n");
 		else
-			brcmf_err("error (%d)\n", err);
+			brcmf_err(bus, "error (%d)\n", err);
 	}
 
 	kfree(params);
@@ -1067,6 +1086,7 @@ static s32
 brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
 
@@ -1076,21 +1096,22 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 		return -EIO;
 
 	if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("Scanning already: status (%lu)\n", cfg->scan_status);
+		brcmf_err(bus, "Scanning already: status (%lu)\n",
+			  cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_SCAN_STATUS_ABORT, &cfg->scan_status)) {
-		brcmf_err("Scanning being aborted: status (%lu)\n",
+		brcmf_err(bus, "Scanning being aborted: status (%lu)\n",
 			  cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
-		brcmf_err("Scanning suppressed: status (%lu)\n",
+		brcmf_err(bus, "Scanning suppressed: status (%lu)\n",
 			  cfg->scan_status);
 		return -EAGAIN;
 	}
 	if (test_bit(BRCMF_VIF_STATUS_CONNECTING, &vif->sme_state)) {
-		brcmf_err("Connecting: status (%lu)\n", vif->sme_state);
+		brcmf_err(bus, "Connecting: status (%lu)\n", vif->sme_state);
 		return -EAGAIN;
 	}
 
@@ -1124,7 +1145,7 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 	return 0;
 
 scan_out:
-	brcmf_err("scan error (%d)\n", err);
+	brcmf_err(bus, "scan error (%d)\n", err);
 	clear_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	cfg->scan_request = NULL;
 	return err;
@@ -1132,36 +1153,41 @@ brcmf_cfg80211_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 
 static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	s32 err = 0;
 
-	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "rtsthresh",
-				      rts_threshold);
+	err = brcmf_fil_iovar_int_set(ifp, "rtsthresh", rts_threshold);
 	if (err)
-		brcmf_err("Error (%d)\n", err);
+		brcmf_err(bus, "Error (%d)\n", err);
 
 	return err;
 }
 
 static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	s32 err = 0;
 
-	err = brcmf_fil_iovar_int_set(netdev_priv(ndev), "fragthresh",
+	err = brcmf_fil_iovar_int_set(ifp, "fragthresh",
 				      frag_threshold);
 	if (err)
-		brcmf_err("Error (%d)\n", err);
+		brcmf_err(bus, "Error (%d)\n", err);
 
 	return err;
 }
 
 static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	s32 err = 0;
 	u32 cmd = (l ? BRCMF_C_SET_LRL : BRCMF_C_SET_SRL);
 
-	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), cmd, retry);
+	err = brcmf_fil_cmd_int_set(ifp, cmd, retry);
 	if (err) {
-		brcmf_err("cmd (%d) , error (%d)\n", cmd, err);
+		brcmf_err(bus, "cmd (%d) , error (%d)\n", cmd, err);
 		return err;
 	}
 	return err;
@@ -1237,6 +1263,7 @@ static u16 brcmf_map_fw_linkdown_reason(const struct brcmf_event_msg *e)
 
 static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_wsec_pmk_le pmk;
 	int i, err;
 
@@ -1250,7 +1277,7 @@ static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
 				     &pmk, sizeof(pmk));
 	if (err < 0)
-		brcmf_err("failed to change PSK in firmware (len=%u)\n",
+		brcmf_err(bus, "failed to change PSK in firmware (len=%u)\n",
 			  pmk_len);
 
 	return err;
@@ -1259,6 +1286,7 @@ static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(vif->wdev.wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	s32 err = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1268,7 +1296,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_vif *vif, u16 reason)
 		err = brcmf_fil_cmd_data_set(vif->ifp,
 					     BRCMF_C_DISASSOC, NULL, 0);
 		if (err) {
-			brcmf_err("WLC_DISASSOC failed (%d)\n", err);
+			brcmf_err(bus, "WLC_DISASSOC failed (%d)\n", err);
 		}
 		if ((vif->wdev.iftype == NL80211_IFTYPE_STATION) ||
 		    (vif->wdev.iftype == NL80211_IFTYPE_P2P_CLIENT))
@@ -1290,6 +1318,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		      struct cfg80211_ibss_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_join_params join_params;
@@ -1356,7 +1385,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_iovar_int_set(ifp, "wsec", wsec);
 	if (err) {
-		brcmf_err("wsec failed (%d)\n", err);
+		brcmf_err(bus, "wsec failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1368,7 +1397,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD, bcnprd);
 	if (err) {
-		brcmf_err("WLC_SET_BCNPRD failed (%d)\n", err);
+		brcmf_err(bus, "WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1413,7 +1442,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_CHANNEL,
 					    target_channel);
 		if (err) {
-			brcmf_err("WLC_SET_CHANNEL failed (%d)\n", err);
+			brcmf_err(bus, "WLC_SET_CHANNEL failed (%d)\n", err);
 			goto done;
 		}
 	} else
@@ -1425,7 +1454,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err) {
-		brcmf_err("WLC_SET_SSID failed (%d)\n", err);
+		brcmf_err(bus, "WLC_SET_SSID failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1461,6 +1490,8 @@ brcmf_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 static s32 brcmf_set_wpa_version(struct net_device *ndev,
 				 struct cfg80211_connect_params *sme)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
@@ -1473,9 +1504,9 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 	else
 		val = WPA_AUTH_DISABLED;
 	brcmf_dbg(CONN, "setting wpa_auth to 0x%0x\n", val);
-	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wpa_auth", val);
+	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", val);
 	if (err) {
-		brcmf_err("set wpa_auth failed (%d)\n", err);
+		brcmf_err(bus, "set wpa_auth failed (%d)\n", err);
 		return err;
 	}
 	sec = &profile->sec;
@@ -1486,6 +1517,8 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 static s32 brcmf_set_auth_type(struct net_device *ndev,
 			       struct cfg80211_connect_params *sme)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 val = 0;
@@ -1506,9 +1539,9 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		break;
 	}
 
-	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "auth", val);
+	err = brcmf_fil_bsscfg_int_set(ifp, "auth", val);
 	if (err) {
-		brcmf_err("set auth failed (%d)\n", err);
+		brcmf_err(bus, "set auth failed (%d)\n", err);
 		return err;
 	}
 	sec = &profile->sec;
@@ -1520,6 +1553,8 @@ static s32
 brcmf_set_wsec_mode(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	s32 pval = 0;
@@ -1543,7 +1578,7 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 			pval = AES_ENABLED;
 			break;
 		default:
-			brcmf_err("invalid cipher pairwise (%d)\n",
+			brcmf_err(bus, "invalid cipher pairwise (%d)\n",
 				  sme->crypto.ciphers_pairwise[0]);
 			return -EINVAL;
 		}
@@ -1564,7 +1599,7 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 			gval = AES_ENABLED;
 			break;
 		default:
-			brcmf_err("invalid cipher group (%d)\n",
+			brcmf_err(bus, "invalid cipher group (%d)\n",
 				  sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1578,9 +1613,9 @@ brcmf_set_wsec_mode(struct net_device *ndev,
 		pval = AES_ENABLED;
 
 	wsec = pval | gval;
-	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wsec", wsec);
+	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err) {
-		brcmf_err("error (%d)\n", err);
+		brcmf_err(bus, "error (%d)\n", err);
 		return err;
 	}
 
@@ -1595,6 +1630,7 @@ static s32
 brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	s32 val;
 	s32 err;
@@ -1613,7 +1649,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 
 	err = brcmf_fil_bsscfg_int_get(netdev_priv(ndev), "wpa_auth", &val);
 	if (err) {
-		brcmf_err("could not get wpa_auth (%d)\n", err);
+		brcmf_err(bus, "could not get wpa_auth (%d)\n", err);
 		return err;
 	}
 	if (val & (WPA_AUTH_PSK | WPA_AUTH_UNSPECIFIED)) {
@@ -1627,7 +1663,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			val = WPA_AUTH_PSK;
 			break;
 		default:
-			brcmf_err("invalid cipher group (%d)\n",
+			brcmf_err(bus, "invalid cipher group (%d)\n",
 				  sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1658,7 +1694,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 			val = WPA2_AUTH_PSK | WPA2_AUTH_FT;
 			break;
 		default:
-			brcmf_err("invalid cipher group (%d)\n",
+			brcmf_err(bus, "invalid cipher group (%d)\n",
 				  sme->crypto.cipher_group);
 			return -EINVAL;
 		}
@@ -1705,7 +1741,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 	brcmf_dbg(CONN, "setting wpa_auth to %d\n", val);
 	err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "wpa_auth", val);
 	if (err) {
-		brcmf_err("could not set wpa_auth (%d)\n", err);
+		brcmf_err(bus, "could not set wpa_auth (%d)\n", err);
 		return err;
 	}
 
@@ -1716,6 +1752,8 @@ static s32
 brcmf_set_sharedkey(struct net_device *ndev,
 		    struct cfg80211_connect_params *sme)
 {
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_cfg80211_profile *profile = ndev_to_prof(ndev);
 	struct brcmf_cfg80211_security *sec;
 	struct brcmf_wsec_key key;
@@ -1742,7 +1780,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	key.len = (u32) sme->key_len;
 	key.index = (u32) sme->key_idx;
 	if (key.len > sizeof(key.data)) {
-		brcmf_err("Too long key length (%u)\n", key.len);
+		brcmf_err(bus, "Too long key length (%u)\n", key.len);
 		return -EINVAL;
 	}
 	memcpy(key.data, sme->key, key.len);
@@ -1755,7 +1793,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 		key.algo = CRYPTO_ALGO_WEP128;
 		break;
 	default:
-		brcmf_err("Invalid algorithm (%d)\n",
+		brcmf_err(bus, "Invalid algorithm (%d)\n",
 			  sme->crypto.ciphers_pairwise[0]);
 		return -EINVAL;
 	}
@@ -1763,16 +1801,16 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	brcmf_dbg(CONN, "key length (%d) key index (%d) algo (%d)\n",
 		  key.len, key.index, key.algo);
 	brcmf_dbg(CONN, "key \"%s\"\n", key.data);
-	err = send_key_to_dongle(netdev_priv(ndev), &key);
+	err = send_key_to_dongle(ifp, &key);
 	if (err)
 		return err;
 
 	if (sec->auth_type == NL80211_AUTHTYPE_SHARED_KEY) {
 		brcmf_dbg(CONN, "set auth_type to shared key\n");
 		val = WL_AUTH_SHARED_KEY;	/* shared key */
-		err = brcmf_fil_bsscfg_int_set(netdev_priv(ndev), "auth", val);
+		err = brcmf_fil_bsscfg_int_set(ifp, "auth", val);
 		if (err)
-			brcmf_err("set auth failed (%d)\n", err);
+			brcmf_err(bus, "set auth failed (%d)\n", err);
 	}
 	return err;
 }
@@ -1792,6 +1830,7 @@ enum nl80211_auth_type brcmf_war_auth_type(struct brcmf_if *ifp,
 static void brcmf_set_join_pref(struct brcmf_if *ifp,
 				struct cfg80211_bss_selection *bss_select)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_join_pref_params join_pref_params[2];
 	enum nl80211_band band;
 	int err, i = 0;
@@ -1830,7 +1869,7 @@ static void brcmf_set_join_pref(struct brcmf_if *ifp,
 	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
 				       sizeof(join_pref_params));
 	if (err)
-		brcmf_err("Set join_pref error (%d)\n", err);
+		brcmf_err(bus, "Set join_pref error (%d)\n", err);
 }
 
 static s32
@@ -1838,6 +1877,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		       struct cfg80211_connect_params *sme)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct ieee80211_channel *chan = sme->channel;
@@ -1857,7 +1897,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	if (!sme->ssid) {
-		brcmf_err("Invalid ssid\n");
+		brcmf_err(bus, "Invalid ssid\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -1886,7 +1926,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
 				    sme->ie, sme->ie_len);
 	if (err)
-		brcmf_err("Set Assoc REQ IE Failed\n");
+		brcmf_err(bus, "Set Assoc REQ IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc request\n");
 
@@ -1907,32 +1947,32 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_set_wpa_version(ndev, sme);
 	if (err) {
-		brcmf_err("wl_set_wpa_version failed (%d)\n", err);
+		brcmf_err(bus, "wl_set_wpa_version failed (%d)\n", err);
 		goto done;
 	}
 
 	sme->auth_type = brcmf_war_auth_type(ifp, sme->auth_type);
 	err = brcmf_set_auth_type(ndev, sme);
 	if (err) {
-		brcmf_err("wl_set_auth_type failed (%d)\n", err);
+		brcmf_err(bus, "wl_set_auth_type failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_wsec_mode(ndev, sme);
 	if (err) {
-		brcmf_err("wl_set_set_cipher failed (%d)\n", err);
+		brcmf_err(bus, "wl_set_set_cipher failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_key_mgmt(ndev, sme);
 	if (err) {
-		brcmf_err("wl_set_key_mgmt failed (%d)\n", err);
+		brcmf_err(bus, "wl_set_key_mgmt failed (%d)\n", err);
 		goto done;
 	}
 
 	err = brcmf_set_sharedkey(ndev, sme);
 	if (err) {
-		brcmf_err("brcmf_set_sharedkey failed (%d)\n", err);
+		brcmf_err(bus, "brcmf_set_sharedkey failed (%d)\n", err);
 		goto done;
 	}
 
@@ -1949,7 +1989,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 		/* enable firmware supplicant for this interface */
 		err = brcmf_fil_iovar_int_set(ifp, "sup_wpa", 1);
 		if (err < 0) {
-			brcmf_err("failed to enable fw supplicant\n");
+			brcmf_err(bus, "failed to enable fw supplicant\n");
 			goto done;
 		}
 	}
@@ -2044,7 +2084,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 				     &join_params, join_params_size);
 	if (err)
-		brcmf_err("BRCMF_C_SET_SSID failed (%d)\n", err);
+		brcmf_err(bus, "BRCMF_C_SET_SSID failed (%d)\n", err);
 
 done:
 	if (err)
@@ -2057,6 +2097,8 @@ static s32
 brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 		       u16 reason_code)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_scb_val_le scbval;
@@ -2075,7 +2117,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_DISASSOC,
 				     &scbval, sizeof(scbval));
 	if (err)
-		brcmf_err("error (%d)\n", err);
+		brcmf_err(bus, "error (%d)\n", err);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -2086,6 +2128,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 			    enum nl80211_tx_power_setting type, s32 mbm)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
@@ -2102,7 +2145,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	case NL80211_TX_POWER_LIMITED:
 	case NL80211_TX_POWER_FIXED:
 		if (mbm < 0) {
-			brcmf_err("TX_POWER_FIXED - dbm is negative\n");
+			brcmf_err(bus, "TX_POWER_FIXED - dbm is negative\n");
 			err = -EINVAL;
 			goto done;
 		}
@@ -2112,7 +2155,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 		qdbm |= WL_TXPWR_OVERRIDE;
 		break;
 	default:
-		brcmf_err("Unsupported type %d\n", type);
+		brcmf_err(bus, "Unsupported type %d\n", type);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2120,11 +2163,11 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 	disable = WL_RADIO_SW_DISABLE << 16;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_RADIO, disable);
 	if (err)
-		brcmf_err("WLC_SET_RADIO error (%d)\n", err);
+		brcmf_err(bus, "WLC_SET_RADIO error (%d)\n", err);
 
 	err = brcmf_fil_iovar_int_set(ifp, "qtxpower", qdbm);
 	if (err)
-		brcmf_err("qtxpower error (%d)\n", err);
+		brcmf_err(bus, "qtxpower error (%d)\n", err);
 
 done:
 	brcmf_dbg(TRACE, "Exit %d (qdbm)\n", qdbm & ~WL_TXPWR_OVERRIDE);
@@ -2135,6 +2178,8 @@ static s32
 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 			    s32 *dbm)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_cfg80211_vif *vif = wdev_to_vif(wdev);
 	s32 qdbm = 0;
 	s32 err;
@@ -2145,7 +2190,7 @@ brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	err = brcmf_fil_iovar_int_get(vif->ifp, "qtxpower", &qdbm);
 	if (err) {
-		brcmf_err("error (%d)\n", err);
+		brcmf_err(bus, "error (%d)\n", err);
 		goto done;
 	}
 	*dbm = (qdbm & ~WL_TXPWR_OVERRIDE) / 4;
@@ -2160,6 +2205,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 				  u8 key_idx, bool unicast, bool multicast)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	u32 index;
 	u32 wsec;
 	s32 err = 0;
@@ -2171,7 +2217,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		brcmf_err("WLC_GET_WSEC error (%d)\n", err);
+		brcmf_err(bus, "WLC_GET_WSEC error (%d)\n", err);
 		goto done;
 	}
 
@@ -2181,7 +2227,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_int_set(ifp,
 					    BRCMF_C_SET_KEY_PRIMARY, index);
 		if (err)
-			brcmf_err("error (%d)\n", err);
+			brcmf_err(bus, "error (%d)\n", err);
 	}
 done:
 	brcmf_dbg(TRACE, "Exit\n");
@@ -2231,6 +2277,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		       struct key_params *params)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_wsec_key *key;
 	s32 val;
 	s32 wsec;
@@ -2245,7 +2292,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (key_idx >= BRCMF_MAX_DEFAULT_KEYS) {
 		/* we ignore this key index in this case */
-		brcmf_err("invalid key index (%d)\n", key_idx);
+		brcmf_err(bus, "invalid key index (%d)\n", key_idx);
 		return -EINVAL;
 	}
 
@@ -2254,7 +2301,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 					      mac_addr);
 
 	if (params->key_len > sizeof(key->data)) {
-		brcmf_err("Too long key length (%u)\n", params->key_len);
+		brcmf_err(bus, "Too long key length (%u)\n", params->key_len);
 		return -EINVAL;
 	}
 
@@ -2308,7 +2355,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_CCMP\n");
 		break;
 	default:
-		brcmf_err("Invalid cipher (0x%x)\n", params->cipher);
+		brcmf_err(bus, "Invalid cipher (0x%x)\n", params->cipher);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2319,13 +2366,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		brcmf_err("get wsec error (%d)\n", err);
+		brcmf_err(bus, "get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec |= val;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err) {
-		brcmf_err("set wsec error (%d)\n", err);
+		brcmf_err(bus, "set wsec error (%d)\n", err);
 		goto done;
 	}
 
@@ -2342,6 +2389,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 {
 	struct key_params params;
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_cfg80211_profile *profile = &ifp->vif->profile;
 	struct brcmf_cfg80211_security *sec;
 	s32 wsec;
@@ -2356,7 +2404,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		brcmf_err("WLC_GET_WSEC error (%d)\n", err);
+		brcmf_err(bus, "WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
 		goto done;
@@ -2377,7 +2425,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev, u8 key_idx,
 		params.cipher = WLAN_CIPHER_SUITE_AES_CMAC;
 		brcmf_dbg(CONN, "WLAN_CIPHER_SUITE_AES_CMAC\n");
 	} else  {
-		brcmf_err("Invalid algo (0x%x)\n", wsec);
+		brcmf_err(bus, "Invalid algo (0x%x)\n", wsec);
 		err = -EINVAL;
 		goto done;
 	}
@@ -2407,6 +2455,7 @@ brcmf_cfg80211_config_default_mgmt_key(struct wiphy *wiphy,
 static void
 brcmf_cfg80211_reconfigure_wep(struct brcmf_if *ifp)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	s32 err;
 	u8 key_idx;
 	struct brcmf_wsec_key *key;
@@ -2423,18 +2472,18 @@ brcmf_cfg80211_reconfigure_wep(struct brcmf_if *ifp)
 
 	err = send_key_to_dongle(ifp, key);
 	if (err) {
-		brcmf_err("Setting WEP key failed (%d)\n", err);
+		brcmf_err(bus, "Setting WEP key failed (%d)\n", err);
 		return;
 	}
 	err = brcmf_fil_bsscfg_int_get(ifp, "wsec", &wsec);
 	if (err) {
-		brcmf_err("get wsec error (%d)\n", err);
+		brcmf_err(bus, "get wsec error (%d)\n", err);
 		return;
 	}
 	wsec |= WEP_ENABLED;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err)
-		brcmf_err("set wsec error (%d)\n", err);
+		brcmf_err(bus, "set wsec error (%d)\n", err);
 }
 
 static void brcmf_convert_sta_flags(u32 fw_sta_flags, struct station_info *si)
@@ -2460,6 +2509,7 @@ static void brcmf_convert_sta_flags(u32 fw_sta_flags, struct station_info *si)
 
 static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct {
 		__le32 len;
 		struct brcmf_bss_info_le bss_le;
@@ -2475,7 +2525,7 @@ static void brcmf_fill_bss_param(struct brcmf_if *ifp, struct station_info *si)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO, buf,
 				     WL_BSS_INFO_MAX);
 	if (err) {
-		brcmf_err("Failed to get bss info (%d)\n", err);
+		brcmf_err(bus, "Failed to get bss info (%d)\n", err);
 		goto out_kfree;
 	}
 	si->filled |= BIT_ULL(NL80211_STA_INFO_BSS_PARAM);
@@ -2497,6 +2547,7 @@ static s32
 brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 				struct station_info *sinfo)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_pktcnt_le pktcnt;
 	s32 err;
@@ -2506,7 +2557,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	/* Get the current tx rate */
 	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_RATE, &rate);
 	if (err < 0) {
-		brcmf_err("BRCMF_C_GET_RATE error (%d)\n", err);
+		brcmf_err(bus, "BRCMF_C_GET_RATE error (%d)\n", err);
 		return err;
 	}
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
@@ -2516,7 +2567,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI, &scbval,
 				     sizeof(scbval));
 	if (err) {
-		brcmf_err("BRCMF_C_GET_RSSI error (%d)\n", err);
+		brcmf_err(bus, "BRCMF_C_GET_RSSI error (%d)\n", err);
 		return err;
 	}
 	rssi = le32_to_cpu(scbval.val);
@@ -2526,7 +2577,7 @@ brcmf_cfg80211_get_station_ibss(struct brcmf_if *ifp,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_GET_PKTCNTS, &pktcnt,
 				     sizeof(pktcnt));
 	if (err) {
-		brcmf_err("BRCMF_C_GET_GET_PKTCNTS error (%d)\n", err);
+		brcmf_err(bus, "BRCMF_C_GET_GET_PKTCNTS error (%d)\n", err);
 		return err;
 	}
 	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS) |
@@ -2545,6 +2596,8 @@ static s32
 brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			   const u8 *mac, struct station_info *sinfo)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_scb_val_le scb_val;
 	s32 err = 0;
@@ -2574,7 +2627,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 					       &sta_info_le,
 					       sizeof(sta_info_le));
 		if (err < 0) {
-			brcmf_err("GET STA INFO failed, %d\n", err);
+			brcmf_err(bus, "GET STA INFO failed, %d\n", err);
 			goto done;
 		}
 	}
@@ -2643,7 +2696,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_RSSI,
 						     &scb_val, sizeof(scb_val));
 			if (err) {
-				brcmf_err("Could not get rssi (%d)\n", err);
+				brcmf_err(bus, "Could not get rssi (%d)\n",
+					  err);
 				goto done;
 			} else {
 				rssi = le32_to_cpu(scb_val.val);
@@ -2663,6 +2717,7 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 			    int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
@@ -2674,7 +2729,7 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 					     &cfg->assoclist,
 					     sizeof(cfg->assoclist));
 		if (err) {
-			brcmf_err("BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
+			brcmf_err(bus, "BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
 				  err);
 			cfg->assoclist.count = 0;
 			return -EOPNOTSUPP;
@@ -2694,6 +2749,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	s32 pm;
 	s32 err = 0;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -2723,9 +2779,9 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PM, pm);
 	if (err) {
 		if (err == -ENODEV)
-			brcmf_err("net_device is not ready yet\n");
+			brcmf_err(bus, "net_device is not ready yet\n");
 		else
-			brcmf_err("error (%d)\n", err);
+			brcmf_err(bus, "error (%d)\n", err);
 	}
 done:
 	brcmf_dbg(TRACE, "Exit\n");
@@ -2736,6 +2792,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 				   struct brcmf_bss_info_le *bi)
 {
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct cfg80211_bss *bss;
 	enum nl80211_band band;
 	struct brcmu_chan ch;
@@ -2748,7 +2805,7 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_info *cfg,
 	struct cfg80211_inform_bss bss_data = {};
 
 	if (le32_to_cpu(bi->length) > WL_BSS_INFO_MAX) {
-		brcmf_err("Bss info is larger than buffer. Discarding\n");
+		brcmf_err(bus, "Bss info is larger than buffer. Discarding\n");
 		return 0;
 	}
 
@@ -2807,6 +2864,7 @@ next_bss_le(struct brcmf_scan_results *list, struct brcmf_bss_info_le *bss)
 
 static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_scan_results *bss_list;
 	struct brcmf_bss_info_le *bi = NULL;	/* must be initialized */
 	s32 err = 0;
@@ -2815,7 +2873,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 	bss_list = (struct brcmf_scan_results *)cfg->escan_info.escan_buf;
 	if (bss_list->count != 0 &&
 	    bss_list->version != BRCMF_BSS_INFO_VERSION) {
-		brcmf_err("Version %d != WL_BSS_INFO_VERSION\n",
+		brcmf_err(bus, "Version %d != WL_BSS_INFO_VERSION\n",
 			  bss_list->version);
 		return -EOPNOTSUPP;
 	}
@@ -2832,6 +2890,7 @@ static s32 brcmf_inform_bss(struct brcmf_cfg80211_info *cfg)
 static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 			     struct net_device *ndev, const u8 *bssid)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
 	struct ieee80211_channel *notify_channel;
 	struct brcmf_bss_info_le *bi = NULL;
@@ -2860,7 +2919,7 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_cmd_data_get(netdev_priv(ndev), BRCMF_C_GET_BSS_INFO,
 				     buf, WL_BSS_INFO_MAX);
 	if (err) {
-		brcmf_err("WLC_GET_BSS_INFO failed: %d\n", err);
+		brcmf_err(bus, "WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
 	}
 
@@ -2914,6 +2973,7 @@ static s32 brcmf_inform_ibss(struct brcmf_cfg80211_info *cfg,
 static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 				 struct brcmf_if *ifp)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_bss_info_le *bi;
 	const struct brcmf_tlv *tim;
 	u16 beacon_interval;
@@ -2930,7 +2990,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BSS_INFO,
 				     cfg->extra_buf, WL_EXTRA_BUF_MAX);
 	if (err) {
-		brcmf_err("Could not get bss info %d\n", err);
+		brcmf_err(bus, "Could not get bss info %d\n", err);
 		goto update_bss_info_out;
 	}
 
@@ -2955,7 +3015,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg,
 		u32 var;
 		err = brcmf_fil_iovar_int_get(ifp, "dtim_assoc", &var);
 		if (err) {
-			brcmf_err("wl dtim_assoc failed (%d)\n", err);
+			brcmf_err(bus, "wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
 		}
 		dtim_period = (u8)var;
@@ -2993,9 +3053,10 @@ static void brcmf_escan_timeout(struct timer_list *t)
 {
 	struct brcmf_cfg80211_info *cfg =
 			from_timer(cfg, t, escan_timeout);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 
 	if (cfg->int_escan_map || cfg->scan_request) {
-		brcmf_err("timer expired\n");
+		brcmf_err(bus, "timer expired\n");
 		schedule_work(&cfg->escan_timeout_work);
 	}
 }
@@ -3044,6 +3105,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 			     const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	s32 status;
 	struct brcmf_escan_result_le *escan_result_le;
 	u32 escan_buflen;
@@ -3060,31 +3122,32 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		goto exit;
 
 	if (!test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status)) {
-		brcmf_err("scan not ready, bsscfgidx=%d\n", ifp->bsscfgidx);
+		brcmf_err(bus, "scan not ready, bsscfgidx=%d\n",
+			  ifp->bsscfgidx);
 		return -EPERM;
 	}
 
 	if (status == BRCMF_E_STATUS_PARTIAL) {
 		brcmf_dbg(SCAN, "ESCAN Partial result\n");
 		if (e->datalen < sizeof(*escan_result_le)) {
-			brcmf_err("invalid event data length\n");
+			brcmf_err(bus, "invalid event data length\n");
 			goto exit;
 		}
 		escan_result_le = (struct brcmf_escan_result_le *) data;
 		if (!escan_result_le) {
-			brcmf_err("Invalid escan result (NULL pointer)\n");
+			brcmf_err(bus, "Invalid escan result (NULL pointer)\n");
 			goto exit;
 		}
 		escan_buflen = le32_to_cpu(escan_result_le->buflen);
 		if (escan_buflen > BRCMF_ESCAN_BUF_SIZE ||
 		    escan_buflen > e->datalen ||
 		    escan_buflen < sizeof(*escan_result_le)) {
-			brcmf_err("Invalid escan buffer length: %d\n",
+			brcmf_err(bus, "Invalid escan buffer length: %d\n",
 				  escan_buflen);
 			goto exit;
 		}
 		if (le16_to_cpu(escan_result_le->bss_count) != 1) {
-			brcmf_err("Invalid bss_count %d: ignoring\n",
+			brcmf_err(bus, "Invalid bss_count %d: ignoring\n",
 				  escan_result_le->bss_count);
 			goto exit;
 		}
@@ -3100,7 +3163,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 
 		bi_length = le32_to_cpu(bss_info_le->length);
 		if (bi_length != escan_buflen -	WL_ESCAN_RESULTS_FIXED_SIZE) {
-			brcmf_err("Ignoring invalid bss_info length: %d\n",
+			brcmf_err(bus, "Ignoring invalid bss_info length: %d\n",
 				  bi_length);
 			goto exit;
 		}
@@ -3109,7 +3172,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 					BIT(NL80211_IFTYPE_ADHOC))) {
 			if (le16_to_cpu(bss_info_le->capability) &
 						WLAN_CAPABILITY_IBSS) {
-				brcmf_err("Ignoring IBSS result\n");
+				brcmf_err(bus, "Ignoring IBSS result\n");
 				goto exit;
 			}
 		}
@@ -3117,7 +3180,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_if *ifp,
 		list = (struct brcmf_scan_results *)
 				cfg->escan_info.escan_buf;
 		if (bi_length > BRCMF_ESCAN_BUF_SIZE - list->buflen) {
-			brcmf_err("Buffer is too small: ignoring\n");
+			brcmf_err(bus, "Buffer is too small: ignoring\n");
 			goto exit;
 		}
 
@@ -3277,6 +3340,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 				const struct brcmf_event_msg *e, void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_pno_net_info_le *netinfo, *netinfo_start;
 	struct cfg80211_scan_request *request = NULL;
 	struct wiphy *wiphy = cfg_to_wiphy(cfg);
@@ -3309,14 +3373,14 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	WARN_ON(status != BRCMF_PNO_SCAN_COMPLETE);
 	brcmf_dbg(SCAN, "PFN NET FOUND event. count: %d\n", result_count);
 	if (!result_count) {
-		brcmf_err("FALSE PNO Event. (pfn_count == 0)\n");
+		brcmf_err(bus, "FALSE PNO Event. (pfn_count == 0)\n");
 		goto out_err;
 	}
 
 	netinfo_start = brcmf_get_netinfo_array(pfn_result);
 	datalen = e->datalen - ((void *)netinfo_start - (void *)pfn_result);
 	if (datalen < result_count * sizeof(*netinfo)) {
-		brcmf_err("insufficient event data\n");
+		brcmf_err(bus, "insufficient event data\n");
 		goto out_err;
 	}
 
@@ -3365,12 +3429,13 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 
 	brcmf_dbg(SCAN, "Enter: n_match_sets=%d n_ssids=%d\n",
 		  req->n_match_sets, req->n_ssids);
 
 	if (test_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status)) {
-		brcmf_err("Scanning suppressed: status=%lu\n",
+		brcmf_err(bus, "Scanning suppressed: status=%lu\n",
 			  cfg->scan_status);
 		return -EAGAIN;
 	}
@@ -3450,6 +3515,7 @@ brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 		      void *data)
 {
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_pno_scanresults_le *pfn_result;
 	struct brcmf_pno_net_info_le *netinfo;
 
@@ -3468,7 +3534,7 @@ brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 	}
 
 	if (le32_to_cpu(pfn_result->count) < 1) {
-		brcmf_err("Invalid result count, expected 1 (%d)\n",
+		brcmf_err(bus, "Invalid result count, expected 1 (%d)\n",
 			  le32_to_cpu(pfn_result->count));
 		return -EINVAL;
 	}
@@ -3496,6 +3562,7 @@ brcmf_wowl_nd_results(struct brcmf_if *ifp, const struct brcmf_event_msg *e,
 static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_wowl_wakeind_le wake_ind_le;
 	struct cfg80211_wowlan_wakeup wakeup_data;
 	struct cfg80211_wowlan_wakeup *wakeup;
@@ -3506,7 +3573,7 @@ static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "wowl_wakeind", &wake_ind_le,
 				       sizeof(wake_ind_le));
 	if (err) {
-		brcmf_err("Get wowl_wakeind failed, err = %d\n", err);
+		brcmf_err(bus, "Get wowl_wakeind failed, err = %d\n", err);
 		return;
 	}
 
@@ -3547,7 +3614,7 @@ static void brcmf_report_wowl_wakeind(struct wiphy *wiphy, struct brcmf_if *ifp)
 				cfg->wowl.nd_data_completed,
 				BRCMF_ND_INFO_TIMEOUT);
 			if (!timeout)
-				brcmf_err("No result for wowl net detect\n");
+				brcmf_err(bus, "No result for wowl net detect\n");
 			else
 				wakeup_data.net_detect = cfg->wowl.nd_info;
 		}
@@ -3734,6 +3801,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			 struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
 	s32 err;
@@ -3755,7 +3823,7 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			cfg->pmk_list.npmk = cpu_to_le32(npmk);
 		}
 	} else {
-		brcmf_err("Too many PMKSA entries cached %d\n", npmk);
+		brcmf_err(bus, "Too many PMKSA entries cached %d\n", npmk);
 		return -EINVAL;
 	}
 
@@ -3776,6 +3844,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			 struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
 	s32 err;
@@ -3801,7 +3870,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 		memset(&pmk[i], 0, sizeof(*pmk));
 		cfg->pmk_list.npmk = cpu_to_le32(npmk - 1);
 	} else {
-		brcmf_err("Cache entry not found\n");
+		brcmf_err(bus, "Cache entry not found\n");
 		return -EINVAL;
 	}
 
@@ -3833,19 +3902,20 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 
 static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	s32 err;
 	s32 wpa_val;
 
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", 0);
 	if (err < 0) {
-		brcmf_err("auth error %d\n", err);
+		brcmf_err(bus, "auth error %d\n", err);
 		return err;
 	}
 	/* set wsec */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", 0);
 	if (err < 0) {
-		brcmf_err("wsec error %d\n", err);
+		brcmf_err(bus, "wsec error %d\n", err);
 		return err;
 	}
 	/* set upper-layer auth */
@@ -3855,7 +3925,7 @@ static s32 brcmf_configure_opensecurity(struct brcmf_if *ifp)
 		wpa_val = WPA_AUTH_DISABLED;
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_val);
 	if (err < 0) {
-		brcmf_err("wpa_auth error %d\n", err);
+		brcmf_err(bus, "wpa_auth error %d\n", err);
 		return err;
 	}
 
@@ -3875,6 +3945,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		      const struct brcmf_vs_tlv *wpa_ie,
 		      bool is_rsn_ie)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	u32 auth = 0; /* d11 open authentication */
 	u16 count;
 	s32 err = 0;
@@ -3905,13 +3976,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* check for multicast cipher suite */
 	if (offset + WPA_IE_MIN_OUI_LEN > len) {
 		err = -EINVAL;
-		brcmf_err("no multicast cipher suite\n");
+		brcmf_err(bus, "no multicast cipher suite\n");
 		goto exit;
 	}
 
 	if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 		err = -EINVAL;
-		brcmf_err("ivalid OUI\n");
+		brcmf_err(bus, "ivalid OUI\n");
 		goto exit;
 	}
 	offset += TLV_OUI_LEN;
@@ -3933,7 +4004,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		break;
 	default:
 		err = -EINVAL;
-		brcmf_err("Invalid multi cast cipher info\n");
+		brcmf_err(bus, "Invalid multi cast cipher info\n");
 		goto exit;
 	}
 
@@ -3944,13 +4015,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* Check for unicast suite(s) */
 	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
 		err = -EINVAL;
-		brcmf_err("no unicast cipher suite\n");
+		brcmf_err(bus, "no unicast cipher suite\n");
 		goto exit;
 	}
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			brcmf_err("ivalid OUI\n");
+			brcmf_err(bus, "ivalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -3968,7 +4039,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 			pval |= AES_ENABLED;
 			break;
 		default:
-			brcmf_err("Invalid unicast security info\n");
+			brcmf_err(bus, "Invalid unicast security info\n");
 		}
 		offset++;
 	}
@@ -3978,13 +4049,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* Check for auth key management suite(s) */
 	if (offset + (WPA_IE_MIN_OUI_LEN * count) > len) {
 		err = -EINVAL;
-		brcmf_err("no auth key mgmt suite\n");
+		brcmf_err(bus, "no auth key mgmt suite\n");
 		goto exit;
 	}
 	for (i = 0; i < count; i++) {
 		if (!brcmf_valid_wpa_oui(&data[offset], is_rsn_ie)) {
 			err = -EINVAL;
-			brcmf_err("ivalid OUI\n");
+			brcmf_err(bus, "ivalid OUI\n");
 			goto exit;
 		}
 		offset += TLV_OUI_LEN;
@@ -4012,7 +4083,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 			wpa_auth |= WPA2_AUTH_1X_SHA256;
 			break;
 		default:
-			brcmf_err("Invalid key mgmt info\n");
+			brcmf_err(bus, "Invalid key mgmt info\n");
 		}
 		offset++;
 	}
@@ -4054,7 +4125,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 		err = brcmf_fil_bsscfg_int_set(ifp, "wme_bss_disable",
 					       wme_bss_disable);
 		if (err < 0) {
-			brcmf_err("wme_bss_disable error %d\n", err);
+			brcmf_err(bus, "wme_bss_disable error %d\n", err);
 			goto exit;
 		}
 
@@ -4068,7 +4139,7 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 							&data[offset],
 							WPA_IE_MIN_OUI_LEN);
 			if (err < 0) {
-				brcmf_err("bip error %d\n", err);
+				brcmf_err(bus, "bip error %d\n", err);
 				goto exit;
 			}
 		}
@@ -4079,13 +4150,13 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	/* set auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "auth", auth);
 	if (err < 0) {
-		brcmf_err("auth error %d\n", err);
+		brcmf_err(bus, "auth error %d\n", err);
 		goto exit;
 	}
 	/* set wsec */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wsec", wsec);
 	if (err < 0) {
-		brcmf_err("wsec error %d\n", err);
+		brcmf_err(bus, "wsec error %d\n", err);
 		goto exit;
 	}
 	/* Configure MFP, this needs to go after wsec otherwise the wsec command
@@ -4094,14 +4165,14 @@ brcmf_configure_wpaie(struct brcmf_if *ifp,
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MFP)) {
 		err = brcmf_fil_bsscfg_int_set(ifp, "mfp", mfp);
 		if (err < 0) {
-			brcmf_err("mfp error %d\n", err);
+			brcmf_err(bus, "mfp error %d\n", err);
 			goto exit;
 		}
 	}
 	/* set upper-layer auth */
 	err = brcmf_fil_bsscfg_int_set(ifp, "wpa_auth", wpa_auth);
 	if (err < 0) {
-		brcmf_err("wpa_auth error %d\n", err);
+		brcmf_err(bus, "wpa_auth error %d\n", err);
 		goto exit;
 	}
 
@@ -4128,7 +4199,7 @@ brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 		vndrie = (struct brcmf_vs_tlv *)ie;
 		/* len should be bigger than OUI length + one */
 		if (vndrie->len < (VS_IE_FIXED_HDR_LEN - TLV_HDR_LEN + 1)) {
-			brcmf_err("invalid vndr ie. length is too small %d\n",
+			brcmf_err(NULL, "invalid vndr ie. length is too small %d\n",
 				  vndrie->len);
 			goto next;
 		}
@@ -4188,6 +4259,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
 	struct brcmf_if *ifp;
+	struct brcmf_bus *bus;
 	struct vif_saved_ie *saved_ie;
 	s32 err = 0;
 	u8  *iovar_ie_buf;
@@ -4208,6 +4280,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 	if (!vif)
 		return -ENODEV;
 	ifp = vif->ifp;
+	bus = ifp->drvr->bus_if;
 	saved_ie = &vif->saved_ie;
 
 	brcmf_dbg(TRACE, "bsscfgidx %d, pktflag : 0x%02X\n", ifp->bsscfgidx,
@@ -4239,13 +4312,13 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		break;
 	default:
 		err = -EPERM;
-		brcmf_err("not suitable type\n");
+		brcmf_err(bus, "not suitable type\n");
 		goto exit;
 	}
 
 	if (vndr_ie_len > mgmt_ie_buf_len) {
 		err = -ENOMEM;
-		brcmf_err("extra IE size too big\n");
+		brcmf_err(bus, "extra IE size too big\n");
 		goto exit;
 	}
 
@@ -4306,7 +4379,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			/* verify remained buf size before copy data */
 			if (remained_buf_len < (vndrie_info->vndrie.len +
 							VNDR_IE_VSIE_OFFSET)) {
-				brcmf_err("no space in mgmt_ie_buf: len left %d",
+				brcmf_err(bus, "no space in mgmt_ie_buf: len left %d",
 					  remained_buf_len);
 				break;
 			}
@@ -4338,7 +4411,7 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 		err  = brcmf_fil_bsscfg_data_set(ifp, "vndr_ie", iovar_ie_buf,
 						 total_ie_buf_len);
 		if (err)
-			brcmf_err("vndr ie set error : %d\n", err);
+			brcmf_err(bus, "vndr ie set error : %d\n", err);
 	}
 
 exit:
@@ -4366,13 +4439,14 @@ static s32
 brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 			struct cfg80211_beacon_data *beacon)
 {
+	struct brcmf_bus *bus = vif->ifp->drvr->bus_if;
 	s32 err;
 
 	/* Set Beacon IEs to FW */
 	err = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_BEACON_FLAG,
 				    beacon->tail, beacon->tail_len);
 	if (err) {
-		brcmf_err("Set Beacon IE Failed\n");
+		brcmf_err(bus, "Set Beacon IE Failed\n");
 		return err;
 	}
 	brcmf_dbg(TRACE, "Applied Vndr IEs for Beacon\n");
@@ -4382,7 +4456,7 @@ brcmf_config_ap_mgmt_ie(struct brcmf_cfg80211_vif *vif,
 				    beacon->proberesp_ies,
 				    beacon->proberesp_ies_len);
 	if (err)
-		brcmf_err("Set Probe Resp IE Failed\n");
+		brcmf_err(bus, "Set Probe Resp IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Probe Resp\n");
 
@@ -4395,6 +4469,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 {
 	s32 ie_offset;
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	const struct brcmf_tlv *ssid_ie;
 	const struct brcmf_tlv *country_ie;
@@ -4491,7 +4566,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
 						    is_11d);
 			if (err < 0) {
-				brcmf_err("Regulatory Set Error, %d\n", err);
+				brcmf_err(bus, "Regulatory Set Error, %d\n",
+					  err);
 				goto exit;
 			}
 		}
@@ -4499,7 +4575,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD,
 						    settings->beacon_interval);
 			if (err < 0) {
-				brcmf_err("Beacon Interval Set Error, %d\n",
+				brcmf_err(bus, "Beacon Interval Set Error, %d\n",
 					  err);
 				goto exit;
 			}
@@ -4508,7 +4584,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_DTIMPRD,
 						    settings->dtim_period);
 			if (err < 0) {
-				brcmf_err("DTIM Interval Set Error, %d\n", err);
+				brcmf_err(bus, "DTIM Interval Set Error, %d\n",
+					  err);
 				goto exit;
 			}
 		}
@@ -4518,7 +4595,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		     !brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RSDB))) {
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 			if (err < 0) {
-				brcmf_err("BRCMF_C_DOWN error %d\n", err);
+				brcmf_err(bus, "BRCMF_C_DOWN error %d\n", err);
 				goto exit;
 			}
 			brcmf_fil_iovar_int_set(ifp, "apsta", 0);
@@ -4526,7 +4603,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, 1);
 		if (err < 0) {
-			brcmf_err("SET INFRA error %d\n", err);
+			brcmf_err(bus, "SET INFRA error %d\n", err);
 			goto exit;
 		}
 	} else if (WARN_ON(supports_11d && (is_11d != ifp->vif->is_11d))) {
@@ -4542,7 +4619,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 1);
 		if (err < 0) {
-			brcmf_err("setting AP mode failed %d\n", err);
+			brcmf_err(bus, "setting AP mode failed %d\n", err);
 			goto exit;
 		}
 		if (!mbss) {
@@ -4551,14 +4628,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			 */
 			err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 			if (err < 0) {
-				brcmf_err("Set Channel failed: chspec=%d, %d\n",
+				brcmf_err(bus, "Set Channel failed: chspec=%d, %d\n",
 					  chanspec, err);
 				goto exit;
 			}
 		}
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0) {
-			brcmf_err("BRCMF_C_UP error (%d)\n", err);
+			brcmf_err(bus, "BRCMF_C_UP error (%d)\n", err);
 			goto exit;
 		}
 		/* On DOWN the firmware removes the WEP keys, reconfigure
@@ -4573,14 +4650,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 					     &join_params, sizeof(join_params));
 		if (err < 0) {
-			brcmf_err("SET SSID error (%d)\n", err);
+			brcmf_err(bus, "SET SSID error (%d)\n", err);
 			goto exit;
 		}
 
 		if (settings->hidden_ssid) {
 			err = brcmf_fil_iovar_int_set(ifp, "closednet", 1);
 			if (err) {
-				brcmf_err("closednet error (%d)\n", err);
+				brcmf_err(bus, "closednet error (%d)\n", err);
 				goto exit;
 			}
 		}
@@ -4589,14 +4666,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	} else if (dev_role == NL80211_IFTYPE_P2P_GO) {
 		err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 		if (err < 0) {
-			brcmf_err("Set Channel failed: chspec=%d, %d\n",
+			brcmf_err(bus, "Set Channel failed: chspec=%d, %d\n",
 				  chanspec, err);
 			goto exit;
 		}
 		err = brcmf_fil_bsscfg_data_set(ifp, "ssid", &ssid_le,
 						sizeof(ssid_le));
 		if (err < 0) {
-			brcmf_err("setting ssid failed %d\n", err);
+			brcmf_err(bus, "setting ssid failed %d\n", err);
 			goto exit;
 		}
 		bss_enable.bsscfgidx = cpu_to_le32(ifp->bsscfgidx);
@@ -4604,7 +4681,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
 					       sizeof(bss_enable));
 		if (err < 0) {
-			brcmf_err("bss_enable config failed %d\n", err);
+			brcmf_err(bus, "bss_enable config failed %d\n", err);
 			goto exit;
 		}
 
@@ -4627,6 +4704,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 	struct brcmf_fil_bss_enable_le bss_enable;
@@ -4652,13 +4731,13 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
 					     &join_params, sizeof(join_params));
 		if (err < 0)
-			brcmf_err("SET SSID error (%d)\n", err);
+			brcmf_err(bus, "SET SSID error (%d)\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
 		if (err < 0)
-			brcmf_err("BRCMF_C_DOWN error %d\n", err);
+			brcmf_err(bus, "BRCMF_C_DOWN error %d\n", err);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0);
 		if (err < 0)
-			brcmf_err("setting AP mode failed %d\n", err);
+			brcmf_err(bus, "setting AP mode failed %d\n", err);
 		if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
 			brcmf_fil_iovar_int_set(ifp, "mbss", 0);
 		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
@@ -4666,7 +4745,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		/* Bring device back up so it can be used again */
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0)
-			brcmf_err("BRCMF_C_UP error %d\n", err);
+			brcmf_err(bus, "BRCMF_C_UP error %d\n", err);
 
 		brcmf_vif_clear_mgmt_ies(ifp->vif);
 	} else {
@@ -4675,7 +4754,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		err = brcmf_fil_iovar_data_set(ifp, "bss", &bss_enable,
 					       sizeof(bss_enable));
 		if (err < 0)
-			brcmf_err("bss_enable config failed %d\n", err);
+			brcmf_err(bus, "bss_enable config failed %d\n", err);
 	}
 	brcmf_set_mpc(ifp, 1);
 	brcmf_configure_arp_nd_offload(ifp, true);
@@ -4704,6 +4783,7 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 			   struct station_del_parameters *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_scb_val_le scbval;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
@@ -4723,7 +4803,8 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
 				     &scbval, sizeof(scbval));
 	if (err)
-		brcmf_err("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
+		brcmf_err(bus, "SCB_DEAUTHENTICATE_FOR_REASON failed %d\n",
+			  err);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -4733,6 +4814,8 @@ static int
 brcmf_cfg80211_change_station(struct wiphy *wiphy, struct net_device *ndev,
 			      const u8 *mac, struct station_parameters *params)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err;
 
@@ -4753,7 +4836,7 @@ brcmf_cfg80211_change_station(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SCB_DEAUTHORIZE,
 					     (void *)mac, ETH_ALEN);
 	if (err < 0)
-		brcmf_err("Setting SCB (de-)authorize failed, %d\n", err);
+		brcmf_err(bus, "Setting SCB (de-)authorize failed, %d\n", err);
 
 	return err;
 }
@@ -4782,6 +4865,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		       struct cfg80211_mgmt_tx_params *params, u64 *cookie)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct ieee80211_channel *chan = params->chan;
 	const u8 *buf = params->buf;
 	size_t len = params->len;
@@ -4803,7 +4887,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
 	if (!ieee80211_is_mgmt(mgmt->frame_control)) {
-		brcmf_err("Driver only allows MGMT packet type\n");
+		brcmf_err(bus, "Driver only allows MGMT packet type\n");
 		return -EPERM;
 	}
 
@@ -4834,13 +4918,13 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 					GFP_KERNEL);
 	} else if (ieee80211_is_action(mgmt->frame_control)) {
 		if (len > BRCMF_FIL_ACTION_FRAME_SIZE + DOT11_MGMT_HDR_LEN) {
-			brcmf_err("invalid action frame length\n");
+			brcmf_err(bus, "invalid action frame length\n");
 			err = -EINVAL;
 			goto exit;
 		}
 		af_params = kzalloc(sizeof(*af_params), GFP_KERNEL);
 		if (af_params == NULL) {
-			brcmf_err("unable to allocate frame\n");
+			brcmf_err(bus, "unable to allocate frame\n");
 			err = -ENOMEM;
 			goto exit;
 		}
@@ -4891,6 +4975,7 @@ brcmf_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
 					u64 cookie)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_cfg80211_vif *vif;
 	int err = 0;
 
@@ -4898,7 +4983,7 @@ brcmf_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
 
 	vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (vif == NULL) {
-		brcmf_err("No p2p device available for probe response\n");
+		brcmf_err(bus, "No p2p device available for probe response\n");
 		err = -ENODEV;
 		goto exit;
 	}
@@ -4912,6 +4997,7 @@ static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
 				      struct cfg80211_chan_def *chandef)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct net_device *ndev = wdev->netdev;
 	struct brcmf_if *ifp;
 	struct brcmu_chan ch;
@@ -4926,7 +5012,7 @@ static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_int_get(ifp, "chanspec", &chanspec);
 	if (err) {
-		brcmf_err("chanspec failed (%d)\n", err);
+		brcmf_err(bus, "chanspec failed (%d)\n", err);
 		return err;
 	}
 
@@ -5038,7 +5124,7 @@ static int brcmf_convert_nl80211_tdls_oper(enum nl80211_tdls_operation oper)
 		ret = BRCMF_TDLS_MANUAL_EP_DELETE;
 		break;
 	default:
-		brcmf_err("unsupported operation: %d\n", oper);
+		brcmf_err(NULL, "unsupported operation: %d\n", oper);
 		ret = -EOPNOTSUPP;
 	}
 	return ret;
@@ -5048,6 +5134,8 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 				    struct net_device *ndev, const u8 *peer,
 				    enum nl80211_tdls_operation oper)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp;
 	struct brcmf_tdls_iovar_le info;
 	int ret = 0;
@@ -5065,7 +5153,7 @@ static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
 	ret = brcmf_fil_iovar_data_set(ifp, "tdls_endpoint",
 				       &info, sizeof(info));
 	if (ret < 0)
-		brcmf_err("tdls_endpoint iovar failed: ret=%d\n", ret);
+		brcmf_err(bus, "tdls_endpoint iovar failed: ret=%d\n", ret);
 
 	return ret;
 }
@@ -5076,6 +5164,8 @@ brcmf_cfg80211_update_conn_params(struct wiphy *wiphy,
 				  struct cfg80211_connect_params *sme,
 				  u32 changed)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp;
 	int err;
 
@@ -5086,7 +5176,7 @@ brcmf_cfg80211_update_conn_params(struct wiphy *wiphy,
 	err = brcmf_vif_set_mgmt_ie(ifp->vif, BRCMF_VNDR_IE_ASSOCREQ_FLAG,
 				    sme->ie, sme->ie_len);
 	if (err)
-		brcmf_err("Set Assoc REQ IE Failed\n");
+		brcmf_err(bus, "Set Assoc REQ IE Failed\n");
 	else
 		brcmf_dbg(TRACE, "Applied Vndr IEs for Assoc request\n");
 
@@ -5112,7 +5202,7 @@ brcmf_cfg80211_set_rekey_data(struct wiphy *wiphy, struct net_device *ndev,
 	ret = brcmf_fil_iovar_data_set(ifp, "gtk_key_info", &gtk_le,
 				       sizeof(gtk_le));
 	if (ret < 0)
-		brcmf_err("gtk_key_info iovar failed: ret=%d\n", ret);
+		brcmf_err(bus, "gtk_key_info iovar failed: ret=%d\n", ret);
 
 	return ret;
 }
@@ -5344,6 +5434,7 @@ static void brcmf_clear_assoc_ies(struct brcmf_cfg80211_info *cfg)
 static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 			       struct brcmf_if *ifp)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_cfg80211_assoc_ielen_le *assoc_info;
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg);
 	u32 req_len;
@@ -5355,7 +5446,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_iovar_data_get(ifp, "assoc_info",
 				       cfg->extra_buf, WL_ASSOC_INFO_MAX);
 	if (err) {
-		brcmf_err("could not get assoc info (%d)\n", err);
+		brcmf_err(bus, "could not get assoc info (%d)\n", err);
 		return err;
 	}
 	assoc_info =
@@ -5367,7 +5458,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
-			brcmf_err("could not get assoc req (%d)\n", err);
+			brcmf_err(bus, "could not get assoc req (%d)\n", err);
 			return err;
 		}
 		conn_info->req_ie_len = req_len;
@@ -5383,7 +5474,7 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 					       cfg->extra_buf,
 					       WL_ASSOC_INFO_MAX);
 		if (err) {
-			brcmf_err("could not get assoc resp (%d)\n", err);
+			brcmf_err(bus, "could not get assoc resp (%d)\n", err);
 			return err;
 		}
 		conn_info->resp_ie_len = resp_len;
@@ -5510,6 +5601,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 			       struct net_device *ndev,
 			       const struct brcmf_event_msg *e, void *data)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	static int generation;
 	u32 event = e->event_code;
 	u32 reason = e->reason;
@@ -5527,7 +5619,7 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	if (((event == BRCMF_E_ASSOC_IND) || (event == BRCMF_E_REASSOC_IND)) &&
 	    (reason == BRCMF_E_STATUS_SUCCESS)) {
 		if (!data) {
-			brcmf_err("No IEs present in ASSOC/REASSOC_IND");
+			brcmf_err(bus, "No IEs present in ASSOC/REASSOC_IND");
 			return -EINVAL;
 		}
 
@@ -5819,6 +5911,7 @@ static void init_vif_event(struct brcmf_cfg80211_vif_event *event)
 
 static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	s32 err;
 	u32 bcn_timeout;
 	__le32 roamtrigger[2];
@@ -5831,7 +5924,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 		bcn_timeout = BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_ON;
 	err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout", bcn_timeout);
 	if (err) {
-		brcmf_err("bcn_timeout error (%d)\n", err);
+		brcmf_err(bus, "bcn_timeout error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5843,7 +5936,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_int_set(ifp, "roam_off",
 				      ifp->drvr->settings->roamoff);
 	if (err) {
-		brcmf_err("roam_off error (%d)\n", err);
+		brcmf_err(bus, "roam_off error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5852,7 +5945,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_TRIGGER,
 				     (void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
-		brcmf_err("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
+		brcmf_err(bus, "WLC_SET_ROAM_TRIGGER error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5861,7 +5954,7 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_ROAM_DELTA,
 				     (void *)roam_delta, sizeof(roam_delta));
 	if (err) {
-		brcmf_err("WLC_SET_ROAM_DELTA error (%d)\n", err);
+		brcmf_err(bus, "WLC_SET_ROAM_DELTA error (%d)\n", err);
 		goto roam_setup_done;
 	}
 
@@ -5872,25 +5965,26 @@ static s32 brcmf_dongle_roam(struct brcmf_if *ifp)
 static s32
 brcmf_dongle_scantime(struct brcmf_if *ifp)
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	s32 err = 0;
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 				    BRCMF_SCAN_CHANNEL_TIME);
 	if (err) {
-		brcmf_err("Scan assoc time error (%d)\n", err);
+		brcmf_err(bus, "Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 				    BRCMF_SCAN_UNASSOC_TIME);
 	if (err) {
-		brcmf_err("Scan unassoc time error (%d)\n", err);
+		brcmf_err(bus, "Scan unassoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_PASSIVE_TIME,
 				    BRCMF_SCAN_PASSIVE_TIME);
 	if (err) {
-		brcmf_err("Scan passive time error (%d)\n", err);
+		brcmf_err(bus, "Scan passive time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
 
@@ -5922,6 +6016,7 @@ static void brcmf_update_bw40_channel_flag(struct ieee80211_channel *channel,
 static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 				    u32 bw_cap[])
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
 	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *channel;
@@ -5944,7 +6039,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_iovar_data_get(ifp, "chanspecs", pbuf,
 				       BRCMF_DCMD_MEDLEN);
 	if (err) {
-		brcmf_err("get chanspecs error (%d)\n", err);
+		brcmf_err(bus, "get chanspecs error (%d)\n", err);
 		goto fail_pbuf;
 	}
 
@@ -5968,7 +6063,8 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 		} else if (ch.band == BRCMU_CHAN_BAND_5G) {
 			band = wiphy->bands[NL80211_BAND_5GHZ];
 		} else {
-			brcmf_err("Invalid channel Spec. 0x%x.\n", ch.chspec);
+			brcmf_err(bus, "Invalid channel Spec. 0x%x.\n",
+				  ch.chspec);
 			continue;
 		}
 		if (!band)
@@ -5991,7 +6087,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 			/* It seems firmware supports some channel we never
 			 * considered. Something new in IEEE standard?
 			 */
-			brcmf_err("Ignoring unexpected firmware channel %d\n",
+			brcmf_err(bus, "Ignoring unexpected firmware channel %d\n",
 				  ch.control_ch_num);
 			continue;
 		}
@@ -6038,6 +6134,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 
 static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
 	struct ieee80211_supported_band *band;
 	struct brcmf_fil_bwcap_le band_bwcap;
@@ -6084,7 +6181,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 		err = brcmf_fil_iovar_data_get(ifp, "chanspecs", pbuf,
 					       BRCMF_DCMD_MEDLEN);
 		if (err) {
-			brcmf_err("get chanspecs error (%d)\n", err);
+			brcmf_err(bus, "get chanspecs error (%d)\n", err);
 			kfree(pbuf);
 			return err;
 		}
@@ -6115,6 +6212,7 @@ static int brcmf_enable_bw40_2g(struct brcmf_cfg80211_info *cfg)
 
 static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 {
+	struct brcmf_bus *bus = ifp->drvr->bus_if;
 	u32 band, mimo_bwcap;
 	int err;
 
@@ -6150,7 +6248,7 @@ static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 		bw_cap[NL80211_BAND_5GHZ] |= WLC_BW_20MHZ_BIT;
 		break;
 	default:
-		brcmf_err("invalid mimo_bw_cap value\n");
+		brcmf_err(bus, "invalid mimo_bw_cap value\n");
 	}
 }
 
@@ -6225,6 +6323,7 @@ static void brcmf_update_vht_cap(struct ieee80211_supported_band *band,
 
 static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
 	struct wiphy *wiphy;
 	u32 nmode = 0;
@@ -6242,7 +6341,7 @@ static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 	(void)brcmf_fil_iovar_int_get(ifp, "vhtmode", &vhtmode);
 	err = brcmf_fil_iovar_int_get(ifp, "nmode", &nmode);
 	if (err) {
-		brcmf_err("nmode error (%d)\n", err);
+		brcmf_err(bus, "nmode error (%d)\n", err);
 	} else {
 		brcmf_get_bwcap(ifp, bw_cap);
 	}
@@ -6252,7 +6351,7 @@ static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 
 	err = brcmf_fil_iovar_int_get(ifp, "rxchain", &rxchain);
 	if (err) {
-		brcmf_err("rxchain error (%d)\n", err);
+		brcmf_err(bus, "rxchain error (%d)\n", err);
 		nchain = 1;
 	} else {
 		for (nchain = 0; rxchain; nchain++)
@@ -6262,7 +6361,7 @@ static int brcmf_setup_wiphybands(struct brcmf_cfg80211_info *cfg)
 
 	err = brcmf_construct_chaninfo(cfg, bw_cap);
 	if (err) {
-		brcmf_err("brcmf_construct_chaninfo failed (%d)\n", err);
+		brcmf_err(bus, "brcmf_construct_chaninfo failed (%d)\n", err);
 		return err;
 	}
 
@@ -6470,12 +6569,13 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 #ifdef CONFIG_PM
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct wiphy_wowlan_support *wowl;
 
 	wowl = kmemdup(&brcmf_wowlan_support, sizeof(brcmf_wowlan_support),
 		       GFP_KERNEL);
 	if (!wowl) {
-		brcmf_err("only support basic wowlan features\n");
+		brcmf_err(bus, "only support basic wowlan features\n");
 		wiphy->wowlan = &brcmf_wowlan_support;
 		return;
 	}
@@ -6499,6 +6599,7 @@ static void brcmf_wiphy_wowl_params(struct wiphy *wiphy, struct brcmf_if *ifp)
 static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_bus *bus = drvr->bus_if;
 	const struct ieee80211_iface_combination *combo;
 	struct ieee80211_supported_band *band;
 	u16 max_interfaces = 0;
@@ -6572,7 +6673,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_BANDLIST, &bandlist,
 				     sizeof(bandlist));
 	if (err) {
-		brcmf_err("could not obtain band info: err=%d\n", err);
+		brcmf_err(bus, "could not obtain band info: err=%d\n", err);
 		return err;
 	}
 	/* first entry in bandlist is number of bands */
@@ -6621,6 +6722,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 
 static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 {
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
 	struct brcmf_if *ifp;
@@ -6658,7 +6760,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_FAKEFRAG, 1);
 	if (err) {
-		brcmf_err("failed to set frameburst mode\n");
+		brcmf_err(bus, "failed to set frameburst mode\n");
 		goto default_conf_out;
 	}
 
@@ -6838,6 +6940,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 					struct regulatory_request *req)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_bus *bus = cfg->pub->bus_if;
 	struct brcmf_if *ifp = brcmf_get_ifp(cfg->pub, 0);
 	struct brcmf_fil_country_le ccreq;
 	s32 err;
@@ -6850,7 +6953,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 	/* ignore non-ISO3166 country codes */
 	for (i = 0; i < 2; i++)
 		if (req->alpha2[i] < 'A' || req->alpha2[i] > 'Z') {
-			brcmf_err("not an ISO3166 code (0x%02x 0x%02x)\n",
+			brcmf_err(bus, "not an ISO3166 code (0x%02x 0x%02x)\n",
 				  req->alpha2[0], req->alpha2[1]);
 			return;
 		}
@@ -6860,7 +6963,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_data_get(ifp, "country", &ccreq, sizeof(ccreq));
 	if (err) {
-		brcmf_err("Country code iovar returned err = %d\n", err);
+		brcmf_err(bus, "Country code iovar returned err = %d\n", err);
 		return;
 	}
 
@@ -6870,7 +6973,7 @@ static void brcmf_cfg80211_reg_notifier(struct wiphy *wiphy,
 
 	err = brcmf_fil_iovar_data_set(ifp, "country", &ccreq, sizeof(ccreq));
 	if (err) {
-		brcmf_err("Firmware rejected country setting\n");
+		brcmf_err(bus, "Firmware rejected country setting\n");
 		return;
 	}
 	brcmf_setup_wiphybands(cfg);
@@ -6907,6 +7010,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 						  bool p2pdev_forced)
 {
 	struct wiphy *wiphy = drvr->wiphy;
+	struct brcmf_bus *bus = drvr->bus_if;
 	struct net_device *ndev = brcmf_get_ifp(drvr, 0)->ndev;
 	struct brcmf_cfg80211_info *cfg;
 	struct brcmf_cfg80211_vif *vif;
@@ -6916,13 +7020,13 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	u16 *cap = NULL;
 
 	if (!ndev) {
-		brcmf_err("ndev is invalid\n");
+		brcmf_err(bus, "ndev is invalid\n");
 		return NULL;
 	}
 
 	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
 	if (!cfg) {
-		brcmf_err("Could not allocate wiphy device\n");
+		brcmf_err(bus, "Could not allocate wiphy device\n");
 		return NULL;
 	}
 
@@ -6943,7 +7047,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 
 	err = wl_init_priv(cfg);
 	if (err) {
-		brcmf_err("Failed to init iwm_priv (%d)\n", err);
+		brcmf_err(bus, "Failed to init iwm_priv (%d)\n", err);
 		brcmf_free_vif(vif);
 		goto wiphy_out;
 	}
@@ -6952,7 +7056,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	/* determine d11 io type before wiphy setup */
 	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &io_type);
 	if (err) {
-		brcmf_err("Failed to get D11 version (%d)\n", err);
+		brcmf_err(bus, "Failed to get D11 version (%d)\n", err);
 		goto priv_out;
 	}
 	cfg->d11inf.io_type = (u8)io_type;
@@ -6986,13 +7090,13 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 #endif
 	err = wiphy_register(wiphy);
 	if (err < 0) {
-		brcmf_err("Could not register wiphy device (%d)\n", err);
+		brcmf_err(bus, "Could not register wiphy device (%d)\n", err);
 		goto priv_out;
 	}
 
 	err = brcmf_setup_wiphybands(cfg);
 	if (err) {
-		brcmf_err("Setting wiphy bands failed (%d)\n", err);
+		brcmf_err(bus, "Setting wiphy bands failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 
@@ -7010,24 +7114,24 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 
 	err = brcmf_fweh_activate_events(ifp);
 	if (err) {
-		brcmf_err("FWEH activation failed (%d)\n", err);
+		brcmf_err(bus, "FWEH activation failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 
 	err = brcmf_p2p_attach(cfg, p2pdev_forced);
 	if (err) {
-		brcmf_err("P2P initialisation failed (%d)\n", err);
+		brcmf_err(bus, "P2P initialisation failed (%d)\n", err);
 		goto wiphy_unreg_out;
 	}
 	err = brcmf_btcoex_attach(cfg);
 	if (err) {
-		brcmf_err("BT-coex initialisation failed (%d)\n", err);
+		brcmf_err(bus, "BT-coex initialisation failed (%d)\n", err);
 		brcmf_p2p_detach(&cfg->p2p);
 		goto wiphy_unreg_out;
 	}
 	err = brcmf_pno_attach(cfg);
 	if (err) {
-		brcmf_err("PNO initialisation failed (%d)\n", err);
+		brcmf_err(bus, "PNO initialisation failed (%d)\n", err);
 		brcmf_btcoex_detach(cfg);
 		brcmf_p2p_detach(&cfg->p2p);
 		goto wiphy_unreg_out;
@@ -7047,7 +7151,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	/* (re-) activate FWEH event handling */
 	err = brcmf_fweh_activate_events(ifp);
 	if (err) {
-		brcmf_err("FWEH activation failed (%d)\n", err);
+		brcmf_err(bus, "FWEH activation failed (%d)\n", err);
 		goto detach;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index b499f90d94f6..c1f260718c8e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -52,6 +52,7 @@ void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 /* Macro for error messages. When debugging / tracing the driver all error
  * messages are important to us.
  */
+#ifndef brcmf_err
 #define brcmf_err(fmt, ...)						\
 	do {								\
 		if (IS_ENABLED(CONFIG_BRCMDBG) ||			\
@@ -59,6 +60,7 @@ void __brcmf_err(struct brcmf_bus *bus, const char *func, const char *fmt, ...);
 		    net_ratelimit())					\
 			__brcmf_err(NULL, __func__, fmt, ##__VA_ARGS__);\
 	} while (0)
+#endif
 
 #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
 
-- 
2.20.1

