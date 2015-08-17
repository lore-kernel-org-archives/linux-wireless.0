Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55877 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbbHQPdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 11:33:07 -0400
Message-ID: <55D1FEB2.4060205@candelatech.com> (sfid-20150817_173311_739082_EDF5929D)
Date: Mon, 17 Aug 2015 08:33:06 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sven Eckelmann <sven@open-mesh.com>
CC: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	simon@open-mesh.com, Marek Lindner <marek@open-mesh.com>
Subject: Re: CT ath10k firmware now supports IBSS + RSN
References: <55285D8D.6070703@candelatech.com> <1701816.PemaYpqoq5@bentobox>
In-Reply-To: <1701816.PemaYpqoq5@bentobox>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/17/2015 06:11 AM, Sven Eckelmann wrote:
> Hi,
> 
> On Friday 10 April 2015 16:32:29 Ben Greear wrote:
>> First, thanks to everyone that helped me with questions,
>> QCA/Tieto's upstream patches, etc.
>>
>> This needs more testing, but it appears to at least mostly work.
>>
>> I am using this 4.0 related kernel.  I think only the last 3 patches
>> are IBSS specific, but possibly there are others that matter as well.
>>
>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-4.0.dev.y/.git;a=summary
>>
>> Firmware binaries and release notes are here:
>> http://www.candelatech.com/downloads/ath10k-fw-beta/
>>
>> I'm using a very recent wpa_supplicant..upstream should work I think,
>> but I am using this one:
>>
>> https://github.com/greearb/hostap-ct/tree/master/hostapd
>>
>> supplicant needs to have this enabled, among other things:
>>
>> CONFIG_IBSS_RSN=y
> 
> thanks for your work on the QCA firmware fork. I have testing your
> firmware v14 (firmware-2-ct-full-community.bin;
> md5sum 800799459c20c1683138c74b3ba58f25) a little bit on OpenWrt r46413
> (+ your patches [1]) with a QCA9880 device and focus on IBSS.
> 
> The performance over IBSS looks a lot better than before. So your
> aggregation/BlockAck fix seems to work quite well.

Thanks for giving it a try!

> 
> But there are also some problems which I've noticed.
> 
>  * setting the mcast rate during `iw dev "$ifname" ibss join`
>    doesn't seem to work for IBSS mode. The bcast frames are still
>    transmitted with 6Mbit/s
>    - I've also tried to use the hack
>      + echo mcast > /sys/kernel/debug/ieee80211/phy0/ath10k/set_rates
>      + iw dev adhoc0 set bitrates legacy-5 18

This is likely fixable, but I have higher priority things to work on
first.  It seems one could spend a good deal of effort in the
rate-ctrl logic.

I am also interested in pursuing host-based rate-ctrl, but I would need
the help of some driver writers as I don't have time to do it all myself.

>  * IBSS/RSN isn't working between ath10k<->ath10k, ath9k<->ath10k
>    (works well between ath9k<->ath9k)
>    - the ath10k device doesn't seem to send its broadcast frames
>      after the handshake finished (ath9k already tries to transmit
>      bcast frames)
>    - also doesn't work with firmware-2-ct-non-commercial-full-14.bin
>      and nohwcrypt=1

I believe I had ath10k to ath9k + RSN work, but I did see problems with ath10k-ath10k + RSN.

I think sometimes it worked a bit, and then stopped.  Truth is, my customers
interested in IBSS are not doing encryption on the IBSS interface, so I have no plans to work on this
soon.  And, even if offered the opportunity, I'm not sure what I could do to
improve the problem.  Possibly someone at QCA would have ideas and might share
them with me...


>  * IBSS stops working everytime an AP interface is added to the same
>    PHY (it isn't importing whether it is using WPA/WPA2 or configured
>    as open AP)
>    - tested again with ath9k on the same OpenWrt version and it
>      working quite well with 1x IBSS + 2x AP

One of my customers is using AP + IBSS interface with no obvious problems
related to concurrency.  But, maybe they are doing things in a different
order.  Does it work for you if you bring up AP first and then add IBSS?

This is likely fixable.

> Were you able to get anything from the above setups working for you?
> Maybe there are some workarounds I've missed and that you've
> mentioned in other mails. It would be really nice if you could
> mention those again :)
> 
> Especially interesting would be to know if some of the problems are
> already known and just not implemented. Are the not implemented
> features planned or currently not the development goal for this
> firmware?

In general, I have about as much work as I can handle.  General development
goals are rate-ctrl improvements, more stability improvements, maybe IBSS + AMSDU
support (that is what I disabled to make it run at least moderately fast).

Part of my rate-ctrl effort is allowing radio-tap transmit to work, and especially
to allow some per-pkt settings w/regard to rate-ctrl.  I am not sure how possible
this will be, but so far, it seems like something I have a chance at making work.

We also see bugs with ANQP and 802.11r roaming....I am thinking this may be
at least partially a driver bug...might have to add a peer for whoever we
are doing ANQP with, for instance.  I'm not sure how multiple peers on a station
vdev will work or not.

Thanks,
Ben

> 
> Kind regards,
> 	Sven
> 
> [1] https://dev.cloudtrax.com/git/ath10k-ibss-test.git/shortlog/refs/heads/master-20150824
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

