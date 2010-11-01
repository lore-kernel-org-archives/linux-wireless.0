Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65438 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0KAPRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 11:17:24 -0400
Received: by iwn10 with SMTP id 10so7141874iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Nov 2010 08:17:23 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Nov 2010 16:17:23 +0100
Message-ID: <AANLkTik=LvRZja13SGOpicVjbyf6chRtTD-RkvSm2VcE@mail.gmail.com>
Subject: ath9k: race conditions in dma
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have an application that creates and destroys a lot of ap vifs and
does a lot of monitor frame injection. The recent ath9k rx locking
fixes have helped with stability in this use-case but there still
seems to be some tx/beacon related race condition(s). These manifests
themselves as follows on an AR913x based router running
compat-wireless-2010-10-19 (with locking fixes etc from openwrt):

1. TX DMA hangs under simultaneous high RX and TX load

This can happen within minutes but only seems to happen if there is
high load on both RX and TX. These hangs take several seconds to fully
recover from and seem more severe than the usual ones we used to see
before the pcu locking fixes. Log output looks like this:

Jan  1 00:08:47 user.debug kernel: ath: Failed to stop TX DMA in 100
msec after killing last frame
Jan  1 00:08:47 user.debug kernel: ath: Failed to stop TX DMA in 100
msec after killing last frame
Jan  1 00:08:47 user.debug kernel: ath: Failed to stop TX DMA in 100
msec after killing last frame
Jan  1 00:08:47 user.debug kernel: ath: Failed to stop TX DMA in 100
msec after killing last frame
Jan  1 00:08:47 user.debug kernel: ath: Failed to stop TX DMA.
Resetting hardware!
Jan  1 00:08:47 user.debug kernel: ath: DMA failed to stop in 10 ms
AR_CR=0x00000024 AR_DIAG_SW=0x42000020
Jan  1 00:08:47 user.debug kernel: ath: ah->misc_mode 0xc
Jan  1 00:08:47 user.debug kernel: ath: Setting CFG 0x10a
Jan  1 00:08:47 user.debug kernel: ath: ah->misc_mode 0xc
Jan  1 00:08:47 user.debug kernel: ath: Setting CFG 0x10a

Also note that in my use-case there is more processing done on
ieee80211_rx() and ieee80211_tx_status() than perhaps normal.

2. TX is completely hung but chip is never reset

Another similar failure mode under the same conditions as above (when
TX and RX load is high) is that the TX pipeline is somehow hung
(nothing coming out on radio) but there is no log output to suggest
that anything is seriously wrong. My guess here is that the tx queue
might be stopped but I have not been able to verify that.

3. Interrupts completely stop coming

The last failure mode happens when the driver is not RX/TX loaded but
instead left running for a longer period of time (about 12 hours is
enough in most cases but 48 hours basically always does the trick).
The system is fine but it seems ath9k is not receiving any interrupts
("cat /sys/kernel/debug/ath9k/phy0/interrupts" produces the same
result over and over again). If full debug is enabled ("echo 0xffff >
/sys/kernel/debug/ath9k/phy0/debug") only shortcal and longcal related
prints appear (driven by a timer). Bringing the interface down and
then up again with ifconfig does not bring it back to life, but
restarting hostapd does.

Help in tracking these down would be much appreciated. I will follow
up below with some thoughts on contributing factors.

/Björn
