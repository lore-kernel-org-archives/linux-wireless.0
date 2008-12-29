Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:41349 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbYL2SXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 13:23:40 -0500
Received: by bwz14 with SMTP id 14so16482725bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 10:23:38 -0800 (PST)
Message-ID: <46fdfd70812291023q62f146edhbbfe7d9f9b9beb1f@mail.gmail.com> (sfid-20081229_192343_902705_50DCDF4C)
Date: Mon, 29 Dec 2008 20:23:38 +0200
From: "Ville Nuorvala" <ville.nuorvala@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Add IWSPY support to mac80211 stack
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1230568151.3116.63.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230567920-16623-1-git-send-email-ville.nuorvala@gmail.com>
	 <1230568151.3116.63.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 6:29 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-12-29 at 18:25 +0200, Ville Nuorvala wrote:
>> The IWSPY ioctls and netlink events were supported in the old ieee80211
>> stack. This patch adds them to mac80211.
>
> missing very long explanation as to why this is needed

Hello Johannes,

to my knowledge it is currently the only way to get a realtime
indication that the wireless link quality has changed, please correct
me if I'm wrong.

Such a feature can be used as an early indication that the link is
going down, and may help prepare a vertical IP layer handover to for
example 3G or just another WLAN interface. The predictive nature of
the event allows you (most of the time) to set up the other link
before the WLAN link is down, which allows a make-before-break
handover without packet loss. In fact such events are described in the
IEEE 802.21 Media Independent Handover document. Ideally these events
might be produced by the 802.11 firmware or at least somewhere lower
in the stack, but lacking that, it can at least be emulated by the
IWSPY interface. Also, as an added bonus for using IWSPY, you can
choose the trigger signal levels yourself and don't have to rely on
any preset levels chosen by the device manufacturer.

> As far as I can tell, nobody uses iwspy support or could possibly want
> it the way it is done.

The IOCTL interface is horrible, but it's already there and there is a
tool that supports it; iwspy.

I'm not bringing any new functionality to the wireless stack, I'm just
reintroducing a feature that got lost when the wireless stack was
changed.

Sure a pure netlink interface without any ugly IOCTL hacks would be
nice, but last time I checked the documentation for nl80211 and
cfg80211 was nonexistent, and even driver_nl80211.c straight from the
hostap GIT repository uses WEXT IOCTLs internally for several
different purposes. To me at least it seems like the nl80211 interface
is still far from ready. As my resources are currently very limited, I
don't have time to implement the necessary netlink API and userspace
tools at the moment. The logical conclusion for me was therefore to
just use the old WEXT interface for now.

Regards,
Ville
