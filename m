Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:43361 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756636Ab2FHGbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:31:08 -0400
Received: by lbbgj10 with SMTP id gj10so1503512lbb.37
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 23:31:05 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 0/5] wl18xx: some alignment with new FWs and conf improvements
Date: Fri,  8 Jun 2012 09:30:50 +0300
Message-Id: <1339137055-30095-1-git-send-email-coelho@ti.com> (sfid-20120608_083113_882210_00849332)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here are a few more patches for wl18xx (or directly related to it).
Two of them align features and the ABI of newer firmware versions: the
new statistics structure format by Ido and the support for FW logger
by default with PG2.0 chips by Arik.

Then there are three more patches by Arik that improve the conf binary
handling.  Align the entire phy structure with the one used by the
firmware, fix the module parameters to reflect the new placement of
the settings (which are now in the conf structure) and make the NVS
file optional, in preparation for total removal from wl18xx.

Thanks guys for these patches!

Cheers,
Luca.

Arik Nemtsov (4):
  wl18xx: allow FW-log by default for PG2.0
  wl18xx: align wl18xx_conf_phy with FW variant and remove it
  wl18xx: clean up phy module parameters
  wlcore/wl12xx/wl18xx: make NVS file optional for wl18xx

Ido Reis (1):
  wl18xx: update fw statistics

 drivers/net/wireless/ti/wl18xx/acx.h     |   33 ++++--
 drivers/net/wireless/ti/wl18xx/conf.h    |   37 ++++++-
 drivers/net/wireless/ti/wl18xx/debugfs.c |   56 ++++++----
 drivers/net/wireless/ti/wl18xx/main.c    |  165 +++++++++++-------------------
 drivers/net/wireless/ti/wl18xx/reg.h     |   57 -----------
 drivers/net/wireless/ti/wl18xx/wl18xx.h  |    2 -
 drivers/net/wireless/ti/wlcore/boot.c    |    4 +-
 drivers/net/wireless/ti/wlcore/main.c    |   22 ++--
 8 files changed, 166 insertions(+), 210 deletions(-)

-- 
1.7.10

