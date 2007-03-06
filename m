Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55607
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966006AbXCFSpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 13:45:22 -0500
From: Michael Buesch <mb@bu3sch.de>
To: jt@hpl.hp.com
Subject: Re: wireless extensions vs. 64-bit architectures
Date: Tue, 6 Mar 2007 19:43:06 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
	Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>,
	Jouni Malinen <jkm@devicescape.com>
References: <1173144447.15891.93.camel@johannes.berg> <20070306171316.GA19669@bougret.hpl.hp.com>
In-Reply-To: <20070306171316.GA19669@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703061943.07350.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 March 2007 18:13, Jean Tourrilhes wrote:
> On Tue, Mar 06, 2007 at 02:27:26AM +0100, Johannes Berg wrote:
> > Hi,
> > 
> > Wtf! After struggling with some strange problems with zd1211rw (see some
> > other mail) I decided to think again about what could possibly cause all
> > the other problems I'm having with it. The kernel seems fine, but iw*
> > userspace continually segfaults! And it also seems to be not
> > reproducible for most other people, I'd asked on IRC once a while.
> > 
> > Well. Some thinking and stracing and thinking later it occurred to me...
> > Hell! wext is ioctls and includes this gem:
> > 
> > struct  iw_point
> > {
> >   void __user   *pointer;       /* Pointer to the data  (in user space) */
> >   __u16         length;         /* number of fields or size in bytes */
> >   __u16         flags;          /* Optional params */
> > };
> > 
> > Of course nobody ever tells you this, but it's used in a shitload of
> > places.
> 
> 	Yep, and it's even in fs/compat_ioctl.c. Hint, hint ;-)

Ok, it is wrapping the following ioctls:

HANDLE_IOCTL(SIOCGIWRANGE, do_wireless_ioctl)
HANDLE_IOCTL(SIOCSIWSPY, do_wireless_ioctl)
HANDLE_IOCTL(SIOCGIWSPY, do_wireless_ioctl)
HANDLE_IOCTL(SIOCSIWTHRSPY, do_wireless_ioctl)
HANDLE_IOCTL(SIOCGIWTHRSPY, do_wireless_ioctl)
HANDLE_IOCTL(SIOCGIWAPLIST, do_wireless_ioctl)
HANDLE_IOCTL(SIOCGIWSCAN, do_wireless_ioctl)
HANDLE_IOCTL(SIOCSIWESSID, do_wireless_ioctl)
HANDLE_IOCTL(SIOCGIWESSID, do_wireless_ioctl)
HANDLE_IOCTL(SIOCSIWNICKN, do_wireless_ioctl)
HANDLE_IOCTL(SIOCGIWNICKN, do_wireless_ioctl)
HANDLE_IOCTL(SIOCSIWENCODE, do_wireless_ioctl)
HANDLE_IOCTL(SIOCGIWENCODE, do_wireless_ioctl)

What about SIOCSIWSCAN, SIOCSIWENCODEEXT, SIOCGIWENCODEEXT
and some others that also use iw_point?

-- 
Greetings Michael.
