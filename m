Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3EMKJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 06:09:43 -0400
Message-ID: <1368439778.8300.20.camel@jlt4.sipsolutions.net> (sfid-20130513_120946_996853_CB228D8C)
Subject: Re: [RFC 0/4] add master channel switch announcement support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Mon, 13 May 2013 12:09:38 +0200
In-Reply-To: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1367867635-3459-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-05-06 at 21:13 +0200, Simon Wunderlich wrote:
> This is an early RFC of a possible channel switch announcement infrastructure.
> It adds CSA/ECSA handling support for AP. This is required for DFS operation
> (e.g. Wi-Fi Alliance requires this for 802.11h certification). This will also
> be required for IBSS-DFS later.
> 
> I'd like to discuss if this design approach is going in the right direction.
> What is currently working:
> 
>  * channels are announced by adding IEs (CSA and Extended CSA) in beacons
>  * after some (configurable) time, the channel is switched
>  * with the channel switch, CSA/ECSA IEs are removed and channel information
>    is updated.
>  * Userspace calls a new command NL80211_CMD_CHANNEL_SWITCH along with channel info
>    (freq + width), whether traffic should be blocked and timing information
>  * it currently works for me [TM] on my ath9k based machine

I don't really like your approach of building all the IEs in the kernel.
There are some things, like the country-after-switch in the CSA wrapper
(introduced in 11ac), that would be really awkward this way.

>  * We already have NL80211_CMD_CH_SWITCH_NOTIFY which is only used for notification.
>    Maybe we can rename that and re-use it instead of adding a new command
>    NL80211_CMD_CHANNEL_SWITCH?

Sure, I don't really care though.

>  * Changes from HT20/NOHT to HT20/NOHT are handled with normal Channel Switch
>    Announcements, everything else (for 40 MHz) is done with Extended Channel Switch
>    Announcements. As far as I read the spec, we can't  use the secondary channel
>    offset IE in beacons, but maybe I'm wrong here?

No, you're right and I was wrong :-)

>  * could other drivers (next to ath9k) work with this API?

Probably not easily. Any TI folks reading this?


Anyway I think it'd be better to try to provide
 (a) the "during-switch IEs", maybe with an offset to the counter so
mac80211,
     driver or the device itself can count down
 (b) the "after-switch beacon" IEs (and maybe probe response for
offload)

johannes

