Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BCEECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 15:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB2FB20825
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 15:08:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmuJ718t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB2FB20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbeKIAol (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:44:41 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40217 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbeKIAok (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 19:44:40 -0500
Received: by mail-lj1-f195.google.com with SMTP id t22-v6so18274835lji.7;
        Thu, 08 Nov 2018 07:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SiXJmd6iqauJXvTd/x52sY1hIyHlva06WaSL0c4yeuY=;
        b=UmuJ718thROvy+tyO6ssIquMZTkhJwcO6hnE3KMjTf89JrKquK6p1GarWoYggatrzF
         nzRQtGwAZRi7Miylh3CP6ZDfWjbaGlmUCZVybfzULTjKIMYmjNxuJRvRii4Jho503Yfh
         nulq1DVgDzhNoxsQkfe8bSCTi0nHrVJHpKoueedJ6jeVyDynZ1JgkLb6iD3n4RALnI6F
         qDmmNFXVk0cAVDjnWrhyMlC4L7I7L7zBN7G+ZtFijiKaLY1fNCkVBcfhr8cyT1iTU7zy
         5n2LY3LUIEsEj/+jg5UsL6NE4wqwFZaNomovzkDHr2GbGJQsr8tzq4Vm04oBD6xY+Yyb
         i7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SiXJmd6iqauJXvTd/x52sY1hIyHlva06WaSL0c4yeuY=;
        b=CizurscyU39UafA8FQ2cyWidt5jO8dGcYI/pBJ1wdnw84prd7Z1ysGiDiGN03qoOp9
         miLt9UGeU0BFf3lpiQc/XNslh3bnU0QPhusr/WWUpsy6HIQetftFJUfCCP76eqzf0i2y
         piefE/J8mDGJkJhR5p7g82l+XYs6oomGWxYQuUkGvaLkPHFV3z97jKUJVTV3sRRugfFR
         +UuXMg4eUOnwU0+dS3csErk70dAQBo1idGHjkxZe0L/PU30/ZiuGZEPmwT3D1iVVOP+m
         cUdl+WuXVc/YZKtSvDjZuoUdlIoKAKZRiQkbAxLuvWzbHSpjGPfTsc92g9hvi+wCUBCC
         TPDA==
X-Gm-Message-State: AGRZ1gJF9Y7HniXwnl9mSTEcOtTNOuP9Hn6bQ6/mT5YR3KHwlPId9hwn
        t5XAC6BhQlKEit0tDyH7erw=
X-Google-Smtp-Source: AJdET5eHK7PfPhmsStvVyiTAVDQbcSLBz1Ozpk1fNtodYdMBTAYuK2fVY7DXQ3skPGmjENHH1UAraQ==
X-Received: by 2002:a2e:9dd0:: with SMTP id x16-v6mr3031657ljj.164.1541689723052;
        Thu, 08 Nov 2018 07:08:43 -0800 (PST)
Received: from linux-veee.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id w193sm719820lff.24.2018.11.08.07.08.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 08 Nov 2018 07:08:42 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        stable@vger.kernel.org
Subject: [PATCH FIX] brcmfmac: fix reporting support for 160 MHz channels
Date:   Thu,  8 Nov 2018 16:08:29 +0100
Message-Id: <20181108150829.24842-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.13.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Driver can report IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ so it's
important to provide valid & complete info about supported bands for
each channel. By default no support for 160 MHz should be assumed unless
firmware reports it for a given channel later.

This fixes info passed to the userspace. Without that change userspace
could try to use invalid channel and fail to start an interface.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 230a378c26fc..7f0a5bade70a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6005,7 +6005,8 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 			 * for subsequent chanspecs.
 			 */
 			channel->flags = IEEE80211_CHAN_NO_HT40 |
-					 IEEE80211_CHAN_NO_80MHZ;
+					 IEEE80211_CHAN_NO_80MHZ |
+					 IEEE80211_CHAN_NO_160MHZ;
 			ch.bw = BRCMU_CHAN_BW_20;
 			cfg->d11inf.encchspec(&ch);
 			chaninfo = ch.chspec;
-- 
2.13.7

