Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BBB5C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30852070B
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 17:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="JarT0gK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729192AbfAHRmo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:42:44 -0500
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:46238 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbfAHRmg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 12:42:36 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 8B83C195
        for <linux-wireless@vger.kernel.org>; Tue,  8 Jan 2019 17:42:34 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j0igpLh8TSzP for <linux-wireless@vger.kernel.org>;
        Tue,  8 Jan 2019 11:42:34 -0600 (CST)
Received: from mail-it1-f197.google.com (mail-it1-f197.google.com [209.85.166.197])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 5D8186C
        for <linux-wireless@vger.kernel.org>; Tue,  8 Jan 2019 11:42:34 -0600 (CST)
Received: by mail-it1-f197.google.com with SMTP id t143so3762176itc.9
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2019 09:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y04K96i7AqfLXVJ20zJQlIpipREv69zPRy9N3+V57qs=;
        b=JarT0gK6+YqBCbclB+NuvmqbXc/ahZXU9O9s5Ai0Zon8lxb+5jxqkTEdVDsh+Afh3U
         u8ai+vnHjFQhPs0FZ1s009jkRfaT+BcZbmwVYSjNxLijdDMSqEwC+dbnOJX+751az+j2
         DjmQlgnV46hffXvS+nSPVj4XDuDhFNGMNTICcriPrbGkwi+SRWcZJ57TBkp19xFneA8/
         LuvB7GMs0HVanLjh6w7fhtwSU+8zQJFEi//u8VHumUvUM4P+zRyCNd5QqC50Whf2t2lA
         YJB9B5YpvY/Tlx0jk0c6Q+PcMzByTZAdxakX7YzNH/PGM4IHZ6W734vCsS9fygVgGcIh
         T01Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y04K96i7AqfLXVJ20zJQlIpipREv69zPRy9N3+V57qs=;
        b=nJC71H9gCVGns8Y4Q3E8yeyTQtz5GiTENYftlhai7TBtgvVN2e39k4hEBF99u4xD/h
         0WEQ/Ibn5Tu1JXaQuDav7cHYDuTqbqM98GfRamKdjvbquXQtlhH0AFWjukXfVVaf/198
         wBo+bcUabTebulgfADvjyPt5YocKB2rVZoqftnCTGRZMQh95K7U8kG8GLoxGwaQ0xknh
         T3k1BxXLNKI/s+k3haYgZkCKauplI4lAQNaJ7yd80k4VUMrTIWJX9u2I07jRTj+27cfc
         ivXDUOlq9hAkcHacoh5X0Xg3aSitfdNSVATzlNEqphVQFKfHlEi2T/CO1+5YqPnGM8QD
         GBjA==
X-Gm-Message-State: AJcUukd3UqaKxX1Da+iAKRwuiH78jTivtrWJeqqCPEltWVqcMtyTRkQo
        tA9xRlySpERC2bQSWOemMMNEc0mytCXCQ7hlHH12NTK4Vr8BPjS1EmDT37+7mEExQ4o0yF3jPvJ
        zPBkwbf6AX1FDEgodHDj1en4is0ki8hs=
X-Received: by 2002:a24:d441:: with SMTP id x62mr1886144itg.141.1546969353961;
        Tue, 08 Jan 2019 09:42:33 -0800 (PST)
X-Google-Smtp-Source: ALg8bN7W7i5rmeT4RwTVx/Ooh3y2UIn0q3CytABbG0ty7keCE3TuvmTmPvlV00mrIvjyfaRk5JNPpg==
X-Received: by 2002:a24:d441:: with SMTP id x62mr1886128itg.141.1546969353659;
        Tue, 08 Jan 2019 09:42:33 -0800 (PST)
Received: from bee.cs.umn.edu (cs-bee0u.cs.umn.edu. [134.84.121.28])
        by smtp.gmail.com with ESMTPSA id w1sm11362788iop.14.2019.01.08.09.42.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 09:42:32 -0800 (PST)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] libertas: add checks for the return value of sysfs_create_group
Date:   Tue,  8 Jan 2019 11:42:21 -0600
Message-Id: <20190108174222.29121-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <87va2zqer0.fsf@kamboji.qca.qualcomm.com>
References: <87va2zqer0.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

sysfs_create_group() could fail. The fix checkes its return values
and issue error messages if it fails.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index b0cb16ef8d1d..2315fdff56c2 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -797,7 +797,12 @@ static void lbs_persist_config_init(struct net_device *dev)
 {
 	int ret;
 	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
+	if (ret)
+		pr_err("failed to create boot_opts_group.\n");
+
 	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
+	if (ret)
+		pr_err("failed to create mesh_ie_group.\n");
 }
 
 static void lbs_persist_config_remove(struct net_device *dev)
-- 
2.17.1

