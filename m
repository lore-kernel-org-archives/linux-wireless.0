Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E96EC2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 480292082B
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 10:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 480292082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbeJ2Su4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 14:50:56 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:39046 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729343AbeJ2Suz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 14:50:55 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id D672223F6CF;
        Mon, 29 Oct 2018 11:02:53 +0100 (CET)
X-Virus-Scanned: by goneo
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id v-9sRBtUDKAy; Mon, 29 Oct 2018 11:02:52 +0100 (CET)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id 5A83823F051;
        Mon, 29 Oct 2018 11:02:52 +0100 (CET)
Date:   Mon, 29 Oct 2018 11:02:46 +0100
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] nfc: pn533: add UART phy driver
Message-ID: <20181029100246.GA5905@lem-wkst-02.lemonage>
References: <20181025132937.24405-1-poeschel@lemonage.de>
 <20181025132937.24405-3-poeschel@lemonage.de>
 <20181028102725.GL27852@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181028102725.GL27852@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johan,

thank you very much for the review!

On Sun, Oct 28, 2018 at 11:27:25AM +0100, Johan Hovold wrote:
> On Thu, Oct 25, 2018 at 03:29:34PM +0200, Lars Poeschel wrote:
> > This adds the UART phy interface for the pn533 driver.
> > The pn533 driver can be used through UART interface this way.
> > It is implemented as a serdev device.
> 
> Just a few drive-by comments below.
> 
> > +// SPDX-License-Identifier: GPL-2.0
> 
> This should match MODULE_LICENSE below which currently says v2 *or
> later*.

Ok. Will change that to GPL-2.0+

> > +/*
> > + * Driver for NXP PN532 NFC Chip - UART transport layer
> > + *
> > + * Copyright (C) 2018 Lemonage Software GmbH
> > + * Author: Lars Pöschel <poeschel@lemonage.de>
> > + * All rights reserved.
> > + */
> 
> > +#define VERSION "0.1"
> 
> We don't version kernel drivers individually, so please drop this here
> and below.

There was a comment from Marcel about this as well and I read it as: You
can do it, but it is not required and nobody really cares.
I included this, because the other pn532 phy driver (i2c) is doing it
this way, but I don't like it either, so I will drop this, as well as
the PN532_UART_DRIVER_NAME define in the next version.

> > +static int pn532_uart_send_frame(struct pn533 *dev,
> > +				struct sk_buff *out)
> > +{
> > +	static const u8 wakeup[] = {
> > +		0x55, 0x55, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
> > +	/* wakeup sequence and dummy bytes for waiting time */
> 
> Comments should go above the code they apply to.

Ok.

> > +	struct pn532_uart_phy *pn532 = dev->phy;
> > +	int count;
> > +
> > +	print_hex_dump_debug("PN532_uart TX: ", DUMP_PREFIX_NONE, 16, 1,
> > +			     out->data, out->len, false);
> > +
> > +	pn532->cur_out_buf = out;
> > +	if (pn532->send_wakeup)
> > +		count = serdev_device_write(pn532->serdev,
> > +				wakeup, sizeof(wakeup),
> > +				MAX_SCHEDULE_TIMEOUT);
> 
> No error handling?

Yes, good point. Also the variable name is misleading. I will change
that.

> > +
> > +	count = serdev_device_write(pn532->serdev, out->data, out->len,
> > +			MAX_SCHEDULE_TIMEOUT);
> 
> Same here.

Ok.

> > +	if (PN533_FRAME_CMD(((struct pn533_std_frame *)out->data)) ==
> > +			PN533_CMD_SAM_CONFIGURATION)
> > +		pn532->send_wakeup = 0;
> > +
> > +	mod_timer(&pn532->cmd_timeout, HZ / 40 + jiffies);
> > +	return 0;
> > +}
> > +
> > +static int pn532_uart_send_ack(struct pn533 *dev, gfp_t flags)
> > +{
> > +	struct pn532_uart_phy *pn532 = dev->phy;
> > +	static const u8 ack[PN533_STD_FRAME_ACK_SIZE] = {
> > +			0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
> > +	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
> 
> Same as above.

Ok.

> > +	int rc;
> > +
> > +	rc = serdev_device_write(pn532->serdev, ack, sizeof(ack),
> > +			MAX_SCHEDULE_TIMEOUT);
> 
> Error handling.

Ok.

> > +
> > +	return 0;
> > +}
> 
> > +static int pn532_uart_probe(struct serdev_device *serdev)
> > +{
> > +	struct pn532_uart_phy *pn532;
> > +	struct pn533 *priv;
> > +	int err;
> > +
> > +	err = -ENOMEM;
> > +	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
> > +	if (pn532 == NULL)
> 
> I'd use !pn532 here (and elsewhere).

I will change it.

> > +		goto err_exit;
> > +
> > +	pn532->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
> > +	if (pn532->recv_skb == NULL)
> > +		goto err_free;
> > +
> > +	pn532->serdev = serdev;
> > +	priv = pn533_register_device(PN533_DEVICE_PN532,
> > +				     PN533_NO_TYPE_B_PROTOCOLS,
> > +				     PN533_PROTO_REQ_ACK_RESP,
> > +				     pn532, &uart_phy_ops, NULL,
> > +				     &pn532->serdev->dev,
> > +				     &serdev->dev);
> > +
> 
> Stray new line.

Ok.

> > +	if (IS_ERR(priv)) {
> > +		err = PTR_ERR(priv);
> > +		goto err_skb;
> > +	}
> 
> Should you not set up your device fully before registering it? I'd
> assume you could get callbacks from NFC core here.

I did not see any during my tests, but you are right: It feels a bit
odd.
The i2c driver is also requesting irqs after registering.
The pn533_finalize_setup() has to be last.
I could do the serdev_* stuff before, but ...

> > +
> > +	pn532->priv = priv;
> > +	serdev_device_set_drvdata(serdev, pn532);
> > +	serdev_device_set_client_ops(serdev, &pn532_serdev_ops);
> > +	err = serdev_device_open(serdev);
> > +	if (err) {
> > +		dev_err(&serdev->dev, "Unable to open device %s\n",
> > +				serdev->dev.init_name);
> 
> dev_err will include the device name so you can drop the init_name bit.

Ok, i drop it.

> > +		goto err_unregister;
> > +	}
> 
> Keeping the serial device open at all times will prevent low power
> states on some platforms. Wouldn't it be possible to open the device
> when the nfc interface is brought up (and during setup)?

... that would then be contrary to this idea.
Also I don't see how to implement it with what is there today. i2c also
does not do something similar.
It can be done with adding some callbacks from the core (pn533.c) driver
to it's phy drivers.
Wouldn't that be the scope of another later patch then ?

Thanks again,
Lars
