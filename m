Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA55FC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:15:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 999B220684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 999B220684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727622AbeJCQDN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:03:13 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:50681 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727188AbeJCQDM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 12:03:12 -0400
Received: by mail-wm1-f53.google.com with SMTP id s12-v6so4954139wmc.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 02:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9/29QdVcnVBxhD5b+ujLejXJYBljx4UBYMU4m+EXHkU=;
        b=E2Lk31Bax8tUzfSicXkqVr7Vpg2aPK0OgqLJLj4avS5/UuvEs2jawy2tz/Yd31nznQ
         J2sS1KThbd0TYHYbwZo/A5D+S3OTsIQxNIZGBbFO8Q5UASme5jkMqw4ck39XodzZf1Zh
         7s33oMA3MvQPNtBLo7T9uKwvLYaVE+hSclnsOXAlgSO8FSbfmwc/hyBqxLI8zhBSTzYF
         rCHEIsnUlxw7WPwsHnmeF2Udw6sqopSZOugPMbjeWnDDm416+oaCT2+l089/89zJNKoF
         tbbxtmVsVJ17w1i3SOR2LJ7g2JVkyZOPlS+AhEtBWiPPdRLO7kuEkVfuEBBrWx5UanjU
         ciLg==
X-Gm-Message-State: ABuFfoiUC2Ky5RyjQyriWrHOmuODUcjTU1vXTqibDy6RJwV5XEON8vZe
        g6M4nk6djz4BM71P0eqWZsMQ8w==
X-Google-Smtp-Source: ACcGV63b75zD8Qdngyqb7gxKMgIGUfcgHRrAgfsButdGu2sJVzCk7FqOUL7pGLSNGL7GZafe12juxA==
X-Received: by 2002:a1c:8dcd:: with SMTP id p196-v6mr671383wmd.49.1538558139674;
        Wed, 03 Oct 2018 02:15:39 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id f1-v6sm1105037wme.23.2018.10.03.02.15.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 02:15:39 -0700 (PDT)
Date:   Wed, 3 Oct 2018 11:15:37 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: new mt76 usb crashes on device removal
Message-ID: <20181003091536.GB27279@localhost.localdomain>
References: <20181003082309.GB2229@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003082309.GB2229@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> After
> 
> b11e19694dc9 "mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature"
> 
> I have new crashs when remove mt76x0u and mt76x2u devices. 
> I can not provide calltrace because some other warning/traces
> show up instantly after the problem happen and mask prints
> for initall problem. Then the machine hungs.
> 
> Anyway bisection blame b11e19694dc9 commit and I confirm that problem
> not happen before this commit. I also applied the fix with I just
> posted, so this is diffrent issue.

Hi Stanislaw,

I do not know if it is related or not, but could you please try following patch:

Regards,
Lorenzo

--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -179,11 +179,11 @@ static int mt76x0u_register_device(struct mt76x0_dev *dev)
 	struct ieee80211_hw *hw = dev->mt76.hw;
 	int err;
 
-	err = mt76u_mcu_init_rx(&dev->mt76);
+	err = mt76u_alloc_queues(&dev->mt76);
 	if (err < 0)
 		return err;
 
-	err = mt76u_alloc_queues(&dev->mt76);
+	err = mt76u_mcu_init_rx(&dev->mt76);
 	if (err < 0)
 		return err;

> 
> Thanks
> Stanislaw 
