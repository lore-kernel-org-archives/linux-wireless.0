Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30361 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbYHNHFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 03:05:43 -0400
To: "Jouni Malinen" <j@w1.fi>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
References: <200808120838.52888.hs4233@mail.mn-solutions.de>
	<20080812082246.GD4981@jm.kir.nu>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 14 Aug 2008 10:05:27 +0300
Message-ID: <87skt86pqg.fsf@nokia.com> (sfid-20080814_090546_571613_EB8B1401)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <j@w1.fi> writes:

> On Tue, Aug 12, 2008 at 08:38:52AM +0200, Holger Schurig wrote:
>
>> How to detect missed beacons?
>> -----------------------------
>> When I know the beacon period, I could setup a timer
>> with "beacon_period + beacon_period*0.5". In the timer function I
>> could then increase a missed beacon counter and act accordingly,
>> e.g. search for APs, roam etc.
>
> Some (most?) wlan hardware designs allow this to be done in
> firmware/hardware and that would likely be more efficient way of
> determining missed beacons. In other words, the design here should take
> into account the possibility of moving this functionality into the
> driver and only optionally (if no hw support) set up this to be done
> with host CPU and timers.

Yes, I have seen firmwares which can send an event if beacons are
lost. This feature is really needed.

>> But how would I determine the beacon period?
>
> struct ieee80211_sta_bss::beacon_int
>
> (in TUs, i.e., 1.024 ms)
>
>> Is detection of missed beacons good enought?
>> --------------------------------------------
>> Certainly it's better to act before the accident happens, so I'd
>> rather do it differently. With a fullmac driver I looked at the
>> RSSI and, when it fell below a certain threshhold, started the
>> roaming.
>
> That is another feature that is available in many hw/firmware designs
> even for softmac drivers (i.e., interrupt if current BSS signal strength
> drops below a threshold value). This could tricker a background scan to
> figure out whether there are better APs available at the moment.
> Similarly, it would be useful to be able to trigger such background
> scans periodically even without a specific signal strength trigger.

I agree, we need this feature as well.

>> In-kernel or in-userspace?   --- or hybrid?
>> -------------------------------------------
>
>> So I think I'd opt to a hybrid approach. Userspace uses cfg80211
>> to configure some roaming threshold to mac80211. mac80211 would
>> gain AP-is-about-to-fail detection and, if it detects this, it
>> would signal via cfg80211 (is this possible?) to user-space that
>> it should now roam.
>
> I would also think that this is the most useful design. You could
> already do background scanning in the kernel (triggered by whatever) and
> just sen SIOCSIWSCAN WE event to notify user space (e.g.,
> wpa_supplicant) of availability of new scan results. This is something
> that madwifi for example is already doing.

Didn't think of it like this. Yes, that's possible as well. But in
some cases we might want to create more advanced scanning logic, for
example different scanning parameters based on if the display is on or
off and stuff like that. If the kernel issues the scan, making more
advanced logic based on policy is more difficult. With user space
roaming this would be simpler.

>> For a WEP or non-encrypted environment a in-kernel-roaming would
>> be possible, this would bring a similar behavior to mac80211 that
>> common fullmac drivers exhibit. But my first goal would not be in
>> this area.
>
> That should not be limited to just WEP or plaintext. If mac80211 reports
> association even to a new BSS, wpa_supplicant should be able to complete
> WPA/IEEE 802.1X handshake with the new AP after that.

What about PMKSA caching? Shouldn't user space need to provide PMKIDs
(or the IEs) to mac80211 before association?

I'm still in favor of handling roaming in user space.

-- 
Kalle Valo
