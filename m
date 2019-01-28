Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611D4C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 21:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D61A2148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 21:01:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VT6ubdoq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfA1VBq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:01:46 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44063 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfA1VBp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 16:01:45 -0500
Received: by mail-ed1-f67.google.com with SMTP id y56so14226056edd.11
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 13:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qpoPab3uU/1KrCFIle8ZJ6xvIB4r+F1qWf2i+YAYUNs=;
        b=VT6ubdoqQaisX14xSDq4QjH1q8Qx2NoBFBpaTPxBhGNkleFtmpEa97gbtH0mMWuqhS
         +sbqOPRrH8t3kahweSWsxoB5RQXAnU1BJoiCHD7A0jSKS5EA0nDqh3aYtl/G1ux6j8Aq
         IvkFxVGVLD/NqofKxy2812dS9x6VLC/ZzszVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qpoPab3uU/1KrCFIle8ZJ6xvIB4r+F1qWf2i+YAYUNs=;
        b=GfKIzVV3Yo7eJlCBpIM2ar3xpMN0Oa9Yw5zYJx85sPlcRm15KdUATWa2PGzAncSsQg
         COw2VyoIPmnGe4tDi8KdbRK2N4yFL73njTlbB4gSJdy1U5eb69zsKGwHDz+1Oem7e9Jh
         fgsoWXF4yk47cro2cTuKRxS+mIbWHM+ZLrDTth/vk1nhEmStUrhDDz9mSvwF73H3rmC6
         Uh7EKMkIX1Szim8gOOMdoorO62Qw/E0OKLeyKz9BG5/yPVGF5byamWR7CHQP4ca4b2iW
         rjrCA1SQA5qXE0H+VrefLsVhfIQPcMzAo0ToY1FcC7BKEVJD+UHBjZL1hXLGZ8JvUUPS
         sr9A==
X-Gm-Message-State: AJcUukeo40+zCvE6vCZUPN6LFKbR0YqsW2A9XxSCDFMt0lS4YxtcECOp
        +XMHELARys5ipgKXpwZmy/tYbhCXLC0=
X-Google-Smtp-Source: ALg8bN67DH5wKvZkaXvo9jHWP1o9z8CYnqJcn0IipZg6DqxuHEu9v4169RgkiPlFYN9Vzxujw78OHw==
X-Received: by 2002:a17:906:2615:: with SMTP id h21mr19322889ejc.86.1548709303409;
        Mon, 28 Jan 2019 13:01:43 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id b9sm16445473ede.12.2019.01.28.13.01.41
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 13:01:42 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id p6so14305041eds.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 13:01:41 -0800 (PST)
X-Received: by 2002:a50:c8c9:: with SMTP id k9mr22771423edh.6.1548709301361;
 Mon, 28 Jan 2019 13:01:41 -0800 (PST)
MIME-Version: 1.0
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
 <1542367879-28880-14-git-send-email-yhchuang@realtek.com> <20190122213423.GA52826@google.com>
 <F7CD281DE3E379468C6D07993EA72F84D1793553@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1793553@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 28 Jan 2019 13:01:29 -0800
X-Gmail-Original-Message-ID: <CA+ASDXOWfFqZRyWbsb=WqORDvsVD+HjNmbGON9R1kOL88=aKew@mail.gmail.com>
Message-ID: <CA+ASDXOWfFqZRyWbsb=WqORDvsVD+HjNmbGON9R1kOL88=aKew@mail.gmail.com>
Subject: Re: [PATCH v2 13/13] rtw88: add support for Realtek 802.11ac wireless chips
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Sun, Jan 27, 2019 at 7:36 PM Tony Chuang <yhchuang@realtek.com> wrote:
> > -----Original Message-----
> > From: Brian Norris [mailto:briannorris@chromium.org]
> >
> > On Fri, Nov 16, 2018 at 07:31:19PM +0800, yhchuang@realtek.com wrote:
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 9ad052a..138515b 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -12546,6 +12546,14 @@ T: git
> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
> > >  S: Maintained
> > >  F: drivers/net/wireless/realtek/rtlwifi/
> > >
> > > +REALTEK WIRELESS DRIVER (rtw88)
> > > +M: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > > +L: linux-wireless@vger.kernel.org
> > > +W: http://wireless.kernel.org/
> > > +T: git
> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> >
> > That tree hasn't been updated in years. I expect that's not relevant, so
> > perhaps you should remove it? I think these days, unless you have a
> > large amount of patches that deserves its own tree / pull-request,
> > you're probably just going to be covered by the wireless-drivers /
> > wireless-drivers-next trees:
> >
> > NETWORKING DRIVERS (WIRELESS)
> > M:      Kalle Valo <kvalo@codeaurora.org>
> > L:      linux-wireless@vger.kernel.org
> > Q:      http://patchwork.kernel.org/project/linux-wireless/list/
> > T:      git
> > git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
> > T:      git
> > git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
>
> OK, I can change to wireless-drivers tree and send PATCHv3.

I wouldn't list wireless-drivers directly -- you don't need to list
any tree at all, and the "NETWORKING DRIVERS (WIRELESS)" entry will
cover you anyway. Notice how none of these list their own trees
either:

MARVELL MWIFIEX WIRELESS DRIVER
MARVELL MWL8K WIRELESS DRIVER
MEDIATEK MT76 WIRELESS LAN DRIVER
ORINOCO DRIVER
P54 WIRELESS DRIVER
...

It's probably not worth another resend. If Kalle cares, I'm sure he
can delete your 'T:' line.

Brian
