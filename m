Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39061 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3LMXCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 18:02:03 -0500
Received: by mail-ie0-f174.google.com with SMTP id at1so3802688iec.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Dec 2013 15:02:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA93jw5tOoYGB5Q=vFT6N_G7-KEjGC7=oxH2CwpM9FMT+J_A7g@mail.gmail.com>
References: <20131211174519.34966001@nehalam.linuxnetplumber.net>
	<21161.18818.926049.511664@gargle.gargle.HOWL>
	<C0DD393A-6810-4CB6-B705-AE801ED5BBBA@gmx.de>
	<21162.54025.118938.614891@gargle.gargle.HOWL>
	<CAA93jw5tOoYGB5Q=vFT6N_G7-KEjGC7=oxH2CwpM9FMT+J_A7g@mail.gmail.com>
Date: Fri, 13 Dec 2013 15:02:01 -0800
Message-ID: <CAA93jw7Tj+jdapc-OWFr1LDYQDx3r6crafk302jXJaa3va43-A@mail.gmail.com> (sfid-20131214_000213_637770_71C7B240)
Subject: Re: [Cerowrt-devel] Wireless failures 3.10.17-3
From: Dave Taht <dave.taht@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Sebastian Moeller <sebastian.moeller@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, I couldn't help myself but boot up that release. Wet paint! It
successfully brought up
the 5ghz radio, but did not manage to assign an ip address to it
(netifd bug?) and failed on the 2ghz radio utterly.

trying to restart it manually fails to bring up the 5ghz radio as well.
Here's an strace of that.

http://snapon.lab.bufferbloat.net/~d/hostapd.strace.txt

I don't see it beacon, either.

Now, I don't have a grip on what started happening two releases back
(I was out of town) but I figure it is perhaps more relevant than
chasing the DMA tx thing. And ENOTIME for me on this til sunday. I
will revert this patch and bisect backwards.

root@CMTS:~# wifi enable
command failed: Device or resource busy (-16)
Configuration file: /var/run/hostapd-phy0.conf
nl80211: Could not configure driver mode
nl80211 driver initialization failed.
hostapd_free_hapd_data: Interface gw00 wasn't started
hostapd_free_hapd_data: Interface gw00 wasn't started
hostapd_free_hapd_data: Interface sw00 wasn't started
Failed to start hostapd for phy0
command failed: Too many open files in system (-23)
command failed: Too many open files in system (-23)
ifconfig: SIOCSIFHWADDR: Device or resource busy
command failed: Device or resource busy (-16)
Configuration file: /var/run/hostapd-phy1.conf
nl80211: Could not configure driver mode
nl80211 driver initialization failed.
hostapd_free_hapd_data: Interface gw10 wasn't started
hostapd_free_hapd_data: Interface sw10 wasn't started
Failed to start hostapd for phy1
netifd: Interface 'sw10' is enabled



On Fri, Dec 13, 2013 at 12:56 PM, Dave Taht <dave.taht@gmail.com> wrote:
> On Fri, Dec 13, 2013 at 1:27 AM, Sujith Manoharan <sujith@msujith.org> wrote:
>> Sebastian Moeller wrote:
>>> It is a net gear WNDR3700 v2, so according to:
>>> http://wiki.openwrt.org/toh/netgear/wndr3700 it is a Atheros AR7161 rev 2 680
>>> MHz soc with the following wireless parts: Atheros AR9223 802.11bgn / Atheros
>>> AR9220 802.11an.
>>>
>>> Sure, I hope I got the right one. Now this is not from the same boot as the
>>> one with the errors, but I assume that does not make a difference… Since I am
>>> located in Germany I set the regulatory domain to DE. please let me know if I
>>> you need any additional information or testing (note I am not set up to build
>>> cerowrt myself, so I would need Dave Täht's help to build a modified firmware)
>
> THANK YOU!
>
> I have applied the patch to the next build of cerowrt-3.10.24-1 for
> the wndr3700v2 and 3800 which will be here when the build completes:
>
> http://snapon.lab.bufferbloat.net/~cero2/cerowrt/wndr/3.10.24-1
>
> 100% completely untested by me til sunday! Don't try this on your
> default home router.
>
> While I'm here on linux-wireless:
>
> Cerowrt really needs a new maintainer and more people able to build
> it. I am generally working on some queuing theory (in wireless/wifi)
> right now, fixing a new chipset in a new box that I can't talk about
> (yet), and low on free time, and working on standardizing fq_codel in
> the ietf is eating what little spare time I have left.
>
> Although dedicating my sundays to Cero, I'm losing the general purpose
> skill set required to keep the continuous integration phase from
> openwrt to cero on the wndr3800 going. I care about keeping cero
> going, but after 3 years of building it and after struggling to make
> it stable since august, I'm feeling washed up and burned out on it. I
> think we are very close to a stable release, though, and I'll feel
> much better about things after this bug is gone…
>
> But while I'm limping along...
>
> Any volunteers to help get the next release after this one out? Any
> suggestions for doing it mo better? Or a better strategy for testing
> more fixes for bufferbloat?
>
> There MIGHT be some funding for Cero next year. There never has been
> before, and there have been too many broken promises, sooo the only
> true reward I know of for working on bufferbloat with cerowrt (and it
> is major!) is doing bleeding edge research on the Internet's most
> nagging problems…. and *solving them*.
>
> OK, then there's also the user base, which is wonderful. And the
> notoriety. And kicking the vendors and ISPs making crappy routers in
> the shins on a regular basis. Etc.
>
> I'd like to add a next-generation bleeding edge chip to the effort but
> can't without more funding and more volunteers.
>
>> Can you try this patch ?
>
> I have folded this into cerowrt-3.10.24-1. Note that in addition to
> this problem the last couple builds have been testing dnsmasq 2.68
> which may have also broke at the same time, and I am far from the
> yurtlab right now so I am unable to test before sunday. (use fixed ip
> addrs if it's still busted)
>
> :Crossed fingers:
>
> I note that I don't know if there is a cause or effect relationship in
> the DMA tx bug to what we are actually seeing, with radios falling off
> the net. I have a similar long-standing bug with babel doing ipv6
> ad-hoc mode multicasts and receives and seeing other nodes, but no
> actual unicast traffic being capable of being transmitted. That too
> seems to happen after seeing the DMA tx bug and days of uptime.
>
> I have also setup an ath9k in several x86 boxes to see if this problem
> occurs there. I'd thought it didn't, and that pointed to some sort of
> write barrier problem, maybe...
>
> thanks again for taking a stab at the problem! I was merely going to
> add a WARN_ON to start searching, didn't think this would arrive in my
> mailbox this morning!
>
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
>> index 8d78253..0337de7 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
>> @@ -76,9 +76,16 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>>                                 mask2 |= ATH9K_INT_CST;
>>                         if (isr2 & AR_ISR_S2_TSFOOR)
>>                                 mask2 |= ATH9K_INT_TSFOOR;
>> +
>> +                       if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
>> +                               REG_WRITE(ah, AR_ISR_S2, isr2);
>> +                               isr &= ~AR_ISR_BCNMISC;
>> +                       }
>>                 }
>>
>> -               isr = REG_READ(ah, AR_ISR_RAC);
>> +               if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)
>> +                       isr = REG_READ(ah, AR_ISR_RAC);
>> +
>>                 if (isr == 0xffffffff) {
>>                         *masked = 0;
>>                         return false;
>> @@ -97,11 +104,23 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>>
>>                         *masked |= ATH9K_INT_TX;
>>
>> -                       s0_s = REG_READ(ah, AR_ISR_S0_S);
>> +                       if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
>> +                               s0_s = REG_READ(ah, AR_ISR_S0_S);
>> +                               s1_s = REG_READ(ah, AR_ISR_S1_S);
>> +                       } else {
>> +                               s0_s = REG_READ(ah, AR_ISR_S0);
>> +                               REG_WRITE(ah, AR_ISR_S0, s0_s);
>> +                               s1_s = REG_READ(ah, AR_ISR_S1);
>> +                               REG_WRITE(ah, AR_ISR_S1, s1_s);
>> +
>> +                               isr &= ~(AR_ISR_TXOK |
>> +                                        AR_ISR_TXDESC |
>> +                                        AR_ISR_TXERR |
>> +                                        AR_ISR_TXEOL);
>> +                       }
>> +
>>                         ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
>>                         ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
>> -
>> -                       s1_s = REG_READ(ah, AR_ISR_S1_S);
>>                         ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
>>                         ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
>>                 }
>> @@ -120,7 +139,12 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>>         if (isr & AR_ISR_GENTMR) {
>>                 u32 s5_s;
>>
>> -               s5_s = REG_READ(ah, AR_ISR_S5_S);
>> +               if (pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED) {
>> +                       s5_s = REG_READ(ah, AR_ISR_S5_S);
>> +               } else {
>> +                       s5_s = REG_READ(ah, AR_ISR_S5);
>> +               }
>> +
>>                 ah->intr_gen_timer_trigger =
>>                                 MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
>>
>> @@ -133,6 +157,16 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>>                 if ((s5_s & AR_ISR_S5_TIM_TIMER) &&
>>                     !(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
>>                         *masked |= ATH9K_INT_TIM_TIMER;
>> +
>> +               if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
>> +                       REG_WRITE(ah, AR_ISR_S5, s5_s);
>> +                       isr &= ~AR_ISR_GENTMR;
>> +               }
>> +       }
>> +
>> +       if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
>> +               REG_WRITE(ah, AR_ISR, isr);
>> +               REG_READ(ah, AR_ISR);
>>         }
>>
>>         if (sync_cause) {
>>
>>
>> A version that applies over OpenWrt trunk is here:
>> http://msujith.org/dir/patches/wl/Dec-13-2013/0001-ath9k-Interrupt-handling-fix-for-AR9002-family.patch
>
> Lots of whitespace errors in the git tree. applied. THANKS!
>
>>
>> Sujith
>> _______________________________________________
>> Cerowrt-devel mailing list
>> Cerowrt-devel@lists.bufferbloat.net
>> https://lists.bufferbloat.net/listinfo/cerowrt-devel
>
>
>
> --
> Dave Täht
>
> Fixing bufferbloat with cerowrt: http://www.teklibre.com/cerowrt/subscribe.html



-- 
Dave Täht

Fixing bufferbloat with cerowrt: http://www.teklibre.com/cerowrt/subscribe.html
