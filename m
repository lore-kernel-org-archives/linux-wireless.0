Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5B1ECDE46
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 13:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1FB22075D
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 13:29:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1FB22075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbeJYWBu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 18:01:50 -0400
Received: from smtp3-1.goneo.de ([85.220.129.38]:41213 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbeJYWBt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 18:01:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 5804323F072;
        Thu, 25 Oct 2018 15:29:01 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ydqys9l-vPVl; Thu, 25 Oct 2018 15:29:00 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPSA id 3E4BC23EFF1;
        Thu, 25 Oct 2018 15:29:00 +0200 (CEST)
Date:   Thu, 25 Oct 2018 15:28:55 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] nfc: pn533: add UART phy driver
Message-ID: <20181025132854.GA24350@lem-wkst-02.lemonage>
References: <20181018144251.30028-1-poeschel@lemonage.de>
 <6CB47B97-F58D-4162-98C1-8C8C88CE2914@holtmann.org>
 <20181019085728.GA26696@lem-wkst-02.lemonage>
 <20181020092733.GV3383@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181020092733.GV3383@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Oct 20, 2018 at 11:27:33AM +0200, Johan Hovold wrote:
> On Fri, Oct 19, 2018 at 10:57:28AM +0200, Lars Poeschel wrote:
> > On Thu, Oct 18, 2018 at 05:00:28PM +0200, Marcel Holtmann wrote:
> 
> > > > --- a/drivers/nfc/pn533/Kconfig
> > > > +++ b/drivers/nfc/pn533/Kconfig
> > > > @@ -25,3 +25,13 @@ config NFC_PN533_I2C
> > > > 
> > > > 	  If you choose to build a module, it'll be called pn533_i2c.
> > > > 	  Say N if unsure.
> > > > +
> > > > +config NFC_PN532_UART
> > > > +	tristate "NFC PN532 device support (UART)”
> > > 
> > > you are missing the "depends on SERIAL_DEV_BUS” here.
> > 
> > Yes, absolutely right. I missed that. I will post a follow-up.
> > 
> > BTW a question:
> > Only enabling SERIAL_DEV_BUS did not suffice for me. I also had to
> > enable SERIAL_DEV_CTRL_TTYPORT, otherwise the probe of the driver was
> > not called. This seems a bit odd to me. This option seems unrelated, but
> > without it, it did not work.
> > 
> > Should I better depend on SERIAL_DEV_CTRL_TTYPORT then ?
> 
> No, SERIAL_DEV_BUS is the correct (build-time) dependency.
> 
> In principle, your driver will work with any serdev-controller
> implementation even if we currently only have one of those in the kernel
> (and SERIAL_DEV_CTRL_TTYPORT therefore default to Y whenever
> SERIAL_DEV_BUS is selected).

Thanks, this makes sense for me now.
I will post a follow-up patchset shortly.

Regards,
Lars
