Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37A3C282D7
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72D03217D6
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 06:34:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KlkHpbQe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfBDGd7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:33:59 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33323 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbfBDGd7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 01:33:59 -0500
Received: by mail-pg1-f195.google.com with SMTP id z11so5858908pgu.0
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2019 22:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b1A3SSSDbacjmzYcSWgZVrdshnUClX93HmbOH70KG3w=;
        b=KlkHpbQebFjzZYlBbdgmWaYPILKnX7OYshjdosAPyBAVH3uGExRrW/JUkjgp+hMCUe
         tLo7J/YC6anK606qxalYquLJlN1jvpsc7G6zkvkjhu0V/qjWRcBQLPZGPHT6mGYzQnGg
         Qpqmjpf+L3h+unS7aFBREYF7VrD8xhKkLnaq6mj5KrHmS0kBOfLuMAF49X8gqPVm2BaP
         62mFvKffR6O+pPyfkfThChrEO9Gk2FbVQEJClOe5FFMxpkvTPK5XqLacE3VNruztOOW0
         +mx0B0yFd7dhq0RRmyKrVgIpJoFCNbVhpQN64ALbreb6UO3dVuV6AqufQiBxjgFYf0WN
         zY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b1A3SSSDbacjmzYcSWgZVrdshnUClX93HmbOH70KG3w=;
        b=MSJmejxsOR7qPFTYrsw3MSUUOSKDPtuPalMoO/6RL3cjyRxmVXp7nniVQpT8+FdANt
         XLNbEUAfml3zkRhJACcOSBB1mRQkrgmN4znfYpTIV4euMNXDTv/RyATsnYBwcy/c5SFF
         9mx3+upaq0t/k3b16AmVbBUVgq06cMs6FTqLBfn5mRcS6W9Q6h3iz2AiVoEa7dooqJ1V
         29B1tXf+6zHG7BrtE++2ZhlYA7Jgws052Nf8goOSItcQM59tB0Hy0u3+wQBbnGZhDYa4
         t9K7tz4EHl2LBW5rrvaUKsMtqPkpuVJ0oYI8pKy+hcPo7MIOFNjUMvmebqvRo9bLm+Zq
         LLYg==
X-Gm-Message-State: AJcUukfq5ZvNi1B+/wvLZVwcLBQyQgSDkTvAe2oeL0G39/9tRJIDdQrh
        iix8mVXDRKeVfhCMFa3GtSA=
X-Google-Smtp-Source: ALg8bN5/PKZC5YKUVaFr51/OCnFTuMGfL+dYF9CjKT1kknZ2pXUrN1ZgjpQ6LmsMBeI9RS4x6hatPw==
X-Received: by 2002:a62:1b83:: with SMTP id b125mr51800305pfb.42.1549262038091;
        Sun, 03 Feb 2019 22:33:58 -0800 (PST)
Received: from cpu459.localdomain ([27.59.252.63])
        by smtp.gmail.com with ESMTPSA id t21sm20240438pgg.24.2019.02.03.22.33.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:33:57 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com, amitkarwar@gmail.com
Subject: [v3 3/5] rsi: fix wowlan wakeup issue for hibernate(S4)
Date:   Mon,  4 Feb 2019 12:03:27 +0530
Message-Id: <1549262009-8766-4-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
References: <1549262009-8766-1-git-send-email-siva8118@gmail.com>
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
index 9a3bb0d..449803c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -1396,7 +1396,6 @@ static int rsi_restore(struct device *dev)
 	common->iface_down = true;
 
 	adapter->sc_nvifs = 0;
-	ieee80211_restart_hw(adapter->hw);
 
 	common->wow_flags = 0;
 	common->iface_down = false;
-- 
2.5.5

