Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:33829 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab1AELwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 06:52:08 -0500
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <i@lri.fr>)
	id 1PaRIs-0006vM-5i
	for linux-wireless@vger.kernel.org; Wed, 05 Jan 2011 12:13:18 +0100
Received: from ig by zenon.in.qult.net with local (Exim 4.72)
	(envelope-from <i@lri.fr>)
	id 1PaRIp-0006N0-08
	for linux-wireless@vger.kernel.org; Wed, 05 Jan 2011 12:13:15 +0100
Date: Wed, 5 Jan 2011 12:13:14 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: About clocks in the carl9170 firmware
Message-ID: <20110105111314.GA23794@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

A few months ago, Christian Lamparter suggested to me the use of
get_clock_counter() in the carl9170 firmware code for time measurement
purposes.

I just got back to that, after a long period of other things to do instead.

According to the results of a few tests I've been running yesterday, it looks
that this clock is 44Mhz, not 40Mhz, nor 80Mhz.

According to Christian, the clock source, as accessed through
get_clock_counter() is stable and does not depend on calls to clock_set().
This is further corroborated by the definition and use of the
AR9170_TICKS_PER_MICROSECOND *constant* in timer.h.  But still, how comes that
constant is 80 then?

I'm obviously missing something here.  I would be really thankful to anybody
who could explain how these clocks/timers work and how they are supposed to be
used.

Thanks,

Ignacy

-- 
I have not lost my mind, it's backed up on disk somewhere.
