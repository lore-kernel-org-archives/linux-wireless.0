Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F87C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 15:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B34AB20880
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 15:51:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B34AB20880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbeJ3Akc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 20:40:32 -0400
Received: from smtp3-1.goneo.de ([85.220.129.38]:34507 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727659AbeJ3Akc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 20:40:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp3.goneo.de (Postfix) with ESMTP id 8772423F072;
        Mon, 29 Oct 2018 16:51:17 +0100 (CET)
X-Virus-Scanned: by goneo
Received: from smtp3.goneo.de ([127.0.0.1])
        by localhost (smtp3.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EA2jYeAogVKE; Mon, 29 Oct 2018 16:51:16 +0100 (CET)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp3.goneo.de (Postfix) with ESMTPSA id 3271123F03B;
        Mon, 29 Oct 2018 16:51:16 +0100 (CET)
Date:   Mon, 29 Oct 2018 16:51:10 +0100
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Johan Hovold <johan@kernel.org>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] nfc: pn533: add UART phy driver
Message-ID: <20181029155110.GA12914@lem-wkst-02.lemonage>
References: <20181025132937.24405-1-poeschel@lemonage.de>
 <20181025132937.24405-3-poeschel@lemonage.de>
 <20181028102725.GL27852@localhost>
 <20181029100246.GA5905@lem-wkst-02.lemonage>
 <20181029110704.GQ27852@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181029110704.GQ27852@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 29, 2018 at 12:07:04PM +0100, Johan Hovold wrote:
> > > > +static int pn532_uart_probe(struct serdev_device *serdev)
> > > > +{
> > > > +	struct pn532_uart_phy *pn532;
> > > > +	struct pn533 *priv;
> > > > +	int err;
> > > > +
> > > > +	err = -ENOMEM;
> > > > +	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
> > > > +	if (pn532 == NULL)
> > > 
> > > I'd use !pn532 here (and elsewhere).
> > 
> > I will change it.
> > 
> > > > +		goto err_exit;
> > > > +
> > > > +	pn532->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
> > > > +	if (pn532->recv_skb == NULL)
> > > > +		goto err_free;
> > > > +
> > > > +	pn532->serdev = serdev;
> > > > +	priv = pn533_register_device(PN533_DEVICE_PN532,
> > > > +				     PN533_NO_TYPE_B_PROTOCOLS,
> > > > +				     PN533_PROTO_REQ_ACK_RESP,
> > > > +				     pn532, &uart_phy_ops, NULL,
> > > > +				     &pn532->serdev->dev,
> > > > +				     &serdev->dev);
> > > > +
> > > 
> > > Stray new line.
> > 
> > Ok.
> > 
> > > > +	if (IS_ERR(priv)) {
> > > > +		err = PTR_ERR(priv);
> > > > +		goto err_skb;
> > > > +	}
> > > 
> > > Should you not set up your device fully before registering it? I'd
> > > assume you could get callbacks from NFC core here.
> > 
> > I did not see any during my tests, but you are right: It feels a bit
> > odd.
> > The i2c driver is also requesting irqs after registering.
> > The pn533_finalize_setup() has to be last.
> > I could do the serdev_* stuff before, but ...
> > 
> > > > +
> > > > +	pn532->priv = priv;
> > > > +	serdev_device_set_drvdata(serdev, pn532);
> > > > +	serdev_device_set_client_ops(serdev, &pn532_serdev_ops);
> > > > +	err = serdev_device_open(serdev);
> > > > +	if (err) {
> > > > +		dev_err(&serdev->dev, "Unable to open device %s\n",
> > > > +				serdev->dev.init_name);
> > > 
> > > dev_err will include the device name so you can drop the init_name bit.
> > 
> > Ok, i drop it.
> > 
> > > > +		goto err_unregister;
> > > > +	}
> > > 
> > > Keeping the serial device open at all times will prevent low power
> > > states on some platforms. Wouldn't it be possible to open the device
> > > when the nfc interface is brought up (and during setup)?
> > 
> > ... that would then be contrary to this idea.
> 
> Not necessarily, that depends on what callbacks you can expect and at
> what time.
> 
> > Also I don't see how to implement it with what is there today. i2c also
> > does not do something similar.
> 
> But i2c doesn't have the concept of an "open" port consuming power.
> 
> > It can be done with adding some callbacks from the core (pn533.c) driver
> > to it's phy drivers.
> 
> Haven't looked at it in any detail, but in general serdev driver should
> only keep the port open while the device is in use.
> 
> I only noticed that nfc core has dev_up/down callbacks which looks like
> they could be used for something like this.

Yes, this is to the nfc core. But my uart phy driver binds to the pn533
driver and this does then register to nfc core. So this needs some more
changes to pn533 driver to be able to be informed of dev_up/down.
I'll look into this tomorrow.

> > Wouldn't that be the scope of another later patch then ?
> 
> Possibly. We have accepted some serdev drivers already taking the lazy
> approach of opening the port in probe. Depending on the driver, it may
> not be too bad (e.g. for some specific hardware which you know you'll
> always use), but it not really nice to have everyone pay a price in
> terms of power-consumption for a feature that is rarely used.

Is there a way in serdev to close a port, but still occupy it ?
I'd like to do the basic chip initialisation in _probe and then close
the port for power-consuption reasons. I'd like to have the port still
occupied, so that it's not available to other possible users in the
meantime. I'd then do a serdev open again in dev_up and really use it
from there.
dev_down is then for serdev close and also still occupy it.
closing and releasing would then be done in _remove.

Regards,
Lars
