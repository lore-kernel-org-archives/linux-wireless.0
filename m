Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.229]:60738 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbYDPRMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 13:12:50 -0400
Received: by wr-out-0506.google.com with SMTP id c48so1430076wra.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 10:12:47 -0700 (PDT)
Message-ID: <a44ae5cd0804161012w7c07efb0w68f9a8664f077556@mail.gmail.com> (sfid-20080416_181325_307669_A96F226B)
Date: Wed, 16 Apr 2008 13:12:45 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: 2.6.25-rc9 -- bcm4306 performance is in the toilet
Cc: "Jiri Benc" <jbenc@suse.cz>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48060D71.6020507@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48056406.2060502@gmail.com> <48060D71.6020507@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 16, 2008 at 10:30 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> Miles Lane wrote:
>
> > Hi,
> >
> > I have a bcm4306 card in my desktop machine.  I am running a build of
> 2.6.25-rc9.  I have tried fiddling with the network build options and no
> matter what I select, my network performance is absolutely terrible (between
> 0 - 24KBps).  Connections take around 10-20 seconds to establish.  I have a
> cable modem, and usually see nearly instantaneous connections and between
> 65-600KBps throughput.  I just tried downloading something and am seeing
> this:  223B/s.  Everything is intermittent and and often times out.
> >
> > I am attempting to collect a log for you to analyze.  However, I am
> running into some snags.
> > 1)  The latest firmware, which is called for in the latest kernel code,
> won't work with my Ubuntu 8.10 kernel (2.6.24-16-386).  I got the latest iw
> git code downloaded, but it won't build for me:
> >
>
>  Which revision of the BCM4306 do you have? Which driver (b43, b43legacy, or
> bcm43xx) are you running?
>
>  Based on comment 1) above, I think you are using b43, but why should I have
> to guess?

Point taken.

This information is collected while running the Ubuntu 2.6.24-16-386 kernel:
b43                   113952  0
ssb                    31236  1 b43
mac80211              162708  1 b43
led_class               5124  1 b43
input_polldev           5000  1 b43
rfkill                  7568  3 b43,rfkill_input

01:06.0 Network controller: Broadcom Corporation BCM4306 802.11b/g
Wireless LAN Controller (rev 03)

[   80.331869] b43-phy0: Broadcom 4306 WLAN found
[   80.404197] phy0: Selected rate control algorithm 'simple'
...
[   94.554107] input: b43-phy0 as /devices/virtual/input/input6
[   96.164622] Registered led device: b43-phy0:tx
[   96.165130] Registered led device: b43-phy0:rx
[   96.165535] Registered led device: b43-phy0:radio
...

Any idea why iw won't build?

interface.c: In function 'get_if_type':
interface.c:50: error: 'NL80211_IFTYPE_MESH_POINT' undeclared (first
use in this function)
interface.c:50: error: (Each undeclared identifier is reported only once
interface.c:50: error: for each function it appears in.)
interface.c: In function 'handle_interface_add':
interface.c:121: error: 'NL80211_ATTR_MESH_ID' undeclared (first use
in this function)
