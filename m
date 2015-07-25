Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:33306 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754208AbbGYA6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2015 20:58:42 -0400
Reply-To: james@nurealm.net
To: linux-wireless@vger.kernel.org
From: James Feeney <james@nurealm.net>
Subject: The kernel and the "ath" module can get confused when a removable
 wireless device is removed
Message-ID: <55B2DD56.9010806@nurealm.net> (sfid-20150725_025845_974832_EECC882D)
Date: Fri, 24 Jul 2015 18:50:30 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

linux 4.1.2 on Arch

Randomly pulling a wireless pccard, "168c:0023", "Atheros AR5416 MAC/BB Rev:2
AR2133 RF Rev:81", the kernel can fail to notice the card removal, such that
there is no "card ejected from slot" event.  In this case, the "ath" module will
"spam" the system log, spewing error messages indefinitely:

...
Jul 24 14:24:01 beryl kernel: ath: phy3: DMA failed to stop in 10 ms
AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jul 24 14:24:01 beryl kernel: ath: phy3: Could not stop RX, we could be
confusing the DMA engine when we start RX up
Jul 24 14:24:01 beryl kernel: ath: phy3: Chip reset failed
Jul 24 14:24:01 beryl kernel: ath: phy3: Unable to reset channel, reset status -22
Jul 24 14:24:01 beryl kernel: ath: phy3: DMA failed to stop in 10 ms
AR_CR=0xffffffff AR_DIAG_SW=0xffffffff DMADBG_7=0xffffffff
Jul 24 14:24:01 beryl kernel: ath: phy3: Could not stop RX, we could be
confusing the DMA engine when we start RX up
Jul 24 14:24:01 beryl kernel: ath: phy3: Chip reset failed
Jul 24 14:24:01 beryl kernel: ath: phy3: Unable to reset channel, reset status -22
...

Of course, at this point, there is no chip to reset, and the Chip reset will
fail forever.

It would be nice if the driver could confirm that the device is actually still
present when the chip reset fails, before repeating this endless loop.

Or, is this error process being repeatedly triggered by something "upstream"?

In which case, it might be effective for the "ath" module to request that the
kernel re-confirm that the card is still present when the chip reset fails.
