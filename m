Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270AFC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 12:00:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F13F420818
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 12:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfBVMAU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 07:00:20 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38244 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfBVMAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 07:00:20 -0500
Received: by mail-wr1-f65.google.com with SMTP id v13so2098743wrw.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2019 04:00:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BXWxKsMzKR5Rip0nDQ4BEZJHJhUWF4CmQb1zllP9Xfk=;
        b=AoQnf4vmBatRctd5ngWrvLXnCV35qILcwYdCC44dRAwPYoFvb+74iJ0zfO2e0N/chU
         mYt0haqgLSQDYfxGDTO8o8KXk46pbfbi9S1JWoI+NRIAZ7FmyWRyqdbEj04f85+62nZY
         LGyMPY7QVg7FZDihEbnCxwKjmIz8KQMLMH3MBY3PQhf0KpdJbVm2nwqolfeUMorPE3Ow
         BbgjUuLjuVL3lX96M/yepTI9T1F1VBbixLpVDPtiZ7zFROQiJdvQgwlM2tTfot89nMpQ
         iMphiqIZgRqVdreK5NXiBHos4e8q8zK5yorKWpxtYN8xk4TYlBrYYrsJBUZKnYcgYc3C
         RHDQ==
X-Gm-Message-State: AHQUAuYxlD0LLytzJ6MLnD8MzLMbL10XpW0w8hJZy9A/dbjYYAM1b/fI
        n7C1/1+9hT8JJFlLbJYDGiprtQ==
X-Google-Smtp-Source: AHgI3Ib/jARwMzxStODKuSdc432iK2cx60MA24XBsIut9JA5qtkKw95fMDa2mXvT/eLqWQBGQqQD8A==
X-Received: by 2002:a5d:5506:: with SMTP id b6mr2563983wrv.33.1550836817655;
        Fri, 22 Feb 2019 04:00:17 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c2sm1721318wrt.93.2019.02.22.04.00.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 04:00:16 -0800 (PST)
Date:   Fri, 22 Feb 2019 13:00:14 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mt76usb: use synchronous msg for mcu command
 responses
Message-ID: <20190222120013.GD14269@localhost.localdomain>
References: <1550679320-14343-1-git-send-email-sgruszka@redhat.com>
 <1550679320-14343-2-git-send-email-sgruszka@redhat.com>
 <20190222095318.GA14269@localhost.localdomain>
 <20190222115446.GA5720@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222115446.GA5720@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Fri, Feb 22, 2019 at 10:53:19AM +0100, Lorenzo Bianconi wrote:
> > > Use usb_bulk_msg for reading MCU command responses. This simplify code
> > > a lot.
> > > 
> > > Together with 97a3005759c ("mt76usb: allow mt76u_bulk_msg be used
> > > for reads") it also fix possible problems with rx data buffers
> > > not being aligned and contained within single page. After doing
> > > page_frag_alloc(1024) consecutive page_frag_alloc(PAGE_SIZE) will
> > > alloc PAGE_SIZE buffer at PAGE_SIZE - 1024 offset.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > >  drivers/net/wireless/mediatek/mt76/mt76.h          |  3 +-
> > >  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 11 --------
> > >  .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 32 +++++++---------------
> > >  drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    | 11 --------
> > >  drivers/net/wireless/mediatek/mt76/usb.c           |  1 -
> > >  drivers/net/wireless/mediatek/mt76/usb_mcu.c       | 31 +++------------------
> > >  6 files changed, 15 insertions(+), 74 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> > > index 6092646014c4..c9b5eb9b0582 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> > > +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> > > @@ -384,8 +384,7 @@ struct mt76_usb {
> > >  
> > >  	struct mt76u_mcu {
> > >  		struct mutex mutex;
> > > -		struct completion cmpl;
> > 
> > Hi Stanislaw,
> > 
> > I was reviewing this approach and I guess it is a little bit racey since now we
> > are not sure that when the device is removed or suspended the pending mcu commands
> > are terminated and we do not have any api to stop usb transactions.
> > Are we sure when we access mt76x02_dev/mt76_dev structure it has not been
> > already removed?
> > Maybe we need to maintain the completion in mt76u_mcu and use it to wait the mcu
> > commands are terminated.
> 
> I don't think so. On suspend we do mt76xxu_mac_stop() which access registers
> using mcu commands, all should be synchronized by mcu->mutex . All other
> process that could use mcu command should be already stopped. Actually suspend
> can be simplified.

ack, I missed mcu->mutex. Thx.

Regards,
Lorenzo

> 
> Device remove should be properly handled by -ENODEV error returned by
> usb_bulk_msg.
> 
> Stanislaw
