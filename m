Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBDDC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F35D32177E
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:33:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cgy8k7ex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfBDGd4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:33:56 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40588 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfBDGdz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 01:33:55 -0500
Received: by mail-pg1-f193.google.com with SMTP id z10so5838694pgp.7
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2019 22:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ueHLsE/JFrX5xf26D7R38A2Ik+NTkR/KFj4XZmiWrTQ=;
        b=Cgy8k7exju3TTVy9Hb00q+9IjJipMOEIU7e6Wy98Ze05mSmHzDz3pu4jd/upLGssWT
         icLh802dDLIHN6XCpOB2PCsK+SgJ5hoGJw5uRpelSqcoGiht+VZIdxAQnBnDEobJBXnQ
         4ajXao72vMWI/lmvj83Fay4/AnFXsFacTpxd/IOYk9RjXvvrW/LWQMvQipVF/9V2XHvi
         pHrx6UHu67stBSfXi7prqutYubEGSgyDGWGRvcFRHEPG880qrq2RljbBUAulMCXsydWQ
         Xgig+uJkKnnB/t1DVXQq7vBxnPefzMCUchv0j3c++e3bup8XzmugNMVBfhy/7mf5BYTP
         pdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ueHLsE/JFrX5xf26D7R38A2Ik+NTkR/KFj4XZmiWrTQ=;
        b=BG6es8Z/o2vzP87udFDm/AqatSxiZNDZEEi5IVekYmBX0hF4Mupc/AuVnYMuhhhgVs
         WPcTsdsLc1tIgO4IIsYdzwXjo9bOqPFP+bAoFSYBweAff13Kv+eOle01AWM9eWxKGf1L
         ZqIkMoIhxFWg7/mz/ThejoYX+q5lSTlKzmCrf4j9SgRpI/UVAMYDyAqY1KoluJtByEC5
         tvcfsrh2Smd2y/OUsW5Tdy6INsOcGwUkv0XeLIyKLDjc0LQFd0Xxw2iPog/Ue/y3KeyS
         twE2DrWf7TXVWmjPlm7+rMOw7aOhnuzdObj7BXAGEnILL5NZFC3TCzmQhc/lrRMyN/Oc
         hJ8A==
X-Gm-Message-State: AHQUAuZybfsJideQmsjv2r4YAIVY1yMgga3JsWqxFAVu+X0kFObz1rUN
        rWbKD7IrtXZf2F4w6DXGGYM=
X-Google-Smtp-Source: AHgI3Ib1VUaUgdJNkKCayQhJm6eZ8eiO924M/d6h+RLPj3FKFoNZ47e4Q65hnUMONBR5GejWca5MEw==
X-Received: by 2002:a65:64d6:: with SMTP id t22mr11647458pgv.52.1549262034673;
        Sun, 03 Feb 2019 22:33:54 -0800 (PST)
Received: from cpu459.localdomain ([27.59.252.63])
        by smtp.gmail.com with ESMTPSA id t21sm20240438pgg.24.2019.02.03.22.33.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:33:54 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com, amitkarwar@gmail.com
Subject: [v3 2/5] rsi: add hci detach for hibernation and poweroff
Date:   Mon,  4 Feb 2019 12:03:26 +0530
Message-Id: <1549262009-8766-3-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
References: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

As we missed to detach HCI, while entering power off or hibernation,
an extra hci interface gets created whenever system is woken up, to
avoid this we added hci_detach() in rsi_disconnect(), rsi_freeze(),
and rsi_shutdown() functions which are invoked for these tests.
This patch fixes the issue

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 18 ++++++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_usb.c  |  7 +++++++
 2 files changed, 25 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b412b65e..9a3bb0d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1132,6 +1132,12 @@ static void rsi_disconnect(struct sdio_func *pfunction)
 	rsi_mac80211_detach(adapter);
 	mdelay(10);
 
+	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
+	    adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	/* Reset Chip */
 	rsi_reset_chip(adapter);
 
@@ -1308,6 +1314,12 @@ static int rsi_freeze(struct device *dev)
 		rsi_dbg(ERR_ZONE,
 			"##### Device can not wake up through WLAN\n");
 
+	if (IS_ENABLED(CONFIG_RSI_COEX) && common->coex_mode > 1 &&
+	    common->bt_adapter) {
+		rsi_bt_ops.detach(common->bt_adapter);
+		common->bt_adapter = NULL;
+	}
+
 	ret = rsi_sdio_disable_interrupts(pfunction);
 
 	if (sdev->write_fail)
@@ -1355,6 +1367,12 @@ static void rsi_shutdown(struct device *dev)
 	if (rsi_config_wowlan(adapter, wowlan))
 		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
 
+	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
+	    adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	rsi_sdio_disable_interrupts(sdev->pfunction);
 
 	if (sdev->write_fail)
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index f360690..d31f9cd 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -816,6 +816,13 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		return;
 
 	rsi_mac80211_detach(adapter);
+
+	if (IS_ENABLED(CONFIG_RSI_COEX) && adapter->priv->coex_mode > 1 &&
+	    adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
-- 
2.5.5

