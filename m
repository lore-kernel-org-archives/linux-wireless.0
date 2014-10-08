Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53520 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaJHIeF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 04:34:05 -0400
From: Loic Poulain <loic.poulain@intel.com>
To: johannes@sipsolutions.net, heikki.krogerus@linux.intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Loic Poulain <loic.poulain@intel.com>
Subject: [PATCH 5/5] net: rfkill: gpio: Add BCM47521 ACPI ID
Date: Wed,  8 Oct 2014 10:34:40 +0200
Message-Id: <1412757280-31367-5-git-send-email-loic.poulain@intel.com> (sfid-20141008_103409_626376_709952ED)
In-Reply-To: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add BCM47521 (GPS) to the ACPI table.
BCM47521 supports host wake.
HOST <---UART---> CONTROLLER
HOST <-- WAKE---- CONTROLLER (gpio res 0)
HOST ---ENABLE--> CONTROLLER (gpio res 1)

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 net/rfkill/rfkill-gpio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 28d1cbf..da239ef 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -309,6 +309,14 @@ static struct rfkill_gpio_desc acpi_bluetooth_wake = {
 	.host_wake_idx = 2,
 };
 
+static struct rfkill_gpio_desc acpi_gps_wake = {
+	.type = RFKILL_TYPE_GPS,
+	.reset_idx = -1,
+	.shutdown_idx = 1,
+	.wake_idx = -1,
+	.host_wake_idx = 0,
+};
+
 static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "BCM2E1A", (kernel_ulong_t)&acpi_default_bluetooth },
 	{ "BCM2E39", (kernel_ulong_t)&acpi_default_bluetooth },
@@ -317,6 +325,7 @@ static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "OBDA8723", (kernel_ulong_t)&acpi_bluetooth_wake },
 	{ "BCM4752", (kernel_ulong_t)&acpi_default_gps },
 	{ "LNV4752", (kernel_ulong_t)&acpi_default_gps },
+	{ "BCM47521", (kernel_ulong_t)&acpi_gps_wake },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, rfkill_acpi_match);
-- 
1.8.3.2

