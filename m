Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3056CC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D715021571
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D715021571
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbeI0Vbo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:31:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39130 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbeI0Vbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:31:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id s14-v6so3039377wrw.6
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 08:13:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Op5jJLw7BA2N51GXcPYyWcJhxWQg8jifSeXXOxRzkM4=;
        b=cTzj0rs6hIKGMP8eOp/nywcibKxHgwHCoeKJh4feWw1xaZlXyxUPd0rkmB5KehtdE1
         R9GW9hGvsS8cRv/ZH7gh4hGzAoqq4FznmKWoG4aqx5aROuNllp2oErFe0eFjDeNWzJ1h
         ng/b67P9z8T4K+d1shAJnioJmnS6ll4AWZeI5g4ju+1nSoQDbwWYbw2C4EvQXNKT+fAi
         W9meQqpYsypvTDd4D65y7Tc6heV20kw4an5uH2txPvSmE0CHdr5lmqhLHDKYh12Pqrb/
         R0NDc+9QKcrvmwyT6CPPsyHWHrYZRemxWb39c084l7eMWkQkdLHKtUk5sHrr+rNEgRu8
         yHcQ==
X-Gm-Message-State: ABuFfohO2keEUUxjQIIh/0L3CrNpNbBdoiV0pcZqFPxpl8k3cuzssyB/
        LmfDQJ2EJ6KEQ0owAqpG4EXuBQ==
X-Google-Smtp-Source: ACcGV62FGY7qT8+84Gh5WnpKeANZjMttUdw3MoqUe12uezktEh7EKTlFJBT1NBHpdg+WVAnCnJXVuA==
X-Received: by 2002:a5d:6051:: with SMTP id j17-v6mr9516206wrt.265.1538061179978;
        Thu, 27 Sep 2018 08:12:59 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2230307wrw.35.2018.09.27.08.12.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 08:12:59 -0700 (PDT)
Date:   Thu, 27 Sep 2018 17:12:57 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/26] mt76x0: init: reset beacon offset during bootstrap
Message-ID: <20180927151256.GC24450@localhost.localdomain>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <758cdeb9c4ab95c01a79dfc44e53f50b631948a2.1538036134.git.lorenzo.bianconi@redhat.com>
 <c0be21df-c518-7a6b-2606-43af139e0683@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0be21df-c518-7a6b-2606-43af139e0683@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sep 27, Felix Fietkau wrote:
> On 2018-09-27 11:01, Lorenzo Bianconi wrote:
> > Add beacon offset reset in mt76x0e_init_hardware routine
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> > index 03211fd0db33..6600ee046800 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
> > @@ -345,7 +345,7 @@ EXPORT_SYMBOL_GPL(mt76x0_mac_stop);
> >  
> >  int mt76x0_init_hardware(struct mt76x0_dev *dev)
> >  {
> > -	int ret;
> > +	int ret, i, j, beacon_len;
> >  
> >  	if (!mt76x02_wait_for_wpdma(&dev->mt76, 1000))
> >  		return -EIO;
> > @@ -385,6 +385,12 @@ int mt76x0_init_hardware(struct mt76x0_dev *dev)
> >  					     MT_BEACON_TIME_CFG_TBTT_EN |
> >  					     MT_BEACON_TIME_CFG_BEACON_TX));
> >  
> > +	beacon_len = mt76x02_beacon_offsets[1] - mt76x02_beacon_offsets[0];
> > +	for (i = 0; i < 8; i++) {
> > +		for (j = 0; j < beacon_len; j += 4)
> > +			mt76_wr(dev, mt76x02_beacon_offsets[i] + j, 0);
> > +
> That looks a bit convoluted. Do we really need to clear beacon memory?
> If we do need it, how about simply clearing the entire scratch space
> instead of looping over beacon offsets?

ack, will do in v2.
Regards,

Lorenzo

> 
> - Felix
> 
