Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F285C71122
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 00:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35FB22075B
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 00:55:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AdljiIzy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35FB22075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbeJMIaf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 04:30:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40523 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbeJMIae (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 04:30:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id s5-v6so6979133pfj.7
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 17:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tOvjbpyRsbuPWsomBHKEhFntlFsBYkZHEyyX+xGS5QQ=;
        b=AdljiIzyMDquZb9pCUfNyYhk9HK9POSax2bqMyH/NirH0WQ812CNVR4RN0PblLrfQK
         USVSnza1jgclk+GiOWBJH5hcTuIlPKApATf+zRWW29ZAEs3PxYaeTr7oO7Sa3+NYASe9
         ztWFMuXVp9fKKcaLxyP2YfzFmVN6uqUAMjEQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tOvjbpyRsbuPWsomBHKEhFntlFsBYkZHEyyX+xGS5QQ=;
        b=Cs6qJ63/majOHd9Sn3g6nZgNAKnJZ0uMOTvm3tyupGovj1uBWeOPdB8zp76QlAPalm
         TISg0q5ilqNX8xjk3fDwONDkUMpJMpETLdkVUjPWl5f7JGjP86p+JObm+s0mCnv8075h
         eZ1q8cxJb/g2lDsMroOryEgimsb2VbW2iwdsOBVoAsuhNUS0AZjztX35eHQpU2FonXZ5
         gCWyOfjeU9y3Z9FAj9ME2yJp62YMS1Ct6pSYUaQvIlH/J6bzVcS2SRjCvKs/aNKrl4Dh
         ivcaNzj8NmxKQMcIwFhSkUQbgXXDlz09clypBmO8NpSml6Pd2zCaZg3GNVT/erfE4wT9
         VwyA==
X-Gm-Message-State: ABuFfogifJqIUAjBOQIaLDoLEo2TEmaNgA5JLIcMAsZUKrk0dUO7uYXO
        49QTMMO9oraQhjE89lJazZck8A==
X-Google-Smtp-Source: ACcGV636T8rgHZXKPx3yLm7H8V4lIl+E7W0FvbdhAc1M7wUaDYMi66v7SX/QXmMKjKDUf7xopXFazQ==
X-Received: by 2002:a62:b09:: with SMTP id t9-v6mr8341927pfi.36.1539392132798;
        Fri, 12 Oct 2018 17:55:32 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id n7-v6sm2766183pgv.63.2018.10.12.17.55.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 17:55:31 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Kalle Valo <kvalo@qca.qualcomm.com>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 3/4] ath10k: snoc: relax voltage requirements
Date:   Fri, 12 Oct 2018 17:55:03 -0700
Message-Id: <20181013005504.46399-3-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.331.ge82ca0e54c-goog
In-Reply-To: <20181013005504.46399-1-briannorris@chromium.org>
References: <20181013005504.46399-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I rarely see drivers specify precise voltage requirements like this, but
if we really have to...let's at least give a little wiggle room. Board
designs (and accompanying device trees) may not provide exactly the
voltage listed here, and we shouldn't fail to probe just because of
this.

Round these ranges down to the nearest volt, and provide a 0.05V margin.
The regulator should provide its own supported ranges, which will
helpfully intersect with these ranges.

I would just as well remove these ranges entirely, but if I understand
correctly, there's some reason that QCOM SoC's like to set zero /
non-zero voltages.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index b63ae8b006b4..5a8e87339df2 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -47,10 +47,10 @@ static char *const ce_name[] = {
 };
 
 static struct ath10k_vreg_info vreg_cfg[] = {
-	{NULL, "vdd-0.8-cx-mx", 800000, 800000, 0, 0, false},
-	{NULL, "vdd-1.8-xo", 1800000, 1800000, 0, 0, false},
-	{NULL, "vdd-1.3-rfa", 1304000, 1304000, 0, 0, false},
-	{NULL, "vdd-3.3-ch0", 3312000, 3312000, 0, 0, false},
+	{NULL, "vdd-0.8-cx-mx", 800000, 850000, 0, 0, false},
+	{NULL, "vdd-1.8-xo", 1800000, 1850000, 0, 0, false},
+	{NULL, "vdd-1.3-rfa", 1300000, 1350000, 0, 0, false},
+	{NULL, "vdd-3.3-ch0", 3300000, 3350000, 0, 0, false},
 };
 
 static struct ath10k_clk_info clk_cfg[] = {
-- 
2.19.1.331.ge82ca0e54c-goog

