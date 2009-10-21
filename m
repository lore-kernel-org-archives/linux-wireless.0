Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:65496 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbZJUVet (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2009 17:34:49 -0400
Received: by fxm18 with SMTP id 18so8288869fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2009 14:34:53 -0700 (PDT)
Date: Wed, 21 Oct 2009 17:34:49 -0400
From: Celejar <celejar@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Broadcom 4318 not working with bleeding edge kernels
Message-Id: <20091021173449.0a3ec80f.celejar@gmail.com>
In-Reply-To: <1256138957.26054.4.camel@mj>
References: <20091020214702.a76fa4aa.celejar@gmail.com>
	<1256138957.26054.4.camel@mj>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 21 Oct 2009 11:29:17 -0400
Pavel Roskin <proski@gnu.org> wrote:

> On Tue, 2009-10-20 at 21:47 -0400, Celejar wrote:
> 
> > Oct 17 19:44:19 localhost wpa_supplicant[3477]: Trying to associate
> > with 00:14:d1:3e:ff:30 (SSID='cranford' freq=2437 MHz) Oct 17
> > 19:44:19 localhost wpa_supplicant[3477]: Association request to the
> > driver failed
> 
> Since the message is from wpa_supplicant, it must be something between
> wpa_supplicant and mac80211.  I don't think any code in b43 is
> involved.
> 
> Perhaps you should include some information about wpa_supplicant, i.e.
> its version and the command line.  Please try the latest
> wpa_supplicant. Please try both wext and nl80211 drivers.  That would
> help understand the extent of the problem.

Version is 0.6.9, from the Debian package version 0.6.9.3.  I don't
know the exact command line, since I've been invoking it through the
Debian ifupdown scripts.  I haven't been specifying a backend, and the
Debian documentation states that wext is used in that case.

I have been playing with it some more, and it sometimes works, and
sometimes doesn't.  The only absolutely consistent pattern that I've
seen is that (in my limited testing) it seems to always work right
after unloading / reloading the driver (b43) (or a fresh boot).

As I mentioned, I've been using the Debian ifupdown scripts.  I have
now tried running wpa_supplicant directly, and so far it has worked
consistently, with a very minimal, mostly default config:

'wpa_supplicant -iwlan0 -c/wpa.conf'

where wpa.conf contains:

ctrl_interface=/var/run/wpa_supplicant

network={
        ssid="my-ssid"
        psk="my passphrase"
}


So at this point, I guess the problem is something that I need to
report to Debian, some sort of bugginess with their scripts.  Thanks
for the help ;)

Celejar
-- 
mailmin.sourceforge.net - remote access via secure (OpenPGP) email
ssuds.sourceforge.net - A Simple Sudoku Solver and Generator

