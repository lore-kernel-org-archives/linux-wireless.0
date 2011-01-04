Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f194.google.com ([209.85.210.194]:41812 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1ADTBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 14:01:06 -0500
Received: by iyf40 with SMTP id 40so6775565iyf.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 11:01:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101041946.56978.helmut.schaa@googlemail.com>
References: <AANLkTim0AM3=T=TMu79ZQi79+CKANamBcz620n2xm8bW@mail.gmail.com>
	<201101041946.56978.helmut.schaa@googlemail.com>
Date: Tue, 4 Jan 2011 19:01:04 +0000
Message-ID: <AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Luis Correia <buga@loide.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: users@rt2x00.serialmonkey.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On Tue, Jan 4, 2011 at 18:46, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
> Hi Aleksandar,
>
> looks like a somewhat strange regulatory handling. However, I'm not really
> familiar with the regulatory stuff. Maybe Luis can give us some info/ideas
> regarding this ...
>
> Luis, mind to have a look at the regulatory messages below?
>

Yes, there is something fishy with it.

this is what is allowed for Ireland

country IE:
	(2402 - 2482 @ 40), (N/A, 20)
	(5170 - 5250 @ 40), (N/A, 20)
	(5250 - 5330 @ 40), (N/A, 20), DFS
	(5490 - 5710 @ 40), (N/A, 27), DFS


Apparently IE Ireland does allow 5Ghz channels, and something is
really strange is going on.

Maybe if the Airport Extreme was changed to a new channel, it would improve.

But I'm not totally sure.

We might also be looking at an old regulatory daemon or database.


Luis Correia
> Am Dienstag, 4. Januar 2011 schrieb Aleksandar Milivojevic:
>> I've searched around a bit and haven't found much information that looks
>> like the problem I'm experiencing with rt2x00 drivers.
>>
>> The hardware I have is Linksys WUSB600N USB stick, v1 hardware revision,
>> which should have RT2870 chipset.  The kernel used is from a generic Ubuntu
>> 10.10 distribution (uname shows "Linux toporko 2.6.35-24-generic #42-Ubuntu
>> SMP Thu Dec 2 01:41:57 UTC 2010 i686 GNU/Linux").  The output of lsusb
>> identifies device as:
>>
>> Bus 001 Device 003: ID 1737:0071 Linksys WUSB600N Dual-Band Wireless-N USB
>> Network Adapter
>>
>> The problem I'm experiencing is that I'm able to connect to my AP (an Apple
>> Airport Extreme operating at 5GHZ) shortly after boot.  However, shortly
>> after connection is made (usually within few minutes), the connection is
>> dropped, and all subsequent attempts to re-connect to AP fail.  Reloading
>> the driver helps to reconnect, but connection is again dropped after few
>> minutes.  I also have another AP (an old Linksys WRT54G) operating on
>> 2.4GHz, and it seems same issue is present if I attempt to connect to it
>> (haven't experimented with this other setup much, as I'm much more
>> interested in connecting to my WiFi-N network).
>>
>> The list of relevant loaded drivers on the system shows (looking for
>> anything starting with 'rt' in the name):
>> rt2800usb               8367  0
>> rt2800lib              28897  1 rt2800usb
>> rt2x00usb               9779  2 rt2800usb,rt2800lib
>> rt2x00lib              27275  2 rt2800lib,rt2x00usb
>> led_class               2633  1 rt2x00lib
>> mac80211              231541  2 rt2x00usb,rt2x00lib
>> cfg80211              144470  2 rt2x00lib,mac80211
>>
>> I have rt2870sta driver blacklisted to prevent it from conflicting with
>> rt2x00 drivers.
>>
>> Looking at the log files, it seems /var/log/messages and /var/log/debug
>> contain most interesting logs.
>>
>> I found following snippet in /var/log/messages:
>>
>> Jan  3 10:39:38 toporko kernel: [   70.143600] ADDRCONF(NETDEV_CHANGE):
>> wlan0: link becomes ready
>> Jan  3 10:39:38 toporko kernel: [   70.143712] cfg80211: Calling CRDA for
>> country: US
>> Jan  3 10:39:38 toporko kernel: [   70.219910] cfg80211: Regulatory domain:
>> US
>> Jan  3 10:39:38 toporko kernel: [   70.219914]     (start_freq - end_freq @
>> bandwidth), (max_antenna_gain, max_eirp)
>> Jan  3 10:39:38 toporko kernel: [   70.219918]     (5170000 KHz - 5250000
>> KHz @ 40000 KHz), (10000 mBi, 3000 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219923]     (5735000 KHz - 5835000
>> KHz @ 40000 KHz), (10000 mBi, 3000 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219928] cfg80211: Regulatory domain:
>> US
>> Jan  3 10:39:38 toporko kernel: [   70.219930]     (start_freq - end_freq @
>> bandwidth), (max_antenna_gain, max_eirp)
>> Jan  3 10:39:38 toporko kernel: [   70.219935]     (2402000 KHz - 2472000
>> KHz @ 40000 KHz), (300 mBi, 2700 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219939]     (5170000 KHz - 5250000
>> KHz @ 40000 KHz), (300 mBi, 1700 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219943]     (5250000 KHz - 5330000
>> KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219947]     (5490000 KHz - 5600000
>> KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219951]     (5650000 KHz - 5710000
>> KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219955]     (5735000 KHz - 5835000
>> KHz @ 40000 KHz), (300 mBi, 3000 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219960] cfg80211: Regulatory domain:
>> 98
>> Jan  3 10:39:38 toporko kernel: [   70.219962]     (start_freq - end_freq @
>> bandwidth), (max_antenna_gain, max_eirp)
>> Jan  3 10:39:38 toporko kernel: [   70.219966]     (5170000 KHz - 5250000
>> KHz @ 40000 KHz), (300 mBi, 1700 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.219971]     (5735000 KHz - 5835000
>> KHz @ 40000 KHz), (300 mBi, 3000 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.220189] cfg80211: Current regulatory
>> domain updated by AP to: US
>> Jan  3 10:39:38 toporko kernel: [   70.220192]     (start_freq - end_freq @
>> bandwidth), (max_antenna_gain, max_eirp)
>> Jan  3 10:39:38 toporko kernel: [   70.220196]     (5170000 KHz - 5250000
>> KHz @ 40000 KHz), (300 mBi, 1700 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.220200]     (5735000 KHz - 5835000
>> KHz @ 40000 KHz), (300 mBi, 3000 mBm)
>> Jan  3 10:39:38 toporko kernel: [   70.409801] padlock: VIA PadLock not
>> detected.
>> Jan  3 10:40:20 toporko kernel: [  112.656632] lo: Disabled Privacy
>> Extensions
>> Jan  3 10:41:31 toporko kernel: [  183.593983] cfg80211: Calling CRDA to
>> update world regulatory domain
>> Jan  3 10:41:31 toporko kernel: [  183.625264] cfg80211: World regulatory
>> domain updated:
>> Jan  3 10:41:31 toporko kernel: [  183.625272]     (start_freq - end_freq @
>> bandwidth), (max_antenna_gain, max_eirp)
>> Jan  3 10:41:31 toporko kernel: [  183.625277]     (2402000 KHz - 2472000
>> KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> Jan  3 10:41:31 toporko kernel: [  183.625282]     (2457000 KHz - 2482000
>> KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> Jan  3 10:41:31 toporko kernel: [  183.625286]     (2474000 KHz - 2494000
>> KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>> Jan  3 10:41:31 toporko kernel: [  183.625290]     (5170000 KHz - 5250000
>> KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>> Jan  3 10:41:31 toporko kernel: [  183.625294]     (5735000 KHz - 5835000
>> KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>
>>
>> I also found similar snippet in /var/log/debug.  Interestingly, unlike the
>> one above that lists IE as US (which is correct for my location, and
>> corresponds to the settings in my AP), in debug log file IE is strangely
>> blank with bunch of lines about disabled frequencies:
>>
>> Jan  3 10:39:38 toporko kernel: [   70.114337] wlan0: authenticate with
>> 00:1e:52:79:e9:ff (try 1)
>> Jan  3 10:39:38 toporko kernel: [   70.114955] wlan0: authenticated
>> Jan  3 10:39:38 toporko kernel: [   70.118103] wlan0: associate with
>> 00:1e:52:79:e9:ff (try 1)
>> Jan  3 10:39:38 toporko kernel: [   70.119214] wlan0: RX AssocResp from
>> 00:1e:52:79:e9:ff (capab=0x511 status=0 aid=1)
>> Jan  3 10:39:38 toporko kernel: [   70.119220] wlan0: associated
>> Jan  3 10:39:38 toporko kernel: [   70.219901] cfg80211: Received country
>> IE:
>> Jan  3 10:39:38 toporko kernel: [   70.219925] cfg80211: CRDA thinks this
>> should applied:
>> Jan  3 10:39:38 toporko kernel: [   70.219957] cfg80211: We intersect both
>> of these and get:
>> Jan  3 10:39:38 toporko kernel: [   70.219977] cfg80211: Leaving channel
>> 2412 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.219981] cfg80211: Leaving channel
>> 2417 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.219985] cfg80211: Leaving channel
>> 2422 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.219988] cfg80211: Leaving channel
>> 2427 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.219992] cfg80211: Leaving channel
>> 2432 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220044] cfg80211: Leaving channel
>> 2437 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220048] cfg80211: Leaving channel
>> 2442 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220052] cfg80211: Leaving channel
>> 2447 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220056] cfg80211: Leaving channel
>> 2452 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220059] cfg80211: Leaving channel
>> 2457 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220063] cfg80211: Leaving channel
>> 2462 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220066] cfg80211: Leaving channel
>> 2467 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220070] cfg80211: Leaving channel
>> 2472 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220073] cfg80211: Leaving channel
>> 2484 MHz intact on phy0 - no rule found in band on Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220078] cfg80211: Disabling channel
>> 5260 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220081] cfg80211: Disabling channel
>> 5270 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220084] cfg80211: Disabling channel
>> 5280 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220087] cfg80211: Disabling channel
>> 5300 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220091] cfg80211: Disabling channel
>> 5310 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220094] cfg80211: Disabling channel
>> 5320 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220097] cfg80211: Disabling channel
>> 5500 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220100] cfg80211: Disabling channel
>> 5510 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220103] cfg80211: Disabling channel
>> 5520 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220106] cfg80211: Disabling channel
>> 5540 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220109] cfg80211: Disabling channel
>> 5550 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220113] cfg80211: Disabling channel
>> 5560 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220116] cfg80211: Disabling channel
>> 5580 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220119] cfg80211: Disabling channel
>> 5590 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220122] cfg80211: Disabling channel
>> 5600 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220125] cfg80211: Disabling channel
>> 5620 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220128] cfg80211: Disabling channel
>> 5630 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220131] cfg80211: Disabling channel
>> 5640 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220135] cfg80211: Disabling channel
>> 5660 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220138] cfg80211: Disabling channel
>> 5670 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220141] cfg80211: Disabling channel
>> 5680 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220144] cfg80211: Disabling channel
>> 5700 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220148] cfg80211: Disabling channel
>> 5835 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220151] cfg80211: Disabling channel
>> 5845 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220154] cfg80211: Disabling channel
>> 5855 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220157] cfg80211: Disabling channel
>> 5865 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220160] cfg80211: Disabling channel
>> 5920 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220163] cfg80211: Disabling channel
>> 5940 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220167] cfg80211: Disabling channel
>> 5960 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220170] cfg80211: Disabling channel
>> 5980 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220173] cfg80211: Disabling channel
>> 6040 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220176] cfg80211: Disabling channel
>> 6060 MHz on phy0 due to Country IE
>> Jan  3 10:39:38 toporko kernel: [   70.220179] cfg80211: Disabling channel
>> 6080 MHz on phy0 due to Country IE
>> Jan  3 10:41:31 toporko kernel: [  183.564046] No probe response from AP
>> 00:1e:52:79:e9:ff after 500ms, disconnecting.
>> Jan  3 10:41:31 toporko kernel: [  183.593968] cfg80211: All devices are
>> disconnected, going to restore regulatory settings
>> Jan  3 10:41:31 toporko kernel: [  183.593977] cfg80211: Restoring
>> regulatory settings
>> Jan  3 10:41:34 toporko kernel: [  186.856369] wlan0: authenticate with
>> 00:1e:52:79:e9:ff (try 1)
>> Jan  3 10:41:34 toporko kernel: [  187.056156] wlan0: authenticate with
>> 00:1e:52:79:e9:ff (try 2)
>> Jan  3 10:41:35 toporko kernel: [  187.256419] wlan0: authenticate with
>> 00:1e:52:79:e9:ff (try 3)
>> Jan  3 10:41:35 toporko kernel: [  187.456054] wlan0: authentication with
>> 00:1e:52:79:e9:ff timed out
>> Jan  3 10:41:47 toporko kernel: [  200.054031] wlan0: direct probe to
>> 00:1e:52:79:e9:ff (try 1)
>> Jan  3 10:41:48 toporko kernel: [  200.252050] wlan0: direct probe to
>> 00:1e:52:79:e9:ff (try 2)
>> Jan  3 10:41:48 toporko kernel: [  200.452085] wlan0: direct probe to
>> 00:1e:52:79:e9:ff (try 3)
>
> We received an empty country IE and as a result disabled serveral 11a channels.
> Maybe even the one we are currently associated to?
>
> Thanks,
> Helmut
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>
