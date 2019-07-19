Return-Path: <SRS0=imzk=VQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B218CC76188
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Jul 2019 08:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B78C2084D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Jul 2019 08:10:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pKmSqnll"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfGSIKZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Jul 2019 04:10:25 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34827 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfGSIKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jul 2019 04:10:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id w24so15247854plp.2;
        Fri, 19 Jul 2019 01:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldCcok439XiSVa6AGYJGqO7cyqiS7oTbReHSOBCfvnE=;
        b=pKmSqnllu7Ylmp71SktjrAuLTPt/Aj9dQ3RdkOi6HrILRYK5FQEWnUxEwsal7uiuUt
         sdeihZFIaKfmiQowAovtE4yy2/iZD1YIHo653AcbDHg+tMPdGzmV9F/EtKKcOkWWVQvp
         ukuAov9z65TUw09OjxmfLyvKohabXmOwHHFlodDD1E7TZg/GmSVV54jEpYkI2gQpznWo
         9pkAtGAOVQbE8hxBQIXDgCetd2BYeNyMVKcXjd5xQ5U66hIh46Kb4fUWF3hi5MaPzEz4
         YbxtvbfRN7eoitHB7VCbl5lgLw5Lqy2n9dRxq970Mt5Mx6zlrUjhmtpCsUDaWztIIbX6
         8/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldCcok439XiSVa6AGYJGqO7cyqiS7oTbReHSOBCfvnE=;
        b=tYrv6lP7cElXKttdeQl+1nEwtOmMwEu+hA4Nv7dwUSoRaJ0TkHLXvJ0/Q6O2l6wDAx
         29LcVP7TB9UNEnscA4W5LLo9nKMppDioIpEPfD/MR3ezlUY9huVUTxNGKn/tW+3KZoz1
         U2WR2fepccmPqzO0n5lnm2PzUcDyoTiS5wpso9VAIoMKwQTDYuUvWAcgfsdVgy5PxZNy
         lUCtKs9iejRL2X6wDdaIxAWvLPea9ZAEQRoQ1xOI+Lz+MHRG/3lG0VnhLTr+FfPK6HmG
         V8oU2YzNhlVR6KqiTnOuOvOEZtGq6fE2YQID9sEoe3xO+KkQ0OM2+u2u0IcKDviv765s
         rNpw==
X-Gm-Message-State: APjAAAVXyVFOSqOfEXG27kaqkMfjFZkmFGbbIqqDEqtbDkb8RVk6ujVN
        Uznk2psJVvr9VGLgjBxkS84=
X-Google-Smtp-Source: APXvYqykkOF8/von8g5LZdSGDNFmG9Aj6nytf+VL5Z4Vd9CSBfS89tB/QwlOHkxkf1zeWyOnvoV88w==
X-Received: by 2002:a17:902:20ec:: with SMTP id v41mr52314648plg.142.1563523823694;
        Fri, 19 Jul 2019 01:10:23 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id 33sm35849261pgy.22.2019.07.19.01.10.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 01:10:23 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] staging: wilc1000: Merge memcpy + le32_to_cpus to get_unaligned_le32
Date:   Fri, 19 Jul 2019 16:10:06 +0800
Message-Id: <20190719081005.4598-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Merge the combo use of memcpy and le32_to_cpus.
Use get_unaligned_le32 instead.
This simplifies the code.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d72fdd333050..12fb4add05ec 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1038,8 +1038,7 @@ void wilc_wfi_p2p_rx(struct wilc_vif *vif, u8 *buff, u32 size)
 	s32 freq;
 	__le16 fc;
 
-	memcpy(&header, (buff - HOST_HDR_OFFSET), HOST_HDR_OFFSET);
-	le32_to_cpus(&header);
+	header = get_unaligned_le32(buff - HOST_HDR_OFFSET);
 	pkt_offset = GET_PKT_OFFSET(header);
 
 	if (pkt_offset & IS_MANAGMEMENT_CALLBACK) {
-- 
2.20.1

