Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 10.mo178.mail-out.ovh.net ([46.105.76.150]:50457 "EHLO
        10.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932489AbeGDByA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 21:54:00 -0400
Received: from player746.ha.ovh.net (unknown [10.109.122.86])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id F39601D03B
        for <linux-wireless@vger.kernel.org>; Tue,  3 Jul 2018 21:55:02 +0200 (CEST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
References: <1523258757.3076.5.camel@sipsolutions.net>
 <20180515102202.2021-1-alexander.wetzel@web.de>
 <1529062392.10037.7.camel@sipsolutions.net>
 <bc327c9b-d5f4-2343-9ca5-932e9295c546@web.de>
 <1529357234.3092.57.camel@sipsolutions.net>
 <2de1493a-5439-b9ef-6d06-3895333f01c3@web.de>
 <1530267147.3481.78.camel@sipsolutions.net>
 <bb4d75d3-7f90-1b58-9525-3f5a54cd952e@web.de>
 <1530611484.4735.18.camel@sipsolutions.net>
From: Alexander Wetzel <alexander.wetzel@web.de>
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
Message-ID: <b1913512-7d33-cd9b-5eb5-4d7f367eb41a@web.de> (sfid-20180704_035422_884678_ED955059)
Date: Tue, 3 Jul 2018 21:54:43 +0200
MIME-Version: 1.0
In-Reply-To: <1530611484.4735.18.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,


> 
>> I was wrong here, this is not an issue. Tkip is simply dropping frames
>> when the IV is too small and never verifies the MIC. And since only MIC
>> errors can trigger counter measures we are fine as it is...
> 
> Err, yes, of course. My bad.
> 
>>>> 3) Is what I implemented. We try what we can with the existing API and
>>>> any driver not working with that has to be considered buggy.
>>>
>>> I don't think we can really do this though. We break - in a potentially
>>> security-relevant way - the older drivers. We can't just say that's
>>> driver bugs, IMHO.
>>
>> We would not break it, only not fix it for all drivers. The current code
>> is already leaking cleartext packets for at least ath9k and most likely
>> many others when the PTK is rekeyed. The patch would improve that, but
>> due to more working rekeys it could leak more packets in specific
>> scenarios, I assume...
> 
> Yeah, ok, fair point. I don't really know.
> 
>>> Obviously if SW crypto is used none of this is a concern, so that's
>>> another factor to take into account in this decision logic of whether to
>>> disconnect or not?
>>
>> I did not check the SW crypto code but I'm pretty sure that indeed works
>> with the current code.
> 
> Me too.
> 
>> I assume the packets will only be decrypted after an RX aggregation is
>> completed. That would filter out all packets send with the old key,
>> since they simply can't be decrypted any more.
> 
> Oh, good point, but that's true - reordering happens before software
> decryption.
> 
>> Shall we bypass stopping aggregation sessions if we are on SW crypto?
>> We'll again lose the benefit that we prevent a broken remote STA to try
>> a TX Agg. (I tend to still stop them, but do not have a real opinion
>> here...)
> 
> I don't really know.
> 
>>> IOW - I'd rather get bugs that we now force a disconnect (if anyone even
>>> notices), rather than potentially having a bug that causes unencrypted
>>> packets to be sent.
>>
>> Any suggestions how to trick hostap/wpa_supplicant into dropping the
>> connection? For me it looks like we can just report an error on key
>> install and expect the wpa_supplicant/hostapd to handle that.
> 
> I think easier would be to just disconnect ourselves? At least if we're
> in managed mode...
>
I still have much to learn about 802.11, but so far I did not see way to
 directly disconnect a STA. (Maybe spoofing a "signal lost" event or
something like that, but I fear complications by losing the sync with
the remote STA.) Is there any call/signal you have in mind I could test?

hostapd or wpa_supplicant are "ordering" mac80211 to install a new key
and are implementing the state machine and are in a good position to
handle the fallout... at least theoretically.


>> Will try that for the next version of the patch, with the other
>> discussed improvements: If driver is not signalling "PTK0 rekey support"
>> we'll simply not accept key installs when we already have a old PTK key
>> for the connection.
> 
> Since I see you have a new patch - how did that work out? :)

So far I've only tested it with iwlwifi client (dvm, so no AP) on my
normal "desktop".

When implementing replace_key it seems to work fine. (No OTA captures
done, just connection tests with the AP running still using the previous
patch.)

Using a unpatched iwlwifi does not reconnect automatically as expected.

Instead I get a pop up asking for the PSK. Entering it reconnects
normally. Cancel the prompt disconnect till a manual reconnect.
I suspect NetworkManager is handling the rekey like the initial key
install and then assumes the PSK is wrong. Hardly surprising but also
highly visible to the users.
But then only to those using the now broken rekey...


Using wpa_supplicant directly reconnects after ~15s.
It also assumes the key is wrong and seems to rate limit the connection
attempts. Here a log with wpa_supplicat running in the console and dmesg
-wT output on top of that:

wlp3s0: WPA: Failed to set PTK to the driver (alg=3 keylen=16
bssid=12:6f:3f:0e:33:3c)
[Tue Jul  3 21:13:17 2018] wlp3s0: Driver is not supporting save PTK key
replacement. Insecure rekey attempt for STA 12:6f:3f:0e:33:3c denied.
[Tue Jul  3 21:13:17 2018] wlp3s0: deauthenticating from
12:6f:3f:0e:33:3c by local choice (Reason: 1=UNSPECIFIED)
wlp3s0: CTRL-EVENT-DISCONNECTED bssid=12:6f:3f:0e:33:3c reason=1
locally_generated=1
wlp3s0: WPA: 4-Way Handshake failed - pre-shared key may be incorrect
wlp3s0: CTRL-EVENT-SSID-TEMP-DISABLED id=0 ssid="mordor-g"
auth_failures=1 duration=10 reason=WRONG_KEY
wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
[Tue Jul  3 21:13:17 2018] wlp3s0: delba from 12:6f:3f:0e:33:3c
(initiator) tid 0 reason code 37
[Tue Jul  3 21:13:17 2018] wlp3s0: Rx BA session stop requested for
12:6f:3f:0e:33:3c tid 0 initiator reason: 0
[Tue Jul  3 21:13:17 2018] wlp3s0: moving STA 12:6f:3f:0e:33:3c to state 3
[Tue Jul  3 21:13:17 2018] wlp3s0: moving STA 12:6f:3f:0e:33:3c to state 2
[Tue Jul  3 21:13:17 2018] wlp3s0: moving STA 12:6f:3f:0e:33:3c to state 1
[Tue Jul  3 21:13:17 2018] wlp3s0: Removed STA 12:6f:3f:0e:33:3c
[Tue Jul  3 21:13:17 2018] wlp3s0: Destroyed STA 12:6f:3f:0e:33:3c


wlp3s0: CTRL-EVENT-SSID-REENABLED id=0 ssid="mordor-g"
wlp3s0: SME: Trying to authenticate with 12:6f:3f:0e:33:3c
(SSID='mordor-g' freq=2432 MHz)
wlp3s0: Trying to associate with 12:6f:3f:0e:33:3c (SSID='mordor-g'
freq=2432 MHz)
[Tue Jul  3 21:13:31 2018] wlp3s0: authenticate with 12:6f:3f:0e:33:3c
[Tue Jul  3 21:13:31 2018] wlp3s0: Allocated STA 12:6f:3f:0e:33:3c
[Tue Jul  3 21:13:31 2018] wlp3s0: Inserted STA 12:6f:3f:0e:33:3c
[Tue Jul  3 21:13:31 2018] wlp3s0: send auth to 12:6f:3f:0e:33:3c (try 1/3)
[Tue Jul  3 21:13:31 2018] wlp3s0: authenticated
[Tue Jul  3 21:13:31 2018] wlp3s0: moving STA 12:6f:3f:0e:33:3c to state 2
[Tue Jul  3 21:13:31 2018] wlp3s0: associate with 12:6f:3f:0e:33:3c (try
1/3)
wlp3s0: Associated with 12:6f:3f:0e:33:3c
wlp3s0: CTRL-EVENT-SUBNET-STATUS-UPDATE status=0
wlp3s0: CTRL-EVENT-REGDOM-CHANGE init=COUNTRY_IE type=COUNTRY alpha2=DE
[Tue Jul  3 21:13:31 2018] wlp3s0: RX AssocResp from 12:6f:3f:0e:33:3c
(capab=0x431 status=0 aid=1)
[Tue Jul  3 21:13:31 2018] wlp3s0: moving STA 12:6f:3f:0e:33:3c to state 3
[Tue Jul  3 21:13:31 2018] wlp3s0: WMM AC=0 acm=0 aifs=2 cWmin=3 cWmax=7
txop=47 uapsd=0, downgraded=0
[Tue Jul  3 21:13:31 2018] wlp3s0: WMM AC=1 acm=0 aifs=2 cWmin=7
cWmax=15 txop=94 uapsd=0, downgraded=0
[Tue Jul  3 21:13:31 2018] wlp3s0: WMM AC=2 acm=0 aifs=3 cWmin=15
cWmax=1023 txop=0 uapsd=0, downgraded=0
[Tue Jul  3 21:13:31 2018] wlp3s0: WMM AC=3 acm=0 aifs=7 cWmin=15
cWmax=1023 txop=0 uapsd=0, downgraded=0
[Tue Jul  3 21:13:31 2018] wlp3s0: associated
wlp3s0: WPA: Key negotiation completed with 12:6f:3f:0e:33:3c [PTK=CCMP
GTK=CCMP]
wlp3s0: CTRL-EVENT-CONNECTED - Connection to 12:6f:3f:0e:33:3c completed
[id=0 id_str=]
[Tue Jul  3 21:13:31 2018] wlp3s0: moving STA 12:6f:3f:0e:33:3c to state 4
[Tue Jul  3 21:13:31 2018] wlp3s0: AddBA Req buf_size=64 for
12:6f:3f:0e:33:3c
[Tue Jul  3 21:13:31 2018] wlp3s0: Rx A-MPDU request on
12:6f:3f:0e:33:3c tid 0 result 0

A test with the code on a AP is still pending. (I'll probably try that
on the weekend.)

Alexander
