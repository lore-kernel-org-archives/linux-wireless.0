Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EB4C282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A00F8218D2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 06:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIcVgE1K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfAYGa0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:30:26 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36933 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbfAYGaZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 01:30:25 -0500
Received: by mail-pg1-f193.google.com with SMTP id c25so3789270pgb.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 22:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wKLTsv8WQv34PB5hXhNvtyTRQ5sUzkKGfvWrDqTNJ50=;
        b=KIcVgE1K+pr7Z37teLi8EYv3vFwHmzgQTD1D1FKa5Aon8uMehexbLzNPxNuS5ZWttv
         XKocSsbu0jEghnGlQF9MbhHd20lV0K7dvWuoi1lFbATBMjwAoostsyM2g9V5R76fGlDa
         ElbnekffoqutRv/D9EoNVaXnVKM2z4vvCCoRU6LU4ZciP17Z5MllY4s1yX2/L2iJPcl5
         GHQGqsyqKJ01DifQtcWJ+l6rYhk7bdJdLEQkROPbjH/JqujwKR5Zf01k8cxn9Bes61WZ
         wOOpvV8M66iQczXyxLP0Bvox5L+fk1CfhCwV8fCoHKgh4I2YBW8i/43SaCZI5cKj5VN4
         aUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wKLTsv8WQv34PB5hXhNvtyTRQ5sUzkKGfvWrDqTNJ50=;
        b=jX95m4jqExE20eXgxN69njKnF5BeVrNbIGhq//dBmzU4AObkF/sNMzfZ/+ESdC+KGv
         aBCbRCfvoWYoR72XfwY4Aliy0IavFE/GLWdBeveaTTa3llRLqyxb3qUHbv3YlORN/Sye
         7nTqhy+nKO2kYayQiegRtu6T5eSlu8UQXe33/QvbN7GGeYjClw10Up83P/leB5Nz74f5
         XUBTKlvCLWkWTU8MHeo76G4kTMjUqq5wc/wmycwYjYaL17zWV/sUJ3L+Sgrc2qfJRSPz
         5lvcaZL0BgZQuBTaENdHP/AXapY+ihESufHt0Iai8Wq6ha0bJMeDwhX66FkNII+OtYC2
         a5Kg==
X-Gm-Message-State: AJcUukfEC03RlIx/bfM3HvEGD5c2DBo7iKdZwwNZfvd9rSxy24cSNcjF
        g7Sd+U0efL7l8XBn6p7Bog0=
X-Google-Smtp-Source: ALg8bN4uh6N/vGnYj6e77ASQ156CDYfeDLH4RIGoxQMPKL63Za/IRg3PMiiLKbEG6yqPBgQgsVZfXQ==
X-Received: by 2002:a63:6984:: with SMTP id e126mr8985881pgc.143.1548397824671;
        Thu, 24 Jan 2019 22:30:24 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id x19sm37384793pfk.14.2019.01.24.22.30.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 22:30:24 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Rishikesh Basu <rishikesh.basu@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Ganapathiraju Kondraju <ganapathi.kondraju@redpinesignals.com>,
        krishna.pedda@redpinesignals.com
Subject: [PATCH 3/5] rsi: fix wowlan wakeup issue for hibernate(S4)
Date:   Fri, 25 Jan 2019 12:00:00 +0530
Message-Id: <1548397802-12180-4-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
References: <1548397802-12180-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

At SDIO restore ieee80211_restart_hw() is getting called to restart all
MAC operations. This step is not required.
Returning 1 from mac80211_resume() will serve this purpose.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 8 ++++++--
 drivers/net/wireless/rsi/rsi_91x_sdio.c     | 1 -
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index aded1ae..8d1282f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1938,8 +1938,12 @@ static int rsi_mac80211_resume(struct ieee80211_hw *hw)
 
 	rsi_dbg(INFO_ZONE, "%s: mac80211 resume\n", __func__);
 
-	if (common->hibernate_resume)
-		return 0;
+	if (common->hibernate_resume) {
+		/* Device need a complete restart of all MAC operations.
+		 * returning 1 will serve this purpose.
+		 */
+		return 1;
+	}
 
 	mutex_lock(&common->mutex);
 	rsi_send_wowlan_request(common, 0, 0);
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 59ff778..3375d64 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1395,7 +1395,6 @@ static int rsi_restore(struct device *dev)
 	common->iface_down = true;
 
 	adapter->sc_nvifs = 0;
-	ieee80211_restart_hw(adapter->hw);
 
 	common->wow_flags = 0;
 	common->iface_down = false;
-- 
2.5.5

