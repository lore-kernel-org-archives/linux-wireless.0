Return-Path: <SRS0=rEuJ=PD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF22BC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 03:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D85920989
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 03:43:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="eRdPUW4B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbeLZDne (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Dec 2018 22:43:34 -0500
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:45454 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbeLZDne (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Dec 2018 22:43:34 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 8B150B92
        for <linux-wireless@vger.kernel.org>; Wed, 26 Dec 2018 03:43:32 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Zj5m8yMccUgc for <linux-wireless@vger.kernel.org>;
        Tue, 25 Dec 2018 21:43:32 -0600 (CST)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 5B9F5B60
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2018 21:43:32 -0600 (CST)
Received: by mail-it1-f200.google.com with SMTP id k133so18688297ite.4
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2018 19:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=hOl5p+2T+SMz/8AEMgt4InNIGEFzNxBsbhO4HjquBZY=;
        b=eRdPUW4BpRTZB3BAgOzRsZdxwe8PFkFpACVrEywrIc06V3l4IWc/6FEl3IiaPCuKYJ
         4FssBkpdtNHFKLqLGcvBTb3mZRGAcj3fI+1YcQDzmJZ9RKSZIo4lRtnao0No14InraGc
         2EEvvOWOidNZ4mzPSrZTpAAYT+kWe4e6qYjc4V+qGN42OEcmrJcHA8HqnCiCHj05k5O9
         h0P7cRZ+rf0IQP62hUkL72GPDFEu1BvD2bAGj8iHtF9/brhs41tRKvCI+Y4hAzVhGSfr
         HPBUDbKxL1DY3Gwy02m1H8vr5tzK6PyOZR3eWU7cytA1auduRBgK5WLp/BXEzlsBQwiq
         Gn0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hOl5p+2T+SMz/8AEMgt4InNIGEFzNxBsbhO4HjquBZY=;
        b=GnLB2nvIoclgr3neZa1/ETEbIDuoNxJcjBMUE8zVasTOihxrfVltZAcdSO0KE63h/y
         UfbtXOJycSviezmumnBP78+kLEO/86F0v4d5+DO52Byv6vNoMxXRaW6wPT8k+Bh7NMpM
         dVm4315ER8fUp6h1XQQjyD/jdMNm0E816ZG5MgwsoYkIJ1jpOyjOFKtKK2wdlB8vcv8U
         VFuKtZgBi7XqB9GCWZGPtrKJwDDX7xWqBa5FJYKVtd4BBukkukAUqu0sWgGFHszbl5m1
         ZUGJNZShYs1d4wV3iqDHgS/8y55FzOmtpGnqAaHJnPiO/eA+968UAHK+uLkCt5tkdPMn
         6ykg==
X-Gm-Message-State: AJcUukdmrp5m3eo2eWmcQw0Aj2wFDRwkiSheFV+4PtGzRs9ULNZybzou
        VTCwNeoS5aC9r2RIshnSNO+ZOUI+1XcIxou3qOfioZJo6E/HhZD+EIkeOfxCWASGweyQvozRbW4
        6ueB8gaZdzUtbhjKh6O1XB4wZ39zHqUg=
X-Received: by 2002:a5d:8614:: with SMTP id f20mr143735iol.241.1545795811955;
        Tue, 25 Dec 2018 19:43:31 -0800 (PST)
X-Google-Smtp-Source: ALg8bN534rNwU19Ro9JJOu8+7q8bkZNReoaF9cOWN8bsLHV2smqMr9Fn14To3ldsAgFEZRbS5fyEfA==
X-Received: by 2002:a5d:8614:: with SMTP id f20mr143729iol.241.1545795811732;
        Tue, 25 Dec 2018 19:43:31 -0800 (PST)
Received: from localhost.localdomain (host-173-230-104-22.mnmigsc.mn.minneapolis.us.clients.pavlovmedia.net. [173.230.104.22])
        by smtp.gmail.com with ESMTPSA id 195sm11918724itm.2.2018.12.25.19.43.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 25 Dec 2018 19:43:30 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: marvell: add checks for the return value of sysfs_create_group
Date:   Tue, 25 Dec 2018 21:43:03 -0600
Message-Id: <20181226034305.73411-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

sysfs_create_group() could fail, so let's check its return values and
issue error messages if it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index b0cb16ef8d1d..90b20618e0af 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -797,7 +797,11 @@ static void lbs_persist_config_init(struct net_device *dev)
 {
 	int ret;
 	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
+	if (ret)
+		pr_err("failed to create boot_opts_group.\n");
 	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
+	if (ret)
+		pr_err("failed to create mesh_ie_group.\n");
 }
 
 static void lbs_persist_config_remove(struct net_device *dev)
-- 
2.17.2 (Apple Git-113)

