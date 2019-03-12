Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D95C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DD392077B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:11:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vgYQokSD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfCLTLs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:11:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39061 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfCLTLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 15:11:48 -0400
Received: by mail-wm1-f65.google.com with SMTP id t124so3781154wma.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 12:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9ZhcyreLFNn4Af8Igjvi3sN8B7hLYDUGoZdti6YAe8w=;
        b=vgYQokSDBysjGMs+FWwmQBt/UdUO9eBJq0EVP+2wPu3JA/VV5zni1Gh4RHcYGOTi5M
         GzkaRGHl7tRz4OJkIW8FLXYRBQNFmnbsYcloe3oIrvdgeHI63i3/GQxrxxeh5ec5sWE7
         i4W6NMUI5v8aw/fy9/xMQSKXL6aY5hoEJD0PBs40vvP71piUpX4xk/tND8JDYjC9bxUr
         OviabJwKG0EHWGfhCY85PLbNuTAonWvEvdOe9LlA6WKIR3LdDxk+f9hNCJ4G3Y9WQE4N
         5CQszwYSTQYUe24gqjMQ/L0VRmKMnPlGWEaIRivRKfWxGil9gundHafMBLFbIhH7YoTo
         vI1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9ZhcyreLFNn4Af8Igjvi3sN8B7hLYDUGoZdti6YAe8w=;
        b=nk0oX/toHCdAeVAKnsJjlI7ekPKDOMhvcAVkj0N8FHSB5ZBGs01lWjGZo87g2520Am
         2Eesa1+f+XT/vEQ+Np6++PufF2874SGyf1sRPHIM+b5g++b+LoELACvIF0P5SZjpp9nL
         cE51mlb830z78BiV1Niifbt+Sn2WISKb2rvX89h8L/eg6gWffNKIHaBgPWAHNQzm54Xh
         LMKR/42Nae86Wsyzn9uOZnqTWnS0/hhcf0OIpSthvqC9ctf+wvuzkcJyeVRfWwkQp2KS
         faHgzeh+87DefG2FQvoIbu0K6qU0i7i1FF9CsfFE+Ln57Mw/EIxPr2V/l6PLMCktt18V
         A6oA==
X-Gm-Message-State: APjAAAUEI4FFLW18gW67oa5BbCuCVrb4KS3dwQAtLd5ERF6udqyiGD2h
        IlKFMHB1uh/LMGJMEeEAhU/TcPAV
X-Google-Smtp-Source: APXvYqxf55CFst8fZT3CykDmMIuJ4DCN9Wkwa+fjdgh443BbGKXeHpSkIYx2QEC25NCeHExkxTat4A==
X-Received: by 2002:a1c:7903:: with SMTP id l3mr3718692wme.22.1552417906716;
        Tue, 12 Mar 2019 12:11:46 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id y140sm8469525wmd.18.2019.03.12.12.11.45
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 12 Mar 2019 12:11:46 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, sgruszka@redhat.com, daniel@makrotopia.org,
        =?UTF-8?q?Tomislav=20Po=B8ega?= <pozega.tomislav@gmail.com>
Subject: [PATCH 1/2] rt2x00: code-style fix in rt2800usb.c
Date:   Tue, 12 Mar 2019 20:11:41 +0100
Message-Id: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Tomislav Po¸ega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 19eabf1..091a607 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -562,13 +562,13 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 		 * stripped it from the frame. Signal this to mac80211.
 		 */
 		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
-        
+
 		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS) {
 			rxdesc->flags |= RX_FLAG_DECRYPTED;
 		} else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
 			/*
 			 * In order to check the Michael Mic, the packet must have
-			 * been decrypted.  Mac80211 doesnt check the MMIC failure 
+			 * been decrypted.  Mac80211 doesnt check the MMIC failure
 			 * flag to initiate MMIC countermeasures if the decoded flag
 			 * has not been set.
 			 */
-- 
1.7.0.4

