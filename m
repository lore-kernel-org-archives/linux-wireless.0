Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:40092 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbaFDMsW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 08:48:22 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Severin Kacianka <severin.kacianka@aau.at>
Cc: linux-wireless@vger.kernel.org
Subject: Re: A question about monitor mode
References: <538EBB1C.3060106@aau.at>
Date: Wed, 04 Jun 2014 15:48:20 +0300
In-Reply-To: <538EBB1C.3060106@aau.at> (Severin Kacianka's message of "Wed, 04
	Jun 2014 08:22:20 +0200")
Message-ID: <87ha40263v.fsf@purkki.adurom.net> (sfid-20140604_144825_246007_AA3BF8E0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Severin Kacianka <severin.kacianka@aau.at> writes:

> I have a question about monitor mode and the monitor interface: When
> will a frame show up in the monitor interface?

The question doesn't really make sense, at least not to me. But I'll try
to answer anyway :)

To simplify, the path when a frame is received with a monitor interface is:

1. hardware
2. firmware
3. driver (eg. ath9k or ath10k)
4. mac80211
5. netdevice
6. user space

And all steps above can cause different amount of latency. So there is
not really a good answer how long it will take the frame to reach user
space.

> If I understand 802.11 correctly, there will first be a Request to
> Send (RTS), then a Clear to Send (CTS) signal. Then the actual frame
> will be send followed by an ACK. I did some testing and it seems, that
> the frame shows up in the monitoring interface after the ACK is
> received.
>
> My test setup was to record the socket.send call of an UDP packet with
> an unique ID and then measure the time it takes for that packet to be
> read on the monitor interface. As the measured time was not constant,
> but seemed to vary in relation to the network conditions I suppose
> that the frame only shows up after its delivery was acknowledged.

There is a strict timing requirements when the ack frame must be sent so
in most of the designs hardware or firmware transmits the ack, host
software (driver/mac80211) cannot provide such accuracy.

-- 
Kalle Valo
