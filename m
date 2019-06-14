Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10231C31E44
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 07:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFB292133D
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 07:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B9BPcDse"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFNHMC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 03:12:02 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34344 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfFNHMC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 03:12:02 -0400
Received: by mail-pg1-f194.google.com with SMTP id p10so1032704pgn.1;
        Fri, 14 Jun 2019 00:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Z24ehB4D4Ib9KAp40EZZmlh/Bvx/EOYlNXp8ka69OO8=;
        b=B9BPcDseXlrG3ycjZwkqgwkcR4nbLzBIh5VosFrf0JeTSEKLiWEH6adqv8bIWjlg4W
         BZ/ZOqF/A/WYbvWb9vmh7V/loVsJqBxoEIuQJweLvcYV0fIC4vlQ7lqYh3yxthPbgr2u
         CNHzecQBxrBeIfgbc8ho7f7yZsrmweoLIveR4N3U2Yil8uZ4FE3XSSXjXYKBWBFuYn7o
         PHQR8MyXRWvpnBsJhGbmXFj8ARsLEMGcjU2gmzLgPiBRvFrrWstDIaXjnW3gIG5E6kRG
         grEUr886Mf21+FzGVkzxd2/v6C+saav0KjRjDR2PrUB29ZETxp+0Q3jgxtGQWB7IslDt
         NP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z24ehB4D4Ib9KAp40EZZmlh/Bvx/EOYlNXp8ka69OO8=;
        b=s8ahWKl+/lZpJFOUZpYoO2JWInshv2JYd7mA68ep6Hrf+calmT7qRiOFRwbUlAa6Q4
         to8YVV+lv8dLZQ9Ca3hFZwo1fil9Ep66SLYsmBVWCzOIFyC3YSH6/Pv1SVbdAup87qOR
         VYD/YPSGiFCxXsPXwP4wgeXtMdiPT56Eu2102vigyBG6hndaT128wHeJFnprDq75PHJ7
         sQxnQvMdQJT9lGFqn1b82azAz8anXG7huqIHwzgw/QXK1e83FFwFJfC+NXIFo2/dhYiD
         UJtbyzT5QFS3e1redzf3+JVfNNOxf5JV1PL1wpNVD5AxBPWGhD/lywOeAtfLBq8Ha3Xd
         LBCw==
X-Gm-Message-State: APjAAAUj2aPYrrfAAlSYPcZr9g8kW/mI6aiPsGfWBk3XbKGXOEv81j9D
        buJT/F4jVGqnGgSJJ20j1Qo=
X-Google-Smtp-Source: APXvYqzts64d3r5DidYI4YK6nxHWTCr4iviOKRGBsvDDVRUCcUr1GO2l5XgET6/yAn2cJC6dCRNUFw==
X-Received: by 2002:a63:3148:: with SMTP id x69mr19476839pgx.226.1560496321289;
        Fri, 14 Jun 2019 00:12:01 -0700 (PDT)
Received: from xy-data.openstacklocal ([159.138.22.150])
        by smtp.gmail.com with ESMTPSA id p68sm1634074pfb.80.2019.06.14.00.11.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Jun 2019 00:12:00 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     sameo@linux.intel.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] nfc: Ensure presence of required attributes in the deactivate_target handler
Date:   Fri, 14 Jun 2019 15:13:02 +0800
Message-Id: <1560496382-32532-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Check that the NFC_ATTR_TARGET_INDEX attributes (in addition to
NFC_ATTR_DEVICE_INDEX) are provided by the netlink client prior to
accessing them. This prevents potential unhandled NULL pointer dereference
exceptions which can be triggered by malicious user-mode programs,
if they omit one or both of these attributes.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 net/nfc/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 04a8e47..89d885d 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -923,7 +923,8 @@ static int nfc_genl_deactivate_target(struct sk_buff *skb,
 	u32 device_idx, target_idx;
 	int rc;
 
-	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
+	    !info->attrs[NFC_ATTR_TARGET_INDEX])
 		return -EINVAL;
 
 	device_idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
-- 
2.7.4

