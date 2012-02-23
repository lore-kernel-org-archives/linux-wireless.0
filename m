Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2023 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2BWNQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 08:16:32 -0500
Message-ID: <4F463C25.8030302@broadcom.com> (sfid-20120223_141636_573465_AB31A8A9)
Date: Thu, 23 Feb 2012 14:16:21 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Guilherme M. Schroeder" <guialemas@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: bcm43224 and brcmsmac - lost connection from time to time
References: <CAM7_POV_J6Ms6sKbOjeRSyB9W-Uxsh92vbsUnUi93mi-9-xQew@mail.gmail.com>
 <CAM7_POUyyiaWk6g2tVQv4MezqO04HrFKRZfwuzRW-COB3BOYHQ@mail.gmail.com>
In-Reply-To: <CAM7_POUyyiaWk6g2tVQv4MezqO04HrFKRZfwuzRW-COB3BOYHQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2012 06:02 AM, Guilherme M. Schroeder wrote:
> On Thu, Feb 23, 2012 at 2:46 AM, Guilherme M. Schroeder
> <guialemas@gmail.com>  wrote:
>> Hi,
>>
>> I'm using Linux 3.2.7 and brcmsmac with BCM43224 (MacBookAir4,2).
>> I have a Time Capsule Dual Band AP (single SSID providing both bands).
>>
>> While using it, sometimes i lost connection with it and on dmesg
>> (attached) i just see this:
>>
>> [14122.660359] ieee80211 phy0: brcms_c_prec_enq_head: No where to go, prec == 4
>> [14122.660405] ieee80211 phy0: brcms_c_prec_enq_head: No where to go, prec == 4
>> [14122.660456] ieee80211 phy0: brcms_c_prec_enq_head: No where to go, prec == 4
>> [14122.660501] ieee80211 phy0: brcms_c_prec_enq_head: No where to go, prec == 4
>>
>> If you look at the log, you will see a lot of BA timeouts and
>> reassociations with the AP.
>> Some other strange messages too.
>>
>> I'm not too far from the router (but have some walls), here is what i
>> get almost all the time:
>>
>> wlan0     IEEE 802.11abgn  ESSID:"cala boca jow"
>>           Mode:Managed  Frequency:2.412 GHz  Access Point: 90:84:0D:D7:28:51
>>           Bit Rate=57.8 Mb/s   Tx-Power=19 dBm
>>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>>           Power Management:off
>>           Link Quality=34/70  Signal level=-76 dBm
>>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>           Tx excessive retries:1  Invalid misc:90   Missed beacon:0
>>
>> And latency:
>>
>> --- 192.168.0.1 ping statistics ---
>> 20 packets transmitted, 20 received, 0% packet loss, time 19022ms
>> rtt min/avg/max/mdev = 0.750/4.346/30.749/7.148 ms
>>
>> When i lost connection, i can't ping the router, but i still have
>> signal and i'm still connected in it.
>> I need to turn wifi off and on to continue working.
>>
>> Do you now anything that can help avoiding this?
>> If some debug is needed, let me know (i like doing this stuff).
>>
>> I really want to use brcmsmac as wl blob doesn't work nice (besides PM).
>>
>> BTW, do you have plans when PM will be developed for this driver?
>>
>> Thanks.
>
> Hmm, one thing that i noticed:
>
> [16101.221548] wlan0: authenticate with 90:84:0d:d7:28:51 (try 1)
> [16101.223232] wlan0: authenticated
>
> [14380.923563] wlan0: authenticate with 90:84:0d:d7:28:52 (try 1)
> [14381.122993] wlan0: authenticate with 90:84:0d:d7:28:52 (try 2)
> [14381.123583] wlan0: authenticated
>
> Maybe the driver is getting lost because of the Dual Band router using
> the same SSID?
> I think that one of this MACs is 2.4GHz and other is 5GHz, but i'm not sure.
>
> I also noticed this commit:
>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=5e379203c7788b7af01150bfadbc74d2797a2ef4
>
> Maybe it could help with the stack trace problem that i get
> (brcms_c_wait_for_tx_completion).
>
> I'm compiling wireless-next right now and see what happens.
>

That patch should certainly improve things. With A-MPDU retrying 
endlessly on 2.4 BSS, I can imagine mac80211 trying the other BSS with 
the same ESSID, ie. the 5G one.

Gr. AvS

