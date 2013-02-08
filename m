Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:33958 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946957Ab3BHUcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 15:32:15 -0500
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.5/8.14.5) with ESMTP id r18KWC1Y012707
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 15:32:12 -0500
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.5/8.14.5/Submit) id r18KWCaK012706
	for linux-wireless@vger.kernel.org; Fri, 8 Feb 2013 15:32:12 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: RFCv4: ST-E CW1100/1200 WLAN driver
Date: Fri,  8 Feb 2013 15:31:53 -0500
Message-Id: <1360355527-12159-1-git-send-email-pizza@shaftnet.org> (sfid-20130208_213359_062625_8A890FCA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's the fourth patch series, now under drivers/net/wireless

This code submission has seen a fair amount of testing across SDIO and 
SPI interfaces, using multiple vendors' cw1200 implementations.

It's stabilizing nicely.  Except for the fact that IBSS is still broken, 
I consider this driver ready for submission.  As you can tell from the 
changelog below, there have been a lot of changes since the last 
submission.

Most of the changes revolve around further simplifying IRQ handling and 
eliminating various Kconfig flags.  API updates to v3.8 kernels, major 
roaming state machine fixes, eliminating dynamic block ack configuration 
(due to firmware bugs), and a pile of minor fixes and cleanups round 
this out.

There are still a couple bits of code present for older (<2.6.36 and <3.2) 
kernels, which I will strip out for inclusion in compat-drivers once 
this is mainlined.  (Is there a better process I should follow here?)

As always, comments and feedback welcome.

Changes from v3:

 * Remove excessive [un]likely() compiler hinting  (Pontus Fuchs)
 * Update to 3.7 API
 * Move from drivers/staging to drivers/net/wireless
 * Fix memory leak when FW download fails  (Pontus Fuchs)
 * Incorrect length calculation for 16-bit I/O  (Pontus Fuchs)
 * Minor sparse/smatch warnings  (Pontus Fuchs)
 * Eliminate sbus_ops.reset() and code that it uses
 * Elimnate CONFIG_CW1200_DEBUGFS  (Pontus Fuchs)
 * Use SSID directly out of ieee80211_bss_conf
 * Eliminate __devinit/__devexit and friends  (Pontus Fuchs)
 * Convert CONFIG_CW1200_5GHZ_SUPPORT to a platform data flag  (Pontus Fuchs)
 * Move NON_POWER_OF_TWO_BLOCKSIZES into platform data
 * Move platform data to include/linux
 * cfg80211_find_ie -> ieee80211_bss_get_ie  (Pontus Fuchs)
 * Add proper RCU locking for v3.8  (Pontus Fuchs)
 * Convert CONFIG_CW1200_USE_SDIO_IRQ into platform data flag
 * Eliminate rid of sbus_ops.irq_enable()
 * Elimnate IRQ polling support
 * Push IRQ registration into the bus handling code
 * Moved code from ap.[ch] into more appropriate places
 * Eliminated CONFIG_CW1200_PM
 * Elminate workarounds for former bad IRQ handling
 * Don't log cmd timeout errors caused by device removal
 * Always disable interrupts when irq handler is called
 * FW Command timeout now triggers a full connection teardown
 * cw1200_unjoin_work() triggers iee80211_connection_loss()
 * Schedule unjoin_work() when we've detected a beacon loss event
 * Cleanups in tx_unlock code
 * Always trigger unjoin_work() when we report a connection loss
 * Use threded IRQ handle for GPIO irq (Pontus Fuchs)
 * Access Func 0 in standard way (Pontus Fuchs)
 * Update to 3.8-rc5 API
 * Eliminate dynamic BlockACK policy configuration
 * Eliminated a pile of BUG_ON() and WARN_ON() calls
 * Prevent deadlock on subsequent cmds after a cmd timeout happens


