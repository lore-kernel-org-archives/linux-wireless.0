Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:25507 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbYFKSJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 14:09:31 -0400
Received: by yx-out-2324.google.com with SMTP id 31so364357yxl.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 11:09:30 -0700 (PDT)
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Rt2400-devel] next-20080611 rt2x00: build failure
Date: Wed, 11 Jun 2008 20:21:42 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	linux-next@vger.kernel.org
References: <20080611100748.d35829f4.randy.dunlap@oracle.com> <200806111948.49976.IvDoorn@gmail.com> <32664704.1213206386295.JavaMail.oracle@acsmt301.oracle.com>
In-Reply-To: <32664704.1213206386295.JavaMail.oracle@acsmt301.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-Id: <200806112021.43707.IvDoorn@gmail.com> (sfid-20080611_201020_310343_8D755A8A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 June 2008, Randy Dunlap wrote:
> --- Original Message ---
> > > when CONFIG_INPUT=n and
> > > # CONFIG_NEW_LEDS is not set
> > > CONFIG_LEDS_CLASS=y
> > 
> > Does below patch help?
> 
> Nope, sorry, same build errors.

Ok this is odd, there is something very strange happening,
the relevant options in your config are:

CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
# CONFIG_INPUT is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_RT2X00_LIB_RFKILL=y

>From net/rfkill/Kconfig:

config RFKILL_INPUT
	tristate "Input layer to RF switch connector"
	depends on RFKILL && INPUT

So RFKILL_INPUT shouldn't not be enabled because it has
a clear dependency on the CONFIG_INPUT option.

>From drivers/net/wireless/rt2x00/Kconfig
config RT2X00_LIB_RFKILL
	boolean
	depends on RT2X00_LIB
	select RFKILL
	select INPUT_POLLDEV

This doesn't mean that the rt2x00 behavior of selecting
CONFIG_INPUT_POLLDEV without dependencies on
CONFIG_INPUT was correct. But more that there is
a secondary bug elsewhere as well, and that is the one
which is causing the build failure now.. :S

Anybody with additional ideas? :)

Ivo
