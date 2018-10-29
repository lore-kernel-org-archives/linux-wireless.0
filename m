Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48302C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 11:07:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA6E52064C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 11:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fkti537c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA6E52064C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbeJ2TzQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 15:55:16 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35390 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbeJ2TzP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 15:55:15 -0400
Received: by mail-lf1-f65.google.com with SMTP id d7-v6so5666151lfi.2;
        Mon, 29 Oct 2018 04:07:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=FOCrY6C6LY1qMKaDyhet23xMCETdYNcQeghglHoE/EM=;
        b=Fkti537crTS2rpU12vjxlt7+K8fYBpcH5tRsFEgzGQ0GovzO3rSRSqc14d2q1G3DF5
         OW0UnSrkkT1gxUibJQXRrrueQur47klE906L4NFjkZNE8IuMtxHasHe6aM9nW8MZ0B90
         3XH1hu9x4nn3Q0DXLWD4WRg2IdygjvmlXXSuuO3pe/zGpmviXfPwlizLl73tLUdSlXdd
         X/1cjzzQiVhZ+WQjWfqWOyZwGSxMOYJS0e6xQCoJPEJMvhReoh3uAgcZxq9w3tUb3NMx
         lJs4zxUkqW1Z9aXN3VM5H/TsifdUNNWbA9jCpUZ0hkj0DDWk2ATLwqNs+G27QCB9cRfc
         lF6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=FOCrY6C6LY1qMKaDyhet23xMCETdYNcQeghglHoE/EM=;
        b=oMnD3lsA8cotMzE7V59iytJ+DKEKx8TDXvHRnhER4hKFg7lXwxTUpsjD/2JcIocv7u
         wS7tdjYhT2tO7qZ7Ht2/m9m02LpHzlSBCsIkDDUlroDO7KVqWdv3zWYCapZOUXr1OsUo
         D3/edQAnflyIi75O+EHAEMP9+B74VJpHQqA59L4BzDoXZGHhFX6zz59vYaQA9d3p8TLl
         e+cjyv7OpY3e2R7UgOWxiPdJEPVnRhHYtKIEkX63IbU5psvS7dD2h8I7y81SYNxFZqBd
         pC9tD83sQQEhNNQAN3P/kpPrKlQk4Z1ik825I0wP9mbJqIqtsZ4/FLOjJBggwsA7UDb0
         1hMw==
X-Gm-Message-State: AGRZ1gLMTmeYxswN9YTVoFithMT8sbtYHPDbLwQHcQK4OwNa44dmWmmU
        xoBfSVo4bbY6sQ2o4CWJVSE=
X-Google-Smtp-Source: AJdET5fkxhJdeOsFQtxycfu03KpLOuaAnwo8hZS++H1SxDuMzu+l9DExzIBojznkE9793ByJ6BGkFw==
X-Received: by 2002:a19:5059:: with SMTP id z25mr7941732lfj.120.1540811221412;
        Mon, 29 Oct 2018 04:07:01 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id b22sm2061959lfg.32.2018.10.29.04.06.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Oct 2018 04:06:59 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gH5Nw-0002ja-TS; Mon, 29 Oct 2018 12:07:04 +0100
Date:   Mon, 29 Oct 2018 12:07:04 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Johan Hovold <johan@kernel.org>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] nfc: pn533: add UART phy driver
Message-ID: <20181029110704.GQ27852@localhost>
References: <20181025132937.24405-1-poeschel@lemonage.de>
 <20181025132937.24405-3-poeschel@lemonage.de>
 <20181028102725.GL27852@localhost>
 <20181029100246.GA5905@lem-wkst-02.lemonage>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181029100246.GA5905@lem-wkst-02.lemonage>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 29, 2018 at 11:02:46AM +0100, Lars Poeschel wrote:
> Hi Johan,
> 
> thank you very much for the review!
> 
> On Sun, Oct 28, 2018 at 11:27:25AM +0100, Johan Hovold wrote:
> > On Thu, Oct 25, 2018 at 03:29:34PM +0200, Lars Poeschel wrote:
> > > This adds the UART phy interface for the pn533 driver.
> > > The pn533 driver can be used through UART interface this way.
> > > It is implemented as a serdev device.
> > 
> > Just a few drive-by comments below.

> > > +/*
> > > + * Driver for NXP PN532 NFC Chip - UART transport layer
> > > + *
> > > + * Copyright (C) 2018 Lemonage Software GmbH
> > > + * Author: Lars Pöschel <poeschel@lemonage.de>
> > > + * All rights reserved.
> > > + */
> > 
> > > +#define VERSION "0.1"
> > 
> > We don't version kernel drivers individually, so please drop this here
> > and below.
> 
> There was a comment from Marcel about this as well and I read it as: You
> can do it, but it is not required and nobody really cares.
> I included this, because the other pn532 phy driver (i2c) is doing it
> this way, but I don't like it either, so I will drop this, as well as
> the PN532_UART_DRIVER_NAME define in the next version.

Sounds good.

> > > +static int pn532_uart_probe(struct serdev_device *serdev)
> > > +{
> > > +	struct pn532_uart_phy *pn532;
> > > +	struct pn533 *priv;
> > > +	int err;
> > > +
> > > +	err = -ENOMEM;
> > > +	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);
> > > +	if (pn532 == NULL)
> > 
> > I'd use !pn532 here (and elsewhere).
> 
> I will change it.
> 
> > > +		goto err_exit;
> > > +
> > > +	pn532->recv_skb = alloc_skb(PN532_UART_SKB_BUFF_LEN, GFP_KERNEL);
> > > +	if (pn532->recv_skb == NULL)
> > > +		goto err_free;
> > > +
> > > +	pn532->serdev = serdev;
> > > +	priv = pn533_register_device(PN533_DEVICE_PN532,
> > > +				     PN533_NO_TYPE_B_PROTOCOLS,
> > > +				     PN533_PROTO_REQ_ACK_RESP,
> > > +				     pn532, &uart_phy_ops, NULL,
> > > +				     &pn532->serdev->dev,
> > > +				     &serdev->dev);
> > > +
> > 
> > Stray new line.
> 
> Ok.
> 
> > > +	if (IS_ERR(priv)) {
> > > +		err = PTR_ERR(priv);
> > > +		goto err_skb;
> > > +	}
> > 
> > Should you not set up your device fully before registering it? I'd
> > assume you could get callbacks from NFC core here.
> 
> I did not see any during my tests, but you are right: It feels a bit
> odd.
> The i2c driver is also requesting irqs after registering.
> The pn533_finalize_setup() has to be last.
> I could do the serdev_* stuff before, but ...
> 
> > > +
> > > +	pn532->priv = priv;
> > > +	serdev_device_set_drvdata(serdev, pn532);
> > > +	serdev_device_set_client_ops(serdev, &pn532_serdev_ops);
> > > +	err = serdev_device_open(serdev);
> > > +	if (err) {
> > > +		dev_err(&serdev->dev, "Unable to open device %s\n",
> > > +				serdev->dev.init_name);
> > 
> > dev_err will include the device name so you can drop the init_name bit.
> 
> Ok, i drop it.
> 
> > > +		goto err_unregister;
> > > +	}
> > 
> > Keeping the serial device open at all times will prevent low power
> > states on some platforms. Wouldn't it be possible to open the device
> > when the nfc interface is brought up (and during setup)?
> 
> ... that would then be contrary to this idea.

Not necessarily, that depends on what callbacks you can expect and at
what time.

> Also I don't see how to implement it with what is there today. i2c also
> does not do something similar.

But i2c doesn't have the concept of an "open" port consuming power.

> It can be done with adding some callbacks from the core (pn533.c) driver
> to it's phy drivers.

Haven't looked at it in any detail, but in general serdev driver should
only keep the port open while the device is in use.

I only noticed that nfc core has dev_up/down callbacks which looks like
they could be used for something like this.

> Wouldn't that be the scope of another later patch then ?

Possibly. We have accepted some serdev drivers already taking the lazy
approach of opening the port in probe. Depending on the driver, it may
not be too bad (e.g. for some specific hardware which you know you'll
always use), but it not really nice to have everyone pay a price in
terms of power-consumption for a feature that is rarely used.

Johan
