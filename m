Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20EEC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91E8D20651
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 13:11:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvTTcHuJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfBZNLz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 08:11:55 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37330 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfBZNLy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 08:11:54 -0500
Received: by mail-lf1-f66.google.com with SMTP id z196so8891208lff.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2019 05:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G1lai5VnnRFsoDItP10QXAVc95UUnO+V7zvJK9V43dI=;
        b=JvTTcHuJFwh2ZwW0cVQxVDfeuD77xTt6kc3xDA9gX9BD+YDu7TZbV6tGnD29eURDRM
         lq/+hZCpvHaOW9m3PCpo7/NZxED7oyBwvmN/pfIQss4GUyrWYzN0CDfZCxcnImCo7K+y
         feGq3t5dxn55wgbKAEv4eYLfaINUyrpLl0bxuw3Y/jMh/ujbn9XdtBL+C2SHXboOPscP
         n0yxyL2HvUTi1MBxIVPykM2QKfOhZMD6Jcmk0il4IxeyOlmmt+ss27QXtP/oqpgIGkBq
         2rm1boVO6iryIEVp0+5WjBnUipXq3IPg9qoeWBu6quzN3VBajMkGOTmQ5xy0GshAhAUP
         6ghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1lai5VnnRFsoDItP10QXAVc95UUnO+V7zvJK9V43dI=;
        b=OyRSohMTuzTbVaDMv9g66Cr1etmXhEn4T6xPXVMhFmuG1He8thB1DYElmN2cM+meAT
         w4mTTHwghoH2VgWu6djFv1QldoFXplt7jyKrJ4599loeJEOqEa0cDGcyojvR5mBQrlLC
         UswvLG5wpi5OJUEza1iAX+/qhRjcV9ujDLXN6ouQoxLQCbekDPNs+o7BonOmv7o36ijc
         Qm3BiQX4uPZHw2KIolPCV7CAg+kNM9YpFYmfda9Uf4Kil7OS37sXT+rokVzEIINBhzcv
         3QBFFkPwXL9KnX/kU8lS4bxZoAl2FnM7TQ14EnquGdleLFwB6X0sQutu2wcrFe2gcfRN
         BlIw==
X-Gm-Message-State: AHQUAubcatMVWNCkCl2QlRDrYZmPiTGuojK/SJ/1ktuBfq4BZxQJQQhc
        7w4LAARar+nmXZuRSDgPlVo=
X-Google-Smtp-Source: AHgI3IZQGdQ3f2yGvMY1/MHoxqomZUEEy/Ztvos9nJvt/uGIZy2zupbM+rMKyZq8ov2Nr8ckHJ8a7w==
X-Received: by 2002:ac2:555d:: with SMTP id l29mr13301420lfk.38.1551186711812;
        Tue, 26 Feb 2019 05:11:51 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f16-v6sm2952518lji.88.2019.02.26.05.11.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 05:11:51 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/4] brcmfmac: support repeated brcmf_fw_alloc_request() calls
Date:   Tue, 26 Feb 2019 14:11:16 +0100
Message-Id: <20190226131119.7907-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190226131119.7907-1-zajec5@gmail.com>
References: <20190226131119.7907-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

During a normal brcmfmac lifetime brcmf_fw_alloc_request() is called
once only during the probe. It's safe to assume provided array is clear.

Further brcmfmac improvements may require calling it multiple times
though. This patch allows it by fixing invalid firmware paths like:
brcm/brcmfmac4366c-pcie.binbrcm/brcmfmac4366c-pcie.bin

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 8209a42dea72..65098a02e1ad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -743,6 +743,7 @@ brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 
 	for (j = 0; j < n_fwnames; j++) {
 		fwreq->items[j].path = fwnames[j].path;
+		fwnames[j].path[0] = '\0';
 		/* check if firmware path is provided by module parameter */
 		if (brcmf_mp_global.firmware_path[0] != '\0') {
 			strlcpy(fwnames[j].path, mp_path,
-- 
2.20.1

