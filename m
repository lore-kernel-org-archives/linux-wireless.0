Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:36671 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbYHNGm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 02:42:29 -0400
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
References: <200808120838.52888.hs4233@mail.mn-solutions.de>
From: Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <200808120838.52888.hs4233@mail.mn-solutions.de> (ext Holger Schurig's message of "Tue\, 12 Aug 2008 08\:38\:52 +0200")
Date: Thu, 14 Aug 2008 09:42:10 +0300
Message-ID: <877iak85dp.fsf@nokia.com> (sfid-20080814_084236_161697_82AA0999)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig <hs4233@mail.mn-solutions.de> writes:

> Hi !

Hello,

> The last days I looked a bit at mac80211 and how it works. While
> doing this, I detected that mac80211 does virtually no roaming.
> That is, it is very usable for a hot-spot setup (Office, Home,
> Starbucks), but not for a place where you have 20 Access-Points
> and move between them.

Yes, the current implementation is far from perfect. I will be working
on with roaming as well and want to improve it.

[...]

> How to detect missed beacons?
> -----------------------------
> When I know the beacon period, I could setup a timer
> with "beacon_period + beacon_period*0.5". In the timer function I
> could then increase a missed beacon counter and act accordingly,
> e.g. search for APs, roam etc.
>
> But how would I determine the beacon period?

Jouni answered this one already.

> Is detection of missed beacons good enought?
> --------------------------------------------
> For me this approach seems like driving a car into the wall of a
> house. Then crash-detection notifies me and I'd search for a new
> way to drive.
>
> Certainly it's better to act before the accident happens, so I'd
> rather do it differently. With a fullmac driver I looked at the
> RSSI and, when it fell below a certain threshhold, started the
> roaming.

Yes, we definitely need background scanning which is triggered, at
least, based on a RSSI threshold and possibly some other parameters,
for example number of failed transmissions.

> In-kernel or in-userspace?   --- or hybrid?
> -------------------------------------------

This is the question.

> Some people say that in-userspace roaming is the way to go.

In my opinion we should move roaming logic to the user space as much
as possible.

> Maybe. But in-kernel, I have more information.

Yes, kernel has more information. But kernel can send an event to the
user space whenever where is need to bacground scan or roam.

> In the mac80211 case, the above quoted code is executed whenever I
> receive a beacon. So I can very quickly react to declining SNR.

It wouln't be that much slower to send an event to userspace and let
userspace initiate scanning. This isn't in hotpath.

> Userspace would have to issue periodically scan requests and process
> them, quite a bit of overhead.

Do you mean the overhead of creating the scan results and sending them
to the user space? Is that really so high that we need to optimize it?
Remember that the interval between scans is measured in seconds, so it
doesn't happen very often.

> But there is existing user-space code that does roaming, e.g. WPA
> Supplicant and (probably, not sure) Network-Manager.
>
> So I think I'd opt to a hybrid approach. Userspace uses cfg80211
> to configure some roaming threshold to mac80211. mac80211 would
> gain AP-is-about-to-fail detection and, if it detects this, it
> would signal via cfg80211 (is this possible?) to user-space that
> it should now roam.

I think we need to support Wireless Extensions as well, because
cfg80211 is not widely used yet.

> Userspace then could, while still associated, scan for other APs
> (e.g. first on preferred channels, like 1,6,11, then on all
> channels) and if it finds something, trigger association to
> another AP.

This sounds just what I have been thinking.

> For a WEP or non-encrypted environment a in-kernel-roaming would
> be possible, this would bring a similar behavior to mac80211 that
> common fullmac drivers exhibit. But my first goal would not be in
> this area.

My view is that in kernel roaming is not worth the effort, I would
prefer to keep the implementation simple and not complicate mac80211
unnecessarily. If we have the scan logic in one place, ie. in user
space, implementation and testing is a lot simpler.

-- 
Kalle Valo
