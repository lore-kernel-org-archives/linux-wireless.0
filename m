Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77DAECDE3D
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 09:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADF5F2150C
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 09:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bhdkmBPW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADF5F2150C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbeJTRhV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 13:37:21 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46306 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbeJTRhV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 13:37:21 -0400
Received: by mail-lf1-f67.google.com with SMTP id p143-v6so15905052lfp.13;
        Sat, 20 Oct 2018 02:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Qu/t0CJCIfwyDrIzO0mMGnEbopBsDAXlovlsCl39rdQ=;
        b=bhdkmBPW92+tMmYAou19kqwLQmE3EWyRKau3/ddCWcAkZvKZs8tDzUGrDWxONTqFan
         s7gPg6ByPDgoqf1ldBUVoANHenZIw9lVVeoRcUpDh1+ivH7uM8mlGr1Z19TnIT4diMt/
         0PbLU2r4ha9/u6OkDy9gCEWwyQGU+QwrNRmcA3wLvxTm6oAmpSu3/LpchlZxOiONcwU/
         sdI8txy1CpPWTi9pgSeUl7IpFzkws6CiBE0QWK5yu9pVxodofJ8wAJMu4RyFf7HLsA1t
         kpuUik9IPeK8is8FlqDKYuRWj1D+8rMOYRnIYae/IRWx1wubZzbJnOadUzuZsGQW2sb0
         ZZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=Qu/t0CJCIfwyDrIzO0mMGnEbopBsDAXlovlsCl39rdQ=;
        b=N2QvQf7XOswUx+EzSezD27g9B5PiNgdl65wzXoj7X0QitcnBMe3z+uOsn7gJJr2AVL
         f1A09TfYdAV9ILTOM4Ai0yhRQNnXOLhjWjr8SaxgFjX/m4qy4ViJqBRf0i5tLT13QRBo
         quIrxqmRo3qmgmh6vCQ8lQfrMfnCBIjvqFcXJ8AEBUMLUeVZL3e8xsHfZ+5bv3Sjbyi1
         p8HAG+4k1r+9RsGYcMDnC51L/iDnsCKI9jECSSgMgJWFQGykPHZEWqcMpVvzhZrJN2Fs
         /aVZDxIUqTmJEz2TuxmfzpMcTycDFJIVl90hjKRtky+JUS0RDXNIR/e0b4lHuaF/moA5
         5+QA==
X-Gm-Message-State: ABuFfogA7CNUgtiDvG9zXHoVROu52H6/PUp3YctfB8P+whCu6gLVE1vD
        IkNX9rUQ0CbAs77LgYaDzQqVcIfS
X-Google-Smtp-Source: ACcGV60q7mPzd0SciCCtu7D1RbaOXeBb81Lm/8yjNffP8NREDZ7o2KEddSBe7RzLc/cJwNA2sOHunw==
X-Received: by 2002:a19:a302:: with SMTP id m2mr62042lfe.108.1540027652845;
        Sat, 20 Oct 2018 02:27:32 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id z19-v6sm5668317ljk.20.2018.10.20.02.27.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 02:27:31 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gDnXh-0002gW-Ov; Sat, 20 Oct 2018 11:27:33 +0200
Date:   Sat, 20 Oct 2018 11:27:33 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Marcel Holtmann <marcel@holtmann.org>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] nfc: pn533: add UART phy driver
Message-ID: <20181020092733.GV3383@localhost>
References: <20181018144251.30028-1-poeschel@lemonage.de>
 <6CB47B97-F58D-4162-98C1-8C8C88CE2914@holtmann.org>
 <20181019085728.GA26696@lem-wkst-02.lemonage>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181019085728.GA26696@lem-wkst-02.lemonage>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 19, 2018 at 10:57:28AM +0200, Lars Poeschel wrote:
> On Thu, Oct 18, 2018 at 05:00:28PM +0200, Marcel Holtmann wrote:

> > > --- a/drivers/nfc/pn533/Kconfig
> > > +++ b/drivers/nfc/pn533/Kconfig
> > > @@ -25,3 +25,13 @@ config NFC_PN533_I2C
> > > 
> > > 	  If you choose to build a module, it'll be called pn533_i2c.
> > > 	  Say N if unsure.
> > > +
> > > +config NFC_PN532_UART
> > > +	tristate "NFC PN532 device support (UART)”
> > 
> > you are missing the "depends on SERIAL_DEV_BUS” here.
> 
> Yes, absolutely right. I missed that. I will post a follow-up.
> 
> BTW a question:
> Only enabling SERIAL_DEV_BUS did not suffice for me. I also had to
> enable SERIAL_DEV_CTRL_TTYPORT, otherwise the probe of the driver was
> not called. This seems a bit odd to me. This option seems unrelated, but
> without it, it did not work.
> 
> Should I better depend on SERIAL_DEV_CTRL_TTYPORT then ?

No, SERIAL_DEV_BUS is the correct (build-time) dependency.

In principle, your driver will work with any serdev-controller
implementation even if we currently only have one of those in the kernel
(and SERIAL_DEV_CTRL_TTYPORT therefore default to Y whenever
SERIAL_DEV_BUS is selected).

Johan
