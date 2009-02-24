Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:45929 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZBXCnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:43:40 -0500
Received: by qw-out-2122.google.com with SMTP id 5so1557833qwi.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 18:43:38 -0800 (PST)
Subject: [PATCH] iwl3945: initialize is_valid_rtc_data_addr function pointer
From: Jason Andryuk <jandryuk@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 21:43:30 -0500
Message-Id: <1235443410.7047.25.camel@rainbow> (sfid-20090224_034343_676010_8D003747)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize is_valid_rtc_data_addr function pointer for iwl3945 to
prevent a NULL pointer dereference in iwl_dump_nic_error_log.

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
--

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d49e48b..6ae0df5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2747,6 +2747,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 		.query_addr = iwlcore_eeprom_query_addr,
 	},
 	.send_tx_power	= iwl3945_send_tx_power,
+	.is_valid_rtc_data_addr = iwl3945_hw_valid_rtc_data_addr,
 };
 
 static struct iwl_hcmd_utils_ops iwl3945_hcmd_utils = {

