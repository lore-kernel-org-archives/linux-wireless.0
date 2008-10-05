Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:45065 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbYJEVv6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 17:51:58 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Jiri Slaby <jirislaby@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: linux-wireless@vger.kernel.org
Subject: ath5k: kernel timing screwed - due to unserialised register access?
Date: Sun, 05 Oct 2008 23:45:09 +0200
Message-ID: <87k5cm3ee2.fsf@denkblock.local> (sfid-20081005_235205_336127_60F0C1DE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

on my system, I observe some odd symptoms which I have troubled Thomas
with before. After some more investigation, I have come to the
conclusion that ath5k is at the bottom of this, but since I don't really
understand the connection, I thought that Thomas may perhaps throw some
light on the matter, after all, even though I still think that ath5k
will have to be fixed. The Behaviour I'm seeing is this: sometimes,
timers fire prematurely, i.e. a timer x started with

	mod_timer(&x, HZ/50);

fires after less than 10 or even 1 msec rather than 20 msec. Trying to
get to the bottom of this, it struck me that these glitches only occur
when ath5k is loaded and an interface is brought up (ifconfig wlan0 up
is quite sufficient). Some more digging revealed that the occurrences of
such ``fast forward events'' coincided with the expiry of the
recalibration timer started for the interface. The same behaviour can be
observed on kernels 2.6.25.16, 2.6.26.5, 2.6.27-rc8-git8 and
next-20080919.

Looking through the code, I tried to find an obvious suspect, but
nothing struck me as out of the ordinary, except for one thing: There
doesn't seem to be anything in place that ensures serialisation of calls
to the functions involved in calibration or, indeed, accesses to the
card's registers. There definitely are parts of the calibration sequence
that don't just get called from the calibration timer callback, so I
think something has to be done about that.

My first question is, can simultaneous unserialised accesses to
registers possibly disturb softirqs in the way I see it happen, or do I
have to look for something else?

What about the locking issue? In fact, I wonder whether this really is
the only place in the driver where we face the problem of potential
concurrent access to the same registers including bit manipulations that
require a read-write-in-a-row operation.

Regards,

Elias
