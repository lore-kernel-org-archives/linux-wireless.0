Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:37215 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbZH0Nn3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 09:43:29 -0400
From: =?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] iwlagn: show_version() displays confusing/wrong firmware version
Date: Thu, 27 Aug 2009 15:33:09 +0200
Message-Id: <1251379989-20728-1-git-send-email-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The output of show_version() is confusing at best, and can also be
considered wrong if you don't know that the order of the API and
SERIAL number has been switched. The unusual dotted hex is also
unecessary unreadable and different from the filename convention and
outout from iwl_read_ucode():

 bjorn@nemi:~$ cat /sys/class/net/wlan0/device/version
 fw version: 0x8.0x18.0xC.0x2
 fw type: 0x1 0x0
 EEPROM version: 0x11e

iwl_read_ucode() prints this when loading the same firmware:

 [   21.406218] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.ucode
 [   21.453118] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12

Note that I have no documentation on the intended usage of the
u8 sw_rev[8] array in struct iwl_alive_resp.  sw_rev[0] and sw_rev[1]
have been switched to make the output match iwl_read_ucode().  Nothing
more, nothing less.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 355f50e..1a1ccb4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2498,10 +2498,10 @@ static ssize_t show_version(struct device *d,
 
 	if (palive->is_valid)
 		pos += sprintf(buf + pos,
-				"fw version: 0x%01X.0x%01X.0x%01X.0x%01X\n"
+				"fw version:  %u.%u.%u.%u\n"
 				"fw type: 0x%01X 0x%01X\n",
 				palive->ucode_major, palive->ucode_minor,
-				palive->sw_rev[0], palive->sw_rev[1],
+				palive->sw_rev[1], palive->sw_rev[0],
 				palive->ver_type, palive->ver_subtype);
 	else
 		pos += sprintf(buf + pos, "fw not loaded\n");
-- 
1.5.6.5

