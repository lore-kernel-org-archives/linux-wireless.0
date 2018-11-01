Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67957C6786F
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BCAB2081B
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tw7EaPec"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2BCAB2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbeKBAgz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:36:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45900 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbeKBAgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 20:36:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id v5-v6so4603554pfm.12;
        Thu, 01 Nov 2018 08:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BNYxv/qYmo0S6AhlHULE0WXrirze8X6OKODaRiSASAc=;
        b=Tw7EaPecIUXbJlIHx8RqGelON9RSfUDcQs8JynCm9B0BBTubg+dbZPf06zycMvyj7Q
         Aymc1IMcbNxvEPWdkX5IHy7JSsoqbAqt8u1KpZm9MDM4yXaL09+TZA7CCqfvXiky5E4i
         aP0ljeaJm8SPag6aYwrljXHYCZvJ89bz8pFZFkJmQ1cwWCQdfNtCE+tannMMuWTOkr1r
         Xc/QOscmt0n5EYIBR4AawdWsZ9evC6H1uScFwZe+/uFymMYopTTHkaMIKCYTGeGrggfr
         gCwRNWvPOHDhiDWP/Bedsx0J6HqUbwNcHdfMJ4SbAd1Lk1QBWWE3nEw0F8XIbTn0UgFQ
         yTow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BNYxv/qYmo0S6AhlHULE0WXrirze8X6OKODaRiSASAc=;
        b=F6bGWYLp2AIu2r4vn8IoHsSVsc/tNL3V5c3K0RNL4bX/kHuW5iy5thUoPF5aBz4K29
         WHrcVrs91DtXPyuLuNYLHNjZKjLiBFxE4CNDGdYA7kwo57ZURzi31fv0/DT8PxH6/hzN
         KozmvLiBK7gRzVoGgexOOkiDFrYClq1IFtgCycrV7s8kcD8I46lypd2ilHGFT1cwSfYg
         1o3yfwVJ1NiMkrFYcH3o5CB1md5444evsbbrHR9TGNEdkNBrL1VbpXu2z3A74+WAEgvN
         1kWKCN3XX5VjTqSYhahCGbhpW53M07JIDg6I62SP7+kw4S69xjwmyhv3sBoqTp7AJGSX
         YFOQ==
X-Gm-Message-State: AGRZ1gIxz8+Fr/0iZ2NHKgrmHIj35458V5W3UWrDTFxYBXsjKzuVErAM
        dR9tzwcHKDAF6BvcE+SRZFw=
X-Google-Smtp-Source: AJdET5cmFdIbJ+eL0zuaP3hIVfDmdIszTCPlRaHaScIu9mdbt9SFWODxqYyWjwm/WP96KSQtIaaUhg==
X-Received: by 2002:a63:a35c:: with SMTP id v28mr7546861pgn.205.1541086407538;
        Thu, 01 Nov 2018 08:33:27 -0700 (PDT)
Received: from localhost (68.168.130.77.16clouds.com. [68.168.130.77])
        by smtp.gmail.com with ESMTPSA id x19-v6sm45698938pga.15.2018.11.01.08.33.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Nov 2018 08:33:26 -0700 (PDT)
From:   Yangtao Li <tiny.windzz@gmail.com>
To:     pizza@shaftnet.org, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] cw1200: fix small typo
Date:   Thu,  1 Nov 2018 11:33:19 -0400
Message-Id: <20181101153319.22830-1-tiny.windzz@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/net/wireless/st/cw1200/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 38678e9a0562..8dae92a79fe1 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -1123,7 +1123,7 @@ int cw1200_setup_mac(struct cw1200_common *priv)
 	 *
 	 * NOTE2: RSSI based reports have been switched to RCPI, since
 	 * FW has a bug and RSSI reported values are not stable,
-	 * what can leads to signal level oscilations in user-end applications
+	 * what can lead to signal level oscilations in user-end applications
 	 */
 	struct wsm_rcpi_rssi_threshold threshold = {
 		.rssiRcpiMode = WSM_RCPI_RSSI_THRESHOLD_ENABLE |
-- 
2.17.0

