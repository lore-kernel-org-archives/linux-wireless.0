Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsrv0.aau.at ([143.205.180.48]:58194 "EHLO
	mailsrv.uni-klu.ac.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190AbaFDOsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 10:48:05 -0400
Message-ID: <538F3165.5090707@aau.at> (sfid-20140604_164812_396530_C3FCC36A)
Date: Wed, 04 Jun 2014 16:47:01 +0200
From: Severin Kacianka <severin.kacianka@aau.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: A question about monitor mode
References: <538EBB1C.3060106@aau.at> <87ha40263v.fsf@purkki.adurom.net>
In-Reply-To: <87ha40263v.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/04/2014 02:48 PM, Kalle Valo wrote:
> The question doesn't really make sense, at least not to me. But I'll try
> to answer anyway :)

Thank you - I will try to better state my question. Let's say we have
two nodes A and B and A sends a packet to B while monitoring all
wireless traffic on mon0. We now have two scenarios when A sees its
packet in its monitor interface.
The first scenario is, that the packet shows up right after it is send
(i.e. after calling socket.send). The other is, that the packet is held
in some layer (probably the firmware) until the ACK is received and the
packet was really "send" before being passed to the monitoring interface.

In my concrete case, I have a program that sends RTP packets to an other
host. It logs the time of the socket.send call and then also logs the
time the packet is read from mon0 (RTP packets have sequence numbers, so
it is easy to match the packets).
I then noticed that this delay is usually extremely small (around 0.001
sec), but will quickly rise when the receiver is moved away from the
sender (up to 10 seconds and more). Along with this rise in the delay
the video quality will degrade to unwatchable when the delay rises
quickly (and quickly improves when the delay gets smaller).

My assumption is that the packet first has to be acknowledged, before it
shows up in the monitoring interface. Due to the movement the connection
quality is probably reduced and thus may require retransmissions (and so
increase this delay).

I am however not sure if this is how it really works :)

Thank you,
Severin



