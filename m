Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1ILTIh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 15:08:37 -0400
Subject: [PATCH 3.1] iwlagn: fix stack corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Alexander Diewald <alex@diewald.cc>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 21:08:25 +0200
Message-ID: <1315854505.11834.3.camel@jlt3.sipsolutions.net> (sfid-20110912_210840_000847_4B5E659B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Alexander reported a strange crash in iwlagn that
Meenakshi and Wey couldn't reproduce. I just ran
into the same issue and tracked it down to stack
corruption. This fixes it.

The problem was introduced in
commit 4b8b99b6e650d0527f3a123744b7459976581d14
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Fri Jul 8 14:29:48 2011 -0700

    iwlagn: radio sensor offset in le16 format

Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Reported-by: Alexander Diewald <alex@diewald.cc>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Wey, please fix your recent commit in our internal tree
that does the v2 offset calibration -- it has the same
bug twice.

 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c	2011-09-12 21:01:34.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c	2011-09-12 21:01:43.000000000 +0200
@@ -167,7 +167,7 @@ static int iwlagn_set_temperature_offset
 
 	memset(&cmd, 0, sizeof(cmd));
 	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
-	memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(offset_calib));
+	memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(*offset_calib));
 	if (!(cmd.radio_sensor_offset))
 		cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
 


