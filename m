Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B876BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 14:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874BC20863
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 14:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOP9em5G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbfB0Owm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 09:52:42 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38641 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfB0Owm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 09:52:42 -0500
Received: by mail-yw1-f68.google.com with SMTP id o184so8274068ywo.5;
        Wed, 27 Feb 2019 06:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wwnyuv2OrFB8ni+eefpvorhS1IOuudyLxlyXqWEaiGg=;
        b=ZOP9em5G+X85wFTwcUve3RF3/mHK1EJ5khqoJwEBOX91+cnjU2GQ1FPHVeFV8rTPXb
         fXYYA77BRqHzByPkebU3gJvxvObWLgxCr+FyhWyvVdCYh9pv/7GJZvfz5tT4gIVDu2vP
         AJwpzl9YjOh6j86PXkrkjGyvDCaQJ5aczNz/wp8MqLQt7yh7pW/AYRWvAGfhTKLwTjJh
         nygN7BRvHb/eooYTYIz2q6l46oCD+RmbSsTnqeu1srtmx1GJo4x1b7DrA2JrhtpS+5Qg
         09/BTWzkbASTJyuD4RS5mbWg3INB4dMiry7D2mz0G6kSjh0R27fe0sqyKn7XF0FiNW97
         MKCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wwnyuv2OrFB8ni+eefpvorhS1IOuudyLxlyXqWEaiGg=;
        b=TX630OFmGdFlPBv4qlM+egOb0rxKK32iYcYKCjjl5Cf/6p8g7fWJ2tZz3sKR00CpQ7
         4mZqxGJDmirs1n0i//glYbvsBJdrHrcIo88NMwabNuj7BGgtkf6f//0+buCkdmGkq22J
         2KCwsiNg34KqgN4gzjlZbs8JdEueZGVKC8+0S1tS75YXEwAiuvpZL1gv/BSfpNWrpYrJ
         bIMsa+AfZSIJVRXL+/SxyOvpzQch3bFikTczWmLo+UF7XUBIScV/4fcTjnDP4QUrnKax
         lWwg4tnKYsVFBxxWzQmvxxog5EpylHoIlI0sy7FczRqeJLiaeH0Af7NH25xXq6/jMPQD
         CDlQ==
X-Gm-Message-State: AHQUAuaJ1RgR12wJjoU4LLnGOSKDskPCxktIi3uQJCEcSTXBJxAP5ac2
        fM6zbHkJ0WgR6ofPhxzvwDA=
X-Google-Smtp-Source: AHgI3IbxzJhMv5Q6NiJWDxuSvwgiFdcPkcxGMn+cwwm5oqfYLmTkT+H9a6k81fF2M0aQk09b++rnAw==
X-Received: by 2002:a25:257:: with SMTP id 84mr2328664ybc.276.1551279161419;
        Wed, 27 Feb 2019 06:52:41 -0800 (PST)
Received: from localhost.localdomain ([191.101.9.198])
        by smtp.gmail.com with ESMTPSA id z201sm5548456ywd.23.2019.02.27.06.52.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Feb 2019 06:52:40 -0800 (PST)
From:   Bo YU <tsu.yubo@gmail.com>
To:     adham.abozaeid@microchip.com, ajay.kathat@microchip.com,
        gregkh@linuxfoundation.org
Cc:     Bo YU <tsu.yubo@gmail.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        yuzibode@126.com
Subject: [PATCH V2] staging: wilc1000: fix incorrent type in initializer
Date:   Wed, 27 Feb 2019 09:52:36 -0500
Message-Id: <20190227145236.30324-1-tsu.yubo@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix sparse warning:

drivers/staging/wilc1000//host_interface.c:444:49: warning: incorrect type in initializer (different address spaces)
drivers/staging/wilc1000//host_interface.c:444:49:    expected struct cfg80211_bss_ies const *ies
drivers/staging/wilc1000//host_interface.c:444:49:    got struct cfg80211_bss_ies const [noderef] <asn:4> *ies

Signed-off-by: Bo YU <tsu.yubo@gmail.com>
---
V2: Adding cc wireless-list
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 20349af2ed30..4dd9a20f6a0b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -441,7 +441,7 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 	const u8 *tim_elm, *ssid_elm, *rates_ie, *supp_rates_ie;
 	const u8 *ht_ie, *wpa_ie, *wmm_ie, *rsn_ie;
 	int ret;
-	const struct cfg80211_bss_ies *ies = bss->ies;
+	const struct cfg80211_bss_ies *ies = rcu_dereference(bss->ies);
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param)
-- 
2.11.0

