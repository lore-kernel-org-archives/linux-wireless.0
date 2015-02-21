Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:37081 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbbBUHNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2015 02:13:40 -0500
Received: by wesw55 with SMTP id w55so9290386wes.4
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 23:13:38 -0800 (PST)
Message-ID: <54E83020.601@gmail.com> (sfid-20150221_081346_845530_8B2890DA)
Date: Sat, 21 Feb 2015 08:13:36 +0100
From: wim torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E1rio_Lopes?= <mjlopes@inescporto.pt>
CC: linux-wireless@vger.kernel.org
Subject: Re: Issue with frame injection on monitor interface (ath9k)
References: <20150219155345.54713ultwqjbtrsp@horde.inescporto.pt> <54E62B1C.9010908@gmail.com> <20150220111149.11345nax1t6qevdx@horde.inescporto.pt>
In-Reply-To: <20150220111149.11345nax1t6qevdx@horde.inescporto.pt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/20/2015 11:11 AM, Mário Lopes wrote:

>
> Quoting wim torfs <wtorfs@gmail.com>:
>
>>
>>
>> On 02/19/2015 03:53 PM, Mário Lopes wrote:
>>> Hi everyone.
>>>
>>> When using frame injection over monitor interface, with handmade packet
>>> with Radiotap header + QoS + Data, at sender I capture the packet with
>>> tcpdump and it is equal to the one I sent.
>>> Although, at receiver station, the packet is diferent, FCS was
>>> recalculated or forced to active and calculated, MCS is not the one I
>>> supplied, sequence number (QoS field) is not the same, amongst other
>>> things.
>>> Also, QoS Ack policy was "No Ack" at sender (QoS Control = 0x0020), a
>>> Ack frame was transmitted to sender and the received packet arrived with
>>> QoS Control = 0x0000.
>>>
>>
>> Mario,
>>
>> If I'm not mistaken, the mac80211 parses your injected packet,
>> retrieves relevant information, such as flags from the radiotap
>> header, removes the radiotap header from your packet and then proceeds
>> with sending the packet as any normal packet towards the radio interface.
>>
>> This, however, means that either the mac80211 rate control algorithm
>> is calls or the ath9k rate control algorithm, depending on your kernel
>> configuration. The ath9k driver uses this rate control information to
>> compose the tx descriptor, after which the packet is handed over to
>> the hardware.
>> I believe it is also the hardware (transmitter side or receiver side,
>> that I don't know), which fills in the actual rate used for the
>> transmission in your packet, since the hardware is capable of
>> retransmitting your packet with a lower rate when transmissions fail
>> too much at the highest rate from the rate selection algorithm.
>>
>> You mentioned that you monitor interface captures the packet as you
>> have sent it. If I remember correctly, the mac80211 forwards this
>> packet towards the monitor interface when the tx status of ath9k has
>> been received, so basically, you receive transmission status
>> information, along with your originally sent packet. Sequence numbers
>> should have been adjusted in this packet I think, however, the
>> transmission rate will be the same as you have specified.
>>
>> If you would like to send at a specific rate, you would need to use
>> the relevant iw commands to fix the transmission rate (or hack ath9k
>> to transmit at a fixed rate).
>>
 > Before trying Radiotap header approach, I did disable Ack's with iw but
 > the transmition rate remained at basic rate (6 Mbit/s) despite forcing
 > higher MCS with iw, so it was useless.
 > Could be this a bug in the driver, unicast traffic sent with NoAck flag
 > treated as a broadcast, despite higher bitrate forcing?
 > Returning to Radiotap, what's the point of injecting a frame with
 > radiotap header if it isn't going to be used? I didn't try all the
 > possible combinations, but the ones I tryied, they where changed before
 > arriving at receiver.
 >
 > Thanks.
 >
 > BR,
 > Mário Lopes.
 >

Mario,

I don't see the relation between the disabling of acks and the rate 
selection. I don't have a working setup currently, so I can not test it, 
but fixing the rate with iw should work. See whether you did everything 
correctly.

I don't have experience with the NoAck flag, so I cannot comment on 
that, however, when reflecting the standard and previous work, I don't 
see any reason why the driver would stick to basic rates. Possibly MPDU 
aggregation is disabled if the NoAck means also no block acks, but this 
does not prevent you to use MCS rates. Look, this is me just thinking 
out loud, so I might be wrong here.

As regards radiotap, it does have its use. For instance, if you look 
into net/mac80211/tx.c and search for ieee80211_parse_tx_radiotap, you 
will notice that it ensures whether or not the 
IEEE80211_TX_INTFL_DONT_ENCRYPT and IEEE80211_TX_CTL_DONTFRAG flags are 
set. Also, it allows you to set the IEEE80211_TX_CTL_NO_ACK flag on a 
per packet base.

Best regards,
Wim.
