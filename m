Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:18976 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZBJKeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 05:34:05 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id n1AAXwWp005301
	for <linux-wireless@vger.kernel.org>; Tue, 10 Feb 2009 12:34:00 +0200
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
Subject: wl12xx: driver for TI wl1251 chipset
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 10 Feb 2009 12:32:04 +0200
Message-ID: <87iqnishuj.fsf@nokia.com> (sfid-20090210_113409_865893_3E14764B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

in Nokia we have been working on a mac80211 driver for TI wl1251
chipset. We named it as wl12xx, and in the future we are planning to
add wl1271 support to the driver as well.

wl1251 is a chipset for embedded devices, supporting both SDIO and SPI
busses. Currently the driver supports only SPI. Adding support 1253
(the 5 GHz version) should be relatively easy. More information here:

http://focus.ti.com/general/docs/wtbu/wtbuproductcontent.tsp?contentId=4711&navigationId=12494&templateId=6123

Because the patch is over 200 KB, the driver is temporarily available
from my server:

http://www.valot.fi/kalle/tmp/wl12xx/wl12xx-2.6.28-1.patch

The patch is against linux-2.6.28-omap1 tag available here:

http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap-2.6.git;a=commit;h=0ec95b96fd77036a13398c66901e11cd301190d0

Currently known issues:

o short slot and preamble support missing
o rts/cts and cts-to-self missing
o no proper bitrate control support
o using deprecated omap_get_config(), need to convert to use platform_data
o firmware wakeup not working, deepest sleep state in firmware not yet
  enabled

Also the driver has a netlink interface which is used for running
production line tests and pushing the calibration data from user
space.

All comments and review is greatly appreciated. After receiving all
the comments, I will port the driver to the wireless-testing tree and
submit a version for the possible inclusion.

TI has given us technical support while developing the driver, big
thanks to them.

-- 
Kalle Valo
