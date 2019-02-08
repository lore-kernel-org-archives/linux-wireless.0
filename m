Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F216C169C4
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 06:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFF302147C
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 06:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TYNInsNO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfBHGlZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 01:41:25 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38023 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfBHGlY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 01:41:24 -0500
Received: by mail-yw1-f66.google.com with SMTP id o184so995659ywo.5
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 22:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1lv7yjcqEphMyRGP0QAna0D/hh1/JGnj1Xyg9vThjJ8=;
        b=TYNInsNOexztZ5Y/K0ZaBxnutqWf+X404/cMiixNneRwWDAJna5vR2MFtqvWvGeNEy
         LVGzfllFR5zC0D1QHktahtdgZtey/VswrYmnVqAQB63Tpno94BEn1Op+6nF1EfyEYlWq
         ivpqDdO4H7FQVO8FUmT/V0i+M+GE2o2cWvSEBJES1WGg5vpuRzH+N6qnP4RicKCmJk7S
         sEwr1G75UvgKEMJ+6cH7uNnpirPmwEuUVf5vT0VSUPCBbbQHNDRPirkH5M8WgzeA7Xw5
         ggYw/navddi4TDzrCWLQJH1USHtlTol7hPT2/waAdoZdxOtmbkE7DQX7MhmRd81s1ZsF
         R1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1lv7yjcqEphMyRGP0QAna0D/hh1/JGnj1Xyg9vThjJ8=;
        b=LGwKSrMSeOqlseaFHMjFd+Y7HR22G/LfpFn+8uNi6JO+t8rJpbYdSSTJc/u8Wcodqi
         qsyYnEMh5tAoFySCxbEi+2V0IYgZ5RD79wBq/KKcbUtoibFuF9hwCcPU9HvQFuyNfhu+
         Y92tFObOo/Fx4VBGS76RMM5693AHjDDrTXxqut+EO7lUKC4W0JtxeuY5gQgIuC2W0m7L
         EZBNSJcnM7F2TQ0BLJ8RbPeBuOclpzlRiRskrEucRcV7aq+u0S86qZGeVhkjEzGFxc0T
         2Rvh+98fLCLkE96wGdtDjr9Koi3WxD8DNv/T/AlAOVIDBurEUlJfLx4jtUAKcM/il4M7
         0TjQ==
X-Gm-Message-State: AHQUAuaOdQpoHQv5IzX9JAKemqPw6fVas8B+V2DP8O54z8kzPNb7ogZu
        TUEoLooIQXkuBj4gqB3ZX35y3x+4Ym6XtZN8O1U=
X-Google-Smtp-Source: AHgI3IavCFPvTRp1pLi9goMPBimUrhObfEvEPEbXl2/eqT0AFftkFpsbBrHJINdS71vXraTerZVFt9dbqubO/yFXkKg=
X-Received: by 2002:a81:71c5:: with SMTP id m188mr16436702ywc.353.1549608083593;
 Thu, 07 Feb 2019 22:41:23 -0800 (PST)
MIME-Version: 1.0
References: <20190122110858.12993-1-zajec5@gmail.com> <20190207163638.53A20607DF@smtp.codeaurora.org>
In-Reply-To: <20190207163638.53A20607DF@smtp.codeaurora.org>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Fri, 8 Feb 2019 07:41:12 +0100
Message-ID: <CACna6rz-hYjZCrmJ-jW9hzXj7fAMqED-xa2UKyAxoKZ7sSKi9Q@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: support monitor frames with hardware/ucode header
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 7 Feb 2019 at 17:36, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafa=C5=82 Mi=C5=82ecki wrote:
>
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >
> > The new FullMAC firmwares for 4366b1/4366c0 were supposed to provide
> > monitor frames with radiotap header but it doesn't seem to be the case.
> > Testing the latest release resulted in discovering a new format being
> > used. It seems (almost?) identical to the one known from ucode used in
> > SoftMAC devices which is most likely the same codebase anyway.
> >
> > While radiotap support was meant to be announced with the "rtap" fw
> > capability string it seems no alternative was added for the hw/ucode
> > format. It means each firmware requires a feature mapping quirk.
> >
> > As for now only an empty radiotap is being created. Adding support for
> > extracting some info (band, channel, signal, etc.) is planned for the
> > future.
> >
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> It's unclear what I should do with this patch, take it?

It seems to me there are no objections regarding the code. It was only
my commit message that was a bit confusing. I'll send V2 with updated
commit message.

--=20
Rafa=C5=82
