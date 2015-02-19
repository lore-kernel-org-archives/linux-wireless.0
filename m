Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:40466 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbbBSS1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 13:27:46 -0500
Received: by wesx3 with SMTP id x3so1402565wes.7
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 10:27:45 -0800 (PST)
Message-ID: <54E62B1C.9010908@gmail.com> (sfid-20150219_192750_463706_A5ED0D3A)
Date: Thu, 19 Feb 2015 19:27:40 +0100
From: wim torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E1rio_Lopes?= <mjlopes@inescporto.pt>
CC: linux-wireless@vger.kernel.org
Subject: Re: Issue with frame injection on monitor interface (ath9k)
References: <20150219155345.54713ultwqjbtrsp@horde.inescporto.pt>
In-Reply-To: <20150219155345.54713ultwqjbtrsp@horde.inescporto.pt>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/19/2015 03:53 PM, Mário Lopes wrote:
> Hi everyone.
>
> When using frame injection over monitor interface, with handmade packet
> with Radiotap header + QoS + Data, at sender I capture the packet with
> tcpdump and it is equal to the one I sent.
> Although, at receiver station, the packet is diferent, FCS was
> recalculated or forced to active and calculated, MCS is not the one I
> supplied, sequence number (QoS field) is not the same, amongst other
> things.
> Also, QoS Ack policy was "No Ack" at sender (QoS Control = 0x0020), a
> Ack frame was transmitted to sender and the received packet arrived with
> QoS Control = 0x0000.
>

Mario,

If I'm not mistaken, the mac80211 parses your injected packet, retrieves 
relevant information, such as flags from the radiotap header, removes 
the radiotap header from your packet and then proceeds with sending the 
packet as any normal packet towards the radio interface.

This, however, means that either the mac80211 rate control algorithm is 
calls or the ath9k rate control algorithm, depending on your kernel 
configuration. The ath9k driver uses this rate control information to 
compose the tx descriptor, after which the packet is handed over to the 
hardware.
I believe it is also the hardware (transmitter side or receiver side, 
that I don't know), which fills in the actual rate used for the 
transmission in your packet, since the hardware is capable of 
retransmitting your packet with a lower rate when transmissions fail too 
much at the highest rate from the rate selection algorithm.

You mentioned that you monitor interface captures the packet as you have 
sent it. If I remember correctly, the mac80211 forwards this packet 
towards the monitor interface when the tx status of ath9k has been 
received, so basically, you receive transmission status information, 
along with your originally sent packet. Sequence numbers should have 
been adjusted in this packet I think, however, the transmission rate 
will be the same as you have specified.

If you would like to send at a specific rate, you would need to use the 
relevant iw commands to fix the transmission rate (or hack ath9k to 
transmit at a fixed rate).

Best regards,
Wim.


