Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:41686 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab1JYQvw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 12:51:52 -0400
Received: from zenon.in.qult.net ([192.168.128.3])
	by qult.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.74)
	(envelope-from <i@lri.fr>)
	id 1RIjgs-0006PR-TJ
	for linux-wireless@vger.kernel.org; Tue, 25 Oct 2011 18:17:27 +0200
Received: from ig by zenon.in.qult.net with local (Exim 4.76)
	(envelope-from <i@lri.fr>)
	id 1RIjgr-0003H3-Po
	for linux-wireless@vger.kernel.org; Tue, 25 Oct 2011 18:17:25 +0200
Date: Tue, 25 Oct 2011 18:17:25 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: linux-wireless@vger.kernel.org
Subject: Measuring TX service time in ath9k
Message-ID: <20111025161725.GA10475@zenon.in.qult.net> (sfid-20111025_185156_248554_57816346)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After having played around with carl9170 and implementing TX service time
measurement in the firmware itself (thanks to Christian Lamparter for his
precious help), we're trying to achieve something equivalent, but in the
driver, for ath9k.

The idea is to measure, for each outgoing unicast frame, the time required to
transmit it, from the moment the interface considers the frame for
transmission and waits for the medium to be clear for at least a DIFS, up to
the moment the interface receives the corresponding ACK frame or gives up
trying because of not receiving any ACK after too many retransmissions.

The way we used to measure that, first in madwifi and then in ath5k, was the
following: take the system current time at the moment the frame is sent to the
interface by the driver and store that (let's call it "start") in the tx
descriptor, which is kept until the "tx complete" interrupt arrives from the
interface.  When the "tx complete" interrupt arrives, take the system time
again (let's call it "now").  When the tx buffers are empty, i.e., when we are
sending frames "slowly", the difference now - start is the value we want to
measure plus some overhead.  When the tx buffers are not empty (we are sending
fast), the overhead is too big, so instead of considering now - start, we
consider now - last, "last" being the "now" from the previous "tx complete"
interrupt.  So in a nutshell, service_time = now - max(start, last).

In practice, the average measured values for the service time when sending
fast were pretty realistic, whereas those when sending slowly were exagerated
by some notable factor.

By implementing the measurements in the firmware, when we started to play with
carl9170, the overhead when sending slowly was small enough for the measured
service time to be realistic both when sending slowly and when sending fast.

Now we ported back the measurements in the ath9k driver and to our surprise,
the measurements when sending slowly are *smaller* and more stable than the
measurements when sending fast.  Nevertheless, it appears that measurements
when sending fast are the most realistic, as usual (when we divide the number
of bytes sent by the sum of service times, we get something very close to what
iperf outputs when asked to send a flow of UDP packets at full speed).

The way we do it in ath9k is the following.  We take the "start" time in
ath_tx_txqaddbuf(), for each entry in the head list and save it into an added
field of the struct ath_buf pointed to by bf.  We take the "now" time as soon
as possible in ath_isr() and save it into an added field of the struct
ath_softc pointed by sc just before calling tasklet_schedule(&sc->intr_tq).
The calculation is performed in ath_tx_complete(), by taking the "start" from
bf (that we passed additionally from the caller), "now" from sc and "last"
also from sc.

If I understand correctly, no call to ath_isr is possible while in
ath_tx_tasklet, since the interrupts are disabled before scheduling it and
re-enabled by it before returning.

Could someone be kind to explain what could be the reason of this
counterintuitive "underhead" in the measurements when sending slowly?  Is it
the management of TX queues that makes the service times larger when sending
fast vs. when sending slowly?

Note that we're testing this only in ad-hoc mode, so no aggregation takes
place, and all user traffic is sent via queue number 2, as far as I know.

Thanks for your help again.

Ignacy

-- 
/* This is not a comment */
