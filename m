Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:47391 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab0G0Txz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 15:53:55 -0400
Date: Tue, 27 Jul 2010 21:25:03 +0200
From: Ignacy Gawedzki <linux-wireless@qult.net>
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: CARL9170
Message-ID: <20100727192503.GA26504@zenon.in.qult.net>
References: <4C169610.5020907@dlasys.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C169610.5020907@dlasys.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

I happen to be trying to achieve something very similar to what you are aiming
at.  I need to measure each TX frame's "service time", i.e. the interval of
time between the instant this frame is considered for transmission and the
instant the corresponding ACK is received or the transmission is given up (too
many failed transmission attempts).  Then I need this value to be returned to
the kernel with the TX status, for further processing.

Until now, I oversimplistically was doing that measurement upstream, in the
kernel driver, taking a timestamp between the instant a frame is shipped
through the USB framework and the instant the TX completion interrupt is
received.  This approach worked well only when sending sustained traffic
(back-to-back frames), since the TX completion time of the previous frame was
then used as the starting instant of the current frame.  When frames were sent
one-by-one, the measured interval was way too large (as a matter of fact, it
was a lot smaller, while still too large, when I used the ar9170
firmware+driver), so as to become unusable.  Since I discovered the carl9170
firmware+driver, I'm seriously thinking about implementing that measurement
inside the firmware for much higher accuracy.

I read with great interest the threads you started and wanted to ask whether
you managed to advance in your quest.  In the meantime, I continue to read
carl9170 firmware code thoroughly to get a feeling of how things are going on
in it.

Ignacy

-- 
Information wants to be beer, or something like that.
