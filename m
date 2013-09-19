Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab3ISEL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Sep 2013 00:11:27 -0400
Message-ID: <1379564168.13091.6.camel@dcbw.foobar.com> (sfid-20130919_061131_185886_26DFD529)
Subject: Re: NetworkManager not listing access points
From: Dan Williams <dcbw@redhat.com>
To: Detlev Casanova <detlev.casanova@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	laurent.pinchart@ideasonboard.com
Date: Wed, 18 Sep 2013 23:16:08 -0500
In-Reply-To: <31357461.i5mG9q5IfA@naboo>
References: <31357461.i5mG9q5IfA@naboo>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-09-18 at 22:47 +0200, Detlev Casanova wrote:
> Hello,
> 
> After a bisection on the kernel, it seems that a patch is causing a 
> problem with NetworkManager: 
> 
> commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8 ("cfg80211: 
> use DS or HT operation IEs to determine BSS channel")
> 
> The Wifi access points are not listed in the KDE plasma widget and it 
> won't even connect to the saved ones even if they are in range.
> 
> There is a fix though: running "iwlist wlan0 scan" twice as root (which 
> properly lists APs in reach) and the second time must be run about two 
> seconds after the first time.
> 
> Then NetworkManager lists the access points and connects to the 
> prefered one if possible (normal behavior).
> 
> This also happens with nm-applet in Gnome.
> 
> The hardware is: 14e4:4315 (Network controller: Broadcom Corporation 
> BCM4312 802.11b/g LP-PHY (rev 01)) on an Intel Core i3 M370 CPU (64 
> bits) computer.
> 
> The abnormal behaviour is not random, it happens every time.

Can you run wpa_supplicant with debugging output?  The quick and dirty
way is to:

mv /usr/sbin/wpa_supplicant /
killall -TERM wpa_supplicant
/wpa_supplicant -dddtu

and then wait for the problem to happen, and grab the log output for us
to analyze.

Dan

