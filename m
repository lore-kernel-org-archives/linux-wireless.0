Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCDDC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 10:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 294A5214DA
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 10:09:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 294A5214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbeJJRam (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 13:30:42 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:50854 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbeJJRal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 13:30:41 -0400
Received: by mail-wm1-f43.google.com with SMTP id i8-v6so4781886wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 03:09:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4slWw4zJUs2x3OTsWJBF1L56+qJDf6XXSobPnlng2B0=;
        b=qouUExnWfVxeIevb9q7PO7cYwueUbxJ3r/YlT8DNatQE/khRiYPMFVbnZB/P8/4mHz
         TUD8MKopRiBbzNodMD38IsJUPu/vghSU1S8PMW0HbqjgZ3oZbME0vG4RfpLKUH86NmYY
         BV7nCGIsJDQz37UdnkwkRoH6OU/gkfYiLtBA7jy/3qG0v1I1yn3/wuZH/MpE/X2Yl/8R
         qYFdwmmxLqqin/ywJtmYXWPEonA4/6rTbn9FHCAQRSdpgZPVWdWSgPLjQBTJp2JCIySU
         mc7Sxa9pKZb0KU9InjueSFORhNm1RPOf38KCpBaOn9RcdZjQVNZBaZRs6NYtgIxIh9tA
         W3kA==
X-Gm-Message-State: ABuFfogwY0LvIq4xOYBsbdny2z2INDNMwLs5ZleHR11sZQwb5DNsCgKr
        Oe3m3OH9/H/dbeCgG3AbmaMX8CpzTEc=
X-Google-Smtp-Source: ACcGV61COYMSEsPUDxM0wDpyjYpJ5Jt39Kavpsjm/0v3zhIVsHA5Trlr8LJ1ISsO7OoXRVRVdvLtjw==
X-Received: by 2002:a1c:cfcb:: with SMTP id f194-v6mr303813wmg.98.1539166153263;
        Wed, 10 Oct 2018 03:09:13 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 74-v6sm17038626wmi.23.2018.10.10.03.09.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Oct 2018 03:09:13 -0700 (PDT)
Date:   Wed, 10 Oct 2018 12:09:07 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mt76x0: phy: fix mt76x0_temp_sensor routine
Message-ID: <20181010100907.GB3371@localhost.localdomain>
References: <cover.1539162246.git.lorenzo.bianconi@redhat.com>
 <81232baeddb434362a3474842890ee9f316bfd67.1539162246.git.lorenzo.bianconi@redhat.com>
 <20181010095642.GB2856@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010095642.GB2856@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> >  static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
> > @@ -832,7 +825,11 @@ static void mt76x0_phy_calibrate(struct work_struct *work)
> >  					       cal_work.work);
> >  
> >  	mt76x0_dynamic_vga_tuning(dev);
> > -	mt76x0_temp_sensor(dev);
> > +	if (!mt76x0_tssi_enabled(dev)) {
> > +		int temp;
> > +
> > +		mt76x0_temp_sensor(dev, &temp);
> 
> Why this &temp is needed ? Preasumble it will be used in the future,
> but maybe you could at least add dev_dbg() to print it's value?

Correct. Sure I can add it in v2.
Regards,

Lorenzo

> 
> Thanks
> Stanislaw
