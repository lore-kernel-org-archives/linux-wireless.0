Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F263CC0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B646F2064C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 15:40:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pUlSxGyu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B646F2064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbeKBAn7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 20:43:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44825 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbeKBAn7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 20:43:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id s5-v6so7443868plq.11;
        Thu, 01 Nov 2018 08:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9RFP00laA7HyBvSrC18XR2I/wXaE2SWkQtly9nfFytA=;
        b=pUlSxGyum+XGuqzLzmFBZ8EoX05f76mu7b3uWKoF7UnxF+LX0iz/rbKviXAOu74HMT
         GhmKWg4byr48vDp4aDbfkAM+KrjjvIchfbXpf6l9jS217ZxhQAPR4lnrIdhei8o5E+Zr
         3mkenHbwyDBoiZaOtv8GLVgamNuNShphuYM1A80IyD9Mo2hX6xzvHIFecH5/+CApxyLS
         U4VhfniPktRR+3jYppYUojOTrZVMMMgE2fOch1c3iqd0idwAQQ7Qse6orxpf/1Ca7bve
         acO3nu/kyYF8XTd3aCG36tigs89cnxbGmK3Qoa0EzTNhs3vnE+Qde/w0yeaN69w6abD/
         v+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9RFP00laA7HyBvSrC18XR2I/wXaE2SWkQtly9nfFytA=;
        b=ewXVFwlShje/Us2wBaWNZRdPX5Cp5+/UMs2X7V0Y0iCYR1KsjvRBfOvbGuqn0Jq/ji
         va3ljjsfMIBCh5SK+OwHYUleHcqvScCZHJoQ/N6GYR3WCdEwHfrEhrXHwGadmvP3Rh73
         R4/sekSHXznVklFynnevPnrS9nArTNP5D7ZMooeFmlwRLIBpKdNaSTg6g0q/m00jD7gZ
         CCDd256zDHoqD0QjbfBerDbHfaw0URZMoGITugBuejCjf/lVSrsUOIuLZF3svKgtvlh2
         ronOaJbyxIZzMxBgpwZuiY7mepGYiN+dotB3lJV7yZ5fVR9s6AnNHM1JDe9VW7+JRctM
         etLQ==
X-Gm-Message-State: AGRZ1gIdKa07SKWil2P+9i8nsUNj38VppF2Z/BeksYtKI/CU4jEZNRmr
        QPDytIPyLRm8C8Ri/UJlLL8=
X-Google-Smtp-Source: AJdET5c1NljKsVW0GZOg5M6fy7s2IOn9MYI2THq004zNTNpybu4BU1UCp/SpQ/CdZaH3IUvgOPrg/g==
X-Received: by 2002:a17:902:107:: with SMTP id 7-v6mr8171914plb.267.1541086830169;
        Thu, 01 Nov 2018 08:40:30 -0700 (PDT)
Received: from localhost (68.168.130.77.16clouds.com. [68.168.130.77])
        by smtp.gmail.com with ESMTPSA id p64-v6sm30334789pfi.22.2018.11.01.08.40.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 01 Nov 2018 08:40:29 -0700 (PDT)
From:   Yangtao Li <tiny.windzz@gmail.com>
To:     sgruszka@redhat.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
Subject: [PATCH] iwlegacy: fix small typo
Date:   Thu,  1 Nov 2018 11:40:23 -0400
Message-Id: <20181101154023.22990-1-tiny.windzz@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-rs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-rs.c b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
index e8983c6a2b7b..a697edd46e7f 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
@@ -781,7 +781,7 @@ il3945_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 
 	switch (scale_action) {
 	case -1:
-		/* Decrese rate */
+		/* Decrease rate */
 		if (low != RATE_INVALID)
 			idx = low;
 		break;
-- 
2.17.0

