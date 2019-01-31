Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4233C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B1212087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVpSPliv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfAaFxg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 00:53:36 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43277 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfAaFxg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 00:53:36 -0500
Received: by mail-pg1-f195.google.com with SMTP id v28so901332pgk.10
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 21:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mOOs7UQhuK6GwgAZ91QxThX+Nje2eRRW7C8mfuKoxy4=;
        b=JVpSPlivXO4DTErW3uTW5g6Q3LytePrNU+HS8zf/wQJWsOgB2juHmX3M0dT014LaIt
         QnYjwlKgkovE/lhgSpXqzbBZEZGKA0DvE/N0XdTH4eenZVgUwkuDxrHD8JCYeMyDa6Rl
         Y0HYZ7e9bFYM9jt8WH14jEq9+fEIrUc4QTkZ3MjPCkIA+o7PNY4dlBD3Ab4QPSeH06ne
         HMBUJiK8+dxB+ghjpRKqglvueKw0bXBidrjqfwhZgFQZ+j0RcH7T/o4tydQOrgRAojs4
         7X2RR6kc66XFeFBXyXsRyjWjqELgUVctGxHVjogSCszT/o4hjJFFP7lNfrEr71g0108u
         y7Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mOOs7UQhuK6GwgAZ91QxThX+Nje2eRRW7C8mfuKoxy4=;
        b=id5Vo8zBYme8KRwkpBYJK0mQkFmKNubmyto55V5tf5ir+dzLILuvk23XM4XM27ui4a
         HtMiUoKmxUh2Oq1wx5+vEGpuWiB5QGt9mp8cZQCg1CKn2r3dh41juT46gN+FXLgHiqag
         +fgomB9mm50MVEQc6ef8J/GiJUwJPqLzghnhojyMw948E+z9TsOO5V/6wXYO3Uakvxyg
         h75d+oMC78wG5mFpzuH0ZDAUGhSxwnxQ7Oy97H2m494BN7i4teNDt2b9nxONNUuqL2Ku
         ckptm6oMbMGUOUDDDCGqpZCfAURR2jQPfI7bAgFeHLmcHbauPZVpBO7YOPsEcd09o767
         IL5w==
X-Gm-Message-State: AJcUukdmGw15zWVdT7Nl7JH926hmsPY44DO6AaAn89DhD8f8em4wkPzN
        KTxQ+bDU4g1YPFYfZr/KHOE=
X-Google-Smtp-Source: ALg8bN4Q9VvUXhQMMVbe0E5djb0ifYaJubFMaJFFAGZqrEXTXXZY6f5RkaxdQa1N1e6zgWEyEg3oRw==
X-Received: by 2002:a63:5518:: with SMTP id j24mr29734873pgb.208.1548914015443;
        Wed, 30 Jan 2019 21:53:35 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id h19sm4314493pfn.114.2019.01.30.21.53.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 21:53:34 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com,
        ganapathi.kondraju@redpinesignals.com
Subject: [v2 2/5] rsi: add hci detach for hibernation and poweroff
Date:   Thu, 31 Jan 2019 11:23:02 +0530
Message-Id: <1548913985-7180-3-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
References: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
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
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 15 +++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_usb.c  |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index b412b65e..4005c1d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1132,6 +1132,11 @@ static void rsi_disconnect(struct sdio_func *pfunction)
 	rsi_mac80211_detach(adapter);
 	mdelay(10);
 
+	if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	/* Reset Chip */
 	rsi_reset_chip(adapter);
 
@@ -1308,6 +1313,11 @@ static int rsi_freeze(struct device *dev)
 		rsi_dbg(ERR_ZONE,
 			"##### Device can not wake up through WLAN\n");
 
+	if (common->coex_mode > 1 && common->bt_adapter) {
+		rsi_bt_ops.detach(common->bt_adapter);
+		common->bt_adapter = NULL;
+	}
+
 	ret = rsi_sdio_disable_interrupts(pfunction);
 
 	if (sdev->write_fail)
@@ -1355,6 +1365,11 @@ static void rsi_shutdown(struct device *dev)
 	if (rsi_config_wowlan(adapter, wowlan))
 		rsi_dbg(ERR_ZONE, "Failed to configure WoWLAN\n");
 
+	if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	rsi_sdio_disable_interrupts(sdev->pfunction);
 
 	if (sdev->write_fail)
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index f360690..38b4880b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -816,6 +816,12 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 		return;
 
 	rsi_mac80211_detach(adapter);
+
+	if (adapter->priv->coex_mode > 1 && adapter->priv->bt_adapter) {
+		rsi_bt_ops.detach(adapter->priv->bt_adapter);
+		adapter->priv->bt_adapter = NULL;
+	}
+
 	rsi_reset_card(adapter);
 	rsi_deinit_usb_interface(adapter);
 	rsi_91x_deinit(adapter);
-- 
2.5.5

