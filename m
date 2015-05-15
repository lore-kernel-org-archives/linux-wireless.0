Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34123 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbbEOSQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2015 14:16:00 -0400
Received: by laat2 with SMTP id t2so132210344laa.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2015 11:15:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAnMG+PjoNO5opNHHnVFRZg9s2yWoK6p6vQqPO1N9PR-5TcjpQ@mail.gmail.com>
References: <CAAnMG+PjoNO5opNHHnVFRZg9s2yWoK6p6vQqPO1N9PR-5TcjpQ@mail.gmail.com>
Date: Fri, 15 May 2015 11:15:58 -0700
Message-ID: <CAAnMG+P4fP5dgbo+b_aL54rfaD7CKbXnVXEJyszWq8Gj92MdYQ@mail.gmail.com> (sfid-20150515_201605_589830_5510CDDC)
Subject: Re: ath9k: chance of failing to install unicast encryption key under
 heavy load
From: Alexis Green <agreen@cococorp.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good <time of day>,

When testing encrypted mesh functionality under heavy load (maxing out
the channel), there is a strong possibility that unicast key does not
get installed properly into hardware.

This test has been done using OpenWRT trunk @ svn revision r45676
Repros on TP-Link WDR-4300 hardware, specifically 5Ghz phy ( Atheros
AR9340 Rev:2 ). It also reproduces on another piece of hardware
running earlier version of OpenWRT ( Atheros AR9280 Rev:2 )

To reproduce, set authsae "lifetime" to a small number of seconds
(I've used 30 seconds) then initiate TCP iperf test across the mesh
link. With iperf in the background, initiate ICMP ping between the two
nodes. Observe pings stop at the rekeying and coming back on the next
rekey. Loading ath9k with "nohwcrypt=1" resolves the issue at cost of
greatly reduced throughput.

Instrumented code to print out key being installed at authsae,
mac80211, and ath9k levels show that correct key is passed all the way
down to hardware. Performing REG_READ on the installed key immediately
after REGWRITE_BUFFER_FLUSH in ath_hw_set_keycache_entry() indicates
that correct key is in the key register. Making authsae daemon instal
same key again after waiting for one second reduces the occurrence of
the problem, but does not eliminate it.

I can provide my openwrt build .config, image, and node configuration
if that helps.

P.S. Possibly manifestation of the same problem -
http://lists.shmoo.com/pipermail/hostap/2014-November/031377.html

Also, this email has been cross-posted to ath9k-devel mailing list

Thank you all,
Alexis Green
