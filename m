Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31880 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1AGXIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 18:08:39 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 15:08:21 -0800
Subject: Re: [ath9k-devel] ath9k tx lockup, ath: received PCI FATAL
 interrupt
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Peter Stuge <peter@stuge.se>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110107215549.4053.qmail@stuge.se>
References: <20110107215549.4053.qmail@stuge.se>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 8 Jan 2011 01:08:34 +0200
Message-ID: <1294441714.12213.75.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-07 at 13:55 -0800, Peter Stuge wrote:
> I normally never use wpa_supplicant. I don't accept that it would be
> required for a working connection and so far noone has really
> explained why that would be the case. Only ath9k (ie. neither ipw2200
> nor ath5k) has ever made a difference between wpa_supplicant running
> or not.

You won't need wpa_supplicant for an open network that has only a single
AP and if you never get disconnected (which could happen, e.g., if you
leave the range for a moment). mac80211 will not be reconnecting to the
network on its own automatically, so you need something like
wpa_supplicant to do it for you.

> The above identifies at least two issues:
> 
> 1. ath: received PCI FATAL interrupt
> 
> How can I find out more about the reason for this?

Have you looked at enabling debugging in ath9k? This is described at
http://wireless.kernel.org/en/users/Drivers/ath9k/debug
For the PCI fatal interrupt, it would be useful to have at least
interrupt and fatal levels included. If the output is still readable
(i.e., you can still find the PCI fatal message), enabling more of these
could end up providing more details, too.

Have you happened to test that WLAN card in any other system or with any
other driver? It could be useful to make sure it is known to be working
reliably before spending huge amount of work trying to figure out why it
doesn't work properly with ath9k..

> 2. Unworking association without wpa_supplicant after power cycle
> 
> How can I find out more about the reason for this?

The part where the dmesg output had "direct probe to <BSSID> timed out"
could potentially be caused by card RX not working properly. I've seen
that happen in some cases (with rmmod + modprobe ath9k being one way of
recovering from that state). Looking at the RX interrupt counters in
ath9k debugfs and checking whether they increment could be of use here.
In general, verifying RX registers (filter, descriptors) would likely
follow in getting more details.

- Jouni


