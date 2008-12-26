Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:46339 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156AbYLZSt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 13:49:57 -0500
Message-ID: <4955274D.30600@lwfinger.net> (sfid-20081226_195002_643687_2602A1A9)
Date: Fri, 26 Dec 2008 12:49:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 3/3] p54: fix WARN_ON at line 2247 of net/mac80211/rx.c
References: <200812261909.46094.chunkeey@web.de>
In-Reply-To: <200812261909.46094.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch hopefully fixes a mac80211<->p54 interaction problem, which was
> described by Larry Finger (ref: http://marc.info/?l=linux-wireless&m=123009889327707 )
> 
> I guess the warning was triggered by pending frames in the receive queue,
> while we're doing a band change 5GHz.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Larry,
> 
> Are you still hammering your p54usb, or have you finished testing p54(usb)'s stability?
> Because I'm waiting for your confirmation for this one. hohohoho.

Merry Christmas (belated). Yes, this patch stopped the warnings, which started
as a result of using the US, rather than world, regdom.

There are some things p54usb cannot handle such as a simultaneous git pull and
full kernel compilation with the source volumes mounted with NFS. That could be
thermal, although I'm still worried about the O(1) allocations of skb's on
machines with 4K page size. Should I prepare a patch to reduce rx_mtu in the
critical cases?

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
---
