Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3F3C10F00
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 08:00:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F013D214D8
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 08:00:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="Ch9vuvjy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfCLIAB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:00:01 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:38488 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfCLH75 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 03:59:57 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id E61049FD
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 07:59:55 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Eh0qNM7Jo7LD for <linux-wireless@vger.kernel.org>;
        Tue, 12 Mar 2019 02:59:55 -0500 (CDT)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id B6BD9A2B
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 02:59:55 -0500 (CDT)
Received: by mail-it1-f200.google.com with SMTP id q184so1511394itd.6
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 00:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1nkZcVU0GvUzDc/ZYNTpuRtHlao+2b0Vm1VZH2b1N8U=;
        b=Ch9vuvjydJ4EhQPIcG7puULxC+JRbV5Chpg2PLSeQh+EyWOBrybWR1/nJNODcDbxaI
         PQskGTtnLDWIo5/AU/BTCwwMJnVQgJs3ekRvPcMXx9Pp984XlFYGe7ufnX/NcpnSoEor
         UorOHxgCM15q/CNDL8doF8cO90EcjUkKKvp+pmPW36YpXU7aK0nB1MOgA+u6Z8i4gMZn
         XjmF4beVRrUNsqrgPHlNdEt3BVcTXDjYdAjqBsVNp7sxXBsHUXYnqQFn5cNQPRmM3rlM
         snfDcGx7lXb78OO0gkXQ/5Yi3ibqv00LObONxyBOn9Ul81VHh61U4k69iGjjy3XnLsIC
         EwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1nkZcVU0GvUzDc/ZYNTpuRtHlao+2b0Vm1VZH2b1N8U=;
        b=uYvv8nUpHR4xoK23YrYsauLUlDD+w0Yqds66NMEuD4B2HrWHLG8fxHfPywkCSBdw6W
         7AocvX/o1yIAlrLFjMZgg5W6Jlf3Vpf6I0SknRF9dM0OvpxlSeUwdqjfglSrJo583neA
         pAusxln7X/Zb56UF869B5hSEsNMJr5Rmw2korABowZY+hU/tGoGOnt3mKxqLNAuZeeDp
         9ntKR5pI5hQerFsmbNp6JREKtaGDufOtnd1pk0AlO928Bzvg/R1N0LhF8v/oDXG2aSEw
         wDJMTNGGrvlt1JRC38ZMHWnv2A2nzX8euedHFWnO1fQIuqxyx9QCyFcF89UjrxBdNl0j
         iXug==
X-Gm-Message-State: APjAAAVJnIr3B8mE4mXt9stUYWnTjbTN2oqOrcwGTf+dPe4EXDeBqo/X
        8R8WYT7SC4R/KMVDZrjsM++tLbA3No6X8DqaxoCmYSiGnmTW7UMy+FbEVP7Qes2FZvZuU5hxXP6
        OxEVcv/hmmLvDm+tH4IwtVPatWlgwqjQ=
X-Received: by 2002:a02:4083:: with SMTP id n125mr21568218jaa.63.1552377595298;
        Tue, 12 Mar 2019 00:59:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyOfP+9mqD+1XLGDv4RfFO3LOxcYkCR4RoLYjEACGFPQr+ni9W5LMOCuUKOkpHRPxMIwUeagA==
X-Received: by 2002:a02:4083:: with SMTP id n125mr21568200jaa.63.1552377595059;
        Tue, 12 Mar 2019 00:59:55 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id u12sm3391365iop.77.2019.03.12.00.59.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 00:59:54 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: rtl8192c: fix a potential NULL pointer dereference
Date:   Tue, 12 Mar 2019 02:59:46 -0500
Message-Id: <20190312075948.1569-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case dev_alloc_skb fails, the fix safely returns to avoid
potential NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 18c76990a089..9042fc044c7e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -623,6 +623,9 @@ void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      u1rsvdpageloc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
+
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
 	if (cmd_send_packet)
-- 
2.17.1

