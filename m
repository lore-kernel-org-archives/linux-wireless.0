Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:20907 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYLAPxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 10:53:46 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
References: <20081202011754.GA9382@myhost.users.atheros.com>
	<1228132431.3478.21.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 01 Dec 2008 17:52:42 +0200
In-Reply-To: <1228132431.3478.21.camel@johannes.berg> (ext Johannes Berg's message of "Mon\, 01 Dec 2008 12\:53\:51 +0100")
Message-ID: <87skp76gfp.fsf@nokia.com> (sfid-20081201_165350_713032_0FBC5685)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2008-12-01 at 17:17 -0800, Vivek Natarajan wrote:
>> This patch is based on Kalle's initial RFC patches on dynamic power save.
>> Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
>> frame, it is appropriate to do it from mac80211. 
>> This patch enables mac80211 to send a null frame and also to
>> check for tim in the beacon if power save is enabled.
>
> Nice! Looks pretty much good to me, but could use some documentation
> (Kalle will hopefully add some too).

I'm adding some documentation in my next round of patches, but we
definitely need more documentation.

> For instance, a casual observer might wonder how the hardware can be
> saving power when the host software has to parse beacons --

Even without beacon filtering and if there is no traffic, we can turn
off the radios for the time between beacons. For example, with beacon
interval 100 ms and dtim 1 the radios might be turned on for only 10
ms per dtim period. So 90% of the time the radios would be turned off
and we would save power. Of course this is very much hardware
specific, but just to give an idea.

> obviously things will only fall into place once we support beacon
> miss offload.

Beacon filtering improves cpu power consumption.

-- 
Kalle Valo
