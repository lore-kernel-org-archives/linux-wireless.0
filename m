Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C67C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 09:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D671120862
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 09:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D671120862
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbeKGShV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 13:37:21 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54036 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbeKGShU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 13:37:20 -0500
Received: by mail-wm1-f66.google.com with SMTP id f10-v6so1064336wme.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2018 01:07:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6eKpE4SJpW9a8Pe1KrJk2YqBUyIbpw6mQNwugThvCSw=;
        b=iHqh3sjhp+1gDb9oIJKR19lHgW7CYoiqKpD7LMi7Pz+rjCQIFqoWCnA/rPdZR/HYeB
         IGWKtHnvvXXY1G8lmiLLqfejHXwWoxV2yZEa1fdlLRMjyVI5770Phm1BnfXPHs2OxoHL
         0r8s0KfnV1Z04XeLaIpqUTBMOV9jiAYErgPv0tKyaoF7CFulTi8CIy5JPKbTi0GUfnfn
         8pnw27Rta1bk0c2tZ1YD/xSb0K4O+pdrbJK0pO6VKWomRzoFE1FGm7w0T5XuUQ6EOt0o
         ZXZmzCClKbTYSq93ahuyhfMPuT74wqtSwp3sdjPam83utKuEm53vOlLSd5X8cWU13vvO
         JFXw==
X-Gm-Message-State: AGRZ1gJ1AQqFFRJGU6OiuW1RMzX5lxg0avDOLoKIIYAndnmuOOJgcV/b
        weAezKbRNbAtZcqlHLir38AAHfDyelQ=
X-Google-Smtp-Source: AJdET5chr11uWrW+EGRCLX9HljgQqmVzI/N9C1XhzU+ZeDaOK+AFFSQ5R/25CAimKYIxEXdJQZbGdQ==
X-Received: by 2002:a1c:410a:: with SMTP id o10-v6mr1227593wma.19.1541581672533;
        Wed, 07 Nov 2018 01:07:52 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id m16-v6sm386384wmd.35.2018.11.07.01.07.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Nov 2018 01:07:51 -0800 (PST)
Date:   Wed, 7 Nov 2018 10:07:47 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: introduce mt76x02_config_mac_addr_list routine
Message-ID: <20181107090746.GA4082@localhost.localdomain>
References: <cover.1541544212.git.lorenzo.bianconi@redhat.com>
 <c9e89034e9d421bd1f2b159050c95fb1d6c236e8.1541544212.git.lorenzo.bianconi@redhat.com>
 <20181107082704.GA2549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181107082704.GA2549@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Tue, Nov 06, 2018 at 11:49:12PM +0100, Lorenzo Bianconi wrote:
> > Add mt76x02_config_mac_addr_list routine in order to set
> > the mac address list supported by the driver. Initialize
> > wiphy->addresses/n_addresses for mt76x0e driver
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> >  .../net/wireless/mediatek/mt76/mt76x0/init.c  |  2 ++
> >  drivers/net/wireless/mediatek/mt76/mt76x02.h  |  1 +
> >  .../net/wireless/mediatek/mt76/mt76x02_util.c | 22 +++++++++++++++++++
> >  .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 17 ++------------
> >  4 files changed, 27 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> > index e74d476eca24..87b575fe1c74 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> > @@ -289,6 +289,8 @@ int mt76x0_register_device(struct mt76x02_dev *dev)
> >  	int ret;
> >  
> >  	mt76x02_init_device(dev);
> > +	mt76x02_config_mac_addr_list(dev);
> > +
> 
> Does this work for USB devices ?

Hi Stanislaw,

for usb devices we have just one interface so it does not make any difference I
guess.

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
