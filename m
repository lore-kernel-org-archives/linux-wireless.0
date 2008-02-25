Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:5235 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760490AbYBYWJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 17:09:39 -0500
Received: by wf-out-1314.google.com with SMTP id 28so977926wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 14:09:39 -0800 (PST)
Message-ID: <a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com> (sfid-20080225_221017_219564_4818FB4C)
Date: Mon, 25 Feb 2008 23:09:39 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: chris2553@googlemail.com
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200802252104.32416.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	 <c6b1100b0802220746s3441d28cj92896618bbb57bde@mail.gmail.com>
	 <200802222047.52312.IvDoorn@gmail.com>
	 <200802252104.32416.chris2553@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>  > > >  Checking those out is simply a matter of:
>  > > >  git branch 2.0.11 2d68de3efa62655d551092f5c787505735d561ad
>  > > >  git checkout 2.0.11
>  > >
>  > > OK, we seem to be struggling a little, so I've built an installed git
>  > > and cloned Linus' 2.6 tree. My wireless network dies after a few pings
>  > > with rt2x00 2.0.11.
>  > >
>  > > >  No further bisecting is needed, but with above tests I can at least
>  > > >  narrow it down to find the cause of this issue.
>  > >
>  > > If you need me to bisect, just shout. Please be patient though, I'm
>  > > exploring new territory here :-)
>  >
>  > I don't think bisecting this will help a lot, the rt2x00 2.0.11 release
>  > introduced software diversity. And that is already something I suspect
>  > of being broken.
>  >
>   I've bisected anyway and although the results are not absolutely conclusive,
>  as I neared the end of the process, I was amongst a bunch of mac80211
>  patches. This set me on a path that resulted in me discovering that with the
>  rt61pci driver, I can freeze my wireless network connection almost at will if
>  I set mac82011's ieee80211_default_rc_algo parameter to 'pid'. if the
>  parametre is set to 'simple', the network seems to be reliable. I've just let
>  the ping application run on and ping another box on my network almost 1500
>  times whilst repeatedly transferring a kernel source tarball by ftp from
>  another box and the network connection was mantained That's with the
>  parameter set to 'simple', if \I set it to 'pid' the connection rarely
>  survives more than 40 pings even without the ftp activity.
>
>  If I replace my wireless card with one that uses the rtl8180 driver, the
>  network connection seems to be reliable regardless of how I set the
>  parameter, although I admit that i have not tested this extensively yet. I'll
>  do that now and report later.

I'm about to send 4 patches to this (linux-wireless) list with patches
for rt2x00,
most of them you already tested individually, but several people reported
success after those patches.

Hopefully it will be working for you as well. :)

Ivo
