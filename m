Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:55671 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab1BIObU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:31:20 -0500
Date: Wed, 9 Feb 2011 15:31:15 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Aleksandar Milivojevic <alex@milivojevic.org>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00-users] [RFC] rt2x00: Add autowakeup timer for
 receiving beacons while in powersave mode
Message-ID: <20110209143115.GA6356@sig21.net>
References: <201101311600.39486.IvDoorn@gmail.com>
 <874o8mbaec.fsf@purkki.adurom.net>
 <20110202212912.GA28687@sig21.net>
 <AANLkTinip3CZ8ZsY95E6dXnvhA_wEPSs4M7B+SmPY-ZM@mail.gmail.com>
 <87mxm69ajp.fsf@purkki.adurom.net>
 <AANLkTikgASqJ_7omn-Z4JWgAJ1dMtOYoSO8oa=GDtB=a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTikgASqJ_7omn-Z4JWgAJ1dMtOYoSO8oa=GDtB=a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 08, 2011 at 11:11:26AM -0800, Aleksandar Milivojevic wrote:
> On Tue, Feb 8, 2011 at 12:48 AM, Kalle Valo <kvalo@adurom.com> wrote:
> >
> > There is CONFIG_CFG80211_DEFAULT_PS kconfig option, but I'm not aware
> > of any other way to globally do this. I can only think of using iw or
> > iwconfig to disable power save per device.
> 
> I'm using iwconfig currently to disable power saving for wireless card
> on my desktop after it boots up.  However, from user perspective of
> things, it would be awesome if default was not hard coded in the
> kernel.

E.g. on Debian you can add iwconfig settings to /etc/network/interfaces,
see http://linux.die.net/man/7/wireless but I've no idea if that
works with NetworkManager or wicd etc.

I am not sure a global config setting for PS would not be an improvement
because you usually want to enable it for the hw which supports it
(unless you have specific low latency requirements).

But I think on some distributions acpid scripts run iwconfig to change
PS depending on if you're on AC or battery power.

FWIW, I had sent a patch to change the rt2800 USB driver
to default to PS off but Ivo seemed determined to
fix power saving instead of disabling it.
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/003017.html
(This RFC patch only changes the default, if it turns out PS
really cannot be fixed we should remove IEEE80211_HW_SUPPORTS_PS instead.)


Johannes
