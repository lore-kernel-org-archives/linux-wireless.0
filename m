Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:64202 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbZHTKOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 06:14:12 -0400
Received: by ewy3 with SMTP id 3so2752405ewy.18
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 03:14:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250760130.4100.23.camel@johannes.local>
References: <eb3ff54b0908200002s4dc0dbf7kc28dda3fa7afaeb9@mail.gmail.com>
	 <1250760130.4100.23.camel@johannes.local>
Date: Thu, 20 Aug 2009 13:14:12 +0300
Message-ID: <eb3ff54b0908200314n435c4ad4g572c16ee185c0304@mail.gmail.com>
Subject: Re: Linux Kernel Wireless stack presentation
From: Rami Rosen <ramirose@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,
  Thanks a lot for your comments. I will fix the presentation accordingly.

The code base for the lecture is indeed not the latest wireless-testing tree.

> Hey that got long!
The presentation is also quite long...

Regards,
Rami Rosen




On Thu, Aug 20, 2009 at 12:22 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-08-20 at 10:02 +0300, Rami Rosen wrote:
>
>> http://tuxology.net/wp-content/uploads/2009/08/wirelessLecHerzelinux.pdf
>
> had a quick look
>
>  * almost all drivers support passive scanning -- all the modern ones at
>   least -- maybe some old drivers don't, but all using cfg80211 do
>  * your presentation is based on old code -- all the code stuff about
>   scanning is already outdated in wireless-testing
>  * you can scan for multiple specific SSIDs and channels:
>   iw wlan0 scan freq 2412 ssid foo bar baz
>  * iw has a better IE parser, so showing a result from that may be more
>   instructive
>  * code stuff about authentication/association is also outdated already
>  * the STA_MLME_DISABLED stuff no longer exists
>  * AP MLME will never be in the kernel, not just not in the near
>   future :)
>  * raw packets still go through the mac80211 stack, they arrive in
>   monitor_start_xmit() or so
>  * four-address format is not necessarily used only for WDS, the
>   standard doesn't define uses for it (ToDS = FromDS = 1)
>  * an AP may transmit nullfunc (!) frames to tell clients it has no data
>   buffered, but it never transmits frames with the PM bit on
>  * power timeout 5 is described incorrectly -- it doesn't go to sleep
>   for 5 seconds, it actually stays awake for 5 seconds after each
>   packet transmission -- the time spent asleep is calculated based on
>   the DTIM period etc. Cf. 04fe20372e70685d9f15966216cdffd3795fe590.
>  * STA may wake up in response to TIM[AID] == 1 instead of sending
>   PS-poll, which we do depends on the timeout (iwconfig wlan0 power
>   timeout 0 == PS-poll, iwconfig wlan0 power timeout 100ms == send
>   nullfunc and stay awake for 100ms)
>  * "paramter" typo
>  * ibss is in net/mac80211/ibss.c and has been for quite a while
>  * PM in IBSS is not implemented typically
>  * s/80211.s/802.11s/
>  * s/80211.n/802.11n/
>  * you can change the channel with iw (iw phy set freq ...) but it isn't
>   really useful unless you're AP/monitor (and rejected otherwise)
>  * Fedora no longer updates from wireless-testing afaik
>  * wmaster0 is no longer created
>  * assigning interface_modes doesn't set the mode, it just sets the
>   possible modes :)
>  * you can also call iterate_interfaces_atomic() in irq context
>  * nobody cares about the wireless extensions version any more :)
>  * for sniffing you may care about "iw dev <devname> set monitor <flag>*"
>
> Hey that got long!
>
> johannes
>
