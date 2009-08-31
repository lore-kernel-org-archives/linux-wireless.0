Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41712 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZHaRzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 13:55:55 -0400
Received: by fxm17 with SMTP id 17so2920972fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 10:55:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <h7eo7q$7ks$1@ger.gmane.org>
References: <h7eo7q$7ks$1@ger.gmane.org>
Date: Mon, 31 Aug 2009 18:55:56 +0100
Message-ID: <3ace41890908311055s5c49a25fjf69ca48024579d44@mail.gmail.com>
Subject: Re: rtl8187b Problem with tx level
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Tobias Schlemmer <keinstein_junior@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 30, 2009 at 9:44 PM, Tobias
Schlemmer<keinstein_junior@gmx.net> wrote:
> Hi,
>
> I have some problem with my rtl8187b device. It is included in my laptop
> running Ubuntu linux 2.6.28. I've tested several compat-wireless releases
> including 2.6.30 and 2.6.31-rc7.

Hmm, are compat-wireless versioned against kernels? I thought they
just have dates and git describe tags. Could you try the
latest-and-greatest? (the latest and greatest is ahead of 2.6.31-rc7
by a few months)
http://linuxwireless.org/en/users/Download

> The problem is that the network adapter looses the connection to the access
> point at very low distances. It seems to be as if the driver is too
> optimistic about tx power. I monitored the singnal strength on the access
> point (Buffalo running DD-WRT). When I associate the laptop with it the
> recieved signal strength starts full and drops rapidly in the first seconds.
> At the end it is about 0 at a distance of 4m. At this moment no ping will
> arrive the destination. Tests with other access points show similar results.
>
> After several attempts to get different drivers working I used an Ubuntu
> 8.04 boot CD this morning which seems to work out of the box. It has kernel
> 2.6.24 using a module called r8187. I compared these two drivers and got
> much better signal strengths, at least more stable connections. Maybe it's
> interesting that the two drivers report different signal strength
> (compat-wireless reports about 10dBm higher values than the old driver) also
> in signal quality the compat wireless driver seems to be more optimistic.

We are familiar with the r8187 module - what version did Ubuntu ship?
(the module headers are not updated so modinfo is useless). I see you
have the mesh code so that's quite recent.

I have compat-wireless from a few days ago, and iwconfig says - Bit
Rate=11 Mb/s   Tx-Power=20 dBm - and I am in a different room from AP,
probably 4m through wall & furniture.
