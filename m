Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BC0C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 08:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81525214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 08:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="JQt1YuzU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfCLIHy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:07:54 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:40244 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfCLIHy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 04:07:54 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 4F21FB29
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 08:07:52 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id T1AnMdQ9C092 for <linux-wireless@vger.kernel.org>;
        Tue, 12 Mar 2019 03:07:52 -0500 (CDT)
Received: from mail-it1-f199.google.com (mail-it1-f199.google.com [209.85.166.199])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 18C199B8
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 03:07:52 -0500 (CDT)
Received: by mail-it1-f199.google.com with SMTP id q184so1527695itd.6
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 01:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Ok+IBvCONQi+e/KlYp7EBjFfyX4ZReX4H/x0Jg0TVfI=;
        b=JQt1YuzUnT4gcd8qJb+/fz/orbJywaA+SuCy7Aopo6VECq/qlmQtTJrvYoufoq5O0O
         LmvpqoUoOYFCHyDtUXcGvFKpTiVGPAUHa8bxxtjRYFHLr71RIW3ug/RH65rtAQzP06fx
         st/IV4LlWgvobHtiy+euErrk49pSjx0GbL95uzHllQjawHneeEXNbr7rO9iA1YWCJINP
         +its9ggrzrbd28ZBY4hL+BYDNk0URehnhO7shuzm79gD2HbtAa9AVTOKj9K3Vl0q9pVx
         Xf3qKwWMFieApbVztLhJSbm1ru9AXgU16qrbI//vBOfePIuQj6DQV4XmXbAOIvtMMZuJ
         84FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ok+IBvCONQi+e/KlYp7EBjFfyX4ZReX4H/x0Jg0TVfI=;
        b=XtcemJDiWoLNL83OjJHuAYqjzoIm0psQ8nTkQ5Pv5VcQ5D4z4HC8Qm/5cUTMDKaf6q
         KNn74kzoAZ5aGMopsgOvU0PQksvc6WlrNwcQrPkMpnKfS926PbLbJpy7RER1q/WLrEgx
         82pTnn2FoKBRYpFQJlaTozbfx65h/AqHw69kDW2bwJyh5+ztTWaGvZADfkQWttZGw0JL
         5+ORjLkPnlNski5ZDyA1UtMZdrRBqFaz6c015PW+Nc99NaEf08FQ3wYwtzP/kcDpvc2s
         a9u7mmKUiE+YwDvUyosMcUu+O1iDcfqSTuGrTdu3DumSnv9xmUIKZKvHfxcRWXB/ifmC
         BuMA==
X-Gm-Message-State: APjAAAVSHPgRGpgA0CBWiifHCh9Sp7pMoA9YGOYdrccD31yZtXiHnCJ5
        atSeLdCPECL17S9HIh56LrchgaHjMtKgVQ4AUabxToEsHaWtnNIJYUyDWkn6+/xxsrl8oSlgydu
        qIP8ueeOiPHTiJbCgYGSTDw2+2Qy8oS4=
X-Received: by 2002:a24:3382:: with SMTP id k124mr1427339itk.23.1552378071710;
        Tue, 12 Mar 2019 01:07:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzxSWlTDSMiid2JYg25/21GNjPcuhzxoiehl9K580B+6k3mUeB38uyky4xTSqRwURRTjyxxRA==
X-Received: by 2002:a24:3382:: with SMTP id k124mr1427327itk.23.1552378071489;
        Tue, 12 Mar 2019 01:07:51 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id f17sm931947itb.36.2019.03.12.01.07.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 01:07:50 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: st-nci: fix a NULL pointer dereference
Date:   Tue, 12 Mar 2019 03:07:44 -0500
Message-Id: <20190312080746.3849-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case devm_kzalloc fails, the fix returns -ENOMEM to avoid NULL
pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/nfc/st-nci/se.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index f55d082ace71..5d6e7e931bc6 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -344,6 +344,8 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 
 		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
 					    skb->len - 2, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
 		memcpy(transaction->aid, &skb->data[2], transaction->aid_len);
-- 
2.17.1

