Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:43646 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751906Ab2J1Pht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2012 11:37:49 -0400
Received: from [70.15.155.205] (port=41724 helo=[206.223.20.150])
	by host200.hostmonster.com with esmtpa (Exim 4.76)
	(envelope-from <dhlii@dlasys.net>)
	id 1TSUvs-0007Qh-7l
	for linux-wireless@vger.kernel.org; Sun, 28 Oct 2012 09:37:48 -0600
Message-ID: <1351438667.3551.29.camel@hp-dhlii> (sfid-20121028_163753_641466_6543E79C)
Subject: Re: Bandwidth monitoring
From: "David H. Lynch Jr." <dhlii@dlasys.net>
Reply-To: dhlii@dlasys.net
To: linux-wireless@vger.kernel.org
Date: Sun, 28 Oct 2012 11:37:47 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From: Christian Lamparter
>>># iw dev wlanX set channel 1 HT40+ (or HT40-/HT20)
>> 
>> This is setting up to send on channel 1 HT40+ correct ?
>yes, I hope so.

Thanks

>> Wireshark appears to handle RadioTap - I am seeing lots of other
>flags
>> etc. but not BW40.
>It depends on the version. Here's a screenshot
>from wireshark 1.8.2: <http://imageshack.us/f/703/mcsinfo.png/>
Thanks

>> Googling Radiotap produces lots of comments that suggest that
>>Radiotap
>> headers - send and receive are not necescarily complete or accurate
>>from
>> device to device - is that a reasonable conclusion ?
>Most mac80211 driver should report rx'ed MCS information.
>At least ath9k, ath9k_htc, brcmsmac, carl9170, iwlagn, iwllegacy,
>mwl8k,
>rt2800*, rtl8192* do
Using carl9170 so that should be OK.

>What might not work is: injecting frames with MCS rates [no code
>in ieee80211_parse_tx_radiotap for that?]... So maybe the issue
>is indeed at the other end?

Assuming Carl9170/AR9170's at both ends 
But if I am am using iw to set monitor mode mode, channel, and
bandwidth, 
And using Raw sockets injection with a radiotap header that has no
frequency/channel/bandwidth information, 
I should then be able to receive that packet on another system with an
AR9170 and 1.8.2 Wireshark and the BW40 flag should be true ?

I need to do something that involves sending HT40 packets in a
completely different context. But I do not have a spectrum analyzer to
confirm that i am actually sending what I want.
So I have been using airmon, wireshark, ....
But i need to be able to send and verify an HT40 packet by some somewhat
normal means, to assure myself that my receiving end wireshark
hardware/driver/software combination can tell me what i need to know. 




--
To unsubscribe from this list: send the line "unsubscribe
linux-wireless" in
the body of a message to majordomo@...
More majordomo info at  http://vger.kernel.org/majordomo-info.html


