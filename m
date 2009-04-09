Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:3361 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbZDISWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 14:22:09 -0400
Subject: sony-laptop still using rfkill's user_claim_unsupported
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 11:27:58 -0700
Message-Id: <1239301678.4684.39.camel@rc-desk> (sfid-20090409_202215_318075_A1E10E0D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes and John,

I found this issue with sony-laptop when trying to compile. This patch
gets me compiling again but I do not know which avenue it should take as
this rfkill cleanup work is not in Linus's tree yet. What do you
suggest?

Thank you

Reinette


From: Reinette Chatre <reinette.chatre@intel.com>

Commit f8c80fa6d4c16b20bc6960f229faeeb8f57ac80c "rfkill: remove user_claim
stuff" removed "user_claim_unsupported" from the rfkill struct. Remove
usage of this member from sony-laptop.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/platform/x86/sony-laptop.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index a90ec5c..3c17995 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -1097,7 +1097,6 @@ static int sony_nc_setup_wifi_rfkill(struct acpi_device *device)
 	sony_wifi_rfkill->name = "sony-wifi";
 	sony_wifi_rfkill->toggle_radio = sony_nc_rfkill_set;
 	sony_wifi_rfkill->get_state = sony_nc_rfkill_get;
-	sony_wifi_rfkill->user_claim_unsupported = 1;
 	sony_wifi_rfkill->data = (void *)SONY_WIFI;
 	err = rfkill_register(sony_wifi_rfkill);
 	if (err)
@@ -1119,7 +1118,6 @@ static int sony_nc_setup_bluetooth_rfkill(struct acpi_device *device)
 	sony_bluetooth_rfkill->name = "sony-bluetooth";
 	sony_bluetooth_rfkill->toggle_radio = sony_nc_rfkill_set;
 	sony_bluetooth_rfkill->get_state = sony_nc_rfkill_get;
-	sony_bluetooth_rfkill->user_claim_unsupported = 1;
 	sony_bluetooth_rfkill->data = (void *)SONY_BLUETOOTH;
 	err = rfkill_register(sony_bluetooth_rfkill);
 	if (err)
@@ -1140,7 +1138,6 @@ static int sony_nc_setup_wwan_rfkill(struct acpi_device *device)
 	sony_wwan_rfkill->name = "sony-wwan";
 	sony_wwan_rfkill->toggle_radio = sony_nc_rfkill_set;
 	sony_wwan_rfkill->get_state = sony_nc_rfkill_get;
-	sony_wwan_rfkill->user_claim_unsupported = 1;
 	sony_wwan_rfkill->data = (void *)SONY_WWAN;
 	err = rfkill_register(sony_wwan_rfkill);
 	if (err)
@@ -1161,7 +1158,6 @@ static int sony_nc_setup_wimax_rfkill(struct acpi_device *device)
 	sony_wimax_rfkill->name = "sony-wimax";
 	sony_wimax_rfkill->toggle_radio = sony_nc_rfkill_set;
 	sony_wimax_rfkill->get_state = sony_nc_rfkill_get;
-	sony_wimax_rfkill->user_claim_unsupported = 1;
 	sony_wimax_rfkill->data = (void *)SONY_WIMAX;
 	err = rfkill_register(sony_wimax_rfkill);
 	if (err)
-- 
1.5.6.3



