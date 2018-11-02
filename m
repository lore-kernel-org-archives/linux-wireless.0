Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA36CC6786F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 18:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 889CA2084D
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 18:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JlUg71d7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 889CA2084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbeKCDSK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 23:18:10 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42239 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbeKCDSJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 23:18:09 -0400
Received: by mail-pg1-f193.google.com with SMTP id i4-v6so1306425pgq.9
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lat4TpCI71/3cxlaRQGsbFWbxSR9AgcpXz1+oAxrm0Y=;
        b=JlUg71d78M20dRhF3abONh16OyZZ6hGn10nWoVIYrTs+kloTHIlkB0hYXV8ABn8HUf
         +jxdSSL58CyFJwoxJNDmfezndYtMYuQAoS17Bi/8F+n7Z9ssA7Mgoq+VRO4OsowfNzBe
         oBh/WxW9lZxW8cx5gr9YNiUnao6X5xZCjb/mA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lat4TpCI71/3cxlaRQGsbFWbxSR9AgcpXz1+oAxrm0Y=;
        b=T+dc07ku4P/iJM0BottepQk0dniSSWfBpbqqlKcfSVaOwydAFF9S0JwFWN/kuaKpoI
         k0+OT/omhATdkaRtzNRFCw9MhgEAyjtz+WHk+svuZeT/5mmvNzkauWSYTEDKrfOD6eyp
         KRpgF8jBYcTXOuZnmAjvb5Zi6InSRY0cGysKIaBwy1G8MlU4fbnV9RgJxC40WJsJRv6R
         aD8VPZejZpSfVAwBzvZJAA6tCVdTAp86XWGsFc6MWLuxO+tuBL71oYpWat10UsXBC1xG
         LO2Ch5yrNBUB5Rfp8yP/3DvC+KmvbOB/dMh9c5ybblnftVTMPZSmtL2w7h7TQ8jFoQZV
         xkXg==
X-Gm-Message-State: AGRZ1gLY38pco+HNEA91Cos+woWrgY0M+7L/n+h5YEjeUNr1uLgUQ96z
        LMVRPIa2qW2KIs6DU9FCjSKs/Q==
X-Google-Smtp-Source: AJdET5ear+DAfnKHu+mWQJNUvZpDYVCwlDRtBn9YycyQ46lvtEQp7LcrAAuB20DtGnLzCei0Bm7/KA==
X-Received: by 2002:a63:4e41:: with SMTP id o1mr12084835pgl.282.1541182205540;
        Fri, 02 Nov 2018 11:10:05 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id y184sm2416357pgd.71.2018.11.02.11.10.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 11:10:03 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] ath10k: ath10k_snoc_{read,write}32() should be static
Date:   Fri,  2 Nov 2018 11:10:00 -0700
Message-Id: <20181102181000.96834-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.19.1.930.g4563a0d9d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

They're provided as callbacks in ath10k_hif_ops and should be accessed
that way, if needed outside of snoc.c, and anyway, they're currently
unused outside snoc.c.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 4 ++--
 drivers/net/wireless/ath/ath10k/snoc.h | 2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index ffdebf9a5ac6..5b37a0c68be6 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -474,14 +474,14 @@ static struct service_to_pipe target_service_to_ce_map_wlan[] = {
 	},
 };
 
-void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value)
+static void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 
 	iowrite32(value, ar_snoc->mem + offset);
 }
 
-u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset)
+static u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset)
 {
 	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
 	u32 val;
diff --git a/drivers/net/wireless/ath/ath10k/snoc.h b/drivers/net/wireless/ath/ath10k/snoc.h
index e1d2d6675556..de077bc8bc74 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.h
+++ b/drivers/net/wireless/ath/ath10k/snoc.h
@@ -91,8 +91,6 @@ static inline struct ath10k_snoc *ath10k_snoc_priv(struct ath10k *ar)
 	return (struct ath10k_snoc *)ar->drv_priv;
 }
 
-void ath10k_snoc_write32(struct ath10k *ar, u32 offset, u32 value);
-u32 ath10k_snoc_read32(struct ath10k *ar, u32 offset);
 int ath10k_snoc_fw_indication(struct ath10k *ar, u64 type);
 
 #endif /* _SNOC_H_ */
-- 
2.19.1.930.g4563a0d9d0-goog

