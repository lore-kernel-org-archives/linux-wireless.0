Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:47268 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3ALOGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:06:20 -0500
Received: from stuffed.shaftnet.org (localhost [127.0.0.1])
	by stuffed.shaftnet.org (8.14.5/8.14.5) with ESMTP id r0CE6HO1013048
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2013 09:06:17 -0500
Received: (from pizza@localhost)
	by stuffed.shaftnet.org (8.14.5/8.14.5/Submit) id r0CE6H5w013047
	for linux-wireless@vger.kernel.org; Sat, 12 Jan 2013 09:06:17 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Subject: RFCv3: ST-E CW1200 WLAN driver
Date: Sat, 12 Jan 2013 09:06:00 -0500
Message-Id: <1357999575-12838-1-git-send-email-pizza@shaftnet.org> (sfid-20130112_150626_907473_63D7FFA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here's the third patch series, still under drivers/staging.

IBSS is still broken, but no longer triggers OOPSes.  Time permitting 
this wekeend I'll be looking into what's still going wrong.

Changes from v2:

 * Integrated a large number of changes originating with Sony:
   * Clear channel params before registering
   * Saner way to tell LMAC to pass up probe requests
   * Fix potential NULL deference in queue code
   * Track RX Block ACKs as well
   * Simplify PM filtering
   * Fixes for PM suspend code
   * Don't let a scan stop on another
   * Make joins asynchronous
   * Handle TSF in RX packets
   * SDIO: Only bind to first function
   * Logging improvements
   * Add ieee80211_ops.change_interface()
   * Use a high-priority workqueue instead of a kthread
   * Saner beacon filtering
 * Reworked SDD parser to be far cleaner
 * PM support for SPI modules
 * Nuked most of the "#if 0" code blocks and other dead code
 * Many more checkpatch-suggested fixes
 * Use round_up macro (thanks Bob Copeland)
 * Low-level locking added to SPI driver
 * Rework tx/rx balance to be far more fair
 * Eliminate '11n' debugfs file
 * Improved initialization/reset code using GPIOs
 * Fixed OOPS when trying to use IBSS
 * Several minor cleanups
 * Added MAINTAINERS entry

