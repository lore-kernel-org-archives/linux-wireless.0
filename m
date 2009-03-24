Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:22310 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbZCXJHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 05:07:01 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: Google Summer of Code 2009 -- Linux wireless roaming project
Date: Tue, 24 Mar 2009 10:06:43 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Mircea Gherzan <mgherzan@gmail.com>
References: <20090320215705.GE8120@tesla> <200903211243.25380.helmut.schaa@gmail.com>
In-Reply-To: <200903211243.25380.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903241006.43512.hs4233@mail.mn-solutions.de> (sfid-20090324_100708_603173_CC774A33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Basically roaming can be divided into 3 steps:
> 1) detect if it is time to roam
> 2) scan for better APs
> 3) associate with the new AP
>
> Step 1 is the most difficult one here, 2 only needs some
> tweaking and 3 should work as it is currently.


For one the disadvantage you mentioned I have some ideas:

> - The signal strength values on different cards are not
> comparable. So the threshold value has to be different for all
> cards.

First thing is to make the drivers report similar values in 
similar situations. What would be helful for user-space as well, 
so I think this should eventually be tackled independend of 
roaming anyway.


But consider for now the case where two different cards provide 
values that are (absolutely) quite different. If we look at 
signal differences, this wouldn't harm us that much. Consider 
this bss entries:

bss 1: 45
bss 2: 42   <- also the current one
bss 3: 10

In this case the difference from our BSS to the best matching one 
is only 3. If we have some heuristic that says "Only roam if you 
find an AP which is 6 points betters" we wouldn't roam. If 
another card would report for the same situation

bss 1: 54
bss 2: 50   <- also the current one
bss 3: 12

(that's the same as above, but multiplied by 1.2) the outcome 
would be the same.

> - Ping-pong effect if you sit between two APs both are in
> range but with a signal strength around the threshold.

It's my understanding that a good threshold would also prevent 
ping-pongs ?!?


> - Unnecessary scanning if the signal strength is below the
> threshold but no better AP is in range will further reduce the
> connection quality and increase power consumption.

Either you know that your device is moving, than you want this 
scanning, because soon the scanning is no longer unnecessary. 
Even if at the current position (corner of the 
street/warehouse/whatever) you "scan" in vein, some minutes 
later the situation has changed.

Or you know that you're in hot-spot mode and then you attach to 
an AP and stay with it. Then you don't need the whole roaming 
sermon at all --- this is BTW the reason why mac80211 is, 
despite it's awful roaming, such a success so for.

What I meant is that this is a policy decision (or trade-off 
decision), that the user should be able to influence.


For one of my devices, I made lots of local changes:

- I provide a list of channels for the driver to scan. In most
  warehouses only channels 1, 6, 11 are used. Then there's no
  reason for the driver to scan at channel 2,3,4 etc. If user-
  space didn't provide such a list, the driver has to scan on
  all frequencies, so this is merely an optimization. But an
  important one, helps tremenduously.

- I let the driver scan one frequency every n time units, e.g.
  every second one channel. This makes the driver visit all
  three channels during 3 seconds.

- If I would get all beacons of the current channel, AND if the
  ESSID is not hidden, I would only scan for the channels I'm
  not on. Because for my current channels I have the signal
  strengths of all channels anyway and know also ESSID an IEs
  to decide if I can roam or not, should the need arise.



> b) Number of consecutivley missed beacons below threshold

This tends to roam only when it is too late, e.g. when the 
connection is nearly breaking. But you wrote this by 
yourself :-)

In my case, I'm doing a full scan if this happens, to protect 
about bad channel list provisioning.




> c) Only scan for new APs if the environment changes (e.g. we
> are moving or the AP is moving etc.)

You very seldom know about this, e.g. GPS is mostly useless 
inside big buildings.

You can however record "Okay, when I associated to the AP my 
signal strength was 56. If it drops below 50, I'll look if I 
find something better".

> I already did some research on c) and it looks very promising
> but the topic is quite complex and needs more theoretical
> research first.

If you're serious about that then mac80211 should only get the 
infrastructure necessary so that we can write different roaming 
implementations, like we now have different rate selection 
implementations.


> Scanning for new APs should not be started from within the
> driver or mac80211. Instead wpa_supplicant should care about
> that. Why? Just because the supplicant might have more
> information (maybe provided by NM) about the used network. For
> example a typical multi-AP network won't use all channels from
> within the bg-band due to signal interferences. Instead, all
> APs will be located on non-overlapping channels. Let's say 1,6
> and 11. Hence, if the supplicant tiggers a scan it will just
> leave all channels != 1,6,11 out of the scan request and the
> scan will take a shorter amount of time, which in turn speeds
> up the handoff delay.

That's similar to my local, debugfs-based channel list hack, but 
better :-)

But please make this be able to run from wpa_supplicant alone, 
don't force NM into the picture. Many embedded developers will 
say "thank you" for this. :-)


> extend wpa_supplicant's network blocks to allow the
> specification of preferred channels ("channels=1,6,11"). This
> value could be provided by NM which gathered that information
> either from the user or through monitoring.

Or the value should simply be recorded in wpa_supplicant's config 
file. No need no stinkin' NM !  :-)


> In order to lower the negative influence a scan has to the
> ongoing traffic the software scan implementation would have to
> be reworked. The scan should simply switch back to the
> operating channel every once in a while to allow queued
> packets to be delivered (in both directions).

Yeah, my local scan hack also does this. Scanning is there 
actually a state machine, that scans a maximum of 3 channels at 
one. If the user did not provide a channel list, I still scan 
only 1,6,11 first. If I find now a better AP, I'm using that 
one. Otherwise, I scan 3,8,13. Then 2,5,8 etc. The numbers are a 
bit arbitrary and hardcoded, but you get the picture. Actually, 
the reason for doing this is that this fullmac driver isn't able 
to send null packets (for power save inidication) to the AP, so 
I can leave the current channel only for very short times. That 
it helps maintaining a smooth connection was a welcom side 
effect :-)
