Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53208 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933151AbdGSS3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 14:29:08 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v1 6/6] device property: Switch to use new generic UUID API
Date: Wed, 19 Jul 2017 21:28:57 +0300
Message-Id: <20170719182857.73693-7-andriy.shevchenko@linux.intel.com> (sfid-20170719_202932_601088_6EB72151)
In-Reply-To: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are new types and helpers that are supposed to be used in new code.

As a preparation to get rid of legacy types and API functions do
the conversion here.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-acpi@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/acpi/property.c | 50 ++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index 917c789f953d..a7fdbe083a7e 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -24,16 +24,14 @@ static int acpi_data_get_property_array(struct acpi_device_data *data,
 					acpi_object_type type,
 					const union acpi_object **obj);
 
-/* ACPI _DSD device properties UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 */
-static const u8 prp_uuid[16] = {
-	0x14, 0xd8, 0xff, 0xda, 0xba, 0x6e, 0x8c, 0x4d,
-	0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01
-};
-/* ACPI _DSD data subnodes UUID: dbb8e3e6-5886-4ba6-8795-1319f52a966b */
-static const u8 ads_uuid[16] = {
-	0xe6, 0xe3, 0xb8, 0xdb, 0x86, 0x58, 0xa6, 0x4b,
-	0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96, 0x6b
-};
+/* ACPI _DSD device properties GUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301 */
+static const guid_t prp_guid =
+	GUID_INIT(0xdaffd814, 0x6eba, 0x4d8c,
+		  0x8a, 0x91, 0xbc, 0x9b, 0xbf, 0x4a, 0xa3, 0x01);
+/* ACPI _DSD data subnodes GUID: dbb8e3e6-5886-4ba6-8795-1319f52a966b */
+static const guid_t ads_guid =
+	GUID_INIT(0xdbb8e3e6, 0x5886, 0x4ba6,
+		  0x87, 0x95, 0x13, 0x19, 0xf5, 0x2a, 0x96, 0x6b);
 
 static bool acpi_enumerate_nondev_subnodes(acpi_handle scope,
 					   const union acpi_object *desc,
@@ -190,22 +188,23 @@ static bool acpi_enumerate_nondev_subnodes(acpi_handle scope,
 {
 	int i;
 
-	/* Look for the ACPI data subnodes UUID. */
+	/* Look for the ACPI data subnodes GUID. */
 	for (i = 0; i < desc->package.count; i += 2) {
-		const union acpi_object *uuid, *links;
+		const union acpi_object *guid, *links;
 
-		uuid = &desc->package.elements[i];
+		guid = &desc->package.elements[i];
 		links = &desc->package.elements[i + 1];
 
 		/*
-		 * The first element must be a UUID and the second one must be
+		 * The first element must be a GUID and the second one must be
 		 * a package.
 		 */
-		if (uuid->type != ACPI_TYPE_BUFFER || uuid->buffer.length != 16
-		    || links->type != ACPI_TYPE_PACKAGE)
+		if (guid->type != ACPI_TYPE_BUFFER ||
+		    guid->buffer.length != 16 ||
+		    links->type != ACPI_TYPE_PACKAGE)
 			break;
 
-		if (memcmp(uuid->buffer.pointer, ads_uuid, sizeof(ads_uuid)))
+		if (!guid_equal((guid_t *)guid->buffer.pointer, &ads_guid))
 			continue;
 
 		return acpi_add_nondev_subnodes(scope, links, &data->subnodes,
@@ -298,26 +297,27 @@ static bool acpi_extract_properties(const union acpi_object *desc,
 	if (desc->package.count % 2)
 		return false;
 
-	/* Look for the device properties UUID. */
+	/* Look for the device properties GUID. */
 	for (i = 0; i < desc->package.count; i += 2) {
-		const union acpi_object *uuid, *properties;
+		const union acpi_object *guid, *properties;
 
-		uuid = &desc->package.elements[i];
+		guid = &desc->package.elements[i];
 		properties = &desc->package.elements[i + 1];
 
 		/*
-		 * The first element must be a UUID and the second one must be
+		 * The first element must be a GUID and the second one must be
 		 * a package.
 		 */
-		if (uuid->type != ACPI_TYPE_BUFFER || uuid->buffer.length != 16
-		    || properties->type != ACPI_TYPE_PACKAGE)
+		if (guid->type != ACPI_TYPE_BUFFER ||
+		    guid->buffer.length != 16 ||
+		    properties->type != ACPI_TYPE_PACKAGE)
 			break;
 
-		if (memcmp(uuid->buffer.pointer, prp_uuid, sizeof(prp_uuid)))
+		if (!guid_equal((guid_t *)guid->buffer.pointer, &prp_guid))
 			continue;
 
 		/*
-		 * We found the matching UUID. Now validate the format of the
+		 * We found the matching GUID. Now validate the format of the
 		 * package immediately following it.
 		 */
 		if (!acpi_properties_format_valid(properties))
-- 
2.11.0
