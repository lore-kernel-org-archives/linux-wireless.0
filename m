Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAADEC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 08:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95319206B7
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 08:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfDCIh0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 04:37:26 -0400
Received: from smtp1.goneo.de ([85.220.129.30]:47804 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726862AbfDCIh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 04:37:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp1.goneo.de (Postfix) with ESMTP id 0961B23F3BE;
        Wed,  3 Apr 2019 10:37:22 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp1.goneo.de ([127.0.0.1])
        by localhost (smtp1.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Vj6QXwzTErxR; Wed,  3 Apr 2019 10:37:20 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp1.goneo.de (Postfix) with ESMTPSA id 1995323FB13;
        Wed,  3 Apr 2019 10:37:20 +0200 (CEST)
Date:   Wed, 3 Apr 2019 11:47:35 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     Johan Hovold <johan@kernel.org>
Subject: [PING 2] [PATCH v5 1/7] nfc: pn533: i2c: "pn532" as dt compatible
 string
Message-ID: <20190403094735.GA19351@lem-wkst-02.lemonage>
References: <20190111161812.26325-1-poeschel@lemonage.de>
 <20190228104801.GA14788@lem-wkst-02.lemonage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228104801.GA14788@lem-wkst-02.lemonage>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Second Ping.

Regards,
Lars

On Thu, Feb 28, 2019 at 11:48:01AM +0100, Lars Poeschel wrote:
> A gentle ping on this whole patch series.
> 
> Regards,
> Lars
> 
> On Fri, Jan 11, 2019 at 05:18:04PM +0100, Lars Poeschel wrote:
> > It is favourable to have one unified compatible string for devices that
> > have multiple interfaces. So this adds simply "pn532" as the devicetree
> > binding compatible string and makes a note that the old ones are
> > deprecated.
> > 
> > Cc: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> > ---
> > Changes in v3:
> > - This patch is new in v3
> > 
> >  drivers/nfc/pn533/i2c.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/nfc/pn533/i2c.c b/drivers/nfc/pn533/i2c.c
> > index 4389eb4c8d0b..f4eae9dd5305 100644
> > --- a/drivers/nfc/pn533/i2c.c
> > +++ b/drivers/nfc/pn533/i2c.c
> > @@ -258,6 +258,11 @@ static int pn533_i2c_remove(struct i2c_client *client)
> >  }
> >  
> >  static const struct of_device_id of_pn533_i2c_match[] = {
> > +	{ .compatible = "nxp,pn532", },
> > +	/*
> > +	 * NOTE: The use of the compatibles with the trailing "...-i2c" is
> > +	 * deprecated and will be removed.
> > +	 */
> >  	{ .compatible = "nxp,pn533-i2c", },
> >  	{ .compatible = "nxp,pn532-i2c", },
> >  	{},
> > -- 
> > 2.20.1
> > 
