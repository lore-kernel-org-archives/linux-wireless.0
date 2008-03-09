Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:44674 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYCIQnN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 12:43:13 -0400
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/12] at76_usb mac80211 port
References: <20080210145733.17592.61729.stgit@tikku>
	<1202706345.20836.26.camel@dv>
From: Kalle Valo <Kalle.Valo@iki.fi>
Date: Sun, 09 Mar 2008 18:43:09 +0200
In-Reply-To: <1202706345.20836.26.camel@dv> (Pavel Roskin's message of "Mon\, 11 Feb 2008 00\:05\:45 -0500")
Message-ID: <87r6ejyhk2.fsf@litku.valot.fi> (sfid-20080309_164336_266541_08235AC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> On Sun, 2008-02-10 at 16:59 +0200, Kalle Valo wrote:
>> Here's a patch series of my at76_usb mac80211 port. I'm sending them now 
>> for comments. Currently open mode and WEP authentication are supported.
>
> Kalle, thank you for your work!
>
> I've put your patches on http://git.80211libre.org/at76_usb.git so that
> they can be tested by more users.  I gave no promise about continuity of
> the branch, so I'm ready to replace the patches.

Thanks, but it seems that John already applied the patches to
wireless-testing. I would prefer working directly with
wireless-testing, because it's easier for me.

> I haven't looked at the code yet, but here are some testing results.

What hardware and firmware did you use?

> When trying to associate to an AP without security (MadWifi on a PC),
> that's what I see in the logs:
>
> wlan3: Initial auth_alg=0
> wlan3: authenticate with AP 00:0b:6b:56:01:bf
> wlan3: authenticate with AP 00:0b:6b:56:01:bf
> wlan3: RX authentication from 00:0b:6b:56:01:bf (alg=0 transaction=2 status=0)
> wlan3: authenticated
> wlan3: associate with AP 00:0b:6b:56:01:bf
> wlan3: authentication frame received from 00:0b:6b:56:01:bf, but not in authenticate state - ignored
> wlan3: associate with AP 00:0b:6b:56:01:bf
> wlan3: RX AssocResp from 00:0b:6b:56:01:bf (capab=0x421 status=0 aid=1)
> wlan3: associated
> wlan3: association frame received from 00:0b:6b:56:01:bf, but not in associate state - ignored
>
> No pings come through.  I see on the AP that the AP is receiving ARP
> requests and sending ARP replies, so it must be the receiving side in
> at76_usb that is broken.

I'm looking at this. Sometimes I see very odd behaviour, for example
AP not hearing our ACKs even though I can see them just fine with
wireshark. The driver must be doing something wrong.

> You forgot end of line in the message (that's patch 05/12).

I see that you fixed this already, thanks.

> I'm totally at loss why a positive value us printed. When trying to
> set the key and ESSID again, I get this:
>
> wlan3: Initial auth_alg=0
> wlan3: authenticate with AP 00:0b:6b:56:01:bf
> wlan3: authenticate with AP 00:0b:6b:56:01:bf
> wlan3: authenticate with AP 00:0b:6b:56:01:bf
> wlan3: authentication with AP 00:0b:6b:56:01:bf timed out
>
> Pings don't come through.  Everything is within one room.  Attenuation
> shouldn't be an issue.

Do you mean that all your tries failed? That's bad.

> Another interesting problem - scan results show the channel two times
> (not counting the "frequency" line).  Other mac80211 drivers do it once.
> No idea why.

Strange. I'll take a look at it as well.

-- 
Kalle Valo
