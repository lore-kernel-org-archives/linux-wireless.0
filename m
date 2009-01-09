Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27428 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbZAIMNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:13:09 -0500
To: "Ville Nuorvala" <ville.nuorvala@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: Add IWSPY support to mac80211 stack
References: <1230567920-16623-1-git-send-email-ville.nuorvala@gmail.com>
	<1230568151.3116.63.camel@johannes>
	<46fdfd70812291023q62f146edhbbfe7d9f9b9beb1f@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 09 Jan 2009 14:12:12 +0200
In-Reply-To: <46fdfd70812291023q62f146edhbbfe7d9f9b9beb1f@mail.gmail.com> (ext Ville Nuorvala's message of "Mon\, 29 Dec 2008 20\:23\:38 +0200")
Message-ID: <87mye0oezn.fsf@nokia.com> (sfid-20090109_131315_112623_5422314D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Ville Nuorvala" <ville.nuorvala@gmail.com> writes:

> On Mon, Dec 29, 2008 at 6:29 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Mon, 2008-12-29 at 18:25 +0200, Ville Nuorvala wrote:
>>> The IWSPY ioctls and netlink events were supported in the old ieee80211
>>> stack. This patch adds them to mac80211.
>>
>> missing very long explanation as to why this is needed
>
> Hello Johannes,
>
> to my knowledge it is currently the only way to get a realtime
> indication that the wireless link quality has changed, please correct
> me if I'm wrong.

Last fall there was a discussion about roaming in mac80211:

http://markmail.org/message/ml4bjiyd6a26he6x

So we are working on support for quality events, just a bit slowly :/

> Such a feature can be used as an early indication that the link is
> going down, and may help prepare a vertical IP layer handover to for
> example 3G or just another WLAN interface.

I didn't even think about vertical handovers, thanks for pointing it
out. I will keep this in mind.

>> As far as I can tell, nobody uses iwspy support or could possibly want
>> it the way it is done.
>
> The IOCTL interface is horrible, but it's already there and there is a
> tool that supports it; iwspy.
>
> I'm not bringing any new functionality to the wireless stack, I'm just
> reintroducing a feature that got lost when the wireless stack was
> changed.

I'm with Johannes here, let's forget iwspy and do it properly with
nl80211.

-- 
Kalle Valo
