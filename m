Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4236 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2FXJmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jun 2012 05:42:00 -0400
Message-ID: <4FE6E0D3.8050704@broadcom.com> (sfid-20120624_114206_320354_6E7AEC75)
Date: Sun, 24 Jun 2012 11:41:39 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jonathan Nieder" <jrnieder@gmail.com>
cc: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"Stanislaw Gruszka" <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	"Seth Forshee" <seth.forshee@canonical.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: Re: [3.2.y] Brcmsmac driver woes, possible regression?
References: <CAKprTDHQT8Oodh_YD5CWffSGJXAg-HgFMjR0STVgEZRxH4FaSQ@mail.gmail.com>
 <20120604084200.GA30645@tiikeri.vuoristo.local>
 <20120604173121.GA9238@stt008.linux.site>
 <20120605050620.GC3118@burratino>
 <CAKprTDHGqDpdZY4ErZmPEc7Ur81GeQoH8tiAL5hrfhAE0RtbvQ@mail.gmail.com>
 <20120610224902.GB3419@burratino>
 <20120611063014.GA4579@stt008.linux.site>
 <CAKprTDHYMyDwvxA52Z9zxP75ZUY5=FfCGPTZZg9ZxTxReFj7pQ@mail.gmail.com>
 <20120619180335.GA19354@burratino>
 <CAKprTDGM8TJC51Bqideeg447+qR5YnfihgORUFdJL_hW9YHiTw@mail.gmail.com>
 <20120623175040.GE2495@burratino>
In-Reply-To: <20120623175040.GE2495@burratino>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/23/2012 07:50 PM, Jonathan Nieder wrote:
> Hi again,
> 
> Camaleón wrote[1]:
>> 2012/6/19 Jonathan Nieder <jrnieder@gmail.com>:
>>> Camaleón wrote:
> 
>>>> Update: I've been running kernel 3.2.2-1 over 4 days (since last
>>>> Saturday until today) and still haven't experienced any disconnection.
>>>
>>> Interesting.  I wonder if the workaround in f96b08a7e6f6 (brcmsmac:
>>> fix tx queue flush infinite loop, 2012-01-17) has too short a timeout
>>> and is backfiring.
>>
>> Mmm...
>>
>>> How about this patch, for 3.2.y kernels?  I suggest the following
>>> steps for testing:
>>
>> (...)
>>
>> Thanks for the detailed steps.
>>
>> I've planned to start debugging over the weekend because I have more
>> spare time for this but the last (yesterday?) set of updates for
>> wheezy have left the system in a very bad shape. Is not only that N-M
>> is reconnecting very often (!) but gnome-shell and mail-notification
>> are segfaulting as crazy horses.
>>
>> I'm attaching the syslog.
>>
>> There is also a "new" segfault coming from "net/wireless/mlme.c" (I
>> say "new" because I don't recall this file was involved in the past
>> :-?) so given the current state of the system I'm a bit reluctant of
>> running more test at least for now. Let's see if an upcoming update
>> restores the sanity to the system. I'll keep you informed.
> 
> Just realized upstream was not in the cc.  Moving to there.
> 
> If I understand correctly, these symptoms are similar to those you
> experienced with 3.2.9-1.  So there is no reason to believe
> f96b08a7e6f6 is the source of the trouble after all.  The problem must
> originate somewhere else.  Right?
> 
> Syslog at [1].
> 
> Thanks,
> Jonathan
> 
> [1] http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=230;bug=664767
> 
> [...]
>> Jun 23 12:43:28 stt300 kernel: [    0.000000] Linux version 3.2.0-1-686-pae (Debian 3.2.2-1) (ben@decadent.org.uk) (gcc version 4.6.2 (Debian 4.6.2-12) ) #1 SMP Wed Feb 1 09:39:41 UTC 2012
> [...]
>> Jun 23 12:44:37 stt300 NetworkManager[1478]: <info> Activation (wlan0/wireless): connection 'WLAN_B5' has security, and secrets exist.  No new secrets needed.
> [...]
>> Jun 23 12:44:38 stt300 kernel: [   88.476883] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [...]
>> Jun 23 12:44:40 stt300 dhclient: bound to 192.168.0.150 -- renewal in 123164 seconds.
> [...]
>> Jun 23 12:59:05 stt300 wpa_supplicant[1514]: wlan0: WPA: Group rekeying completed with 00:23:f8:9d:ad:11 [GTK=TKIP]
> [...]
>> Jun 23 13:14:41 stt300 wpa_supplicant[1514]: wlan0: WPA: Key negotiation completed with 00:23:f8:9d:ad:11 [PTK=TKIP GTK=TKIP]
> [...]
>> Jun 23 13:29:05 stt300 wpa_supplicant[1514]: wlan0: WPA: Group rekeying completed with 00:23:f8:9d:ad:11 [GTK=TKIP]
> [...]
>> Jun 23 13:41:44 stt300 kernel: [ 3513.868441] ieee80211 phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
>> Jun 23 13:41:44 stt300 kernel: [ 3513.868462] ieee80211 phy0: brcmsmac: brcms_ops_bss_info_changed: disassociated
>> Jun 23 13:41:44 stt300 kernel: [ 3513.868478] ieee80211 phy0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
>> Jun 23 13:41:45 stt300 wpa_supplicant[1514]: wlan0: CTRL-EVENT-DISCONNECTED bssid=00:23:f8:9d:ad:11 reason=4

This means AP is not receiving anything from this machine.

>> Jun 23 13:41:45 stt300 kernel: [ 3514.806036] cfg80211: Calling CRDA to update world regulatory domain
> [...]
>> Jun 23 13:41:45 stt300 kernel: [ 3514.825799] cfg80211: Calling CRDA for country: ES
>> Jun 23 13:41:45 stt300 kernel: [ 3514.840865] cfg80211: Regulatory domain changed to country: ES
> [...]

I am curious how the system would behave if you select US instead ES
country.

Gr. AvS

