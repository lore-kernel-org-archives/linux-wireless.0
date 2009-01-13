Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35727 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025AbZAMT7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 14:59:54 -0500
Message-ID: <496CF2B3.1000402@lwfinger.net> (sfid-20090113_210902_480524_DD2F5520)
Date: Tue, 13 Jan 2009 13:59:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901131449.41189.chunkeey@web.de> <496CC514.3030307@gmail.com> <200901131906.13096.chunkeey@web.de>
In-Reply-To: <200901131906.13096.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> well, you have a 32-bit architecture, unlike me or larry.
> So, with a bit of luck the skbs always fitted into a single page and you never
> had problems with memory fragmentation. 

Whether it is a 32- or 64-bit kernel, it has a 4K page size. If
that were not true, the rx_mtu reduction would not have triggered.

I have additional information obtained from a kmemleak kernel. Driver
p54usb and mac80211 do not show any memory leaks, at least in STA
mode. I tested this by running normal traffic for about 15 minutes,
and then rmmod'ed p54usb. If kernel leaks are the problem, then they
are arising from hostapd. Userland memory leaks can be checked with
valgrind.

Larry


