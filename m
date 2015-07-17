Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f50.google.com ([209.85.216.50]:35075 "EHLO
	mail-vn0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbbGQM20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 08:28:26 -0400
Received: by vnaa140 with SMTP id a140so274065vna.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 05:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHjFwoD20-PMejmNEmJp=hH016yjaLXPocCV3u6-34PpAoshHg@mail.gmail.com>
References: <CAHjFwoB8N=uKrVv3qkFyr4BuPuY9L71kXqvJP3HZ+3qj=7z_ag@mail.gmail.com>
 <CAHjFwoAv2NA243S6UF=uK7ZoSxOWzdeayCAX5EOrVPP_NsGMMg@mail.gmail.com>
 <9f46c4afaab64213bdbbffe8227fcf00@NASANEXM01E.na.qualcomm.com> <CAHjFwoD20-PMejmNEmJp=hH016yjaLXPocCV3u6-34PpAoshHg@mail.gmail.com>
From: Su Kang Yin <paradyse@gmail.com>
Date: Fri, 17 Jul 2015 20:27:52 +0800
Message-ID: <CAHjFwoAcDfq0oh6k0Ctsk+Z2JWQaTs0t5ZSwg-4+UBwC6KU87g@mail.gmail.com> (sfid-20150717_142830_421737_27DCEF7E)
Subject: Re: ath9k 4.1.2 freeze
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pan,

The problem fixed!! Thank you!

- cantona

On 17 July 2015 at 18:39, Su Kang Yin <paradyse@gmail.com> wrote:
> Hi Pan,
>
> I applied 736-MIPS-ath79-fix-chained-irq-disable.patch but make no difference.
>
> Thanks,
> cantona
>
> [  238.200000] ath: phy3: rx chain 1: iq corr coeff=fffffffd
> [  238.210000] ath: phy3: Doing Tx IQ Cal for chain 1
> [  238.210000] ath: phy3: IQ_RES[0]=0xcf4e200e IQ_RES[1]=0xff2f
> [  238.220000] ath: phy3: IQ_RES[2]=0xf3f314f4 IQ_RES[3]=0x292f
> [  238.220000] ath: phy3: IQ_RES[4]=0x9cfa7001 IQ_RES[5]=0xfe32
> [  238.230000] ath: phy3: chain 1: mag mismatch=0 phase mismatch=0
> [  238.230000] ath: phy3: tx chain 1: mag corr=1  phase corr=-13
> [  238.240000] ath: phy3: tx chain 1: iq corr coeff=f3
> [  238.250000] ath: phy3: rx chain 1: mag corr=-1  phase corr=-3
> [  238.250000] ath: phy3: rx chain 1: iq corr coeff=fffffffd
> [  238.260000] ath: phy3: Doing Tx IQ Cal for chain 1
> [  238.260000] ath: phy3: IQ_RES[0]=0xc654d011 IQ_RES[1]=0xff9f
> [  238.270000] ath: phy3: IQ_RES[2]=0xf0f20561 IQ_RES[3]=0x2caf
> [  238.270000] ath: phy3: IQ_RES[4]=0xd0f9dffd IQ_RES[5]=0xfe02
> [  238.280000] ath: phy3: chain 1: mag mismatch=0 phase mismatch=0
> [  238.280000] ath: phy3: tx chain 1: mag corr=0  phase corr=-13
> [  238.290000] ath: phy3: tx chain 1: iq corr coeff=73
> [  238.300000] ath: phy3: rx chain 1: mag corr=-1  phase corr=-2
> [  238.300000] ath: phy3: rx chain 1: iq corr coeff=fffffffe
> [  238.310000] ath: phy3: enabling IQ Calibration
> [  238.310000] ath: phy3: starting IQ Mismatch Calibration
> [  238.320000] ath: phy3: Enabled BB Watchdog timeout (25 ms)
> [  238.320000] ath: phy3: New interrupt mask 0xf4000473
> [  238.330000] ath: phy3: new IMR 0x81800175
> [  238.330000] ath: phy3: macaddr: 00:1a:dd:d4:73:a0, bssid:
> 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
> [  238.340000] ath: phy3: Enable MIB counters
> [  238.350000] ath: phy3: Restore history: opmode 2 chan 2412 Mhz
> is_scanning=0 ofdm:3 cck:2
> [  238.350000] ath: phy3: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
> [  238.360000] ath: phy3: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
> [  238.370000] ath: phy3: New interrupt mask 0xf4000473
> [  238.370000] ath: phy3: new IMR 0x81800175
> [  238.370000] ath: phy3: enable IER
> Freezed here--------------------
>
> On 17 July 2015 at 17:28, Pan, Miaoqing <miaoqing@qti.qualcomm.com> wrote:
>> +Felix
>>
>> Seems the new version miss two patches,
>>
>> Upstream: a3e6c1eff54878506b2dddcc202df9cc8180facb
>> http://git.openwrt.org/?p=openwrt.git;a=blob;f=target/linux/ar71xx/patches-3.18/736-MIPS-ath79-fix-chained-irq-disable.patch;h=8cb38d3971678e3cf951d36e6ab2f4b170cd1f0c;hb=HEAD
>>
>> - Miaoqing
>>
>> -----Original Message-----
>> From: Su Kang Yin [mailto:paradyse@gmail.com]
>> Sent: Friday, July 17, 2015 4:36 PM
>> To: linux-wireless@vger.kernel.org; ath9k-devel
>> Subject: Re: ath9k 4.1.2 freeze
>>
>> log attached
>>
>> On 17 July 2015 at 16:35, Su Kang Yin <paradyse@gmail.com> wrote:
>>> resend
>>>
>>>
>>> On 17 July 2015 at 16:33, Su Kang Yin <paradyse@gmail.com> wrote:
>>>>
>>>> Hi,
>>>>
>>>> Kernel 4.1.2 ath9k with atheros DB120, driver lockup on "enable IER"
>>>> after AHB interface up (PCI interface is fine). No problem found on kernel 3.10.
>>>>
>>>> - cantona
>>>>
>>>> [   83.990000] ath: phy1: tx chain 1: iq corr coeff=74
>>>> [   84.000000] ath: phy1: rx chain 1: mag corr=0  phase corr=-2
>>>> [   84.000000] ath: phy1: rx chain 1: iq corr coeff=7e
>>>> [   84.010000] ath: phy1: Doing Tx IQ Cal for chain 1
>>>> [   84.010000] ath: phy1: IQ_RES[0]=0xd248900b IQ_RES[1]=0xfeff
>>>> [   84.020000] ath: phy1: IQ_RES[2]=0xf0f46499 IQ_RES[3]=0x262f
>>>> [   84.020000] ath: phy1: IQ_RES[4]=0x66fa9fff IQ_RES[5]=0xfe82
>>>> [   84.030000] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
>>>> [   84.040000] ath: phy1: tx chain 1: mag corr=0  phase corr=-13
>>>> [   84.040000] ath: phy1: tx chain 1: iq corr coeff=73
>>>> [   84.050000] ath: phy1: rx chain 1: mag corr=0  phase corr=-3
>>>> [   84.050000] ath: phy1: rx chain 1: iq corr coeff=7d
>>>> [   84.060000] ath: phy1: Doing Tx IQ Cal for chain 1
>>>> [   84.060000] ath: phy1: IQ_RES[0]=0xcc4ed011 IQ_RES[1]=0xff2f
>>>> [   84.070000] ath: phy1: IQ_RES[2]=0xeff334fa IQ_RES[3]=0x295f
>>>> [   84.070000] ath: phy1: IQ_RES[4]=0x9bfa1ffd IQ_RES[5]=0xfe42
>>>> [   84.080000] ath: phy1: chain 1: mag mismatch=0 phase mismatch=0
>>>> [   84.090000] ath: phy1: tx chain 1: mag corr=0  phase corr=-14
>>>> [   84.090000] ath: phy1: tx chain 1: iq corr coeff=72
>>>> [   84.100000] ath: phy1: rx chain 1: mag corr=0  phase corr=-2
>>>> [   84.100000] ath: phy1: rx chain 1: iq corr coeff=7e
>>>> [   84.110000] ath: phy1: enabling IQ Calibration
>>>> [   84.110000] ath: phy1: starting IQ Mismatch Calibration
>>>> [   84.120000] ath: phy1: Enabled BB Watchdog timeout (25 ms)
>>>> [   84.120000] ath: phy1: New interrupt mask 0xf4000473
>>>> [   84.130000] ath: phy1: new IMR 0x81800175
>>>> [   84.130000] ath: phy1: macaddr: 00:11:aa:d4:73:a0, bssid:
>>>> 00:00:00:00:00:00, bssidmask: ff:ff:ff:ff:ff:ff
>>>> [   84.140000] ath: phy1: Enable MIB counters
>>>> [   84.150000] ath: phy1: Restore history: opmode 2 chan 2412 Mhz
>>>> is_scanning=0 ofdm:3 cck:2
>>>> [   84.150000] ath: phy1: **** ofdmlevel 3=>3, rssi=0[lo=7 hi=40]
>>>> [   84.160000] ath: phy1: **** ccklevel 2=>2, rssi=0[lo=7 hi=40]
>>>> [   84.170000] ath: phy1: New interrupt mask 0xf4000473
>>>> [   84.170000] ath: phy1: new IMR 0x81800175
>>>> [   84.170000] ath: phy1: enable IER
>>>> =======================<FREEZE on wlan1
>>>> (AHB))========================================
>>>>
