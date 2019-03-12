Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89812C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 05:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5868B214AF
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 05:31:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="SrhfHimQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfCLFbd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 01:31:33 -0400
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:54676 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfCLFbb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 01:31:31 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 6BB24A78
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 05:31:30 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FXUI-o-UJURO for <linux-wireless@vger.kernel.org>;
        Tue, 12 Mar 2019 00:31:30 -0500 (CDT)
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 3918DA63
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 00:31:30 -0500 (CDT)
Received: by mail-io1-f69.google.com with SMTP id e9so1002301iob.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 22:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qO/rCpuBodEkloMdIkUNCA/uOUm0aMljN4/zI/6ygLk=;
        b=SrhfHimQ6rI8W1KvqRKkj1iPyfKerOEX49LpaLKy8YT9JA83+BezmciiCb+G4DSSLJ
         B4FFPr6MB+Fb3M4319tqnEtnQDZ5APhSN2rm9dVWoyw/JKGuw7Xp1rkmAMCXaRE468qr
         Bv0LElc2aDdLZaBcpmBrbL2DOeHYrUsYBCecnyiKWip8SF4GKnbuUxcXc+0NXV52SSmG
         CkmXDGkEY108HrGMqQj1F0Fd6G1/817xtV6uUPCohvCPhw7YQolpVds9ejrfJ2CCgHeT
         gSro2Z7jFejbkyrITT6DfR8hEE1aFXGy2rapvHQyubXqcxeigQQa71Pn9NJfIzgRD2Zk
         crFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qO/rCpuBodEkloMdIkUNCA/uOUm0aMljN4/zI/6ygLk=;
        b=cNdY4wiMlr0zkS3RRlfYh8j0e1d/uGLf2qbr7hBdpMfK1PzoOpN/V3LDGORR3nWE01
         iTlGTxLcIVwYVQbxnldfGH90gc8J787ig7aVCvr8AD1wwPKTXYmogoMMDTQkCDkdarfJ
         vJNjAMlOHPyPpLsu699kbZUCnE6OwPSLxAI8GXT6BdIOUXGeAXMMc/xKDjEDNRGXntf8
         OAjwHOZwrKRjD5+deDk+Exvg1QCb95x2l9+W0pt3jZFB+YZuhbax/NTvhYcXx8/fkk4T
         ADKAvGsBBb3c2eETfLcwCcygHvCnt7cBBD5pa4rvqq2ZqDW7Fs/zIyQ63jPh9xFJjEbm
         8E/Q==
X-Gm-Message-State: APjAAAVO/+lP8aY/IkOAbaL2PlIRn2PhFPxE3rTPB0TKrKRkOb2aadco
        9ylhTOjXa2dFNW5lcLBHpiuuU6+J4pha02Vg2m/CC20RBPpyd4WabGbN7wMyoYM+y2fy3vv/1Ja
        sc9LKbioEWmvbZYomAKFTrS63vWShQdA=
X-Received: by 2002:a5d:8b42:: with SMTP id c2mr2130668iot.192.1552368689759;
        Mon, 11 Mar 2019 22:31:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxdBSTxobvPbXRF4tDfCHuxv1PyWpNNw4i37iz/swgwm1hsK96LrHZP+AQcdMI8d/me2NR2pg==
X-Received: by 2002:a5d:8b42:: with SMTP id c2mr2130648iot.192.1552368689481;
        Mon, 11 Mar 2019 22:31:29 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id p141sm789754itb.39.2019.03.11.22.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 22:31:28 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: mwifiex: fix a NULL pointer dereference
Date:   Tue, 12 Mar 2019 00:31:07 -0500
Message-Id: <20190312053107.5790-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case dev_alloc_skb fails, the fix returns -ENOMEM to avoid
NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 60db2b969e20..8c35441fd9b7 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -341,6 +341,12 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		sleep_cfm_tmp =
 			dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)
 				      + MWIFIEX_TYPE_LEN);
+		if (!sleep_cfm_tmp) {
+			mwifiex_dbg(adapter, ERROR,
+				    "SLEEP_CFM: dev_alloc_skb failed\n");
+			return -ENOMEM;
+		}
+
 		skb_put(sleep_cfm_tmp, sizeof(struct mwifiex_opt_sleep_confirm)
 			+ MWIFIEX_TYPE_LEN);
 		put_unaligned_le32(MWIFIEX_USB_TYPE_CMD, sleep_cfm_tmp->data);
-- 
2.17.1

