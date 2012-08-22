Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55035 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2HVRtg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 13:49:36 -0400
Received: by wibhq12 with SMTP id hq12so173139wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2012 10:49:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50350706.609@hauke-m.de>
References: <1342612598.5006a476022c6@mail.bluebottle.com>
	<50350706.609@hauke-m.de>
Date: Wed, 22 Aug 2012 19:49:35 +0200
Message-ID: <CACna6rxTkc-0aXjettNKaz7mN3Bc2MS7Bo1OYxH_E7fzqKKctw@mail.gmail.com> (sfid-20120822_194941_303586_D64BF780)
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Bastian Bittorf <bittorf@bluebottle.com>,
	openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	feint@lists.subsignal.org, b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/22 Hauke Mehrtens <hauke@hauke-m.de>:
> On 07/18/2012 01:56 PM, Bastian Bittorf wrote:
>> hi devs!
>>
>> yesterday we had a breaktrough debugging b43 in our hackspace maschinenraum/m18[1,2]
>> at weimar.freifunk.net[3,4] - since a long time our darling wrt54g suffers from a
>> hanging wifi and bad performance[5], but the workaround is easy: now it's up to
>> you to fix the rootcause.
>>
>> our testsetup, where we could _reproduce_ reliably a stopping TX is like this:
>>
>> laptop ---lan--- "A"-wrt54g/adhoc ~~~   air  ~~~ "B"-anyrouter/adhoc
>>
>> now make a testdownload with the laptop from B.
>> wireless will stop working after ~10 seconds.
>>
>> wifi up will reanimate and our freifunk-cron.minutely-check
>> will do this automagically. (read further, this is not the solution)
>>
>> we tried to limit the rateset to e.g. lower rates, but this does NOT change
>> the behaviour. what works is: define a rateset on BOTH router which makes
>> it impossible to change the band, e.g.:
>>
>> iw dev $WIFIDEV set bitrates legacy-2.4 1 2 5.5 11
>> OR
>> iw dev $WIFIDEV set bitrates legacy-2.4 6 9 12 18 24 36 48 54
>>
>> now we had a great performance, 10 Gigabytes of wireless transfer,
>> no stopping TX anymore and an empty box of beer. three things to do now:
>>
>> 1) why does a band change (can be seen through minstrel) is a problem?
>>
>> 2) we have to make in config-option to force a band, or a rateset:
>>       e.g. uci set wireless.radio0.hwmode=11g
>>       e.g. uci set wireless.radio0.bitrates='6 9 12 18 24 36 48 54'
>>
>> 3) spread to word:
>>    there is a great frustration in the community about b43,
>>    but the old drivers _have_ to die, it's about time - really.
>>
>> thanks for your work,
>> bye storchi, andi, bastian + m18 crew
>>
>> [1] http://blog.maschinenraum.tk/
>> [2] http://blog.maschinenraum.tk/2012/07/15/bitcoin-vending-machine-exchange-euro-coins-for-bitcoin-wallets/
>> [3] http://wireless.subsignal.org
>> [4] http://wireless.subsignal.org/index.php?title=Main_Page_en
>> [5] https://dev.openwrt.org/ticket/7552
>
> I tried this on some of my devices (BCM4318 G-PHY and BCM4322 N-PHY) and
> it is easily reproducible on all tested devices when restricting the
> rates to 11 and 12 MBit/s.
>
> I have the Broadcom device working as an Access point (on a MIPS SoC)
> and a Laptop with an Intel Wifi device is connected to it. I generated
> the traffic with iperf. If the Access Points sends the traffic the
> problem occurs, if it is just receiving there is not problem.
>
> After the problem occurred b43_generate_txhdr is called rarely ( every
> ~10 seconds) and I am not able to stay connected or connect to the
> network any more. I am not familiar with the internal flow in b43 or
> mac80211 could someone give me a hint where to look.
>
> I can not see any special changes between CCK and OFDM rates before it
> goes down there are many changes without a problem before it goes down.
>
> Currently I do not have a Broadcom wifi card running in a x86 device
> just mips devices could someone try to reproduce the problem on a x86
> device.
>
> I added the b43 mailing list and Rafał.

Does your kernel include

commit bad6919469662b7c92bc6353642aaaa777b36bac
Author: francesco.gringoli@ing.unibs.it <francesco.gringoli@ing.unibs.it>
Date:   Fri Dec 16 18:34:56 2011 +0100

    b43: avoid packet losses in the dma worker code.

? I have a lot of things on my TODO list, including that. Right now I
just want to focus on BCM4706 support, which slowly moves into
mainline.

-- 
Rafał
