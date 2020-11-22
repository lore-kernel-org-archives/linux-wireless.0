Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BEAC64E69
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Nov 2020 23:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A05AE20771
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Nov 2020 23:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DKuZomgn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgKVXkl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 22 Nov 2020 18:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgKVXkj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Nov 2020 18:40:39 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 781A9C0613CF;
        Sun, 22 Nov 2020 15:40:39 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id o24so16084198ljj.6;
        Sun, 22 Nov 2020 15:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0I/omSkEt2kL2zxUSqvevYzdi5z/5TNsUg1IEtpD0CE=;
        b=DKuZomgnkoLU2GG4VHWfesxnoXdhPdwVl90ZKO+qyGry86oBwaJql10KjzRnYkny0l
         C6MbcwRWZ4hnxqB7qD+eVqoqdFKGwUz+H+VSv4XwFXTA+jJZSwEO3jEtOeRZoS5NhgA1
         RoZAhRBLLSUr3y35JoTYVJEbyGzPj2jWB5k9NWRiFVp31qWbQX0/qp9+MRuYI0Nm61aM
         lOQey5F2owxBWpGMC3Xa+7dQK/uWSR8GhJzxmdrIqvVSpnMtfRUrlYUYQi9GsC54cZM2
         LsVIuVKHjEnHISc+HxkBpEiaBUnQtbzmUdD1ENw/8Ou4byr9OieYwfawzrl3ffvPhIep
         2VQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0I/omSkEt2kL2zxUSqvevYzdi5z/5TNsUg1IEtpD0CE=;
        b=jxWDFjRD2fefRljaDhPKeiwkteYKufN6DU2N11psjBWWkSNyJJ1ySD0pRtS4rNTCyw
         ivjk0tKpUhrW+dVXm8KOYjb0pU/1aEIxC/X8eBKxsMrPPLN5tM3OsI0ccj7xhpMz1+zR
         +eEHn+/b9XW/0NITA5zUcbA7uVtqSstJOekt8jJdrZox76IzKE3Q7+safFzZDr6CqhgQ
         8P+go8PS5CCduTnZ9XYaoZmg4DkLF8m5YdsjF9QpEMtSkggirKkeeCw09LR/4YKuc+KA
         C37bUoqCBbfq/5sBjj3S5mlN9rzftKxpnv3XPkfVwIo1QaF+3sTqO7rzetckyTArZZFq
         RNnQ==
X-Gm-Message-State: AOAM530MpmSQ/C+GJzfNnzOkOw1DM6IsV5ZFp71wke7iejEmSWfDHDBs
        SNWEpnaeceycy3oO3wdr3C8=
X-Google-Smtp-Source: ABdhPJwHUkthoL13lFCHBkamhHxvBZWczt+cLQqPZqRUnct4ZOagib13KsARh4yd05qedbXsfe7BBQ==
X-Received: by 2002:a2e:9b07:: with SMTP id u7mr10985426lji.219.1606088438005;
        Sun, 22 Nov 2020 15:40:38 -0800 (PST)
Received: from localhost.localdomain (h-158-174-22-6.NA.cust.bahnhof.se. [158.174.22.6])
        by smtp.gmail.com with ESMTPSA id q13sm1178173lfk.147.2020.11.22.15.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 15:40:37 -0800 (PST)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alex Elder <elder@kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH net-next 2/2] ath10k: Constify static qmi structs
Date:   Mon, 23 Nov 2020 00:40:31 +0100
Message-Id: <20201122234031.33432-3-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
References: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

qmi_msg_handler[] and ath10k_qmi_ops are only used as input arguments
to qmi_handle_init() which accepts const pointers to both qmi_ops and
qmi_msg_handler. Make them const to allow the compiler to put them in
read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/net/wireless/ath/ath10k/qmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
index ae6b1f402adf..07e478f9a808 100644
--- a/drivers/net/wireless/ath/ath10k/qmi.c
+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -917,7 +917,7 @@ static void ath10k_qmi_msa_ready_ind(struct qmi_handle *qmi_hdl,
 	ath10k_qmi_driver_event_post(qmi, ATH10K_QMI_EVENT_MSA_READY_IND, NULL);
 }
 
-static struct qmi_msg_handler qmi_msg_handler[] = {
+static const struct qmi_msg_handler qmi_msg_handler[] = {
 	{
 		.type = QMI_INDICATION,
 		.msg_id = QMI_WLFW_FW_READY_IND_V01,
@@ -981,7 +981,7 @@ static void ath10k_qmi_del_server(struct qmi_handle *qmi_hdl,
 					     NULL);
 }
 
-static struct qmi_ops ath10k_qmi_ops = {
+static const struct qmi_ops ath10k_qmi_ops = {
 	.new_server = ath10k_qmi_new_server,
 	.del_server = ath10k_qmi_del_server,
 };
-- 
2.29.2

