Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1538BECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 08:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D70C621476
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 08:57:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D70C621476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbeJSRCt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:02:49 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:54022 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbeJSRCt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:02:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id B88C923F5D5;
        Fri, 19 Oct 2018 10:57:36 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id a_RXTW9CRsgI; Fri, 19 Oct 2018 10:57:35 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id 7FD8323F6C8;
        Fri, 19 Oct 2018 10:57:35 +0200 (CEST)
Date:   Fri, 19 Oct 2018 10:57:28 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] nfc: pn533: add UART phy driver
Message-ID: <20181019085728.GA26696@lem-wkst-02.lemonage>
References: <20181018144251.30028-1-poeschel@lemonage.de>
 <6CB47B97-F58D-4162-98C1-8C8C88CE2914@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6CB47B97-F58D-4162-98C1-8C8C88CE2914@holtmann.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 18, 2018 at 05:00:28PM +0200, Marcel Holtmann wrote:
> Hi Lars,
> 
> > This adds the UART phy interface for the pn533 driver.
> > The pn533 driver can be used through UART interface this way.
> > It is implemented as a serdev device.
> > 
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> > ---
> > Changes in v2:
> > - switched from tty line discipline to serdev, resulting in many
> >  simplifications
> > - SPDX License Identifier
> > 
> > drivers/nfc/pn533/Kconfig  |  10 ++
> > drivers/nfc/pn533/Makefile |   2 +
> > drivers/nfc/pn533/pn533.h  |   8 ++
> > drivers/nfc/pn533/uart.c   | 283 +++++++++++++++++++++++++++++++++++++
> > 4 files changed, 303 insertions(+)
> > create mode 100644 drivers/nfc/pn533/uart.c
> > 
> > diff --git a/drivers/nfc/pn533/Kconfig b/drivers/nfc/pn533/Kconfig
> > index d94122dd30e4..da3ea2dbaa8a 100644
> > --- a/drivers/nfc/pn533/Kconfig
> > +++ b/drivers/nfc/pn533/Kconfig
> > @@ -25,3 +25,13 @@ config NFC_PN533_I2C
> > 
> > 	  If you choose to build a module, it'll be called pn533_i2c.
> > 	  Say N if unsure.
> > +
> > +config NFC_PN532_UART
> > +	tristate "NFC PN532 device support (UART)”
> 
> you are missing the "depends on SERIAL_DEV_BUS” here.

Yes, absolutely right. I missed that. I will post a follow-up.

BTW a question:
Only enabling SERIAL_DEV_BUS did not suffice for me. I also had to
enable SERIAL_DEV_CTRL_TTYPORT, otherwise the probe of the driver was
not called. This seems a bit odd to me. This option seems unrelated, but
without it, it did not work.

Should I better depend on SERIAL_DEV_CTRL_TTYPORT then ?

Thanks,
Lars
