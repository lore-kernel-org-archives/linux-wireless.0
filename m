Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD180C4CEC4
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 19:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 908DB206C2
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 19:49:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Je1LjaS7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502409AbfIWTtg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 15:49:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51806 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502394AbfIWTtg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 15:49:36 -0400
Received: by mail-wm1-f67.google.com with SMTP id 7so11333350wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 23 Sep 2019 12:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5B/Mh0LM7+3R0IUqdEb/xm0Cw/iYqewSqzeC/0CfkIw=;
        b=Je1LjaS7mkfqGTMy9PS8hdn/1XvE3ixc3SgKhuKwXQNG5LT/RpvjxmvOfS+90WubTc
         jbm8RG8AY7l1Wf5EVFaKtWt1NI5F48WubqwcJBsx76PHTi7rJzQqtwR/ASifgWuiyP2V
         Grr4K90JF9ANJiQ3UvDP8JQS5CFkrVuirR7yd9W0HVgEKTdh9+DyBPpCd0ahkkB6U1Xi
         aaRd4su4ZBKmpiTzv9WHNPX517tUHRM64xLSUGTaL8Lf9lhyFuUVh2OW9YWXxt3R3bKL
         iQfWWBPsfjSofThp1HF0FhbIILBlSZT0LdictHzrZ/wTnd76e66+yXxXNWYhwx6xl4Vd
         JcVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5B/Mh0LM7+3R0IUqdEb/xm0Cw/iYqewSqzeC/0CfkIw=;
        b=XvzM4Prnt3LmIiGR2opvFeweDXnnTmYY1STwZ0VNweFUfUflyvyMfzvO41Q1PoWZeK
         aLQ6e0eaqzs23ixT7SatmwOOJrlgQ3KUmEYysJ2kW0C8f6PPSxFA3+1e1FTpKhI8xrYT
         2GX23+T5/FiB7NmoakDv5DMJWkEecQB8TwtZcKZf1TRqDTuD7Ek16TMtr+eIRRHwOw48
         T/0eDfc1VlXLa5OUPYKKUcPFxwN0Nn0qv3fzrndOePHT5xI1tCePNtJx2EVDd52Cf1A9
         nDU5+8fl7C2BVy0Q3dfi8yLsXZz606Aj42B+JOO7HqnWTOECxTcx1f7pn4n3Gkmug7Cl
         aUJw==
X-Gm-Message-State: APjAAAUFHXc97CzUF6oKKe2HDAgk4gxi44RGePxQcEAeBxUPtyHfHZD+
        idJ1Oo7P9PNwgdyUmgme74buZdAH
X-Google-Smtp-Source: APXvYqwL53XSKibUyDWZ7XLazAjizCey5Aut1uilDPUfzn73pHc89LjaNpRT0xm8yHme8Bz578baAA==
X-Received: by 2002:a1c:6a06:: with SMTP id f6mr991788wmc.113.1569268172748;
        Mon, 23 Sep 2019 12:49:32 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id o188sm25108013wma.14.2019.09.23.12.49.31
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 23 Sep 2019 12:49:32 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, ath10k@lists.infradead.org
Subject: [PATCH 5/5] ath10k: pull_svc_rdy code-style fix
Date:   Mon, 23 Sep 2019 21:49:25 +0200
Message-Id: <1569268165-1639-5-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1569268165-1639-1-git-send-email-pozega.tomislav@gmail.com>
References: <1569268165-1639-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Drop unneeded lines by moving skb data in both main and 10x WMI
pull service ready event operations.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 59d2d2a..8ab178c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5345,13 +5345,12 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 ath10k_wmi_main_op_pull_svc_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 				   struct wmi_svc_rdy_ev_arg *arg)
 {
-	struct wmi_service_ready_event *ev;
+	struct wmi_service_ready_event *ev = (void *)skb->data;
 	size_t i, n;
 
 	if (skb->len < sizeof(*ev))
 		return -EPROTO;
 
-	ev = (void *)skb->data;
 	skb_pull(skb, sizeof(*ev));
 	arg->min_tx_power = ev->hw_min_tx_power;
 	arg->max_tx_power = ev->hw_max_tx_power;
@@ -5387,13 +5386,12 @@ static int ath10k_wmi_alloc_host_mem(struct ath10k *ar, u32 req_id,
 ath10k_wmi_10x_op_pull_svc_rdy_ev(struct ath10k *ar, struct sk_buff *skb,
 				  struct wmi_svc_rdy_ev_arg *arg)
 {
-	struct wmi_10x_service_ready_event *ev;
+	struct wmi_10x_service_ready_event *ev = (void *)skb->data;
 	int i, n;
 
 	if (skb->len < sizeof(*ev))
 		return -EPROTO;
 
-	ev = (void *)skb->data;
 	skb_pull(skb, sizeof(*ev));
 	arg->min_tx_power = ev->hw_min_tx_power;
 	arg->max_tx_power = ev->hw_max_tx_power;
-- 
1.7.0.4

