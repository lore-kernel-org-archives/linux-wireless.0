Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3A0C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 18:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0275821019
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 18:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="nFNtfzBY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfCMSml (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 14:42:41 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:48850 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfCMSmk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 14:42:40 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 616CAC9B
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 18:42:39 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id E736aHhPtLAI for <linux-wireless@vger.kernel.org>;
        Wed, 13 Mar 2019 13:42:39 -0500 (CDT)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 374BDA31
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 13:42:39 -0500 (CDT)
Received: by mail-it1-f200.google.com with SMTP id 190so2340965itv.3
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 11:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8ghsiZfNwLC/j1f+xgqjTbC5IFJtUmxVAyN34aNAvZA=;
        b=nFNtfzBYSEGJx5paxTIeBAd5YBmmR/u4g7BXmj8U2O/gSPrsXt4U9vJtAe2py/nZwL
         b+1x/U+qkcjU+LI5zKE9bmKj4+fNLtvO/7GMTmjkWLkyNop70Cs6Tru/dz19V+LjjqHy
         gDU1LMMxoggxRmPMiFgkHOYzk7iPa3DU0BpWqE1Qq6+X3ZJsMvXPwpGFkvaoxnHbr8Ij
         Acm/EmyfwbxxXaYJn8y16vfQTgdK5ovhfxTu1MFlJqmb/HdTP6nNNk/QdHYcZM9SNckU
         9t9pjfip6n/olwWyt6bOAdkVJNaVO8lb7ZKdHvYVodzYJ6sIsVMXlVo/pF8+uATqErDX
         JAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8ghsiZfNwLC/j1f+xgqjTbC5IFJtUmxVAyN34aNAvZA=;
        b=rbd+9hIqIllxhntZz+qQf8coqkaAeNfTT9m9wJqOJOw0yY9pVASG/A2NIeNud2tw9S
         zNfypEATKvTDstY4o58CuXW0a0w33qLluJ1ai7jqgGv433oW04tP6Mvpx5LsL5dVrx0h
         5N96ZZNjcjO+poN414erACgliEemtQC6MTSyrHDOYg+oUdttkTFqk0qI4bRmJwh4++Ea
         vl3JlTzI7thfwH0qrUxmoHYfTsmwzOce0xpOmQQXR0hjY3xRMoyvfwF5eeCgF6D0BXzB
         UKdW4YAjhPwZrZRXXNCVpDK30cjFZvMCTeZf7lPGUdkpVJrInyc/GXJfNacE1ZiwnsDp
         F4/w==
X-Gm-Message-State: APjAAAXq7FC8hxJqzhAgOfl7LD9kPyTIBWuc5UvmuJxMLL2/bce2bO+c
        DHdKHZJl88vGwqchTsJkW37J3aYpBkE7GPbHe+YTSjDgL+gMUrddf+Mg3TP8kXv47vTCDmmp7HK
        GuDvW9/a8stn6aYJ9YJ6yr4yfLjOtJCU=
X-Received: by 2002:a24:5c43:: with SMTP id q64mr2673747itb.75.1552502558801;
        Wed, 13 Mar 2019 11:42:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyt9UzYS4kbMOZoPbgo08PkW3VVK+QnvLOMbz3oC2BTWpqMRRwMJkpz/0Qk36jIBBpUHGaylw==
X-Received: by 2002:a24:5c43:: with SMTP id q64mr2673730itb.75.1552502558576;
        Wed, 13 Mar 2019 11:42:38 -0700 (PDT)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id z25sm690067ioh.43.2019.03.13.11.42.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 11:42:38 -0700 (PDT)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: Fix potential NULL pointer dereference
Date:   Wed, 13 Mar 2019 13:42:29 -0500
Message-Id: <20190313184229.24780-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

dev_alloc_skb can fail and return a NULL pointer. The patch avoids
a potential NULL pointer dereference and returns -ENOMEM.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 60db2b969e20..4e2fa972a78a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -341,6 +341,9 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		sleep_cfm_tmp =
 			dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)
 				      + MWIFIEX_TYPE_LEN);
+		if (!sleep_cfm_tmp)
+			return -ENOMEM;
+
 		skb_put(sleep_cfm_tmp, sizeof(struct mwifiex_opt_sleep_confirm)
 			+ MWIFIEX_TYPE_LEN);
 		put_unaligned_le32(MWIFIEX_USB_TYPE_CMD, sleep_cfm_tmp->data);
-- 
2.17.1

