Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59014 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZAILuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 06:50:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 03:50:10 -0800
From: Vivek Natarajan <Vivek.Natarajan@Atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 9 Jan 2009 17:20:05 +0530
Subject: RE: multicast traffic and ath9k
Message-ID: <44EE5C37ADC36343B0625A05DD408C4845A77DAF05@CHEXMB-01.global.atheros.com> (sfid-20090109_125016_516311_8E6306C2)
References: <1231346161.3545.52.camel@johannes>
In-Reply-To: <1231346161.3545.52.camel@johannes>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Johannes Berg wrote:
> Does ath9k hardware really not check the multicast bit by itself? It
> seems that we can't really be fast enough to wake up the hardware, so
> the check for the MC bit is kinda useless, no?

There are two options in atheros drivers. One is hardware beacon processing
and the other is sw beacon processing. For some reason, sw beacon processing
is enabled by default, the performance is as expected and it has been working fine
for Windows implementation.

Some functions related to power save and beacon are beacon timestamp update,
verify tim bit and verify mc bit. The beacon timers have to be programmed correctly
to wake up for every beacon and process it for tim.  If the timer is slightly
out of sync, we my fail to receive the beacon.

The alternative is sw beacon processing using TIM_TIMER interrupt. This is a timer
which runs in the hw while majority of the hw is asleep. This generates an interrupt
for every beacon listen interval to wake up the chip and listen to beacon. We do not
go back to sleep unless we receive a beacon. Since there is no dependency on the
higher layers to update the beacon/sleep timers,  this implementation works fine in any
corner case. Hence, there is a need to process multicast bit in the software itself.

Vivek.
