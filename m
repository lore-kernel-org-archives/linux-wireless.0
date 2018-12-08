Return-Path: <SRS0=h78J=OR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAE6C07E85
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 00:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AADC220857
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Dec 2018 00:58:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BuDzNbmB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AADC220857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbeLHA6q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 19:58:46 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:33929 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbeLHA6q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 19:58:46 -0500
Received: by mail-io1-f42.google.com with SMTP id r9so4746083ioa.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2018 16:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dsmuyw/xzox71IZf2j+yz3+AfNLVYRtXDJN8hE2exjU=;
        b=BuDzNbmB1OydeAx4VMm/jYweaKf6pcrryk+VEHuGsqZZGdL4W2AsbfHriZbl4Itsqq
         zeMc3uAbKYN3DLwtGbcrud1sIS4nekqMDvwr4PPmd7Nj4JyVigsKYP6FQgwEs4S3Ul78
         P56DgNOjFHTvfg7iycoH0geYaQPCzw0XzNqxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dsmuyw/xzox71IZf2j+yz3+AfNLVYRtXDJN8hE2exjU=;
        b=Cl3h4F2F1YYohkYqtBNZ3EqbeqtKGdlvuzwCUjGAcJ5RNxub/6jzZ3+MdTjXbtGMkw
         ElryXQGgvUhxC2QfjtdCNqaYwWOO5yt0a+ufpvYucHctY4UapoAVClbs/3DURbQrgf0g
         jQCjCc8yZmRiNpQhwrgXk6NVZfQGdxv+yDzR56Tz+qVh1oT40XZq6rb2Q2qxaj/lAP8U
         O3EVZQvj079XRZsvHSoKTZFpE0H7tP8TyHiTYir4RkZ73StEMU2XUOmg6STneYDB9jcn
         wnCQu4Yb7em3YYJh+i2wrc5suF123uCurOoT/Pu8FbbZCteXdMtKzLA9IkoyJztvokfe
         UBqA==
X-Gm-Message-State: AA+aEWb723+2SfC4FD85I+ocw2uSav3GdMohiO8jiDHTvvcNKYhNIQS2
        ZD9QsjZcd8IpNovja8RkKD1mxis8H4M=
X-Google-Smtp-Source: AFSGD/WL6xVRsORZ+8Ut48PolphEn/tmIKJ/7YJ6jLbIvuQgY9EK2ITunW3DktwHi+ZeVbl98MvF7g==
X-Received: by 2002:a6b:4a09:: with SMTP id w9mr2697587iob.260.1544230723985;
        Fri, 07 Dec 2018 16:58:43 -0800 (PST)
Received: from mail-it1-f178.google.com (mail-it1-f178.google.com. [209.85.166.178])
        by smtp.gmail.com with ESMTPSA id c3sm1987891ioi.2.2018.12.07.16.58.41
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Dec 2018 16:58:42 -0800 (PST)
Received: by mail-it1-f178.google.com with SMTP id z7so9703258iti.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2018 16:58:41 -0800 (PST)
X-Received: by 2002:a24:5d11:: with SMTP id w17mr3931250ita.169.1544230721003;
 Fri, 07 Dec 2018 16:58:41 -0800 (PST)
MIME-Version: 1.0
References: <1524633572-5588-1-git-send-email-gbhat@marvell.com>
 <87in8fbvrr.fsf@purkki.adurom.net> <47b96e61ff234dacbe5da02f0730fb84@SC-EXCH02.marvell.com>
In-Reply-To: <47b96e61ff234dacbe5da02f0730fb84@SC-EXCH02.marvell.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 7 Dec 2018 16:58:29 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNShxiJXVOa3fHGKGy0iHFTpUNEbGAdSb3QOpSqj0P6wg@mail.gmail.com>
Message-ID: <CA+ASDXNShxiJXVOa3fHGKGy0iHFTpUNEbGAdSb3QOpSqj0P6wg@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH] mwifiex: fix nested rtnl locking on BG_SCAN_STOPPED
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ganapathi,

For some reason, I'm daft enough to reply to this ancient thread. It
appears as if you probably have not resolved this issue yet though, so
I figured I could lend some advice.

On Wed, Apr 25, 2018 at 1:06 AM Ganapathi Bhat <gbhat@marvell.com> wrote:
> > Ganapathi Bhat <gbhat@marvell.com> writes:
> > > --- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
> > > @@ -848,7 +848,10 @@ int mwifiex_process_sta_event(struct
> > > mwifiex_private *priv)
> > >
> > >     case EVENT_BG_SCAN_STOPPED:
> > >             dev_dbg(adapter->dev, "event: BGS_STOPPED\n");
> > > -           cfg80211_sched_scan_stopped(priv->wdev.wiphy, 0);
> > > +           if (rtnl_is_locked())
> > > +                   cfg80211_sched_scan_stopped_rtnl(priv-
> > >wdev.wiphy, 0);
> > > +           else
> > > +                   cfg80211_sched_scan_stopped(priv->wdev.wiphy,
> > 0);
> >
> > IMHO checking if a lock is taking is rather ugly and an indication there's a
> > problem with the locking. Instead making an ugly workaround like this I
> > would rather investigate who is holding the rtnl and solve that.

Agreed, this is not good. You are now bound to hit ASSERT_RTNL()
warnings occasionally, since you might see rtnl locked here, but a
split second later, when you're running in
__cfg80211_stop_sched_scan(), it could be released by some other
thread.

> There can be applications trying to access driver(via cfg80211), holding rtnl_lock.
> For example(in our case):
> 1. "iw dev"  was called, when BG_SCAN was active.
> 2. NL80211_CMD_GET_INTERFACE requires rtnl_lock to be hold(specified in internal_flags)
> 3. cfg80211 will  hold rtnl_lock before calling "get_tx_power"(in pre_doit).
> 4. mwifiex will download RF_TX_PWR command to firmware
> 5. firmware will send BG_SCAN_STOPPED event(since BG_SCAN was active).
> 6. mwifiex will call "cfg80211_sched_scan_stopped" causing nested rtnl locking.

IIUC, it's not exactly a nested lock, but a lock inversion issue.

#1
NL80211_CMD_GET_INTERFACE thread is holding rtnl lock and later
waiting on one of its HostCmd_CMD_* to complete

In the meantime:
#2
a EVENT_BG_SCAN_STOPPED is queued, and it grabs the rtnl lock

Because events are served on the same thread as commands, you get #1
waiting on #2, which is waiting on the lock held in #1. i.e., ABBA.

The way to resolve this is to either move event processing to a
different thread than command processing (that looks it would be very
difficult to do correctly, given the ossified structure of your
driver; but that might be a wise move in the long term)...
...or else maybe you could defer this specific piece of work to its
own thread. That might require yet another workqueue?

Anyway, the key point is that you really don't want to hold rtnl_lock
in your main workqueue, or in any other way that might block the rest
of the operation of your driver.

Brian
