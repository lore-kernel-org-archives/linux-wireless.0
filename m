Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:44253 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754273Ab2J2Aoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2012 20:44:39 -0400
Received: from [70.15.155.205] (port=47052 helo=[206.223.20.150])
	by host200.hostmonster.com with esmtpa (Exim 4.76)
	(envelope-from <dhlii@dlasys.net>)
	id 1TSdT2-0000GT-V1
	for linux-wireless@vger.kernel.org; Sun, 28 Oct 2012 18:44:37 -0600
Message-ID: <1351471475.3551.44.camel@hp-dhlii> (sfid-20121029_014447_777678_7AE340F7)
Subject: Re: Bandwidth monitoring
From: "David H. Lynch Jr." <dhlii@dlasys.net>
Reply-To: dhlii@dlasys.net
To: linux-wireless@vger.kernel.org
Date: Sun, 28 Oct 2012 20:44:35 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From: Christian Lamparter <chunkeey@...>
>> But if I am am using iw to set monitor mode mode, channel, and
>> bandwidth, And using Raw sockets injection with a radiotap header
>> that has no frequency/channel/bandwidth information, 
>> I should then be able to receive that packet on another system
>> with an AR9170 and 1.8.2 Wireshark and the BW40 flag should be true?
>Ah now I see where the problem is.
>You see, the "40MHz bit" is part of the MCS rate meta info (aka flags).
>(See enum mac80211_rate_control_flags in include/net/mac80211.h)
RADIOTAP packet injection is not a manditory facet of my problem. 
I am only using it to inject a packet with know parameters so that I can
trace what is happening for the purposes of duplicating the behavior
either in firmware or in userspace. But before I can do so I need to see
the construction and environment changes needed to transmit an HT40
packet.

I would be happy with any other means of forcing the transmission of an
HT40 packet. RADIOTAP injection is just the only means I am aware of to
do so - and from what I am gathering not an effective one. 




>OffTopic:
>There is also a legacy duplicate flag IEEE80211_TX_RC_DUP_DATA that
>duplicates the 20MHz legacy packet in two 20MHz halves of a 40MHz
>channel. (The downside is that there's no dedicated RX_FLAG for
>that and this information is not available in the radiotap)
This might be sufficient - for the purposes of testing I do nto care
about the data in the packet. 






>The sending part is not. AFAICT you'll have to start by declaring
>and defining a new radiotap rate info element (IEEE80211_RADIOTAP_RATE
>can only handle the bit rate and that is not enough). Then you have
>to add a parser which translate the rate info in the radiotap header
>into mac80211 ieee80211_tx_rate and tell mac80211 to bypass rate_ctrl
>tx handler in this case so the info won't be overwritten again...
>And finally you'll have to add a header with this new rate info element
>into the radiotap header of all the frames you send through the raw
>monitor interface.

>A proof-of-concept should be easily doable within a day. But getting
>this
>new radiotap to be part of the spec will take longer ;)
with my level of Radiotap/mac80211/wifi knowledge this is much more than
a days work.

Any other ideas for forcing transmission of an HT40 packet ?
What If I omit radiotap and just send an ieee80211 raw packet ?

>> So I have been using airmon, wireshark, ....
>> But i need to be able to send and verify an HT40 packet by some
>>somewhat
>> normal means, to assure myself that my receiving end wireshark
>> hardware/driver/software combination can tell me what i need to
>know. 
>Well, you should be able to verify if your device picks up HT40 frames
>easily. All you need is any busy 11n network with a 11n AP and a 11n
>client. Just setup the receiver device (correct channel and HT40+/-
>setting) and start listening.
still not easy - no 80211n AP's just alot of AR9170's.
I guess I am going to be looking for a cheap 80211n AP. 



--
To unsubscribe from this list: send the line "unsubscribe
linux-wireless" in
the body of a message to majordomo@...
More majordomo info at  http://vger.kernel.org/majordomo-info.html


