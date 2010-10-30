Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40856 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab0J3MbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 08:31:10 -0400
Received: by fxm16 with SMTP id 16so3842552fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 05:31:09 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Lee <lee-in-berlin@web.de>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond authentication (2.6.36, rt73usb)
Date: Sat, 30 Oct 2010 14:30:15 +0200
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <4CC0D0F6.4080507@web.de> <201010290017.13174.helmut.schaa@googlemail.com> <4CCB3F24.1030701@web.de>
In-Reply-To: <4CCB3F24.1030701@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010301430.15868.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 29 Oktober 2010 schrieb Lee:
> On 29/10/10 00:17, Helmut Schaa wrote:
> > In commit f1aa4c541e98afa8b770a75ccaa8504d0bff44a7 "rt2x00: Write the BSSID
> > to register when interface is added" we've added the bssid passing to the
> > device in AP mode to fix hw crypto on rt2800 devices in AP mode. But maybe
> > the older devices behave differently and don't like getting a bssid set
> > in AP mode?
> >
> > Lee, if you just revert the commit you've identified are you able to use
> > the device in AP mode with hw crypto?
> >
> Reverting that memcpy() to it's original parameters works for me (AP mode + hw 
> crypto).

Thanks for the info Lee. So, in AP mode we need to set the bssid on rt2800
devices in order to get hw crypto to work but on (at least) rt73 devices we
may not set the bssid to get hw crypto to work :(

Ivo, Gertjan, any ideas how to handle that case. I don't feel like introducing
another device specific flag makes sense here?

Helmut
