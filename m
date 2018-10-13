Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4D6C6787C
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 00:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ABE52075B
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 00:55:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AMreK8x/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5ABE52075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbeJMIaa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 04:30:30 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36766 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbeJMIaa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 04:30:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id l81-v6so6988252pfg.3
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 17:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KhatUidEATM1dyEWadH/V2c3Hdep3l08021kxRdjpjQ=;
        b=AMreK8x/2VIp0PScOGFiVbRdb3ntCFc422TRdQCZ9nXxj68RwHn0hDzZ6p2NmF7mN2
         oxI2gqHK5ek4UozFaNfjocC77eJZ/3YlxeJ5UZfReuPCl7NeeTgV+gUarI3X85jpHUE0
         h9EchBlvybovGflTL9AF8mYZJxiZgrL7HoZ80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KhatUidEATM1dyEWadH/V2c3Hdep3l08021kxRdjpjQ=;
        b=mVMijsXm+mNW1vE//zKJamWyufdHyqjS9B2CNgOFXTlCPlM/IqHSKzaz0H+L856x3a
         7LJT4St7YXifzOIqhL2Em22xL5XFia6z2+I/Fx1u2mqEtpWlU4y/wL5w3+lFMZpdjyS3
         DY0s1+uMrX+3L8OlVBRoHf/IkA1z+j5XrU0bx495tu75G7sKhQDUrIqOjA1Jj1s/62BE
         59KxRlVLMtAK9z9tLNUl/fkRul6tPnhw8tPbBkO6aVgTjgwP06debBjgTQ9GaaICyaoR
         jMRNpumOlRGkfWl4HrOYXqrvInwvZYaE+zPfnl0J6nYRC6sqnFEqn6tI0AlT0FOhT9Nc
         nmEA==
X-Gm-Message-State: ABuFfoiHqWuDomAUujYdZBLBmY1P+nxAYlEqPKY56OO2clpSC2g0mw4T
        XdirlP5oMhFwagHK/fYkdWMzRg==
X-Google-Smtp-Source: ACcGV6318p75321C6lU7pfqQUG8yiKK/ZQ4cliRSbYOhal1cfKuYCTB51x1HtCsdyf7OKSOJVuTACA==
X-Received: by 2002:a62:64d5:: with SMTP id y204-v6mr8228333pfb.187.1539392128884;
        Fri, 12 Oct 2018 17:55:28 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id n7-v6sm2766183pgv.63.2018.10.12.17.55.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 17:55:27 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Kalle Valo <kvalo@qca.qualcomm.com>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 1/4] ath10k: snoc: remove 'wcn3990' from generic resource handling
Date:   Fri, 12 Oct 2018 17:55:01 -0700
Message-Id: <20181013005504.46399-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.331.ge82ca0e54c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath10k_wcn3990_clk_info and ath10k_wcn3990_vreg_info are not
WCN3990-specific structures. They hold generic data. So don't name them
with wcn3990 specifics.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 34 +++++++++++++-------------
 drivers/net/wireless/ath/ath10k/snoc.h |  8 +++---
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index 8d3d9bca410f..c6254db17dab 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -46,14 +46,14 @@ static char *const ce_name[] = {
 	"WLAN_CE_11",
 };
 
-static struct ath10k_wcn3990_vreg_info vreg_cfg[] = {
+static struct ath10k_vreg_info vreg_cfg[] = {
 	{NULL, "vdd-0.8-cx-mx", 800000, 800000, 0, 0, false},
 	{NULL, "vdd-1.8-xo", 1800000, 1800000, 0, 0, false},
 	{NULL, "vdd-1.3-rfa", 1304000, 1304000, 0, 0, false},
 	{NULL, "vdd-3.3-ch0", 3312000, 3312000, 0, 0, false},
 };
 
-static struct ath10k_wcn3990_clk_info clk_cfg[] = {
+static struct ath10k_clk_info clk_cfg[] = {
 	{NULL, "cxo_ref_clk_pin", 0, false},
 };
 
@@ -1246,7 +1246,7 @@ static void ath10k_snoc_release_resource(struct ath10k *ar)
 }
 
 static int ath10k_get_vreg_info(struct ath10k *ar, struct device *dev,
-				struct ath10k_wcn3990_vreg_info *vreg_info)
+				struct ath10k_vreg_info *vreg_info)
 {
 	struct regulator *reg;
 	int ret = 0;
@@ -1284,7 +1284,7 @@ static int ath10k_get_vreg_info(struct ath10k *ar, struct device *dev,
 }
 
 static int ath10k_get_clk_info(struct ath10k *ar, struct device *dev,
-			       struct ath10k_wcn3990_clk_info *clk_info)
+			       struct ath10k_clk_info *clk_info)
 {
 	struct clk *handle;
 	int ret = 0;
@@ -1311,10 +1311,10 @@ static int ath10k_get_clk_info(struct ath10k *ar, struct device *dev,
 	return ret;
 }
 
-static int ath10k_wcn3990_vreg_on(struct ath10k *ar)
+static int ath10k_snoc_vreg_on(struct ath10k *ar)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
-	struct ath10k_wcn3990_vreg_info *vreg_info;
+	struct ath10k_vreg_info *vreg_info;
 	int ret = 0;
 	int i;
 
@@ -1376,10 +1376,10 @@ static int ath10k_wcn3990_vreg_on(struct ath10k *ar)
 	return ret;
 }
 
-static int ath10k_wcn3990_vreg_off(struct ath10k *ar)
+static int ath10k_snoc_vreg_off(struct ath10k *ar)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
-	struct ath10k_wcn3990_vreg_info *vreg_info;
+	struct ath10k_vreg_info *vreg_info;
 	int ret = 0;
 	int i;
 
@@ -1412,10 +1412,10 @@ static int ath10k_wcn3990_vreg_off(struct ath10k *ar)
 	return ret;
 }
 
-static int ath10k_wcn3990_clk_init(struct ath10k *ar)
+static int ath10k_snoc_clk_init(struct ath10k *ar)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
-	struct ath10k_wcn3990_clk_info *clk_info;
+	struct ath10k_clk_info *clk_info;
 	int ret = 0;
 	int i;
 
@@ -1461,10 +1461,10 @@ static int ath10k_wcn3990_clk_init(struct ath10k *ar)
 	return ret;
 }
 
-static int ath10k_wcn3990_clk_deinit(struct ath10k *ar)
+static int ath10k_snoc_clk_deinit(struct ath10k *ar)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
-	struct ath10k_wcn3990_clk_info *clk_info;
+	struct ath10k_clk_info *clk_info;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(clk_cfg); i++) {
@@ -1488,18 +1488,18 @@ static int ath10k_hw_power_on(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "soc power on\n");
 
-	ret = ath10k_wcn3990_vreg_on(ar);
+	ret = ath10k_snoc_vreg_on(ar);
 	if (ret)
 		return ret;
 
-	ret = ath10k_wcn3990_clk_init(ar);
+	ret = ath10k_snoc_clk_init(ar);
 	if (ret)
 		goto vreg_off;
 
 	return ret;
 
 vreg_off:
-	ath10k_wcn3990_vreg_off(ar);
+	ath10k_snoc_vreg_off(ar);
 	return ret;
 }
 
@@ -1509,9 +1509,9 @@ static int ath10k_hw_power_off(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_SNOC, "soc power off\n");
 
-	ath10k_wcn3990_clk_deinit(ar);
+	ath10k_snoc_clk_deinit(ar);
 
-	ret = ath10k_wcn3990_vreg_off(ar);
+	ret = ath10k_snoc_vreg_off(ar);
 
 	return ret;
 }
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index e1d2d6675556..4a3837b5c68d 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -53,7 +53,7 @@ struct ath10k_snoc_ce_irq {
 	u32 irq_line;
 };
 
-struct ath10k_wcn3990_vreg_info {
+struct ath10k_vreg_info {
 	struct regulator *reg;
 	const char *name;
 	u32 min_v;
@@ -63,7 +63,7 @@ struct ath10k_wcn3990_vreg_info {
 	bool required;
 };
 
-struct ath10k_wcn3990_clk_info {
+struct ath10k_clk_info {
 	struct clk *handle;
 	const char *name;
 	u32 freq;
@@ -81,8 +81,8 @@ struct ath10k_snoc {
 	struct ath10k_snoc_ce_irq ce_irqs[CE_COUNT_MAX];
 	struct ath10k_ce ce;
 	struct timer_list rx_post_retry;
-	struct ath10k_wcn3990_vreg_info *vreg;
-	struct ath10k_wcn3990_clk_info *clk;
+	struct ath10k_vreg_info *vreg;
+	struct ath10k_clk_info *clk;
 	struct ath10k_qmi *qmi;
 };
 
-- 
2.19.1.331.ge82ca0e54c-goog

