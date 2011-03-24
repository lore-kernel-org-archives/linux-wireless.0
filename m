Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.srv.pl ([217.17.32.250]:39356 "EHLO mail.srv.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933338Ab1CXHcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 03:32:10 -0400
Subject: Problem with brcm80211 monitor mode
From: jarek <jarek@poczta.srv.pl>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 08:02:57 +0100
Message-ID: <1300950177.6288.23.camel@jlap2.macro.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

The brcmsmac driver has problems with monitor mode.

First of all in monitor mode card is not intercepting any packets.

Second, it is not possible to change channel when card is in monitor
mode. I've received information that by design it is possible only when
interface is down (ifconfig wlan0 down). This is strange for me, because
all cards I was testing before (ralink, atheros, b43, iwlang) allowed to
change channel in monitor mode.

Next, the driver(?) totally freezes computer after the following
sequence:

ifconfig wlan0 down
iwconfig wlan0 mode monitor
iwconfig wlan0 channel 7
ifconfig wlan0 up

(Sometimes it is possible to do it once, but freezes at second trial)
What is strange, this sequence freezes computer without any messages -
I've tested this with console and netconsole.

Testing environment:
HP Mini 5103
01:00.0 Network controller: Broadcom Corporation BCM43224 802.11a/b/g/n
(rev 01)
	Subsystem: Hewlett-Packard Company Device 1510
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at 50200000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>

System: Debian Squeeze i386 6.0.1
Kernel: 2.6.38-git11

Best regards
Jarek

