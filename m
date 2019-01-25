Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B411BC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8240E218D2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CzvVPSbA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfAYGaX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:30:23 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40086 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbfAYGaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 01:30:23 -0500
Received: by mail-pg1-f195.google.com with SMTP id z10so3784549pgp.7
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 22:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bJuDtLb1pBeqzoK/fjWl+rfJQg+7dX50nVRNiyCbias=;
        b=CzvVPSbAG4X2OOjUUYFUT5LEsk4jRZtcFyTBHVCwoC1qJL+iNA0HsNMd3CS2ieGGAR
         aiILIDf/7dlpEcWcYKmr/labouePu0KXJ8PmNpyzRBzVBSgmkPgQDtQB/ImrK2hbNK8m
         N4s8HMNFGTbU9NsFbnm71jml2lv4fdALOQbeeEy49+p4pCohAFYschiGiNyAil1W1nFJ
         WGP8CooS285uyasDGH62xZPpM/YQaoQQxGWCrDSGGpj3v123xReitbW82eG+CC8UEHh2
         YaIANTTMc6S86RwTi8OMKAWYSnTu+gY7mhYI+hyw8sNvqpRHI9Ts+BIKYek2iCopObh8
         dz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bJuDtLb1pBeqzoK/fjWl+rfJQg+7dX50nVRNiyCbias=;
        b=R+Tgto79/tx59YvTe1eOGbS5yWxBo/j3XJYjUvpENrcGu09593ZBAhePp6QXQt7paP
         OPmWf91UqGEwKQxFLMfC1D/75yN859Opd+B/YXsiO0b3ZGxJP+z5b53akdgS69wgi6Yu
         C4Mdb7nDKWLmReaNKvYnDJLoZpp8gTObEmcSlfLKozoE7KLHx1dCLAi32VXZOLALf5dW
         zpR9cBBCdOCUgWqEOCr5ElBxHv60E8a4FuP9ffOqoceWfpQYQ2nsUGUx4N0hpsW3y/P7
         xft3s6kWBRkRDdPVPadQiVWpca5nwNCzvBtyj18vjldatGwKuZJI8xFwc7q1SSo8KUN1
         pTAw==
X-Gm-Message-State: AJcUukcB63/yFFvczUolpjzy4AN3nirYEiTTBSJ6lNuFAxtg9ql6j9Wn
        ul9y+/+Un3vio4hq2kN2UEE=
X-Google-Smtp-Source: ALg8bN4zP5jo949JrRT93fHuEfTNeMkCtdB+5JGrLYkFKpCxAR+W+ILOMiHqI3LJ8dF1TRunv1sy4w==
X-Received: by 2002:a63:658:: with SMTP id 85mr8785642pgg.373.1548397822057;
        Thu, 24 Jan 2019 22:30:22 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id x19sm37384793pfk.14.2019.01.24.22.30.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 22:30:21 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        krishna.pedda@redpinesignals.com
Subject: [PATCH 2/5] rsi: add hci detach for hibernation and poweroff
Date:   Fri, 25 Jan 2019 11:59:59 +0530
Message-Id: <1548397802-12180-3-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
References: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
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
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 +++++++++++++++++++--
 drivers/net/wireless/rsi/rsi_91x_usb.c  |  6 ++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b412b65e..59ff778 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1131,7 +1131,12 @@ static void rsi_disconnect(struct sdio_func *pfunction)
 
 	rsi_mac80211_detach(adapter);
 	mdelay(10);
-
+#ifdef CONFIG_RSI_COEX
+	if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+#endif
 	/* Reset Chip */
 	rsi_reset_chip(adapter);
 
@@ -1308,6 +1313,13 @@ static int rsi_freeze(struct device *dev)
 		rsi_dbg(ERR_ZONE,
 			"##### Device can not wake up through WLAN\n");
 
+#ifdef CONFIG_RSI_COEX
+	if (common->coex_mode > 1 && common->bt_adapter) {
+		rsi_bt_ops.detach(common->bt_adapter);
+		common->bt_adapter = NULL;
+	}
+#endif
+
 	ret = rsi_sdio_disable_interrupts(pfunction);
 
 	if (sdev->write_fail)
@@ -1354,7 +1366,12 @@ static void rsi_shutdown(struct device *dev)
 
 	if (rsi_config_wowlan(adapter, wowlan))
 		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
-
+#ifdef CONFIG_RSI_COEX
+	if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+#endif
 	rsi_sdio_disable_interrupts(sdev->pfunction);
 
 	if (sdev->write_fail)
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index f360690..be20fd1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -816,6 +816,12 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		return;
 
 	rsi_mac80211_detach(adapter);
+#ifdef CONFIG_RSI_COEX
+	if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+#endif
 	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
-- 
2.5.5

