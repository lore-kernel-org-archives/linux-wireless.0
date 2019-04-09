Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60122C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EEDC2084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rAnTJJIU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfDITNP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 15:13:15 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36100 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfDITNO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 15:13:14 -0400
Received: by mail-lj1-f193.google.com with SMTP id r24so3765698ljg.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 12:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3jf7/3Wcpi0foIcFTrOIi7geeJuAbQU85kMpO8kay/o=;
        b=rAnTJJIUQ9lxjUTBnu3mbOvLRNJ7une05H3PUjGOLeXnVdcW091vW6AEz13kU64D5n
         C3TFZZjuGMazpeB65t9DE4htgAFSrQczvyG3PtRGF67jzpo0OJkFsMh+lASn2P6dhH1G
         s2gIyq8VG7CEPc6I6GOHc2NT5kPl+41INmdid/KcaM7llEHooQ7enZlJI13uiqGdaJGb
         4Ao8868JjNZPk4p01BEv0a5VB/KErYMF53i2F1M0bYSRf8vhEQ68VRaDlmntl7p52rqC
         OT3/RCj3NO71fUSycwNwJRomD9MFjAzhlZoXZWFNT/b4aMI8hHGFWbFidDQIBvRq2Xpc
         2AGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3jf7/3Wcpi0foIcFTrOIi7geeJuAbQU85kMpO8kay/o=;
        b=XoSJnggwhUMhGcyrXXSfhDc1hBpqKPFGgA6UQHfIVhpUvSio7VGE8IHLyGIxfymkdA
         s6rdLaXWB/6bcM8e7K1uk0s0OvyYokP7cE5v4VXJ0wRFfZkiwfBHcMpSyd0kwPaYXiXQ
         KZ1tv/QUmjsXNzdDfkQHh0bNt1wZPkiqhrx3p6+8AXRNzTP4WBPj+61e8mBdY2DS4u/a
         RtuZNQeaFQj8AyBV6ZuWSrB6zgLQmtrm+zjnWzGbOkN7fWMK8aYletHGMo/p/S9ZOLOH
         04EqFLvWK4rizaXO0o/OJ0mhIXOHcZiQuKZCIXqyy+TCLUr3mI31Vu+9SOxzMD1qoKYg
         ojvQ==
X-Gm-Message-State: APjAAAXejOF1N7Phl9bDJUZTEVUeGR33gu0LqUc5zFaGIO1R9L2GHDvE
        Me6FnNokoVAl8wtZJ3duvpmCpBky
X-Google-Smtp-Source: APXvYqzseMVHi/zp2dLhKoFEYoelUgs68BX8p1VKuSrL/qFlGOzWDIE/FmiHVhECZY05srrr6gZpQw==
X-Received: by 2002:a2e:2e04:: with SMTP id u4mr11410205lju.37.1554837192057;
        Tue, 09 Apr 2019 12:13:12 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id q64sm6807848ljq.76.2019.04.09.12.13.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 12:13:11 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 5/6] ath10k: sdio: add missing error check
Date:   Tue,  9 Apr 2019 21:08:50 +0200
Message-Id: <20190409190851.4557-6-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190409190851.4557-1-erik.stromdahl@gmail.com>
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Although not likely, the bundle allocation might fail.
Add proper error check and warning print.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 295e1e7ec3b0..3eb241cb8a25 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -586,6 +586,11 @@ static int ath10k_sdio_mbox_rx_alloc(struct ath10k *ar,
 								act_len,
 								&bndl_cnt);
 
+			if (ret) {
+				ath10k_warn(ar, "alloc_bundle error %d\n", ret);
+				goto err;
+			}
+
 			n_lookaheads += bndl_cnt;
 			i += bndl_cnt;
 			/*Next buffer will be the last in the bundle */
-- 
2.19.1

