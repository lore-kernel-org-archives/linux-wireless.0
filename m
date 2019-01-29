Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF56FC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 23:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F6820882
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 23:12:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YQUUiUBS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfA2XMM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 18:12:12 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33530 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfA2XMM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 18:12:12 -0500
Received: by mail-pg1-f195.google.com with SMTP id z11so9456349pgu.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 15:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n5QI9SCQIVH2sd+cRwUOWax4a5NWTgXxRP/Hc68OVrQ=;
        b=YQUUiUBSHwmDWfSh6N7OjxAVwrzbdWTyxu4juK6HCDi9FZecOTFP7xBtOkWg+Eu35O
         XNyJlPQDbqeqDOXAIJBHC7Dncvf8H+ral7ymA/xDRd/9F8kQvv8rTeB/asLgmQzsxtbw
         V8pIIGDF2Vls4cRH/U1QWu+uBwGUeMMuWWehQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n5QI9SCQIVH2sd+cRwUOWax4a5NWTgXxRP/Hc68OVrQ=;
        b=Ff+pCURei3AeZrXdCpXpmpqWVg68dc1oKOumm/uCgkeiEhIAEHvaPTy0Gb9Yb5Wyry
         fTELCSaa6Sq6j0jP/A/k2M5UVgHujnJY9kUYeM3N9FNUxThLCMf4q3rTnELhNxE/38Jg
         GJeuL/4/zoaLz25/mcOrg8sEe2mFSQ/AT/SfZIAQa+C3TTyKqz8LuyaGsZbDdsXnonaU
         xfZmANJRkUwrp/nuUYQbUaaP5DcINC6/39EggN2nz4QJu6ubpFAO9B1rXhQ/ON5V2rux
         aYgLTqGI7w7hvBPY/MUyDWOMtNcxBTnh0R96wijXlXWJvsy3y/3EtzAqbZG1hRjheUY7
         6vDA==
X-Gm-Message-State: AJcUukfI7cbVeWEfwwZ/1jvtRu1YTVPHcziIg3OQslb9OeiTlaayy3g7
        jxRuO79oJgszc7julh99SqbxyA==
X-Google-Smtp-Source: ALg8bN5hcrgKnk1iWV5DfqWkGd+kA9rqOlnjRdi2FYjS7j2cC25d1TdNfqqU7RcYCEIu7zzwe3W2CA==
X-Received: by 2002:a63:2315:: with SMTP id j21mr25714008pgj.297.1548803531180;
        Tue, 29 Jan 2019 15:12:11 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id m67sm64681055pfb.25.2019.01.29.15.12.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 15:12:09 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Wen Gong <wgong@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH for-5.0] ath10k: correct bus type for WCN3990
Date:   Tue, 29 Jan 2019 15:12:01 -0800
Message-Id: <20190129231201.42230-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.20.1.495.gaa96b0ce6b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 is SNOC, not PCI. This prevents probing WCN3990.

Fixes: 367c899f622c ("ath10k: add bus type check in ath10k_init_hw_params")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
This was a regression in 4.20.

 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 399b501f3c3c..e8891f5fc83a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -548,7 +548,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
 		.dev_id = 0,
-		.bus = ATH10K_BUS_PCI,
+		.bus = ATH10K_BUS_SNOC,
 		.name = "wcn3990 hw1.0",
 		.continuous_frag_desc = true,
 		.tx_chain_mask = 0x7,
-- 
2.20.1.495.gaa96b0ce6b-goog

