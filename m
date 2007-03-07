Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:57176 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161162AbXCGBn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 20:43:26 -0500
Date: Tue, 6 Mar 2007 17:42:48 -0800
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>,
	Jouni Malinen <jkm@devicescape.com>
Subject: Re: wireless extensions vs. 64-bit architectures
Message-ID: <20070307014248.GA20360@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1173144447.15891.93.camel@johannes.berg> <20070306171316.GA19669@bougret.hpl.hp.com> <200703061943.07350.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200703061943.07350.mb@bu3sch.de>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 06, 2007 at 07:43:06PM +0100, Michael Buesch wrote:
> > 
> > 	Yep, and it's even in fs/compat_ioctl.c. Hint, hint ;-)
> 
> Ok, it is wrapping the following ioctls:
> 
> HANDLE_IOCTL(SIOCGIWRANGE, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCSIWSPY, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCGIWSPY, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCSIWTHRSPY, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCGIWTHRSPY, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCGIWAPLIST, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCGIWSCAN, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCSIWESSID, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCGIWESSID, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCSIWNICKN, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCGIWNICKN, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCSIWENCODE, do_wireless_ioctl)
> HANDLE_IOCTL(SIOCGIWENCODE, do_wireless_ioctl)
> 
> What about SIOCSIWSCAN, SIOCSIWENCODEEXT, SIOCGIWENCODEEXT
> and some others that also use iw_point?

	Yep, good point.
	SIOCSIWSCAN is up there. I did not realise that all the WPA
ioctls are missing. That's easy enough to fix, remember that you have
the full description of the ioctls in wireless.c.
	I'll try to do a patch if I find 5 min, but feel free to
forward something to John L.
	Thanks a lot !

> Greetings Michael.

	Jean
