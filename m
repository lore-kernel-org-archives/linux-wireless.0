Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7168CC282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FD6C218D2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XpsEIOaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfAYGa2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:30:28 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42219 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbfAYGa2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 01:30:28 -0500
Received: by mail-pl1-f195.google.com with SMTP id y1so4083867plp.9
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 22:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qtkqNqaY/uO0ZZbknk5RaMtB52FCJSZoJtJOxtJ569c=;
        b=XpsEIOafjMBUwqHm6ErHDZkqMC/oXBtCc/roQSRUnAyEsV0AS1E2CvT0fBZ0BpNELN
         NyffFMSBWZXHuxX6bWGQtfbsmmsYy6wVA2hYasZbg7An0MqXeGhSneNAL6yOAYG9v4se
         YTzKsCLWEEVAZMRYvnDtBoLUlUwps3wEjdxLNCeLC5Eb/RyEb0Jn5svw/C8lc5sK69ez
         f1qGzav7u6uR60iPb4QRYhRARuT2VVweXbkVK60ldfSvCHEoZtzab8InzqCbDEGPX+im
         O4Dw4ierU9z7i7z5908jFhQBKg3pTJq8cQ/Slao9uohdZ/ODWVKxgZcMGwfOWp7CZMHl
         vLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qtkqNqaY/uO0ZZbknk5RaMtB52FCJSZoJtJOxtJ569c=;
        b=GkE4voKgSjQ7lYiUKIFbQserXudSi1EFfIgmMzysmFaE+KhhOEaHw26/dEEg76P0lB
         qxymPJoWzxWyuYgk1uJ52SvsHymF0JDRR9nQbI/GobCXtAfDar7DhRdOLj3PM9cNGsgb
         kK8DkR1hA4PMWQQAnWCqClpTn24pxv28TMNVTshP3X/JHMnRI+t4jBVGQ1hoJHUQMxnU
         +PdoB6jCUozvF1aUxeXKSmJYMvr1gt1kdbAwn64WvNVz0/5ZryuP1eYFDaYVgfS0sPWs
         F8KsxHtpK4oMZgiNGMMBSIqvKXgQ7Oo5FhZnSZtPi1ICQ07gs0acdLZLs23CivMI4uKG
         Kx3g==
X-Gm-Message-State: AJcUukf+uumROevHj7yb87LE3sWAJQRKTbYs0c745yPW4xDEI1LRED4y
        xKEfZA9qALSEqp3bxJu9IvM=
X-Google-Smtp-Source: ALg8bN5oY4zwZUZD2Lo7SDGIfPmRrkBtBh329iZOMjrTd8j52J4Mypk1p5P6Vo9sSUcYLIOdMthWqA==
X-Received: by 2002:a17:902:bb98:: with SMTP id m24mr9421310pls.71.1548397827289;
        Thu, 24 Jan 2019 22:30:27 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id x19sm37384793pfk.14.2019.01.24.22.30.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 22:30:26 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        krishna.pedda@redpinesignals.com
Subject: [PATCH 4/5] rsi: resolve power save issue after S4 resume
Date:   Fri, 25 Jan 2019 12:00:01 +0530
Message-Id: <1548397802-12180-5-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
References: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

We are redownloading the firmware after S4 restore and observed in
stress test that mac80211 sometimes gives power save request after
resume which causes the firmware in bad state. mac_ops_resumed flag
is added to skip that request until initialisation is done and Keeping
power save state is NONE.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 9 ++++++++-
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 1 +
 drivers/net/wireless/rsi/rsi_main.h         | 1 +
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 8d1282f..7bc8da6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -239,6 +239,7 @@ static int rsi_mac80211_hw_scan_start(struct ieee80211_hw *hw,
 	struct ieee80211_bss_conf *bss = &vif->bss_conf;
 
 	rsi_dbg(INFO_ZONE, "***** Hardware scan start *****\n");
+	common->mac_ops_resumed = false;
 
 	if (common->fsm_state != FSM_MAC_INIT_DONE)
 		return -ENODEV;
@@ -370,6 +371,10 @@ static void rsi_mac80211_tx(struct ieee80211_hw *hw,
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	struct ieee80211_hdr *wlh = (struct ieee80211_hdr *)skb->data;
+
+	if (ieee80211_is_auth(wlh->frame_control))
+		common->mac_ops_resumed = false;
 
 	rsi_core_xmit(common, skb);
 }
@@ -677,7 +682,8 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
 	}
 
 	/* Power save parameters */
-	if (changed & IEEE80211_CONF_CHANGE_PS) {
+	if ((changed & IEEE80211_CONF_CHANGE_PS) &&
+	    !common->mac_ops_resumed) {
 		struct ieee80211_vif *vif, *sta_vif = NULL;
 		unsigned long flags;
 		int i, set_ps = 1;
@@ -1939,6 +1945,7 @@ static int rsi_mac80211_resume(struct ieee80211_hw *hw)
 	rsi_dbg(INFO_ZONE, "%s: mac80211 resume\n", __func__);
 
 	if (common->hibernate_resume) {
+		common->mac_ops_resumed = true;
 		/* Device need a complete restart of all MAC operations.
 		 * returning 1 will serve this purpose.
 		 */
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 3375d64..7e0edc7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1395,6 +1395,7 @@ static int rsi_restore(struct device *dev)
 	common->iface_down = true;
 
 	adapter->sc_nvifs = 0;
+	adapter->ps_state = PS_NONE;
 
 	common->wow_flags = 0;
 	common->iface_down = false;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 4dc0c01..35d13f3 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -311,6 +311,7 @@ struct rsi_common {
 	struct cfg80211_scan_request *hwscan;
 	struct rsi_bgscan_params bgscan;
 	u8 bgscan_en;
+	u8 mac_ops_resumed;
 };
 
 struct eepromrw_info {
-- 
2.5.5

