Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F9EC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE52021571
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE52021571
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbeI0VbI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:31:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39825 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbeI0VbI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:31:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id q8-v6so6370173wmq.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 08:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L/LkT0GprUCSwlSFGPfBimy5yKcd3Uj8ek+CtLVbEr8=;
        b=bbP4dTmo8WOMpE6bZMr8az1ppDcJcl/VBWFtckEx2Bgx6pcCKrsPZ4TNcjPHS7rT6s
         UJ+HQJTF5WpipExkUNtVG/XLURz/t+XUKG6pFp9Ghv7NILJ7VcSiGBYIeO8LiVfdZ5LG
         tsvxwxg2aCEeVc+8sCJ9gqYTWZuWteOp3fwOzFJrpRMigvWyN6oaeL20a2XQs7Kl4NNt
         r99s2IiQ+c39bd2lDwPYXPqudd2AZxLP1Gcc8/z1MiXEFc2TBZcezmdN1L/an6yxg4Cs
         aB9mugAAceZphVe9yNHirhJZl85Z110sEz0tyKTA8D1xOKtE/4lAZDIoi7vLXEEw3PoH
         89ug==
X-Gm-Message-State: ABuFfogyGK1b6OJC4XfA8bKyajhXmY1iysSw3qiq/KHhuypv3L1ssMd2
        uqqZMSkX3C2w+u2E4jNfStj1GA==
X-Google-Smtp-Source: ACcGV61cL8HSk0Hoe0yNOVh1vUWh6oHtv6p214Kd4QaaYltAUXSPJDsJrXEjWjkmZzvTKdGecKxmBQ==
X-Received: by 2002:a7b:c04c:: with SMTP id u12-v6mr8444151wmc.24.1538061143992;
        Thu, 27 Sep 2018 08:12:23 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 62-v6sm3587370wra.48.2018.09.27.08.12.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 08:12:23 -0700 (PDT)
Date:   Thu, 27 Sep 2018 17:12:21 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/26] mt76x0: init: reset beacon offset during bootstrap
Message-ID: <20180927151221.GB24450@localhost.localdomain>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <758cdeb9c4ab95c01a79dfc44e53f50b631948a2.1538036134.git.lorenzo.bianconi@redhat.com>
 <20180927101404.GC19941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927101404.GC19941@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sep 27, Stanislaw Gruszka wrote:
> On Thu, Sep 27, 2018 at 11:01:44AM +0200, Lorenzo Bianconi wrote:
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
> > +	}
> > +
> 
> This seems to ba fix for 
> 
> "mt76: move mt76x02_beacon_offset in mt76x02_core.c"

I will double-check vendor driver but I guess this is in usb code as well,
so I will add a 'Fixes' tag

Regards,
Lorenzo

> 
> please add "Fixes:" tag or merge this patch into previous one.
> 
> Thanks
> Stanislaw
