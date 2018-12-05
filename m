Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8406C04EBF
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 15:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 818B22084C
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 15:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GYk6jDYI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 818B22084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbeLEP3x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 10:29:53 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35358 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbeLEP3x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 10:29:53 -0500
Received: by mail-lj1-f196.google.com with SMTP id x85-v6so18724360ljb.2;
        Wed, 05 Dec 2018 07:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hqh55ZpQu4kLll1eIkjGjqKf2zcc+i/G0xCQhidr/ds=;
        b=GYk6jDYIR5x4a9/kbzOoQ5CecVYCvkBn0dJef6SlDqJJTeLa4lG7KKjFJJHd7sKh/E
         mEvnNBDhTPDSlIA58INT5LA34qsSV8LDBwMzW3aNYwJyytwF2qbCJmwhLs3f560vv4d4
         plDY1IN3glo7IrfcGnW5WXWMpe3P9FigmGDSY2Avm8XstVInz56yYotsIwwAlNekniYc
         7RJfPUF7LrSnGZ680fxkvQ+gOXLRhlq3PnGCXz/K3m9jMJ0/H6PY2UlP9fB4U+52bcoS
         VCqlkZjD63RoSU+uZBugBR5F/jOJtGDFDgT9MRjs+gninJGW+UD/f1j1pS91Ix1GZYyb
         rA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hqh55ZpQu4kLll1eIkjGjqKf2zcc+i/G0xCQhidr/ds=;
        b=HynR1cinX0suhiuGfAL3AGt6U8A+3Ku3rrCmMJuGcvRRi1ypDXgMpcjpUEX7dI8vcE
         HWdw9urY1s58r7+x+a7a0jMMXh2kqYXGTcurTLmUALgNJpoHiou5YeodUR8Ms5oP7CxC
         1IY7lFBjer7P3wCHkNTzhjaiNtJp52VFs0CZseUuvFfjw45N7yjrfpw3QBM+Lp67T33m
         zZHkZNPyPLLHxfrSjIvEQ1hjZ/G+KgmBxr2eTqyXuJaZy5fZmBCJPew1UpQRF3D7SBQ2
         brdAZIOaZPbttswDgety07bzE86dqfOVjvUIg8sDY0Zqc4BSK49mSMBtizcutJRGvnKp
         8fmA==
X-Gm-Message-State: AA+aEWZas/DCNZhqELcVkJ+weYlawtnTa8/WGO8ZOf/8FPWkduKrhbXl
        QCm3XhT+N09B/RCVAPnappQDGVao
X-Google-Smtp-Source: AFSGD/U7FmjZzsPlH4zSRVSbyR4WxhhsIZNWbSX/LAqraoc9+XOkBX/2SRp9z1QdmPRfaEpDm5MjFQ==
X-Received: by 2002:a2e:7317:: with SMTP id o23-v6mr17461684ljc.67.1544023790300;
        Wed, 05 Dec 2018 07:29:50 -0800 (PST)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id p19-v6sm3882085ljb.47.2018.12.05.07.29.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Dec 2018 07:29:49 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gUZ7Y-0004A7-2c; Wed, 05 Dec 2018 16:29:52 +0100
Date:   Wed, 5 Dec 2018 16:29:52 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Johan Hovold <johan@kernel.org>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] nfc: pn533: add UART phy driver
Message-ID: <20181205152952.GK15689@localhost>
References: <20181101100216.613-1-poeschel@lemonage.de>
 <20181101100216.613-4-poeschel@lemonage.de>
 <20181114153517.GB19900@localhost>
 <20181203142622.GA8057@lem-wkst-02.lemonage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203142622.GA8057@lem-wkst-02.lemonage>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 03, 2018 at 03:26:22PM +0100, Lars Poeschel wrote:
> On Wed, Nov 14, 2018 at 04:35:17PM +0100, Johan Hovold wrote:
> > On Thu, Nov 01, 2018 at 11:02:12AM +0100, Lars Poeschel wrote:
> > > This adds the UART phy interface for the pn533 driver.
> > > The pn533 driver can be used through UART interface this way.
> > > It is implemented as a serdev device.
> > > 
> > > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> > 
> > Please make sure to include reviewers on CC.
> 
> It's hard to do all things right, about how to correctly email patches,
> patch sets and follow ups and send what to whom.
> I am still learning. Sorry about that.

No problem, I fully understand that.

> > > +	err = serdev_device_open(serdev);
> > > +	if (err) {
> > > +		dev_err(&serdev->dev, "Unable to open device\n");
> > > +		goto err_skb;
> > > +	}
> > > +
> > > +	err = serdev_device_set_baudrate(serdev, 115200);
> > > +	if (err != 115200) {
> > > +		err = -EINVAL;
> > > +		goto err_serdev;
> > > +	}
> > > +
> > > +	serdev_device_set_flow_control(serdev, false);
> > > +	pn532->send_wakeup = PN532_SEND_WAKEUP;
> > > +	timer_setup(&pn532->cmd_timeout, pn532_cmd_timeout, 0);
> > > +	priv = pn533_register_device(PN533_DEVICE_PN532,
> > > +				     PN533_NO_TYPE_B_PROTOCOLS,
> > > +				     PN533_PROTO_REQ_ACK_RESP,
> > > +				     pn532, &uart_phy_ops, NULL,
> > > +				     &pn532->serdev->dev,
> > > +				     &serdev->dev);
> > > +	if (IS_ERR(priv)) {
> > > +		err = PTR_ERR(priv);
> > > +		goto err_serdev;
> > > +	}
> > > +
> > > +	pn532->priv = priv;
> > > +	err = pn533_finalize_setup(pn532->priv);
> > > +	if (err)
> > > +		goto err_unregister;
> > > +
> > > +	serdev_device_close(serdev);
> > 
> > This looks broken; what if the NFC interface is brought up before this
> > point? You'd get a double open, which is likely to crash things, but
> > even if you survive that, the port would not be closed despite the
> > interface being up.
> 
> I understand the problem and would like to solve it with a mutex. I will
> not have time to work on that until next year. Please be patient. I will
> send a new patchset.

I'm in no hurry here. :)

But I still think doing that setup before registering the device might
be preferred if it's possible as you wouldn't need a mutex then.

> > Can't you finalise your setup before registering the interface?
> 
> Well, propably I can do that. But I did it the way the other drivers
> (usb and i2c) are already doing and reusing the code of the pn533 core
> driver. Since their probe works very similar to mine, I suspect them to
> have the same problems.

Quite possibly.

> I can rewrite the probe for my driver, but not for the other two. I can
> not test them.
> Would you prefer that I rewrite my own _register_device and
> _finalize_setup functions, not using the ones from the core driver ?

If you add common paths that you can test using your driver I think it
should be fine to convert the others unless it ends up being really
complicated. Perhaps the authors of those driver can help out with
testing too.

> Thank you for your very valuable feedback.

You're welcome.

Johan
