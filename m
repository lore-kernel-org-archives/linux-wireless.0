Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:43888 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759844AbZC0TOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 15:14:55 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1476754wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 12:14:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2da21fe50903271208m1c369c88lba8399416dace43a@mail.gmail.com>
References: <2da21fe50903270727m7b7007ctaa846aea61902436@mail.gmail.com>
	<87ljqr58oa.fsf@litku.valot.fi> <2da21fe50903271208m1c369c88lba8399416dace43a@mail.gmail.com>
Date: Fri, 27 Mar 2009 12:14:38 -0700
Message-ID: <43e72e890903271214g6e4497ao9c53e782a7807df9@mail.gmail.com> (sfid-20090327_201512_157557_AE752744)
Subject: Re: ath9k and power management
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 27, 2009 at 12:08 PM, Davide Pesavento <davidepesa@gmail.com> wrote:
> On Fri, Mar 27, 2009 at 15:42, Kalle Valo <kalle.valo@iki.fi> wrote:
>> Davide Pesavento <davidepesa@gmail.com> writes:
>>
>>> I'm running a 2.6.29-wl kernel, using ath9k and wpa_supplicant 0.6.9
>>> (with -Dnl80211).
>>> Enabling power management when connected (i.e. 'iwconfig wlan0 power
>>> on'), causes the currently established connection to break and the
>>> machine is no longer able to reconnect to the AP.
>>
>> Try with a timeout, for example three seconds:
>>
>> iwconfig wlan0 power timeout 3
>>
>> It might be that ath9k doesn't work when timeout is zero (which 'power
>> on' effectively does). You need a fairly new wireless-tools to set the
>> timeout, older versions had a bug with that.
>>
>
> Ok, I installed wireless-tools 30-pre8 and tried with a timeout.
> The results are more or less the same as before...
>
> < iwconfig wlan0 power timeout 3 >
>
> [ 2315.293198] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2321.296532] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2327.299864] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2333.303208] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2335.303190] wlan0: no probe response from AP 00:1b:2f:58:30:76 -
> disassociating
> [ 2335.303431] phy0: Removed STA 00:1b:2f:58:30:76
> [ 2335.333248] phy0: Destroyed STA 00:1b:2f:58:30:76
> [ 2388.465095] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 2388.669843] wlan0: deauthenticating by local choice (reason=3)
> [ 2388.840995] ADDRCONF(NETDEV_UP): wlan0: link is not ready
>
> < manual restart of wpa_supplicant >
>
> [ 2392.979891] wlan0: dropped data frame to not associated station
> 00:00:00:00:00:00
> [ 2403.113236] wlan0: dropped data frame to not associated station
> 00:00:00:00:00:00
> [ 2403.705107] wlan0: authenticate with AP 00:1b:2f:58:30:76
> [ 2403.707389] wlan0: authenticated
> [ 2403.707395] wlan0: associate with AP 00:1b:2f:58:30:76
> [ 2403.710568] wlan0: RX AssocResp from 00:1b:2f:58:30:76 (capab=0x431
> status=0 aid=1)
> [ 2403.710574] wlan0: associated
> [ 2403.710603] phy0: Allocated STA 00:1b:2f:58:30:76
> [ 2403.710622] phy0: Inserted STA 00:1b:2f:58:30:76
> [ 2403.710628] wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15
> cWmax=1023 txop=0
> [ 2403.710643] wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15
> cWmax=1023 txop=0
> [ 2403.710656] wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
> [ 2403.710668] wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
> [ 2403.710685] wlan0: switched to short barker preamble
> (BSSID=00:1b:2f:58:30:76)
> [ 2403.710690] wlan0: switched to short slot time (BSSID=00:1b:2f:58:30:76)
> [ 2403.711356] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [ 2408.535506] ath9k: rx failed to go idle in 10 ms RXSM=0xdeadbeef
> [ 2414.393163] wlan0: no IPv6 routers present
> [ 2421.536523] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2427.539851] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2433.543195] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2439.546535] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2451.413267] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2461.416589] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [ 2467.419835] wlan0: beacon loss from AP 00:1b:2f:58:30:76 - sending
> probe request
> [...]

Thanks for reporting this, it will be looked at internally.

  Luis
