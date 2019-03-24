Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A00AC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 23:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAA9120870
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 23:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="L2E98J0a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbfCXXHI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 19:07:08 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:47768 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729031AbfCXXHI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 19:07:08 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 3DF5B977
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2019 23:07:07 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zNySY8ha6Qbg for <linux-wireless@vger.kernel.org>;
        Sun, 24 Mar 2019 18:07:07 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 0F980957
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2019 18:07:07 -0500 (CDT)
Received: by mail-io1-f71.google.com with SMTP id r21so6531463iod.12
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2019 16:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=iud7r8lDyLIqpYWBPtgGvRs/3cKXa5HA3MyfNcMQxm0=;
        b=L2E98J0ad7zGGY5KESoAs+GF+nyVHj0EmwXcrfS0TH+7zHkmUEwKxE6T9lQv5r0p6f
         5u4WolAWDJe1xyvnCVM5g/mzVxFK6ljiSl2li6zXPav596QNR6CTo8aPuks9VXfKD44Z
         KDsNJadi4h6B73j89FwRA5I+TO3zd4zAJeNSsROPwV8gXJXb8kNz7c7ItboP/xkPgou3
         DzuFXW8VkNik0a6HmemDjjX3Rxt8AM16PsnJ40jxZyveq1vrUIXszJKlIgKeQ9yyk4Ht
         O7V0vbmIFOy6b1spF6jPlMUQcT4hI2OAwnqVSC8H8ue3V//5CumwSKHuG30AP/R26bdH
         YDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iud7r8lDyLIqpYWBPtgGvRs/3cKXa5HA3MyfNcMQxm0=;
        b=TkWRgji15hbqJE/y+vS+LRrHlqbPxadGySTFiCstW44JDhTHNbNFnbfV2z2Se2f5wm
         TJ8chrRpBF4AQnGKa1gJ34ju07lsEUD5u3tsiZSA6jGXMIpGzVRuYmrtoKUtcE7+/O7S
         g24dZYnW0dy7xJmPtpShZfnHHr5NqMXVigZke+Da9ZJYIEjnItJNS7g7dN+X+AeR0Zjl
         un4Q5ed9AI3pLz0TKso8wyxO9dsYEtBKrCpWP6vjPeWj8qiiILWLAQw9lx8wOyVgiyur
         1uOFCCJnE7ykES+q+DJufvBMhhJjvscAa8GQkZhw309Y0qmw9i/D8iP7qM+ZObg3EEBw
         QtLA==
X-Gm-Message-State: APjAAAWuHYHAW/IO94JFhhdI/REz3TtQCoqG5Q4BdD4GJtBi1vAbonrL
        X7T6yjOX9QuXWHNgpiAxeSt8FRMbD2gvX+Yp4UVoWfuD4CpUM4wZNbu9ABeZ/QpQFHMpZpw73k/
        Gtil9nqqeRiUAb7bOPwMERFOBfN3csUQ=
X-Received: by 2002:a6b:f702:: with SMTP id k2mr6397254iog.31.1553468826732;
        Sun, 24 Mar 2019 16:07:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw4uXb+XdvzuUbxPIPDTS1EIoNr8npmn6hxjWLKlDKAkQff+vPPJX1WQxoysWeTRwKTJNmXMw==
X-Received: by 2002:a6b:f702:: with SMTP id k2mr6397241iog.31.1553468826545;
        Sun, 24 Mar 2019 16:07:06 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id t74sm5056061itb.11.2019.03.24.16.07.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Mar 2019 16:07:05 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nfc: fix a NULL pointer dereference
Date:   Sun, 24 Mar 2019 18:06:59 -0500
Message-Id: <20190324230700.1956-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case devm_kzalloc, the fix returns -ENOMEM to avoid the NULL
pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/nfc/st21nfca/se.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 4bed9e842db3..fd967a38a94a 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -328,6 +328,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 
 		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
 						   skb->len - 2, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
 		memcpy(transaction->aid, &skb->data[2],
-- 
2.17.1

