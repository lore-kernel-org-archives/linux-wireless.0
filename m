Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46411 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbZKWEpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 23:45:43 -0500
Received: by yxe17 with SMTP id 17so4418946yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2009 20:45:49 -0800 (PST)
Message-ID: <4B0A137B.7050604@lwfinger.net>
Date: Sun, 22 Nov 2009 22:45:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
References: <200911192224.29491.mb@bu3sch.de>
In-Reply-To: <200911192224.29491.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2009 03:24 PM, Michael Buesch wrote:
> This rewrites the error handling policies in the TX status handler.
> It tries to be error-tolerant as in "try hard to not crash the machine".
> It won't recover from errors (that are bugs in the firmware or driver),
> because that's impossible. However, it will return a more or less useful
> error message and bail out. It also tries hard to use rate-limited messages
> to not flood the syslog in case of a failure.

This patch definitely helped open-source firmware, but it is not a complete fix.
Usually, a failure occurs within minutes to a few hours under heavy load. For my
system, the load is repeating tcpperf transmits in one terminal, and a flood
ping in a second. This time, the system ran for ~25 hours before failing. After
removing the header to eliminate wrap-around, the messages logged are:

b43 ssb0:0: firmware: requesting b43-open/pcm5.fw
Loading OpenSource firmware version 410.31754
Hardware crypto acceleration not supported by firmware
QoS not supported by firmware
debug: Chip initialized
debug: 32-bit DMA initialized
debug: QoS disabled
debug: Wireless interface started
debug: Adding Interface type 2
wlan0: direct probe to AP 00:14:bf:85:49:fa (try 1)
wlan0: direct probe responded
wlan0: authenticate with AP 00:14:bf:85:49:fa (try 1)
wlan0: authenticated
wlan0: associate with AP 00:14:bf:85:49:fa (try 1)
wlan0: RX ReassocResp from 00:14:bf:85:49:fa (capab=0x411 status=12 aid=0)
wlan0: AP denied association (code=12)
wlan0: associate with AP 00:14:bf:85:49:fa (try 1)
wlan0: RX ReassocResp from 00:14:bf:85:49:fa (capab=0x411 status=12 aid=0)
wlan0: AP denied association (code=12)
wlan0: deauthenticating from 00:14:bf:85:49:fa by local choice (reason=3)
wlan0: direct probe to AP 00:14:bf:85:49:fa (try 1)
wlan0: direct probe to AP 00:14:bf:85:49:fa (try 1)
wlan0: direct probe responded
wlan0: authenticate with AP 00:14:bf:85:49:fa (try 1)
wlan0: authenticated
wlan0: associate with AP 00:14:bf:85:49:fa (try 1)
wlan0: RX ReassocResp from 00:14:bf:85:49:fa (capab=0x411 status=0 aid=2)
wlan0: associated
spurious 8259A interrupt: IRQ15.
SFW2-INext-DROP-DEFLT IN=wlan0 OUT=
MAC=00:18:39:5e:90:f9:00:14:bf:85:49:f8:08:00 SRC=192.168.1.1 DST=192.168.1.107
LEN=336 TOS=0x00 PREC=0x00 TTL=64 ID=64124 PROTO=UDP SPT=67 DPT=68 LEN=316
SFW2-INext-DROP-DEFLT IN=wlan0 OUT=
MAC=00:18:39:5e:90:f9:00:14:bf:85:49:f8:08:00 SRC=192.168.1.1 DST=192.168.1.107
LEN=336 TOS=0x00 PREC=0x00 TTL=64 ID=6664 PROTO=UDP SPT=67 DPT=68 LEN=316
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 146
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 148
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 118
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 150
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 152
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 154
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 156
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 158
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 160
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 162
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 164
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 134
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 166
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 168
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 170
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 172
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 174
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 176
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 178
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 180
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 182
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 184
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 154
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 186
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 156
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 188
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 158
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 190
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 160
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 192
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 162
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 194
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 196
debug: Out of order TX status report on DMA ring 1. Expected 114, but got 198

These messages continued. Unloading and reloading the driver restored the network.

Larry

