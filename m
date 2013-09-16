Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:48004 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab3IPLjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 07:39:17 -0400
From: Daniel Mack <zonque@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: s.neumann@raumfeld.com, afenkart@gmail.com, bzhao@marvell.com,
	linville@tuxdriver.com, johannes.berg@intel.com,
	Daniel Mack <zonque@gmail.com>
Subject: [PATCH] mwifiex: fix command timeout with SDIO interrupts enabled
Date: Mon, 16 Sep 2013 13:39:05 +0200
Message-Id: <1379331546-30617-1-git-send-email-zonque@gmail.com> (sfid-20130916_133921_136069_48650D7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We've been hunting a command timeout issue in the mwifiex driver which
occurs on an AM33xx platform when Andreas Fenkart's omap_hsmmc SDIO IRQ
patches are applied (they are not yet in the mainline kernel). We first
suspected the mmc host driver to be racy, but that wasn't the case.

I dug a little through the changes between 3.7 and 3.10 on the mwifiex
driver, and it turned out that the culprit is 601216e12 ("mwifiex:
process RX packets in SDIO IRQ thread directly"), especially the
situation where mwifiex_main_process() bails when mwifiex_processing is
set.

In other words: if an SDIO irq arrives while the driver is processing
mwifiex_main_process() from the work queue, we effectively loose the
interrupt, which then results in a command timeout.

I've written a little test case scenario that calls
mwifiex_dump_station_info() through the SIOCGIWSTATS ioctl excessively,
and that reproduces the problem after a couple of seconds already:

  https://gist.github.com/zonque/6579314


The fix for this issue is quite simple and works very well.


Thanks,
Daniel


Daniel Mack (1):
  mwifiex: queue main work from main process when bailing on races

 drivers/net/wireless/mwifiex/main.c | 1 +
 1 file changed, 1 insertion(+)

-- 
1.8.3.1

