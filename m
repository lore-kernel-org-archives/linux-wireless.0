Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 831DFC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 08:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50F282133F
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 08:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQCRFpaj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbeLRII0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 03:08:26 -0500
Received: from mail-pl1-f172.google.com ([209.85.214.172]:47040 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbeLRIIZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 03:08:25 -0500
Received: by mail-pl1-f172.google.com with SMTP id t13so7441436ply.13
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2018 00:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4R8/VLPZrJn9vSYTePrs8K5VHrnIeHZRgGlh1K7UCYI=;
        b=TQCRFpajiY/mX5yF3I+AJchM/1mAmBmFuMfQprajkZfFSEDb1VecSL/awOo7obc7nG
         VxU6R0YvhoyLkw6QlQx5Ksnxh0swsKPy5KVO+3sbnvw1035RScaQRJjZH9M+G2GwsZE9
         mM/+s694SlO5Pi9Jmmy2x0QcsEUECn9Tg+yvLZ0dwjMGRgVvt1l6+2/q+Pe/uTH99U+1
         NBPkIxdHrkGiHNiPocA7supyH64umN/lHyRc7jtI2567KDlbzbm/eGUmWLhv9zIpnxrJ
         yRCsgU7lZCZ1KrifsF6Zo4ClFthIK1YOWSiSy+UZdQ6hwPM77oxauj5Yf72xD0epIkWQ
         VGWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4R8/VLPZrJn9vSYTePrs8K5VHrnIeHZRgGlh1K7UCYI=;
        b=hWwkbcmLdOTCQpFhwPv0ZUjl1mF98H1oh0Y6HoRyBJRsDgqdLSPWMX78nVyOYR9TLz
         hweZ4JqYOLD6PgbbOZtCRTTHc7PKjG5XFaaB6H+wBsAc06h/fz3aHUPqkHXoGMUenfPs
         zlI62pIhCAZ310xfyCSII2OdK6rDCay2egPQCQ+9hfJ9ZVqkbhFIcnr69zD/b+YbNGED
         Nr14m9cPXtLwf3f4Gp3yIjuItugM9qgstNuslg8XXveqLRuBORsH2hCjjzL4koMCAUtC
         imNETCzss4jvPYxUPqzPZfTIPqvMtp1JpXluQPD68FKs1K/PVNgf/YvK1V5KWIIu3i2W
         Jdhw==
X-Gm-Message-State: AA+aEWZZbW2BDXqIyCHMikIs/jlxj+s2pB7zjNFMGHYHI8T0aZgTNxKd
        kDNaomBVUy0f2/XFgXfWJ6E=
X-Google-Smtp-Source: AFSGD/XzuA65qEoc6oSFSUB+kpfJa1oVVJsLkSHOFO3mY9glQANhcr6LDCBuN4ml/PptFkA9DuUVkw==
X-Received: by 2002:a17:902:12b:: with SMTP id 40mr15251401plb.72.1545120505166;
        Tue, 18 Dec 2018 00:08:25 -0800 (PST)
Received: from BWT-FWA-0475.bluwirelesstechnology.com ([103.248.210.66])
        by smtp.gmail.com with ESMTPSA id l184sm21534490pfc.112.2018.12.18.00.08.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 00:08:24 -0800 (PST)
From:   chaitanya.mgit@gmail.com
To:     seth.forshee@canonical.com
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        Chaitanya Tata <Chaitanya.Mgit@gmail.com>
Subject: [PATCH] wireless-regdb: update 60ghz band rules for us
Date:   Tue, 18 Dec 2018 13:38:15 +0530
Message-Id: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chaitanya Tata <Chaitanya.Mgit@gmail.com>

Include channels 4, 5 & 6 for US in 60GHz band. FCC extended the
57-64GHz band till 71GHz with almost same rules.
---
 db.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index fa5c0e0..ae650dd 100644
--- a/db.txt
+++ b/db.txt
@@ -1280,9 +1280,9 @@ country US: DFS-FCC
 	(5490 - 5730 @ 160), (23), DFS
 	(5735 - 5835 @ 80), (30)
 	# 60g band
-	# reference: http://cfr.regstoday.com/47cfr15.aspx#47_CFR_15p255
-	# channels 1,2,3, EIRP=40dBm(43dBm peak)
-	(57240 - 63720 @ 2160), (40)
+	# reference: section IV-D https://docs.fcc.gov/public/attachments/FCC-16-89A1.pdf
+	# channels 1-6 EIRP=40dBm(43dBm peak)
+	(57240 - 71000 @ 2160), (40)
 
 country UY: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
2.17.1

