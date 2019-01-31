Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F64C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E22DF2087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 05:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jcRzsuho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfAaFxp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 00:53:45 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:41896 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfAaFxp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 00:53:45 -0500
Received: by mail-pf1-f174.google.com with SMTP id b7so987082pfi.8
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 21:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9c5Qv3xKOnSbwK7hxSyqCi1So4hNP+y66JHHTtRgqGg=;
        b=jcRzsuhoMegy5GqpQuRW6YshrEZveMoW1wUIkca8UPAy4AnJcw3jS3qEbCpmdNbe1V
         UXJhrnb634JUmnZJqXWXKX7TrtOpOnWf7/Kv3KwnBwEac9yepxYJ880yHb2nXVIGrYO2
         /+cE5tJbtK1XAKg8dWG2JyfiGHNF8sGFA/wfLQZcRHJCNht6M7HubedAO6OWUmYPGhtj
         +8zxFJjKWp1o5zi3IunbQLa+r07mb6qq7hT95ucs6vzFlozsp4N9+nGJS3NiXzqjkb/o
         DTVNybLXpGdBCCtolc8Pi47hSVvMXLQ9qVduETKIDslew8t645vVeUqlZFrCRNhRbvAj
         s+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9c5Qv3xKOnSbwK7hxSyqCi1So4hNP+y66JHHTtRgqGg=;
        b=r9w4yy9TcRr6CYMpklS8/JduVdp/Q6chOKtO21PvjtNhx7LF3WZS/pPu/uTrzzY9p3
         nXj3w5YEAm8vdWOQ+sz4PCLdy2nSy8FaXTSdfzYgyVEyj93fMjOyYSNkmzOic+WKAFD9
         QgUjAQ/Gt9+3+sp3XvMMwNWKQLCULb7L7WYaVBvToPWYwSvfP9zZwojh8QONTYXYVPoQ
         twuH4C3v4nJb1ZDXPVAM7u4im2Qw6JJ38aKV4rVAvDKEeC9bNV+HjYNoSrPelQhgY9IB
         f9IzfsTQmspl8RS52YSzcQX7ENrHeqIpqhrJCA/iI20mbxHlRSQu24oe7wq8AnYj88sb
         hLzw==
X-Gm-Message-State: AJcUuke3dw6JzOkGtlXp+ulewz5t+qUROu1U6GzE52vCPWAm00sHWDIS
        OQyxLM4AYC32EhZ5QvsrCtw=
X-Google-Smtp-Source: ALg8bN4hU40aogGLINOl003AD/rUOer6QD656XZirKrZohpfFYAmqpxjYkJ9c2M87dkJJ6MAHd/ZxA==
X-Received: by 2002:a63:2f07:: with SMTP id v7mr22284932pgv.368.1548914024154;
        Wed, 30 Jan 2019 21:53:44 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id h19sm4314493pfn.114.2019.01.30.21.53.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 21:53:43 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, rishikesh.basu@redpinesignals.com,
        siva.rebbagondla@redpinesignals.com,
        krishna.pedda@redpinesignals.com,
        ganapathi.kondraju@redpinesignals.com
Subject: [v2 5/5] rsi: fix for wowlan wakeup failure
Date:   Thu, 31 Jan 2019 11:23:05 +0530
Message-Id: <1548913985-7180-6-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
References: <1548913985-7180-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

During wowlan regression tests, sometimes radio is not waking up for wowlan
packet in coex mode. This is because of power save is enabled by default
in case of coex mode greater than one. Hence, disable power save in coex
mode to avoid radio loss.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 7bc8da6..3fd2571 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1901,6 +1901,10 @@ int rsi_config_wowlan(struct rsi_hw *adapter, struct cfg80211_wowlan *wowlan)
 		return 0;
 	}
 	rsi_dbg(INFO_ZONE, "TRIGGERS %x\n", triggers);
+
+	if (common->coex_mode > 1)
+		rsi_disable_ps(adapter, adapter->vifs[0]);
+
 	rsi_send_wowlan_request(common, triggers, 1);
 
 	/**
-- 
2.5.5

