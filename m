Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1A7C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 10:02:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB9F220838
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 10:02:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB9F220838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbeJRSCo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 14:02:44 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37948 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbeJRSCo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 14:02:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id 193-v6so5067206wme.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 03:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1fmkp01dfhL3y/KuxulDl7KRWgvJ0X/tKQAgE9/op4A=;
        b=IQ0F691jGBLnGXstq+fFtpv9VRqHRlHhh8NRTOEfsrmI99vyk0xZ10IHGDMzu6Hmeo
         Zec0eKhHXHgEc5/0QJ9I6Dja1XAceMIJbE34HJOTxVPLjVKfaNS06nSK4RtkCfUVgoxI
         rbj3+noyzukkRiGpeWmbAAYoTviVUktn8VfVojRuwnSQUaXCSY/BePMoyoGqYAYrHelQ
         71vzm2AokXCyrcOSyN5fyeGlAqN/3q8v3kpwuWdw7Mgz7hgJESfChbrDBYErkufT8LC2
         MtS9Xth+I+36QXEn7EZPKiB3akMIL4QtU6PIsGWXoXgXJAkOAt1KU6hAyoiqqtg3wSUD
         Xyzg==
X-Gm-Message-State: ABuFfogA8HD18iH/MkjG0vn8oqB9VDfGuzaz/OhcSyKyIDfuQYzDuYos
        t8J2O15R+NdAOpC9D074zYrnVQ==
X-Google-Smtp-Source: ACcGV61ea9wnEn26/RiyrIE5HsGU0FBUILHynBM5aQmH9dYF7ZWrM2A2WAFPHktAGRezRw2vjvqFjw==
X-Received: by 2002:a1c:af07:: with SMTP id y7-v6mr6945384wme.33.1539856947540;
        Thu, 18 Oct 2018 03:02:27 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id l11-v6sm28276995wrn.61.2018.10.18.03.02.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Oct 2018 03:02:26 -0700 (PDT)
Date:   Thu, 18 Oct 2018 12:02:24 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: antenna select corrections
Message-ID: <20181018100223.GF4938@localhost.localdomain>
References: <1539850059-11886-1-git-send-email-sgruszka@redhat.com>
 <20181018091335.GB4938@localhost.localdomain>
 <20181018092146.GC2190@redhat.com>
 <20181018092819.GC4938@localhost.localdomain>
 <20181018094055.GA6294@redhat.com>
 <20181018095333.GA6495@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018095333.GA6495@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Thu, Oct 18, 2018 at 11:40:56AM +0200, Stanislaw Gruszka wrote:
> > On GPL realeased driver for MT7610U ( mt7610u_wifi_sta_v3002_dpo_2013091 )
> > it's like this:
> > 
> >         CoexCfg3 &= ~(BIT5 | BIT4 | BIT3 | BIT2 | BIT1);
> 
> <snip>
> > Does your SDK do something diffrent ?
> Ok I can see:
> 
> 	CoexCfg3 &= ~(BIT5 | BIT4 | BIT3 | BIT2);
> 
> in
> https://github.com/i80s/mtk-sources 
> which is newer version of the driver, so preasumely BIT1
> should not be cleared. Will fix that in the patch.
> 
> Thanks
> Stanislaw

Btw fixing that bits:

Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
