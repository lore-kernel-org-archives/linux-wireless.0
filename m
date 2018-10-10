Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0D2C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C82F2086E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 20:12:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C82F2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbeJKDf4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 23:35:56 -0400
Received: from fudo.makrotopia.org ([185.142.180.71]:49079 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbeJKDf4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 23:35:56 -0400
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
         (Exim 4.90_1)
        (envelope-from <daniel@makrotopia.org>)
        id 1gAKpx-0000NO-H8; Wed, 10 Oct 2018 22:12:07 +0200
Date:   Wed, 10 Oct 2018 22:11:51 +0200
From:   Daniel Golle <daniel@makrotopia.org>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 4/4] rt2800: comment and simplify AGC init for RT6352
Message-ID: <20181010201149.GA17530@makrotopia.org>
References: <1539186380-31949-1-git-send-email-sgruszka@redhat.com>
 <1539186380-31949-5-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJfQuFee4P-cnp_7bKGmoUTTxnkCfXoovqsGxs72+gCLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVJfQuFee4P-cnp_7bKGmoUTTxnkCfXoovqsGxs72+gCLg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 10:09:14PM +0200, Tom Psyborg wrote:
> it's 6352 dude

true. thanks for the review!

> 
> On 10/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > We do not need separate lines for calculating register values.
> > Also add comment that value is different than in vendor driver.
> >
> > Suggested-by: Daniel Golle <daniel@makrotopia.org>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > index a2cdd3a5034a..7b6effaa0740 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > @@ -3986,9 +3986,12 @@ static void rt2800_config_channel(struct rt2x00_dev
> > *rt2x00dev,
> >  		rt2800_bbp_write(rt2x00dev, 195, 141);
> >  		rt2800_bbp_write(rt2x00dev, 196, reg);
> >
> > -		/* AGC init */
> > -		reg = rf->channel <= 14 ? 0x1c : 0x24;
> > -		reg += 2 * rt2x00dev->lna_gain;
> > +		/* AGC init.
> > +		 * Despite the vendor driver using different values here for
> > +		 * RT6362 chip, we use 0x1c for now. This may have to be changed
> > +		 * once TSSI got implemented.
> > +		 */
> > +		reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2*rt2x00dev->lna_gain;
> >  		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
> >
> >  		rt2800_iq_calibrate(rt2x00dev, rf->channel);
> > --
> > 2.7.5
> >
> >
