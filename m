Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A5EC64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28EC82087D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:47:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28EC82087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbeJIUEh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 16:04:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbeJIUEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 16:04:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8FD13308424A;
        Tue,  9 Oct 2018 12:47:49 +0000 (UTC)
Received: from localhost (unknown [10.40.205.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29A74106A78E;
        Tue,  9 Oct 2018 12:47:49 +0000 (UTC)
Date:   Tue, 9 Oct 2018 14:47:48 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: Re: [PATCH v3 2/4] rt2x00: remove confusing AGC register
Message-ID: <20181009124747.GA31203@redhat.com>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-2-git-send-email-sgruszka@redhat.com>
 <20181009122720.GB2458@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009122720.GB2458@makrotopia.org>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Tue, 09 Oct 2018 12:47:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

On Tue, Oct 09, 2018 at 02:27:22PM +0200, Daniel Golle wrote:
> On Tue, Oct 09, 2018 at 01:56:08PM +0200,  Gruszka wrote:
> > Register 66 was causing issues on RT6352 if set to the same value as
> > in MTK driver. With 1c reg value device was working fine in both HT20
> > and HT40 modes.
> 
> My guess is that this may change once we add proper TSSI which involes
> parts of AGC init as well. I suggest to add a comment in the code to
> reflect that.

I don't understand what you suggest, could you be more specific ?

> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > index 1a2bf6c49b82..3a04eaef8511 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > @@ -3981,11 +3981,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
> >  		rt2800_bbp_write(rt2x00dev, 196, reg);
> >  
> >  		/* AGC init */
> > -		if (rt2x00_rt(rt2x00dev, RT6352))
> > -			reg = 0x04;
> > -		else
> > -			reg = rf->channel <= 14 ? 0x1c : 0x24;
> > -
> > +		reg = rf->channel <= 14 ? 0x1c : 0x24;
> >  		reg += 2 * rt2x00dev->lna_gain;
> 
> We can summerize the two lines into
> 		reg = 0x1c + (2 * rt2x00dev->lna_gain);
> which is also what is was before introducing support for MT7620.

I think you mean

reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2 * rt2x00dev->lna_gain; 

to do not break 5GHz support for RT5592.  I can change that in
separate patch, since this one in not technically wrong.

Thanks
Stanislaw

