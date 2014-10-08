Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:53430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbaJHIdj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 04:33:39 -0400
From: Loic Poulain <loic.poulain@intel.com>
To: johannes@sipsolutions.net, heikki.krogerus@linux.intel.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Loic Poulain <loic.poulain@intel.com>
Subject: [PATCH 4/5] net: rfkill: gpio: Add OBDA8723 ACPI ID
Date: Wed,  8 Oct 2014 10:34:39 +0200
Message-Id: <1412757280-31367-4-git-send-email-loic.poulain@intel.com> (sfid-20141008_103347_086858_97A75064)
In-Reply-To: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add OBDA8723 (rtl8723) ACPI id.
rtl8723 bluetooth chip has the following interface:
HOST <---UART---> CONTROLLER
HOST --- WAKE---> CONTROLLER (gpio res 0)
HOST ---ENABLE--> CONTROLLER (gpio res 1)
HOST <---WAKE---- CONTROLLER (gpio res 2)

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
---
 net/rfkill/rfkill-gpio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 2f6aad1..28d1cbf 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -301,11 +301,20 @@ static struct rfkill_gpio_desc acpi_default_gps = {
 	.host_wake_idx = -1,
 };
 
+static struct rfkill_gpio_desc acpi_bluetooth_wake = {
+	.type = RFKILL_TYPE_BLUETOOTH,
+	.reset_idx = -1,
+	.shutdown_idx = 1,
+	.wake_idx = 0,
+	.host_wake_idx = 2,
+};
+
 static const struct acpi_device_id rfkill_acpi_match[] = {
 	{ "BCM2E1A", (kernel_ulong_t)&acpi_default_bluetooth },
 	{ "BCM2E39", (kernel_ulong_t)&acpi_default_bluetooth },
 	{ "BCM2E3D", (kernel_ulong_t)&acpi_default_bluetooth },
 	{ "BCM2E64", (kernel_ulong_t)&acpi_default_bluetooth },
+	{ "OBDA8723", (kernel_ulong_t)&acpi_bluetooth_wake },
 	{ "BCM4752", (kernel_ulong_t)&acpi_default_gps },
 	{ "LNV4752", (kernel_ulong_t)&acpi_default_gps },
 	{ },
-- 
1.8.3.2

