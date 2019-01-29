Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9401DC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63A4A20869
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 09:56:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="2PWTVC/O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfA2J4d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 04:56:33 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39264 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfA2J4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 04:56:33 -0500
Received: by mail-ed1-f65.google.com with SMTP id b14so15462415edt.6
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 01:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PxYCS0vbXS2rAPwfuknM+cRMaSaBS70amtnuRyFlOoA=;
        b=2PWTVC/OP3+ccvhBKv8jcBnsfgEwWR093DhBrQXZV27af8cXvdoGpee0tqjrDfTP50
         e1ucR547pLBbrjnppdct69rARQRnA69dVD24XBrxfTM6iafcFNzimzmNVxMuq8z3gNho
         r5ZfeIi0O+PmF+6YwM9dMLru5mrK8157mBpGUo0iP3ulaRzW3l8AdKwSV6r5NCuX3vJu
         enszaWqzsWUf0VL/kjf0jPykdnuasmflKy/0hHdqn5uOxu2cjvo4jmHjaVaxTCjBV5gE
         UZy2QsnoXGkkD52QpTwDLHpldDs6BAan4rS0qaxRLJE7oAD7eRu9U6Ybh6tcVMJB1yJz
         YIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PxYCS0vbXS2rAPwfuknM+cRMaSaBS70amtnuRyFlOoA=;
        b=Gm3ymjxor4QpsEF4bFl8QpripxK+W7mE8+EJDAs504e+4mbHRIREtLo3lyVNinBMSp
         xlqJoBXjZsRO+TRMeJvoIsSM9zzCnIzmJFXKnWHy2cJDTmSN/fwcleZCRzCUJ1NMzb4d
         88KECwhFRUr0Unw7HgG3WCMBVtUj5bXb3cfOr4IL6qzDWWgL2lxVVRqv7tatLELsyL9y
         csu8AoA/OAQN6mlsTHs7T1FIE7mirgel6CoWXPw5Xwm0jBAnp9FrRDzavPUDtNlfsE+5
         IjtBGOTb3NMrRpMeFXoVqEU1M81yLddvISElfFJH07JSI1K7JKmh4QoEcqaMJ7xXQC6X
         vMvg==
X-Gm-Message-State: AJcUukdIqxOWY7p641dsFFFU4XUAJfKquCvoS5NW8X5d5jwYayNvLav9
        A7fV3/srgDDAnq8x152Pzp99W7UAWLPdEa8iYe7+7Q==
X-Google-Smtp-Source: ALg8bN7osAI8iFw62zcCIeHJ+7h6CFAeUMuuyKiy5G3efld7pJDp7dvys2jOQmcfTjRZO8Yd0R9n4Zw96TbkGyIFSzE=
X-Received: by 2002:aa7:d29a:: with SMTP id w26mr25149614edq.30.1548755791525;
 Tue, 29 Jan 2019 01:56:31 -0800 (PST)
MIME-Version: 1.0
References: <CAL9uMOFT3VwqHs5+wvot+dxArvhd7Bi-U5+CKhYUXjYwHcU=jg@mail.gmail.com>
 <20180111103006.GA17574@thinktank.home.org> <14c5f7f4-0d5b-cecd-b45b-3672b67da07a@gmail.com>
 <CAL9uMOG77it=kqkbjryPVpY2eVJqqjedVeAhdxqpZM6Z8JWuiA@mail.gmail.com>
In-Reply-To: <CAL9uMOG77it=kqkbjryPVpY2eVJqqjedVeAhdxqpZM6Z8JWuiA@mail.gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Tue, 29 Jan 2019 17:56:20 +0800
Message-ID: <CAB4CAwd2WtWwf9p=kZZQ-SzE6DhsLu1OpGaVyS1Mq8wx8eT6ww@mail.gmail.com>
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

On Mon, Jan 22, 2018 at 6:56 AM Carlo Caione <carlo@endlessm.com> wrote:
>
> On Sun, Jan 21, 2018 at 9:46 PM, Jes Sorensen <jes.sorensen@gmail.com> wrote:
> > On 01/11/2018 05:30 AM, Barry Day wrote:
>
> > One issue with rtl8723bu is that it needs to coexist with the bluetooth
> > driver. When I wrote the rtl8723bu support that was no BT support for
> > the chip in the kernel and it worked fine, at least for me. However if
> > you load the BT driver for the dongle which someone pushed into the
> > kernel since then, it is likely to hijack the antennas causing the weak
> > signal you describe.
>
> Yeah, that's why when testing the dongle I carefully disabled BT and
> made sure no BT driver was probed at all. Still I can see the issue.
> I honestly doubt that the problem is caused by BT coexistence. Any
> other idea or suggestion to debug this problem?
>
> Thanks,
>
> --
> Carlo Caione  |  +44.7384.69.16.04  |  Endless

This problem has been reported for 1 year, but it still persists now.

I found that the problem disappeared after I resume from suspend. Before
suspend, the rssi observed from AP side for this dongle is quite poor. But
it comes back to normal after resume. The signal strength differs almost
30dBm. So I compared/checked the RF/BB related register values
(in .init_phy_bb/.init_phy_rf/.set_tx_power) but they are identical with the
same routines in the driver from https://github.com/lwfinger/rtl8723bu

The registers also remain the same across suspend/resume. Don't really
know why a simple suspend/resume could cause such difference. Can
anyone suggest which part I should look into to get more information?

Chris
