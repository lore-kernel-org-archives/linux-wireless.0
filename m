Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35447 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933350Ab2HVVGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2012 17:06:09 -0400
Message-ID: <503549B2.7030900@hauke-m.de> (sfid-20120822_230614_023650_FE68B423)
Date: Wed, 22 Aug 2012 23:05:54 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Bastian Bittorf <bittorf@bluebottle.com>,
	openwrt-devel@lists.openwrt.org, linux-wireless@vger.kernel.org,
	feint@lists.subsignal.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: WRT54g / b43 / mac802.11 BREAKTHROUGH
References: <1342612598.5006a476022c6@mail.bluebottle.com> <50350706.609@hauke-m.de> <503528BD.2020302@lwfinger.net>
In-Reply-To: <503528BD.2020302@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2012 08:45 PM, Larry Finger wrote:
> On 08/22/2012 11:21 AM, Hauke Mehrtens wrote:
>> On 07/18/2012 01:56 PM, Bastian Bittorf wrote:
>>> hi devs!
>>>
>>> yesterday we had a breaktrough debugging b43 in our hackspace
>>> maschinenraum/m18[1,2]
>>> at weimar.freifunk.net[3,4] - since a long time our darling wrt54g
>>> suffers from a
>>> hanging wifi and bad performance[5], but the workaround is easy: now
>>> it's up to
>>> you to fix the rootcause.
>>>
>>> our testsetup, where we could _reproduce_ reliably a stopping TX is
>>> like this:
>>>
>>> laptop ---lan--- "A"-wrt54g/adhoc ~~~   air  ~~~ "B"-anyrouter/adhoc
>>>
>>> now make a testdownload with the laptop from B.
>>> wireless will stop working after ~10 seconds.
>>>
>>> wifi up will reanimate and our freifunk-cron.minutely-check
>>> will do this automagically. (read further, this is not the solution)
>>>
>>> we tried to limit the rateset to e.g. lower rates, but this does NOT
>>> change
>>> the behaviour. what works is: define a rateset on BOTH router which
>>> makes
>>> it impossible to change the band, e.g.:
>>>
>>> iw dev $WIFIDEV set bitrates legacy-2.4 1 2 5.5 11
>>> OR
>>> iw dev $WIFIDEV set bitrates legacy-2.4 6 9 12 18 24 36 48 54
>>>
>>> now we had a great performance, 10 Gigabytes of wireless transfer,
>>> no stopping TX anymore and an empty box of beer. three things to do now:
>>>
>>> 1) why does a band change (can be seen through minstrel) is a problem?
>>>
>>> 2) we have to make in config-option to force a band, or a rateset:
>>>     e.g. uci set wireless.radio0.hwmode=11g
>>>     e.g. uci set wireless.radio0.bitrates='6 9 12 18 24 36 48 54'
>>>
>>> 3) spread to word:
>>>     there is a great frustration in the community about b43,
>>>     but the old drivers _have_ to die, it's about time - really.
>>>
>>> thanks for your work,
>>> bye storchi, andi, bastian + m18 crew
>>>
>>> [1] http://blog.maschinenraum.tk/
>>> [2]
>>> http://blog.maschinenraum.tk/2012/07/15/bitcoin-vending-machine-exchange-euro-coins-for-bitcoin-wallets/
>>>
>>> [3] http://wireless.subsignal.org
>>> [4] http://wireless.subsignal.org/index.php?title=Main_Page_en
>>> [5] https://dev.openwrt.org/ticket/7552
>>
>> I tried this on some of my devices (BCM4318 G-PHY and BCM4322 N-PHY) and
>> it is easily reproducible on all tested devices when restricting the
>> rates to 11 and 12 MBit/s.
>>
>> I have the Broadcom device working as an Access point (on a MIPS SoC)
>> and a Laptop with an Intel Wifi device is connected to it. I generated
>> the traffic with iperf. If the Access Points sends the traffic the
>> problem occurs, if it is just receiving there is not problem.
>>
>> After the problem occurred b43_generate_txhdr is called rarely ( every
>> ~10 seconds) and I am not able to stay connected or connect to the
>> network any more. I am not familiar with the internal flow in b43 or
>> mac80211 could someone give me a hint where to look.
>>
>> I can not see any special changes between CCK and OFDM rates before it
>> goes down there are many changes without a problem before it goes down.
>>
>> Currently I do not have a Broadcom wifi card running in a x86 device
>> just mips devices could someone try to reproduce the problem on a x86
>> device.
>>
>> I added the b43 mailing list and Rafał.
> 
> Hauke or Bastian,
> 
> Do you have any info whether the failure occurs with the change from
> OFDM to CCK, or vice versa? I am wondering if the radio needs a dummy
> transmission when the switch happens. I will try to put together a patch
> to test that hypothesis.
> 
> Larry

It is strange. The stop does not occur directly after changing from OFDM
to CCK or vice versa. TX seams to still work, but the device does not
receive anything any more.

Here are some logs from my device:
http://hauke-m.de/files/b43/wifi-stop/2012-08-22/b43-ap-block.txt
Patch used:
http://hauke-m.de/files/b43/wifi-stop/2012-08-22/b43-ap-block.patch

"iw dev wlan0 set bitrates legacy-2.4 11 12" was issued at ~120.000000.

How do I monitor this particular channel with an other wifi card to get
most of the packages, with aircrack I am unable to set the channel?

Hauke
