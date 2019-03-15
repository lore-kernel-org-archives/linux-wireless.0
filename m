Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FDAC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 05:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17040218A1
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 05:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="UY/qewNh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfCOFTM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 01:19:12 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:35960 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfCOFTL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 01:19:11 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 4EB4C646
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 05:19:10 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id c1T_znEBtbkS for <linux-wireless@vger.kernel.org>;
        Fri, 15 Mar 2019 00:19:10 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 188141B5
        for <linux-wireless@vger.kernel.org>; Fri, 15 Mar 2019 00:19:10 -0500 (CDT)
Received: by mail-io1-f71.google.com with SMTP id r21so6060650iod.12
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2019 22:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=j6U+y4iY6osT5hFspHyeI/vwu/lDKXRQlpMa/rD0jqM=;
        b=UY/qewNhGz4utE7ET1BCB4W5qFAv9i/7Ym8Kw+LRwCcnUAtGFZTsGqLboUPZBk3zD8
         NzSeeYN8KEk/a0aSTPHEL9yECaerc0sxDJZDOLOc3fkbyvsBKOVloEOZgzmW8XVxxF5v
         SxLGn0+J1zW1vvhFzzDTTSX+8ODPg7h2a570FG4+VGRpt1x6jYG3scXOdf6bsQWCi5yn
         WwcQkgsks/blMfe1pJmvEbKkdOW2IaV8ShnxizXFJHDv62UsiocKDmjLIcMJ1yk1DLKV
         oFMGRSVE+urfcFRcsjt40/Wa7qBBRPTVmrzRVGEBBD4xvAfrR1kWDUrpd28a/4q3yFem
         Gqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j6U+y4iY6osT5hFspHyeI/vwu/lDKXRQlpMa/rD0jqM=;
        b=I8MFFy1BuWNR+zmKtZkQhWoFDB3MMnF0Y/4AqtiQxgPsoU42e0XeWNRDfdFbpMN/B0
         gyipyntuWJqHIREookz6XOq0otcylWGoF78xye4c5CCg1OQtcnhvjjpBTL0ofYNyQW79
         UTFBDr/nMUeJmIswiTAYGSWf6km1v/AzO42JAO0Neus3X4vgSE3Dp6wNUIrZS1amaQ7p
         5sFrzRbp1nDUsKPhlXuphkka0VWqWUv9BGpkIDyo76mM0kCWVon+ot0K3TZiXLgqdyX7
         +/fp5vM8jWGiVqAeATcTRTIFvJOGKS/lxEOfgXwpx+zM8b4m++Mf8cNFGw+rXLwZg/GD
         32Ew==
X-Gm-Message-State: APjAAAVZmjLzf+BausGWaNdwAKtRIlAG8USUv0mJ+VLEmEDRijswshgt
        YJmxlUcplgOghWPWLomvrLuf/t2Q0GhTSjNyoJTyVPBLMBjxbK8bR1Yqm2rl/1bSrwjAcw5PFqO
        u34qJtmhzLVN2tN4cQHxXEvdvy977aC0=
X-Received: by 2002:a24:418c:: with SMTP id b12mr841782itd.74.1552627149662;
        Thu, 14 Mar 2019 22:19:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxNQimi15aoZT/w9cz7ZwWP0xM9MwZMlkkoQWsF9RX+9EIVw1Okv1h5KXV753E2PkvarZnfgQ==
X-Received: by 2002:a24:418c:: with SMTP id b12mr841772itd.74.1552627149389;
        Thu, 14 Mar 2019 22:19:09 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id l134sm530985itb.12.2019.03.14.22.19.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 22:19:08 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ath: fix missing checks for bmi reads and writes
Date:   Fri, 15 Mar 2019 00:19:03 -0500
Message-Id: <20190315051903.10664-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ath10k_bmi_write32 and ath10k_bmi_read32 can fail. The fix
checks their statuses to avoid potential undefined behaviors.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/ath/ath10k/core.c | 40 ++++++++++++++++++++------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 835b8de92d55..1bb586f0040e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -629,13 +629,20 @@ static void ath10k_send_suspend_complete(struct ath10k *ar)
 	complete(&ar->target_suspend);
 }
 
-static void ath10k_init_sdio(struct ath10k *ar)
+static int ath10k_init_sdio(struct ath10k *ar)
 {
+	int ret;
 	u32 param = 0;
 
-	ath10k_bmi_write32(ar, hi_mbox_io_block_sz, 256);
-	ath10k_bmi_write32(ar, hi_mbox_isr_yield_limit, 99);
-	ath10k_bmi_read32(ar, hi_acs_flags, &param);
+	ret = ath10k_bmi_write32(ar, hi_mbox_io_block_sz, 256);
+	if (ret)
+		return ret;
+	ret = ath10k_bmi_write32(ar, hi_mbox_isr_yield_limit, 99);
+	if (ret)
+		return ret;
+	ret = ath10k_bmi_read32(ar, hi_acs_flags, &param);
+	if (ret)
+		return ret;
 
 	/* Data transfer is not initiated, when reduced Tx completion
 	 * is used for SDIO. disable it until fixed
@@ -647,14 +654,22 @@ static void ath10k_init_sdio(struct ath10k *ar)
 	 */
 	param &= ~HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
 	param |= HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET;
-	ath10k_bmi_write32(ar, hi_acs_flags, param);
+	ret = ath10k_bmi_write32(ar, hi_acs_flags, param);
+	if (ret)
+		return ret;
 
 	/* Explicitly set fwlog prints to zero as target may turn it on
 	 * based on scratch registers.
 	 */
-	ath10k_bmi_read32(ar, hi_option_flag, &param);
+	ret = ath10k_bmi_read32(ar, hi_option_flag, &param);
+	if (ret)
+		return ret;
 	param |= HI_OPTION_DISABLE_DBGLOG;
-	ath10k_bmi_write32(ar, hi_option_flag, param);
+	ret = ath10k_bmi_write32(ar, hi_option_flag, param);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 static int ath10k_init_configure_target(struct ath10k *ar)
@@ -2500,8 +2515,15 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		if (status)
 			goto err;
 
-		if (ar->hif.bus == ATH10K_BUS_SDIO)
-			ath10k_init_sdio(ar);
+		if (ar->hif.bus == ATH10K_BUS_SDIO) {
+			status = ath10k_init_sdio(ar);
+			if (status) {
+				ath10k_err(ar,
+					   "could not init HTC (%d)\n",
+					   status);
+				goto err;
+			}
+		}
 	}
 
 	ar->htc.htc_ops.target_send_suspend_complete =
-- 
2.17.1

