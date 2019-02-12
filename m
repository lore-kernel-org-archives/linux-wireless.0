Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F5B1C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6670B20811
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:38:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="zCg8eRoX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfBLPi5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:38:57 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37521 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfBLPi5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 10:38:57 -0500
Received: by mail-ed1-f67.google.com with SMTP id m12so872829edv.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 07:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6pBqO3xp/1B0zFnqLcuHxvRhsA22yWdbUAXgQ9hiknQ=;
        b=zCg8eRoXWYBCsvybjdNlWj+M2/h3YmOBzi/7XcMpsOgtWZyBTfDzfFxs9XwhtBVn7T
         mRvFAAvf9bfpdznKU1/l08JzkwQQZ+iEoTylOSpMVyaPr88u7XU9a9275aT7QlImrFzp
         8QzaIFTC0iPrvIABUzL7JbEbHMwA3n0/kAJSck02gsez/RipoQhcIshWMF0dKWfdMKAV
         TlX1t/RENSvqxsedrT/t6PuKQ/5+wP2XRIcBsBp6j+4sLPVA+bgVCCsJgo45rSncaj5V
         +jcgMX/b8DMGoovR1lEin4/lluBTqn1a/CAFtZXyuaJWQJXteeSdYaJ0EYp6ismOqQn/
         MPEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6pBqO3xp/1B0zFnqLcuHxvRhsA22yWdbUAXgQ9hiknQ=;
        b=haPmMZorBqhkqxvTigp9mvu7mJRd9uoytP4mdm6URL7JtQ7IvPxZKnQBRkzrs8wnnY
         GUicyLXiCEmyiT0eiFyId3k6r+KvnsJvq5Vt+yJoHp+nzQJRYuMTCCqjomPaS68lCzlJ
         vym9ni+8wGN69vnvre1hJUzNIc+ATx2X0Z/ojWG72HzjDwy2k7QUnaC70eefOU8F3FkR
         2s/KzwqNAYpMIZv+b4Km8vLN4UqfCACl2j3VYUhg7+ZUW6HjipNaehqQjEoU4Imy9tf0
         sXsjOhfOI4rT+fZ+3eEQxCXP2KAyiQoq9UKYLygSuxgzJSYhIf/4bNbSooaqlJIIG2DM
         gRGA==
X-Gm-Message-State: AHQUAuZTpghOfhyvERcEVx+DzNk/GQzDAUc6OPTJ9mEjj4gbuun/C6no
        2HM4OufKzGA9MjUZ7d4IW+iGDmwwzA/7d3MVuIBlAg==
X-Google-Smtp-Source: AHgI3IaqXo4ydZf//Hn6G1eGoZsai+hu999Ws03JREaJu8Yt5Nhi1slh3Sw6Ef7qpTW+BCsvxCOOEEhxp79iAiXfAeQ=
X-Received: by 2002:a17:906:9a2:: with SMTP id q2mr3177416eje.40.1549985935042;
 Tue, 12 Feb 2019 07:38:55 -0800 (PST)
MIME-Version: 1.0
References: <CAL9uMOFT3VwqHs5+wvot+dxArvhd7Bi-U5+CKhYUXjYwHcU=jg@mail.gmail.com>
 <20180111103006.GA17574@thinktank.home.org> <14c5f7f4-0d5b-cecd-b45b-3672b67da07a@gmail.com>
 <CAL9uMOG77it=kqkbjryPVpY2eVJqqjedVeAhdxqpZM6Z8JWuiA@mail.gmail.com> <CAB4CAwd2WtWwf9p=kZZQ-SzE6DhsLu1OpGaVyS1Mq8wx8eT6ww@mail.gmail.com>
In-Reply-To: <CAB4CAwd2WtWwf9p=kZZQ-SzE6DhsLu1OpGaVyS1Mq8wx8eT6ww@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Tue, 12 Feb 2019 23:38:44 +0800
Message-ID: <CAB4CAwdkYSJBLODnS2_vgps8Ds+vhedSDVVRATMAz3OGhW_5=Q@mail.gmail.com>
Subject: Re: RTL8723bu: poor signal and connection troubles
To:     Carlo Caione <carlo@endlessm.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Barry Day <briselec@gmail.com>, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org,
        mylene.josserand@free-electrons.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 29, 2019 at 5:56 PM Chris Chiu <chiu@endlessm.com> wrote:
>
> On Mon, Jan 22, 2018 at 6:56 AM Carlo Caione <carlo@endlessm.com> wrote:
> >
> > On Sun, Jan 21, 2018 at 9:46 PM, Jes Sorensen <jes.sorensen@gmail.com> wrote:
> > > On 01/11/2018 05:30 AM, Barry Day wrote:
> >
> > > One issue with rtl8723bu is that it needs to coexist with the bluetooth
> > > driver. When I wrote the rtl8723bu support that was no BT support for
> > > the chip in the kernel and it worked fine, at least for me. However if
> > > you load the BT driver for the dongle which someone pushed into the
> > > kernel since then, it is likely to hijack the antennas causing the weak
> > > signal you describe.
> >
> > Yeah, that's why when testing the dongle I carefully disabled BT and
> > made sure no BT driver was probed at all. Still I can see the issue.
> > I honestly doubt that the problem is caused by BT coexistence. Any
> > other idea or suggestion to debug this problem?
> >
> > Thanks,
> >
> > --
> > Carlo Caione  |  +44.7384.69.16.04  |  Endless
>
> This problem has been reported for 1 year, but it still persists now.
>
> I found that the problem disappeared after I resume from suspend. Before
> suspend, the rssi observed from AP side for this dongle is quite poor. But
> it comes back to normal after resume. The signal strength differs almost
> 30dBm. So I compared/checked the RF/BB related register values
> (in .init_phy_bb/.init_phy_rf/.set_tx_power) but they are identical with the
> same routines in the driver from https://github.com/lwfinger/rtl8723bu
>
> The registers also remain the same across suspend/resume. Don't really
> know why a simple suspend/resume could cause such difference. Can
> anyone suggest which part I should look into to get more information?
>
> Chris

I found one thing interesting. It does seem to be related to BT coexist just
as Jes mentioned. Follow the steps below and the signal can always come
back to normal. The '1-7:1.0' is one of the IDs for the rtl8723bu usb interface.

1. unbind btusb first, cd /sys/bus/usb/drivers/btusb; echo 1-7:1.0 > unbind
2. unload rtl8xxxu driver then reload it. The signal stays at poor level
3. bind the btusb. cd /sys/bus/usb/drivers/btusb; echo 1-7:1.0 > bind

Seems that the BT firmware loaded is helpful for the only antenna config
which is shared by WiFi/BT. If I load the BT firmware after rtl8xxxu driver,
everything's fine.

Can anyone suggest the next step? I've compared all registers and h2c cmds
between vendor driver and rtl8xxxu driver. Basically, they're almost the same
even the bt coexist related settings. So it's difficult to imagine why the same
power on sequence setting and RF enable setting cause that huge signal
difference.

Chris
