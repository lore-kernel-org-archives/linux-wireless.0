Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9443FC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 00:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 647872082F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 00:02:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gAGB4sY5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbfAPAC1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 19:02:27 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43904 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbfAPAC1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 19:02:27 -0500
Received: by mail-pf1-f193.google.com with SMTP id w73so2079189pfk.10
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 16:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Wpx9C3gke45794DvIebWUi/xcVR5MPYC13bd7BIljjQ=;
        b=gAGB4sY557ITsqI5hdDXSpBYVjXoZb+umGduj3ir4bigHTcRVES0RQY5wJQykgvyt6
         ztwuFAgTzmNqSu/h3lsv22jE1Yevl1qJGOn0/M17/aX+CSLrz+8xPyJwlmi8Y/wG9prE
         5uy9yJvA5xe3kWcAdYLuPqGdXHtZBcVFTUjlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Wpx9C3gke45794DvIebWUi/xcVR5MPYC13bd7BIljjQ=;
        b=XfoZ6t3JNtrqJEx+MSsawSlM4ZbsMlahcPtsCwGnYS3yzjnLDOtrWqlRlsaiXHimYh
         7Y8v8SjtghDBJd+q7wzEDn36t5dAB6dAir+ocgWz/uyLVBJ7dgUTTK8ubz+TY5NYLoOT
         IXWFPfyF6J46qkBFWlKVOc03yeb0wE2zgQpX/+7BY8K6hQiuK3qW218QmvGjpTu69Ew9
         4O+Da/Lx/lFXpwvfRsHEqS//7nHCR2KZKyHRCwc7z0Q+KkJA7QbOqWVGyqJ2zQA/zxt/
         qE0KCXofbV4lo7H4c6r66VHAK8fVrv+zKIgEfTaNplQHWbRmSAekW4G0SjNw6/3Vhr+J
         pDWw==
X-Gm-Message-State: AJcUukepZqm3yytuTq1aQcDgdS7WApDq90sCQ6vcym85/ezq5UNlDJ74
        9DoZ1Lo8Z/KTQuGwZJ2Qkzl3sQNs+jI=
X-Google-Smtp-Source: ALg8bN4SNztm9LZ9b68UE8lDQrOuELR2eroVNKed5aV6Sm5OoMSl1m0HDJrlgJ2R/Nuqb8PmrTaWcw==
X-Received: by 2002:a62:d2c1:: with SMTP id c184mr6764582pfg.248.1547596946273;
        Tue, 15 Jan 2019 16:02:26 -0800 (PST)
Received: from www.outflux.net (173-164-112-133-Oregon.hfc.comcastbusiness.net. [173.164.112.133])
        by smtp.gmail.com with ESMTPSA id z62sm8536957pfi.4.2019.01.15.16.02.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 16:02:25 -0800 (PST)
Date:   Tue, 15 Jan 2019 16:02:23 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Willy Tarreau <w@1wt.eu>, Silvio Cesare <silvio.cesare@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k/eeprom: Use scnprintf instead of snprintf
Message-ID: <20190116000223.GA29196@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Change snprintf to scnprintf. There are generally two cases where using
snprintf causes problems.

1) Uses of size += snprintf(buf, SIZE - size, fmt, ...)  In this case,
if snprintf would have written more characters than what the buffer
size (SIZE) is, then size will end up larger than SIZE. In later uses
of snprintf, SIZE - size will result in a negative number, leading to
problems. Note that size might already be too large by using size =
snprintf before the code reaches a case of size += snprintf.

2) If size is ultimately used as a length parameter for a copy back to
user space, then it will potentially allow for a buffer overflow and
information disclosure when size is greater than SIZE. When the size is
used to index the buffer directly, we can have memory corruption. This
also means when size = snprintf... is used, it may also cause problems
since size may become large. Copying to userspace is mitigated by the
HARDENED_USERCOPY kernel configuration.

The solution to these issues is to use scnprintf which returns the number
of characters actually written to the buffer, so the size variable will
never exceed SIZE.

Cc: Willy Tarreau <w@1wt.eu>
Cc: Silvio Cesare <silvio.cesare@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index f019a20e5a1f..2b29bf4730f6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3457,9 +3457,9 @@ static u32 ar9003_dump_cal_data(struct ath_hw *ah, char *buf, u32 len, u32 size,
 		if (!((pBase->txrxMask >> i) & 1))
 			continue;
 
-		len += snprintf(buf + len, size - len, "Chain %d\n", i);
+		len += scnprintf(buf + len, size - len, "Chain %d\n", i);
 
-		len += snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 			"Freq\t ref\tvolt\ttemp\tnf_cal\tnf_pow\trx_temp\n");
 
 		for (j = 0; j < cal_pier_nr; j++) {
@@ -3471,10 +3471,10 @@ static u32 ar9003_dump_cal_data(struct ath_hw *ah, char *buf, u32 len, u32 size,
 				freq = 4800 + eep->calFreqPier5G[j] * 5;
 			}
 
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 				"%d\t", freq);
 
-			len += snprintf(buf + len, size - len,
+			len += scnprintf(buf + len, size - len,
 				"%d\t%d\t%d\t%d\t%d\t%d\n",
 				cal_pier->refPower,
 				cal_pier->voltMeas,
@@ -3505,12 +3505,12 @@ static u32 ath9k_hw_ar9003_dump_eeprom(struct ath_hw *ah, bool dump_base_hdr,
 		len += scnprintf(buf + len, size - len, "Calibration data\n");
 		len = ar9003_dump_cal_data(ah, buf, len, size, true);
 
-		len +=  snprintf(buf + len, size - len,
+		len += scnprintf(buf + len, size - len,
 				 "%20s :\n", "5GHz modal Header");
 		len = ar9003_dump_modal_eeprom(buf, len, size,
 						&eep->modalHeader5G);
 
-		len += snprintf(buf + len, size - len, "Calibration data\n");
+		len += scnprintf(buf + len, size - len, "Calibration data\n");
 		len = ar9003_dump_cal_data(ah, buf, len, size, false);
 
 		goto out;
-- 
2.17.1


-- 
Kees Cook
