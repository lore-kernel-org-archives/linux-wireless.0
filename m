Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE60CC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 03:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDA12218B0
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 03:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="WMnfmVvU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfCWD5S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 23:57:18 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:56818 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfCWD5S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 23:57:18 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 5ADFDE0B
        for <linux-wireless@vger.kernel.org>; Sat, 23 Mar 2019 03:57:17 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id UeVFWMXbw8Rw for <linux-wireless@vger.kernel.org>;
        Fri, 22 Mar 2019 22:57:17 -0500 (CDT)
Received: from mail-it1-f198.google.com (mail-it1-f198.google.com [209.85.166.198])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 2B6AEDA1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 22:57:17 -0500 (CDT)
Received: by mail-it1-f198.google.com with SMTP id z190so3715001itc.9
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 20:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pSzJjsTnJ+rvVPvMAXI4CzCBC1u3I5ehw1LY0kNuyYw=;
        b=WMnfmVvUUcklqGVY1voyZ6yjTfrAtmhQHsX8oASmB/F2p/pR0IEqkX7yb9declZOZa
         fBNLKAk/GSPWhOW3uykYgdClZrqMryOhtYTnDGPTaFFVcS/oBKT+nhyuJW/MGVK3V2Rp
         M9q7fQEBhekFIXIfzd48sYngUjl3JyjDT18a3bErgOlzs87UpCXYeEWEpeFkVtzm3Jhm
         0KwL2vP4VZ9beyQ6O0fNupFI1dtEtJor+DwH2P4nENcE0vjZiie1b5Kk0eEtBVz8uONR
         1sVbPROAaNqA2Q94LhYg4uAVZWDaRlHWnQQfLPVAjcJz2iQaEPMygkip2c4ptsuoRkZ6
         7GRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pSzJjsTnJ+rvVPvMAXI4CzCBC1u3I5ehw1LY0kNuyYw=;
        b=OqGVRzl+x1v1TBUu468FHj1LRdg9GtTy7bELhPt38Yk8ouhmmuqMWZDub7i10G5wOB
         QcP/sNGgWh6CXhYcmJRuDUqDouzv4/4ha9a9/5zj4MK1EWp98dMKriXiKSOSucIX6BIH
         zADv+2ZGTvsdv2vcTCkBWOhyJelSVs3scPItsO74Y6nb0cUZHZuKumF2D9dY9GYLV7ix
         G/QB36ACWq2PdlLc3rW/Fh6nChV/mN5gq07IrohfpgDRzCkyJ3fr73x2CUlqLWXPLnUw
         s4OlxI3wr9js82ptoujYhhQZgSMQrgbNJgEn/Gleo3cNOT0w4WeDDklnYLQFSmJgnnjm
         LhWQ==
X-Gm-Message-State: APjAAAUeSX4lxFyiJBdTgthsCcp2e8NZxjyY8BY0CIv31c3eof0Se1MN
        zhXGnwdxjZce4T0EmmXUd3yBuLmk6OnHGXs3bwKNx5BWFoa//JhZ6XRxzXwSy1qNVXtOhASiFtw
        wSCGTDYu6wQacKuD7lNj5fFRCevVEjdE=
X-Received: by 2002:a6b:4104:: with SMTP id n4mr9878015ioa.305.1553313436787;
        Fri, 22 Mar 2019 20:57:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxUI3unBBOONvUMI9c6AMh44IuN1nAKASV+nQx5otvB1K5XQWjXzxbeJKBi/wa++99yGNNMqQ==
X-Received: by 2002:a6b:4104:: with SMTP id n4mr9878005ioa.305.1553313436571;
        Fri, 22 Mar 2019 20:57:16 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id c1sm2379962itd.23.2019.03.22.20.57.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 20:57:15 -0700 (PDT)
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
Date:   Fri, 22 Mar 2019 22:57:11 -0500
Message-Id: <20190323035711.23882-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <87zhq04pl0.fsf@codeaurora.org>
References: <87zhq04pl0.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case dev_alloc_skb fails, the fix returns -ENOMEM to avoid
NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
V2: minor change: simply remove whitespace
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

