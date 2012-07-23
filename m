Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28130 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2GWERj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 00:17:39 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20492.53272.943747.11705@gargle.gargle.HOWL> (sfid-20120723_061745_095268_C236BFDD)
Date: Mon, 23 Jul 2012 09:46:24 +0530
To: <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] qca-swiss-army-knife: Add a tool to dump EEPROM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 tools/edump/Makefile.am      |   1 +
 tools/edump/README           |  31 ++++
 tools/edump/autogen.sh       |   8 +
 tools/edump/configure.ac     |  25 +++
 tools/edump/src/Makefile.am  |   4 +
 tools/edump/src/edump.c      | 315 +++++++++++++++++++++++++++++++++++
 tools/edump/src/edump.h      | 136 +++++++++++++++
 tools/edump/src/eep_4k.c     | 308 ++++++++++++++++++++++++++++++++++
 tools/edump/src/eep_4k.h     | 142 ++++++++++++++++
 tools/edump/src/eep_9287.c   | 303 ++++++++++++++++++++++++++++++++++
 tools/edump/src/eep_9287.h   | 133 +++++++++++++++
 tools/edump/src/eep_common.h |  87 ++++++++++
 tools/edump/src/eep_def.c    | 382 +++++++++++++++++++++++++++++++++++++++++++
 tools/edump/src/eep_def.h    | 148 +++++++++++++++++
 14 files changed, 2023 insertions(+)
 create mode 100644 tools/edump/Makefile.am
 create mode 100644 tools/edump/README
 create mode 100755 tools/edump/autogen.sh
 create mode 100644 tools/edump/configure.ac
 create mode 100644 tools/edump/src/Makefile.am
 create mode 100644 tools/edump/src/edump.c
 create mode 100644 tools/edump/src/edump.h
 create mode 100644 tools/edump/src/eep_4k.c
 create mode 100644 tools/edump/src/eep_4k.h
 create mode 100644 tools/edump/src/eep_9287.c
 create mode 100644 tools/edump/src/eep_9287.h
 create mode 100644 tools/edump/src/eep_common.h
 create mode 100644 tools/edump/src/eep_def.c
 create mode 100644 tools/edump/src/eep_def.h

diff --git a/tools/edump/Makefile.am b/tools/edump/Makefile.am
new file mode 100644
index 0000000..af437a6
--- /dev/null
+++ b/tools/edump/Makefile.am
@@ -0,0 +1 @@
+SUBDIRS = src
diff --git a/tools/edump/README b/tools/edump/README
new file mode 100644
index 0000000..2a91533
--- /dev/null
+++ b/tools/edump/README
@@ -0,0 +1,31 @@
+This is a tool to dump the eeprom contents of WLAN chips supported by ath9k.
+
+Requirements
+------------
+
+libpcicaccess (http://cgit.freedesktop.org/xorg/lib/libpciaccess/)
+
+Installation
+------------
+
+./autogen.sh
+./configure
+make
+make install
+
+Usage
+-----
+
+To dump everything:       "edump" or "edump -a"
+To dump the base header:  "edump -b"
+To dump the modal header: "edump -m"
+
+Help
+----
+
+"edump --help"
+
+Bugs
+----
+
+Report them to "ath9k-devel@qualcomm.com"
diff --git a/tools/edump/autogen.sh b/tools/edump/autogen.sh
new file mode 100755
index 0000000..ca48004
--- /dev/null
+++ b/tools/edump/autogen.sh
@@ -0,0 +1,8 @@
+#!/bin/sh
+
+echo "Running autoreconf..."
+
+autoreconf -f -i -v
+if [ $? -ne 0 ]; then
+  echo "autoreconf failed"
+fi
diff --git a/tools/edump/configure.ac b/tools/edump/configure.ac
new file mode 100644
index 0000000..9fa329e
--- /dev/null
+++ b/tools/edump/configure.ac
@@ -0,0 +1,25 @@
+AC_INIT([edump], [1.0], [ath9k-devel@qualcomm.com])
+AM_INIT_AUTOMAKE([-Wall -Werror foreign])
+AC_CONFIG_SRCDIR([src/edump.c])
+AC_CONFIG_HEADER([config.h])
+
+# Checks for programs.
+AC_PROG_CC
+AM_PROG_CC_C_O
+AC_PROG_INSTALL
+
+# Checks for header files.
+AC_HEADER_STDC
+
+# Checks for libraries.
+PKG_CHECK_MODULES([pciaccess],
+                  [pciaccess >= 0.10.3],
+		  [],
+                  [AC_MSG_ERROR(libpciaccess-0.10.3 is required)])
+
+# Checks for typedefs, structures, and compiler characteristics.
+AC_C_CONST
+
+AC_CONFIG_FILES([Makefile
+                 src/Makefile])
+AC_OUTPUT
diff --git a/tools/edump/src/Makefile.am b/tools/edump/src/Makefile.am
new file mode 100644
index 0000000..6434bf1
--- /dev/null
+++ b/tools/edump/src/Makefile.am
@@ -0,0 +1,4 @@
+bin_PROGRAMS = edump
+edump_CFLAGS = -Wall $(pciaccess_CFLAGS)
+edump_LDADD = $(pciaccess_LIBS)
+edump_SOURCES = eep_def.c eep_4k.c eep_9287.c edump.c
diff --git a/tools/edump/src/edump.c b/tools/edump/src/edump.c
new file mode 100644
index 0000000..b0de387
--- /dev/null
+++ b/tools/edump/src/edump.c
@@ -0,0 +1,315 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "edump.h"
+
+const char *argp_program_version = PACKAGE_VERSION;
+const char *argp_program_bug_address = PACKAGE_BUGREPORT;
+
+int dump;
+
+static struct argp_option argp_cmd_options[] = {
+	{"base", 'b', 0, 0, "Dump base header", 0},
+	{"modal", 'm', 0, 0, "Dump modal header", 0},
+	{"power", 'p', 0, 0, "Dump power calibration info", 0},
+	{"all", 'a', 0, 0, "Dump everything", 0},
+	{ 0 }
+};
+
+static error_t argp_parser(int key, char *arg, struct argp_state *state)
+{
+	switch(key) {
+	case 'b':
+		dump = DUMP_BASE_HEADER;
+		break;
+	case 'm':
+		dump = DUMP_MODAL_HEADER;
+		break;
+	case 'p':
+		dump = DUMP_POWER_INFO;
+		break;
+	case 'a':
+		dump = DUMP_ALL;
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+
+	return 0;
+}
+
+static struct argp argp = {argp_cmd_options, argp_parser};
+
+static struct pci_id_match pci_id[] = {
+	{ATHEROS_VENDOR_ID, PCI_MATCH_ANY, PCI_MATCH_ANY, PCI_MATCH_ANY},
+	{ 0 }
+};
+
+static struct {
+	uint32_t version;
+	const char * name;
+} mac_bb_names[] = {
+	/* Devices with external radios */
+	{ AR_SREV_VERSION_5416_PCI,	"5416" },
+	{ AR_SREV_VERSION_5416_PCIE,	"5418" },
+	{ AR_SREV_VERSION_9160,		"9160" },
+	/* Single-chip solutions */
+	{ AR_SREV_VERSION_9280,		"9280" },
+	{ AR_SREV_VERSION_9285,		"9285" },
+	{ AR_SREV_VERSION_9287,         "9287" },
+};
+
+static const char *
+mac_bb_name(uint32_t mac_bb_version)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mac_bb_names); i++) {
+		if (mac_bb_names[i].version == mac_bb_version) {
+			return mac_bb_names[i].name;
+		}
+	}
+
+	return "????";
+}
+
+static int is_supported_chipset(struct pci_device *pdev)
+{
+	if (pdev->vendor_id != ATHEROS_VENDOR_ID)
+		return 0;
+
+	if ((pdev->device_id != AR5416_DEVID_PCI) &&
+	    (pdev->device_id != AR5416_DEVID_PCIE) &&
+	    (pdev->device_id != AR9160_DEVID_PCI) &&
+	    (pdev->device_id != AR9280_DEVID_PCI) &&
+	    (pdev->device_id != AR9280_DEVID_PCIE) &&
+	    (pdev->device_id != AR9285_DEVID_PCIE) &&
+	    (pdev->device_id != AR9287_DEVID_PCI) &&
+	    (pdev->device_id != AR9287_DEVID_PCIE)) {
+		fprintf(stderr, "Device ID: 0x%x not supported\n", pdev->device_id);
+		return 0;
+	}
+
+	printf("Found Device ID: 0x%04x\n", pdev->device_id);
+	return 1;
+}
+
+static struct edump* init_pci_device(struct pci_device *pdev)
+{
+	int err;
+	struct edump *edump;
+
+	if (!pdev->regions[0].base_addr) {
+		fprintf(stderr, "Invalid base address\n");
+		return NULL;
+	}
+
+	edump = malloc(sizeof(struct edump));
+	if (edump == NULL) {
+		fprintf(stderr, "Unable to alloc memory for edump\n");
+		return NULL;
+	}
+
+	memset(edump, 0, sizeof(struct edump));
+
+	edump->pdev = pdev;
+	edump->base_addr = pdev->regions[0].base_addr;
+	edump->size = pdev->regions[0].size;
+	pdev->user_data = (intptr_t)edump;
+
+	if ((err = pci_device_map_range(pdev, edump->base_addr, edump->size,
+					0, &edump->io_map)) != 0) {
+		fprintf(stderr, "%s\n", strerror(err));
+		goto map_fail;
+	}
+
+	printf("Mapped IO region at: %p\n", edump->io_map);
+	return edump;
+
+map_fail:
+	free(edump);
+	return NULL;
+}
+
+static void cleanup_pci_device(struct edump *edump)
+{
+	int err;
+
+	printf("\nFreeing Mapped IO region at: %p\n", edump->io_map);
+
+	if ((err = pci_device_unmap_range(edump->pdev, edump->io_map,
+					  edump->size)) != 0)
+		fprintf(stderr, "%s\n", strerror(err));
+
+	free(edump);
+}
+
+static void hw_read_revisions(struct edump *edump)
+{
+	uint32_t val;
+
+	val = REG_READ(AR_SREV) & AR_SREV_ID;
+
+	if (val == 0xFF) {
+		val = REG_READ(AR_SREV);
+		edump->macVersion = (val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
+		edump->macRev = MS(val, AR_SREV_REVISION2);
+	} else {
+		edump->macVersion = MS(val, AR_SREV_VERSION);
+		edump->macRev = val & AR_SREV_REVISION;
+	}
+
+	printf("Atheros AR%s MAC/BB Rev:%x\n",
+	       mac_bb_name(edump->macVersion), edump->macRev);
+}
+
+bool hw_wait(struct edump *edump, uint32_t reg, uint32_t mask,
+	     uint32_t val, uint32_t timeout)
+{
+	int i;
+
+	for (i = 0; i < (timeout / AH_TIME_QUANTUM); i++) {
+		if ((REG_READ(reg) & mask) == val)
+			return true;
+
+		usleep(AH_TIME_QUANTUM);
+	}
+
+	return false;
+}
+
+bool pci_eeprom_read(struct edump *edump, uint32_t off, uint16_t *data)
+{
+	(void)REG_READ(AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
+
+	if (!hw_wait(edump,
+		     AR_EEPROM_STATUS_DATA,
+		     AR_EEPROM_STATUS_DATA_BUSY |
+		     AR_EEPROM_STATUS_DATA_PROT_ACCESS, 0,
+		     AH_WAIT_TIMEOUT)) {
+		return false;
+	}
+
+	*data = MS(REG_READ(AR_EEPROM_STATUS_DATA),
+		   AR_EEPROM_STATUS_DATA_VAL);
+
+	return true;
+}
+
+int register_eep_ops(struct edump *edump)
+{
+	if (AR_SREV_9287(edump)) {
+		edump->eep_map = EEP_MAP_9287;
+		edump->eep_ops = &eep_9287_ops;
+	} else if (AR_SREV_9285(edump)) {
+		edump->eep_map = EEP_MAP_4K;
+		edump->eep_ops = &eep_4k_ops;
+	} else {
+		edump->eep_map = EEP_MAP_DEFAULT;
+		edump->eep_ops = &eep_def_ops;
+	}
+
+	if (!edump->eep_ops->fill_eeprom(edump)) {
+		fprintf(stderr, "Unable to fill EEPROM data\n");
+		return -1;
+	}
+
+	if (!edump->eep_ops->check_eeprom(edump)) {
+		fprintf(stderr, "EEPROM check failed\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+void dump_device(struct edump *edump)
+{
+	hw_read_revisions(edump);
+
+	if (register_eep_ops(edump) < 0)
+		return;
+
+	switch(dump) {
+	case DUMP_BASE_HEADER:
+		edump->eep_ops->dump_base_header(edump);
+		break;
+	case DUMP_MODAL_HEADER:
+		edump->eep_ops->dump_modal_header(edump);
+		break;
+	case DUMP_POWER_INFO:
+		edump->eep_ops->dump_power_info(edump);
+		break;
+	case DUMP_ALL:
+		edump->eep_ops->dump_base_header(edump);
+		edump->eep_ops->dump_modal_header(edump);
+		edump->eep_ops->dump_power_info(edump);
+		break;
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct edump *edump;
+	struct pci_device_iterator *iter;
+	struct pci_device *pdev;
+	int ret = 0, cnt = 0;;
+
+	dump = DUMP_ALL;
+
+	if (argp_parse(&argp, argc, argv, 0, 0, NULL) != 0)
+		return -EINVAL;
+
+	if ((ret = pci_system_init()) != 0) {
+		fprintf(stderr, "%s\n", strerror(ret));
+		return ret;
+	} else {
+		printf("Initializing PCI\n");
+	}
+
+	iter = pci_id_match_iterator_create(pci_id);
+	if (iter == NULL) {
+		ret = -EINVAL;
+		fprintf(stderr, "Iter creation failed\n");
+		goto iter_fail;
+	}
+
+	while((pdev = pci_device_next(iter)) != NULL) {
+		if ((ret = pci_device_probe(pdev)) != 0) {
+			fprintf(stderr, "%s\n", strerror(ret));
+			continue;
+		}
+
+		if (!is_supported_chipset(pdev))
+			continue;
+
+		edump = init_pci_device(pdev);
+		if (edump == NULL)
+			continue;
+
+		cnt++;
+		dump_device(edump);
+		cleanup_pci_device(edump);
+	}
+
+	if (!cnt)
+		printf("No supported card found\n");
+
+	pci_iterator_destroy(iter);
+
+iter_fail:
+	pci_system_cleanup();
+	return ret;
+}
diff --git a/tools/edump/src/edump.h b/tools/edump/src/edump.h
new file mode 100644
index 0000000..0480acb
--- /dev/null
+++ b/tools/edump/src/edump.h
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef EDUMP_H
+#define EDUMP_H
+
+#if HAVE_CONFIG_H
+#include <config.h>
+#endif
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <byteswap.h>
+#include <argp.h>
+#include <pciaccess.h>
+
+#include "eep_common.h"
+#include "eep_def.h"
+#include "eep_4k.h"
+#include "eep_9287.h"
+
+#if __BYTE_ORDER == __BIG_ENDIAN
+#define REG_READ(_reg) \
+	bswap_32(*((volatile uint32_t *)(edump->io_map + (_reg))))
+#else
+#define REG_READ(_reg) \
+	(*((volatile uint32_t *)(edump->io_map + (_reg))))
+#endif
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#define MS(_v, _f)  (((_v) & _f) >> _f##_S)
+
+enum {
+	false = 0,
+	true = 1
+};
+
+typedef int bool;
+
+#define ATHEROS_VENDOR_ID       0x168c
+#define AR5416_DEVID_PCI        0x0023
+#define AR5416_DEVID_PCIE       0x0024
+#define AR9160_DEVID_PCI        0x0027
+#define AR9280_DEVID_PCI        0x0029
+#define AR9280_DEVID_PCIE       0x002a
+#define AR9285_DEVID_PCIE       0x002b
+#define AR9287_DEVID_PCI        0x002d
+#define AR9287_DEVID_PCIE       0x002e
+
+#define AR_SREV                 0x4020
+#define AR_SREV_ID              0x000000FF
+#define AR_SREV_VERSION         0x000000F0
+#define AR_SREV_VERSION_S       4
+#define AR_SREV_REVISION        0x00000007
+#define AR_SREV_VERSION2        0xFFFC0000
+#define AR_SREV_VERSION2_S      18
+#define AR_SREV_TYPE2           0x0003F000
+#define AR_SREV_TYPE2_S         12
+#define AR_SREV_REVISION2       0x00000F00
+#define AR_SREV_REVISION2_S     8
+
+#define AR_SREV_VERSION_5416_PCI        0xD
+#define AR_SREV_VERSION_5416_PCIE       0xC
+#define AR_SREV_VERSION_9160            0x40
+#define AR_SREV_VERSION_9280            0x80
+#define AR_SREV_VERSION_9285            0xC0
+#define AR_SREV_VERSION_9287            0x180
+
+#define AR_SREV_9280_20_OR_LATER(edump) \
+	(((edump)->macVersion >= AR_SREV_VERSION_9280))
+#define AR_SREV_9285(_ah) \
+	(((edump)->macVersion == AR_SREV_VERSION_9285))
+#define AR_SREV_9287(_ah) \
+	(((edump)->macVersion == AR_SREV_VERSION_9287))
+
+#define AH_WAIT_TIMEOUT 100000 /* (us) */
+#define AH_TIME_QUANTUM 10
+
+enum dump_data {
+	DUMP_BASE_HEADER = 1,
+	DUMP_MODAL_HEADER = 2,
+	DUMP_POWER_INFO = 3,
+	DUMP_ALL = 4
+};
+
+struct edump {
+	struct pci_device *pdev;
+	pciaddr_t base_addr;
+	pciaddr_t size;
+	void *io_map;
+
+	uint32_t macVersion;
+	uint16_t macRev;
+
+	struct eeprom_ops *eep_ops;
+	enum eep_map eep_map;
+
+	union {
+		struct ar5416_eeprom_def def;
+		struct ar5416_eeprom_4k map4k;
+		struct ar9287_eeprom map9287;
+	} eeprom;
+};
+
+struct eeprom_ops {
+	bool (*fill_eeprom)(struct edump *edump);
+	int (*check_eeprom)(struct edump *edump);
+	int (*get_eeprom_ver)(struct edump *edump);
+	int (*get_eeprom_rev)(struct edump *edump);
+	void (*dump_base_header)(struct edump *edump);
+	void (*dump_modal_header)(struct edump *edump);
+	void (*dump_power_info)(struct edump *edump);
+};
+
+extern struct eeprom_ops eep_def_ops;
+extern struct eeprom_ops eep_4k_ops;
+extern struct eeprom_ops eep_9287_ops;
+
+bool pci_eeprom_read(struct edump *edump, uint32_t off, uint16_t *data);
+
+#endif /* EDUMP_H */
diff --git a/tools/edump/src/eep_4k.c b/tools/edump/src/eep_4k.c
new file mode 100644
index 0000000..a23ae3a
--- /dev/null
+++ b/tools/edump/src/eep_4k.c
@@ -0,0 +1,308 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "edump.h"
+
+static int get_eeprom_ver_4k(struct edump *edump)
+{
+	return ((edump->eeprom.map4k.baseEepHeader.version >> 12) & 0xF);
+}
+
+static int get_eeprom_rev_4k(struct edump *edump)
+{
+	return ((edump->eeprom.map4k.baseEepHeader.version) & 0xFFF);
+}
+
+static bool fill_eeprom_4k(struct edump *edump)
+{
+#define SIZE_EEPROM_4K (sizeof(struct ar5416_eeprom_4k) / sizeof(uint16_t))
+
+	uint16_t *eep_data = (uint16_t *)&edump->eeprom.map4k;
+	int addr, eep_start_loc = 0;
+
+	eep_start_loc = 64;
+
+	for (addr = 0; addr < SIZE_EEPROM_4K; addr++) {
+		if (!pci_eeprom_read(edump, addr + eep_start_loc, eep_data)) {
+			fprintf(stderr, "Unable to read eeprom region\n");
+			return false;
+		}
+		eep_data++;
+	}
+
+	return true;
+
+#undef SIZE_EEPROM_4K
+}
+
+static bool check_eeprom_4k(struct edump *edump)
+{
+#define EEPROM_4K_SIZE (sizeof(struct ar5416_eeprom_4k) / sizeof(uint16_t))
+
+	struct ar5416_eeprom_4k *eep = &edump->eeprom.map4k;
+	uint16_t *eepdata, temp, magic, magic2;
+	uint32_t sum = 0, el;
+	bool need_swap = false;
+	int i, addr;
+
+	if (!pci_eeprom_read(edump, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+		fprintf(stderr, "Reading Magic # failed\n");
+		return false;
+	}
+
+	if (magic != AR5416_EEPROM_MAGIC) {
+		magic2 = bswap_16(magic);
+
+		if (magic2 == AR5416_EEPROM_MAGIC) {
+			need_swap = true;
+			eepdata = (uint16_t *) (&edump->eeprom);
+
+			for (addr = 0; addr < EEPROM_4K_SIZE; addr++) {
+				temp = bswap_16(*eepdata);
+				*eepdata = temp;
+				eepdata++;
+			}
+		} else {
+			fprintf(stderr, "Invalid EEPROM Magic, endianness mismatch.\n");
+			return false;
+		}
+	}
+
+	if (need_swap)
+		el = bswap_16(edump->eeprom.map4k.baseEepHeader.length);
+	else
+		el = edump->eeprom.map4k.baseEepHeader.length;
+
+	if (el > sizeof(struct ar5416_eeprom_4k))
+		el = sizeof(struct ar5416_eeprom_4k) / sizeof(uint16_t);
+	else
+		el = el / sizeof(uint16_t);
+
+	eepdata = (uint16_t *)(&edump->eeprom);
+
+	for (i = 0; i < el; i++)
+		sum ^= *eepdata++;
+
+	if (need_swap) {
+		uint32_t integer;
+		uint16_t word;
+
+		printf("EEPROM Endianness is not native.. Changing\n");
+
+		word = bswap_16(eep->baseEepHeader.length);
+		eep->baseEepHeader.length = word;
+
+		word = bswap_16(eep->baseEepHeader.checksum);
+		eep->baseEepHeader.checksum = word;
+
+		word = bswap_16(eep->baseEepHeader.version);
+		eep->baseEepHeader.version = word;
+
+		word = bswap_16(eep->baseEepHeader.regDmn[0]);
+		eep->baseEepHeader.regDmn[0] = word;
+
+		word = bswap_16(eep->baseEepHeader.regDmn[1]);
+		eep->baseEepHeader.regDmn[1] = word;
+
+		word = bswap_16(eep->baseEepHeader.rfSilent);
+		eep->baseEepHeader.rfSilent = word;
+
+		word = bswap_16(eep->baseEepHeader.blueToothOptions);
+		eep->baseEepHeader.blueToothOptions = word;
+
+		word = bswap_16(eep->baseEepHeader.deviceCap);
+		eep->baseEepHeader.deviceCap = word;
+
+		integer = bswap_32(eep->modalHeader.antCtrlCommon);
+		eep->modalHeader.antCtrlCommon = integer;
+
+		for (i = 0; i < AR5416_EEP4K_MAX_CHAINS; i++) {
+			integer = bswap_32(eep->modalHeader.antCtrlChain[i]);
+			eep->modalHeader.antCtrlChain[i] = integer;
+		}
+
+		for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
+			word = bswap_16(eep->modalHeader.spurChans[i].spurChan);
+			eep->modalHeader.spurChans[i].spurChan = word;
+		}
+	}
+
+	if (sum != 0xffff || edump->eep_ops->get_eeprom_ver(edump) != AR5416_EEP_VER ||
+	    edump->eep_ops->get_eeprom_rev(edump) < AR5416_EEP_NO_BACK_VER) {
+		fprintf(stderr, "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+			sum, edump->eep_ops->get_eeprom_ver(edump));
+		return false;
+	}
+
+	return true;
+
+#undef EEPROM_4K_SIZE
+}
+
+static void base_eeprom_4k(struct edump *edump)
+{
+	struct ar5416_eeprom_4k *ar5416Eep = &edump->eeprom.map4k;
+	struct base_eep_header_4k *pBase = &ar5416Eep->baseEepHeader;
+	uint16_t i;
+
+	pBase = &(ar5416Eep->baseEepHeader);
+
+	printf("\n----------------------\n");
+	printf("| EEPROM Base Header |\n");
+	printf("----------------------\n\n");
+
+	printf("%-30s : %2d\n", "Major Version",
+	       pBase->version >> 12);
+	printf("%-30s : %2d\n", "Minor Version",
+	       pBase->version & 0xFFF);
+	printf("%-30s : 0x%04X\n", "Checksum",
+	       pBase->checksum);
+	printf("%-30s : 0x%04X\n", "Length",
+	       pBase->length);
+	printf("%-30s : 0x%04X\n", "RegDomain1",
+	       pBase->regDmn[0]);
+	printf("%-30s : 0x%04X\n", "RegDomain2",
+	       pBase->regDmn[1]);
+	printf("%-30s : %02X:%02X:%02X:%02X:%02X:%02X\n",
+	       "MacAddress",
+	       pBase->macAddr[0], pBase->macAddr[1], pBase->macAddr[2],
+	       pBase->macAddr[3], pBase->macAddr[4], pBase->macAddr[5]);
+	printf("%-30s : 0x%04X\n",
+	       "TX Mask", pBase->txMask);
+	printf("%-30s : 0x%04X\n",
+	       "RX Mask", pBase->rxMask);
+	printf("%-30s : %d\n",
+	       "OpFlags(5GHz)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
+	printf("%-30s : %d\n",
+	       "OpFlags(2GHz)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 2GHz HT20)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT20));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 2GHz HT40)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT40));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 5Ghz HT20)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT20));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 5Ghz HT40)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT40));
+	printf("%-30s : %d\n",
+	       "Big Endian",
+	       !!(pBase->eepMisc & AR5416_EEPMISC_BIG_ENDIAN));
+	printf("%-30s : %d\n",
+	       "Cal Bin Major Ver",
+	       (pBase->binBuildNumber >> 24) & 0xFF);
+	printf("%-30s : %d\n",
+	       "Cal Bin Minor Ver",
+	       (pBase->binBuildNumber >> 16) & 0xFF);
+	printf("%-30s : %d\n",
+	       "Cal Bin Build",
+	       (pBase->binBuildNumber >> 8) & 0xFF);
+
+	if (edump->eep_ops->get_eeprom_rev(edump) >= AR5416_EEP_MINOR_VER_3) {
+		printf("%-30s : %s\n",
+		       "Device Type",
+		       sDeviceType[(pBase->deviceType & 0x7)]);
+	}
+
+	printf("\nCustomer Data in hex:\n");
+	for (i = 0; i < 64; i++) {
+		printf("%02X ", ar5416Eep->custData[i]);
+		if ((i % 16) == 15)
+			printf("\n");
+	}
+}
+
+static void modal_eeprom_4k(struct edump *edump)
+{
+#define PR(_token, _p, _val_fmt, _val)			\
+	do {						\
+		printf("%-23s %-2s", (_token), ":");	\
+		printf("%s%"_val_fmt, _p, (_val));	\
+		printf("\n");				\
+	} while(0)
+
+	struct ar5416_eeprom_4k *ar5416Eep = &edump->eeprom.map4k;
+	struct modal_eep_4k_header *pModal = &ar5416Eep->modalHeader;
+
+	printf("\n\n-----------------------\n");
+	printf("| EEPROM Modal Header |\n");
+	printf("-----------------------\n\n");
+
+	PR("Ant Chain 0", "0x", "X", pModal->antCtrlChain[0]);
+	PR("Antenna Common", "0x", "X", pModal->antCtrlCommon);
+	PR("Antenna Gain Chain 0", "", "d", pModal->antennaGainCh[0]);
+	PR("Switch Settling", "", "d", pModal->switchSettling);
+	PR("TxRxAttenation Chain 0", "", "d", pModal->txRxAttenCh[0]);
+	PR("RxTxMargin Chain 0", "", "d", pModal->rxTxMarginCh[0]);
+	PR("ADC Desired Size", "", "d", pModal->adcDesiredSize);
+	PR("PGA Desired Size", "", "d", pModal->pgaDesiredSize);
+	PR("XLNA Gain Chain 0", "", "d", pModal->xlnaGainCh[0]);
+	PR("TxEndToXpaOff", "", "d", pModal->txEndToXpaOff);
+	PR("TxEndToRxOn", "", "d", pModal->txEndToRxOn);
+	PR("TxFrameToXpaOn", "", "d", pModal->txFrameToXpaOn);
+	PR("Thresh 62", "", "d", pModal->thresh62);
+	PR("NF Thresh Chain 0", "", "d", pModal->noiseFloorThreshCh[0]);
+	PR("XPD Gain", "", "d", pModal->xpdGain);
+	PR("XPD", "", "d", pModal->xpd);
+	PR("IQ Cal I Chain 0", "", "d", pModal->iqCalICh[0]);
+	PR("IQ Cal Q Chain 0", "", "d", pModal->iqCalQCh[0]);
+	PR("PD Gain Overlap", "", "d", pModal->pdGainOverlap);
+	PR("Output Bias CCK", "", "d", pModal->ob_0);
+	PR("Output Bias BPSK", "", "d", pModal->ob_1);
+	PR("Driver 1 Bias CCK", "", "d", pModal->db1_0);
+	PR("Driver 1 Bias BPSK", "", "d", pModal->db1_1);
+	PR("XPA Bias Level", "", "d", pModal->xpaBiasLvl);
+	PR("TX Frame to Data Start", "", "d", pModal->txFrameToDataStart);
+	PR("TX Frame to PA On", "", "d", pModal->txFrameToPaOn);
+	PR("HT40PowerIncForPDADC", "", "d", pModal->ht40PowerIncForPdadc);
+	PR("bsw_atten Chain 0", "", "d", pModal->bswAtten[0]);
+	PR("bsw_margin Chain 0", "", "d", pModal->bswMargin[0]);
+	PR("Switch Settling [HT40]", "", "d", pModal->swSettleHt40);
+	PR("xatten2DB Chain 0", "", "d", pModal->xatten2Db[0]);
+	PR("xatten2margin Chain 0", "", "d", pModal->xatten2Margin[0]);
+	PR("Driver 2 Bias CCK", "", "d", pModal->db2_0);
+	PR("Driver 2 Bias BPSK", "", "d", pModal->db2_1);
+	PR("ob_db Version", "", "d", pModal->version);
+	PR("Output Bias QPSK", "", "d", pModal->ob_2);
+	PR("Output Bias 16QAM", "", "d", pModal->ob_3);
+	PR("Output Bias 64QAM", "", "d", pModal->ob_4);
+	PR("Ant diversity ctrl 1", "", "d", pModal->antdiv_ctl1);
+	PR("Driver 1 Bias QPSK", "", "d", pModal->db1_2);
+	PR("Driver 1 Bias 16QAM", "", "d", pModal->db1_3);
+	PR("Driver 1 Bias 64QAM", "", "d", pModal->db1_4);
+	PR("Ant diversity ctrl 2", "", "d", pModal->antdiv_ctl2);
+	PR("Driver 2 Bias QPSK", "", "d", pModal->db2_2);
+	PR("Driver 2 Bias 16QAM", "", "d", pModal->db2_3);
+	PR("Driver 2 Bias 64QAM", "", "d", pModal->db2_4);
+}
+
+static void power_info_eeprom_4k(struct edump *edump)
+{
+}
+
+struct eeprom_ops eep_4k_ops = {
+	.fill_eeprom  = fill_eeprom_4k,
+	.check_eeprom = check_eeprom_4k,
+	.get_eeprom_ver = get_eeprom_ver_4k,
+	.get_eeprom_rev = get_eeprom_rev_4k,
+	.dump_base_header = base_eeprom_4k,
+	.dump_modal_header = modal_eeprom_4k,
+	.dump_power_info = power_info_eeprom_4k,
+};
diff --git a/tools/edump/src/eep_4k.h b/tools/edump/src/eep_4k.h
new file mode 100644
index 0000000..1bfc938
--- /dev/null
+++ b/tools/edump/src/eep_4k.h
@@ -0,0 +1,142 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef EEP_4K_H
+#define EEP_4K_H
+
+#define AR5416_EEP4K_START_LOC                64
+#define AR5416_EEP4K_NUM_2G_CAL_PIERS         3
+#define AR5416_EEP4K_NUM_2G_CCK_TARGET_POWERS 3
+#define AR5416_EEP4K_NUM_2G_20_TARGET_POWERS  3
+#define AR5416_EEP4K_NUM_2G_40_TARGET_POWERS  3
+#define AR5416_EEP4K_NUM_CTLS                 12
+#define AR5416_EEP4K_NUM_BAND_EDGES           4
+#define AR5416_EEP4K_NUM_PD_GAINS             2
+#define AR5416_EEP4K_MAX_CHAINS               1
+
+struct base_eep_header_4k {
+	uint16_t length;
+	uint16_t checksum;
+	uint16_t version;
+	uint8_t opCapFlags;
+	uint8_t eepMisc;
+	uint16_t regDmn[2];
+	uint8_t macAddr[6];
+	uint8_t rxMask;
+	uint8_t txMask;
+	uint16_t rfSilent;
+	uint16_t blueToothOptions;
+	uint16_t deviceCap;
+	uint32_t binBuildNumber;
+	uint8_t deviceType;
+	uint8_t txGainType;
+} __attribute__ ((packed));
+
+struct modal_eep_4k_header {
+	uint32_t antCtrlChain[AR5416_EEP4K_MAX_CHAINS];
+	uint32_t antCtrlCommon;
+	uint8_t antennaGainCh[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t switchSettling;
+	uint8_t txRxAttenCh[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t rxTxMarginCh[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t adcDesiredSize;
+	uint8_t pgaDesiredSize;
+	uint8_t xlnaGainCh[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t txEndToXpaOff;
+	uint8_t txEndToRxOn;
+	uint8_t txFrameToXpaOn;
+	uint8_t thresh62;
+	uint8_t noiseFloorThreshCh[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t xpdGain;
+	uint8_t xpd;
+	uint8_t iqCalICh[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t iqCalQCh[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t pdGainOverlap;
+#if __BYTE_ORDER == __BIG_ENDIAN
+	uint8_t ob_1:4, ob_0:4;
+	uint8_t db1_1:4, db1_0:4;
+#else
+	uint8_t ob_0:4, ob_1:4;
+	uint8_t db1_0:4, db1_1:4;
+#endif
+	uint8_t xpaBiasLvl;
+	uint8_t txFrameToDataStart;
+	uint8_t txFrameToPaOn;
+	uint8_t ht40PowerIncForPdadc;
+	uint8_t bswAtten[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t bswMargin[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t swSettleHt40;
+	uint8_t xatten2Db[AR5416_EEP4K_MAX_CHAINS];
+	uint8_t xatten2Margin[AR5416_EEP4K_MAX_CHAINS];
+#if __BYTE_ORDER == __BIG_ENDIAN
+	uint8_t db2_1:4, db2_0:4;
+#else
+	uint8_t db2_0:4, db2_1:4;
+#endif
+	uint8_t version;
+#if __BYTE_ORDER == __BIG_ENDIAN
+	uint8_t ob_3:4, ob_2:4;
+	uint8_t antdiv_ctl1:4, ob_4:4;
+	uint8_t db1_3:4, db1_2:4;
+	uint8_t antdiv_ctl2:4, db1_4:4;
+	uint8_t db2_2:4, db2_3:4;
+	uint8_t reserved:4, db2_4:4;
+#else
+	uint8_t ob_2:4, ob_3:4;
+	uint8_t ob_4:4, antdiv_ctl1:4;
+	uint8_t db1_2:4, db1_3:4;
+	uint8_t db1_4:4, antdiv_ctl2:4;
+	uint8_t db2_2:4, db2_3:4;
+	uint8_t db2_4:4, reserved:4;
+#endif
+	uint8_t tx_diversity;
+	uint8_t flc_pwr_thresh;
+	uint8_t bb_scale_smrt_antenna;
+	uint8_t futureModal[1];
+	struct spur_chan spurChans[AR_EEPROM_MODAL_SPURS];
+} __attribute__ ((packed));
+
+struct cal_data_per_freq_4k {
+	uint8_t pwrPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+	uint8_t vpdPdg[AR5416_EEP4K_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+} __attribute__ ((packed));
+
+struct cal_ctl_data_4k {
+	struct cal_ctl_edges
+	ctlEdges[AR5416_EEP4K_MAX_CHAINS][AR5416_EEP4K_NUM_BAND_EDGES];
+} __attribute__ ((packed));
+
+struct ar5416_eeprom_4k {
+	struct base_eep_header_4k baseEepHeader;
+	uint8_t custData[20];
+	struct modal_eep_4k_header modalHeader;
+	uint8_t calFreqPier2G[AR5416_EEP4K_NUM_2G_CAL_PIERS];
+	struct cal_data_per_freq_4k
+	calPierData2G[AR5416_EEP4K_MAX_CHAINS][AR5416_EEP4K_NUM_2G_CAL_PIERS];
+	struct cal_target_power_leg
+	calTargetPowerCck[AR5416_EEP4K_NUM_2G_CCK_TARGET_POWERS];
+	struct cal_target_power_leg
+	calTargetPower2G[AR5416_EEP4K_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	calTargetPower2GHT20[AR5416_EEP4K_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	calTargetPower2GHT40[AR5416_EEP4K_NUM_2G_40_TARGET_POWERS];
+	uint8_t ctlIndex[AR5416_EEP4K_NUM_CTLS];
+	struct cal_ctl_data_4k ctlData[AR5416_EEP4K_NUM_CTLS];
+	uint8_t padding;
+} __attribute__ ((packed));
+
+#endif /* EEP_4K_H */
diff --git a/tools/edump/src/eep_9287.c b/tools/edump/src/eep_9287.c
new file mode 100644
index 0000000..16b2794
--- /dev/null
+++ b/tools/edump/src/eep_9287.c
@@ -0,0 +1,303 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "edump.h"
+
+#define SIZE_EEPROM_AR9287 (sizeof(struct ar9287_eeprom) / sizeof(uint16_t))
+
+static int get_eeprom_ver_9287(struct edump *edump)
+{
+	return (edump->eeprom.map9287.baseEepHeader.version >> 12) & 0xF;
+}
+
+static int get_eeprom_rev_9287(struct edump *edump)
+{
+	return (edump->eeprom.map9287.baseEepHeader.version) & 0xFFF;
+}
+
+static bool fill_eeprom_9287(struct edump *edump)
+{
+	uint16_t *eep_data = (uint16_t *)&edump->eeprom.map9287;
+	int addr, eep_start_loc = 0;
+
+	eep_start_loc = AR9287_EEP_START_LOC;
+
+	for (addr = 0; addr < SIZE_EEPROM_AR9287; addr++) {
+		if (!pci_eeprom_read(edump, addr + eep_start_loc, eep_data)) {
+			fprintf(stderr, "Unable to read eeprom region\n");
+			return false;
+		}
+		eep_data++;
+	}
+
+	return true;
+}
+
+static bool check_eeprom_9287(struct edump *edump)
+{
+	struct ar9287_eeprom *eep = &edump->eeprom.map9287;
+	uint16_t *eepdata, temp, magic, magic2;
+	uint32_t sum = 0, el;
+	bool need_swap = false;
+	int i, addr;
+
+	if (!pci_eeprom_read(edump, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+		fprintf(stderr, "Reading Magic # failed\n");
+		return false;
+	}
+
+	if (magic != AR5416_EEPROM_MAGIC) {
+		magic2 = bswap_16(magic);
+
+		if (magic2 == AR5416_EEPROM_MAGIC) {
+			need_swap = true;
+			eepdata = (uint16_t *) (&edump->eeprom);
+
+			for (addr = 0; addr < SIZE_EEPROM_AR9287; addr++) {
+				temp = bswap_16(*eepdata);
+				*eepdata = temp;
+				eepdata++;
+			}
+		} else {
+			fprintf(stderr, "Invalid EEPROM Magic, endianness mismatch.\n");
+			return false;
+		}
+	}
+
+	if (need_swap)
+		el = bswap_16(edump->eeprom.map9287.baseEepHeader.length);
+	else
+		el = edump->eeprom.map9287.baseEepHeader.length;
+
+	if (el > sizeof(struct ar9287_eeprom))
+		el = sizeof(struct ar9287_eeprom) / sizeof(uint16_t);
+	else
+		el = el / sizeof(uint16_t);
+
+	eepdata = (uint16_t *)(&edump->eeprom);
+
+	for (i = 0; i < el; i++)
+		sum ^= *eepdata++;
+
+	if (need_swap) {
+		uint32_t integer;
+		uint16_t word;
+
+		printf("EEPROM Endianness is not native.. Changing\n");
+
+		word = bswap_16(eep->baseEepHeader.length);
+		eep->baseEepHeader.length = word;
+
+		word = bswap_16(eep->baseEepHeader.checksum);
+		eep->baseEepHeader.checksum = word;
+
+		word = bswap_16(eep->baseEepHeader.version);
+		eep->baseEepHeader.version = word;
+
+		word = bswap_16(eep->baseEepHeader.regDmn[0]);
+		eep->baseEepHeader.regDmn[0] = word;
+
+		word = bswap_16(eep->baseEepHeader.regDmn[1]);
+		eep->baseEepHeader.regDmn[1] = word;
+
+		word = bswap_16(eep->baseEepHeader.rfSilent);
+		eep->baseEepHeader.rfSilent = word;
+
+		word = bswap_16(eep->baseEepHeader.blueToothOptions);
+		eep->baseEepHeader.blueToothOptions = word;
+
+		word = bswap_16(eep->baseEepHeader.deviceCap);
+		eep->baseEepHeader.deviceCap = word;
+
+		integer = bswap_32(eep->modalHeader.antCtrlCommon);
+		eep->modalHeader.antCtrlCommon = integer;
+
+		for (i = 0; i < AR9287_MAX_CHAINS; i++) {
+			integer = bswap_32(eep->modalHeader.antCtrlChain[i]);
+			eep->modalHeader.antCtrlChain[i] = integer;
+		}
+
+		for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
+			word = bswap_16(eep->modalHeader.spurChans[i].spurChan);
+			eep->modalHeader.spurChans[i].spurChan = word;
+		}
+	}
+
+	if (sum != 0xffff || edump->eep_ops->get_eeprom_ver(edump) != AR9287_EEP_VER ||
+	    edump->eep_ops->get_eeprom_rev(edump) < AR5416_EEP_NO_BACK_VER) {
+		fprintf(stderr, "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+			sum, edump->eep_ops->get_eeprom_ver(edump));
+		return false;
+	}
+
+	return true;
+}
+
+static void base_eeprom_9287(struct edump *edump)
+{
+	struct ar9287_eeprom *eep = &edump->eeprom.map9287;
+	struct base_eep_ar9287_header *pBase = &eep->baseEepHeader;
+	uint16_t i;
+
+	pBase = &(eep->baseEepHeader);
+
+	printf("\n----------------------\n");
+	printf("| EEPROM Base Header |\n");
+	printf("----------------------\n\n");
+
+	printf("%-30s : %2d\n", "Major Version",
+	       pBase->version >> 12);
+	printf("%-30s : %2d\n", "Minor Version",
+	       pBase->version & 0xFFF);
+	printf("%-30s : 0x%04X\n", "Checksum",
+	       pBase->checksum);
+	printf("%-30s : 0x%04X\n", "Length",
+	       pBase->length);
+	printf("%-30s : 0x%04X\n", "RegDomain1",
+	       pBase->regDmn[0]);
+	printf("%-30s : 0x%04X\n", "RegDomain2",
+	       pBase->regDmn[1]);
+	printf("%-30s : %02X:%02X:%02X:%02X:%02X:%02X\n",
+	       "MacAddress",
+	       pBase->macAddr[0], pBase->macAddr[1], pBase->macAddr[2],
+	       pBase->macAddr[3], pBase->macAddr[4], pBase->macAddr[5]);
+	printf("%-30s : 0x%04X\n",
+	       "TX Mask", pBase->txMask);
+	printf("%-30s : 0x%04X\n",
+	       "RX Mask", pBase->rxMask);
+	printf("%-30s : %d\n",
+	       "OpFlags(5GHz)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
+	printf("%-30s : %d\n",
+	       "OpFlags(2GHz)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 2GHz HT20)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT20));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 2GHz HT40)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT40));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 5Ghz HT20)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT20));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 5Ghz HT40)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT40));
+	printf("%-30s : %d\n",
+	       "Big Endian",
+	       !!(pBase->eepMisc & AR5416_EEPMISC_BIG_ENDIAN));
+	printf("%-30s : %d\n",
+	       "Wake on Wireless",
+	       !!(pBase->eepMisc & AR9287_EEPMISC_WOW));
+	printf("%-30s : %d\n",
+	       "Cal Bin Major Ver",
+	       (pBase->binBuildNumber >> 24) & 0xFF);
+	printf("%-30s : %d\n",
+	       "Cal Bin Minor Ver",
+	       (pBase->binBuildNumber >> 16) & 0xFF);
+	printf("%-30s : %d\n",
+	       "Cal Bin Build",
+	       (pBase->binBuildNumber >> 8) & 0xFF);
+	printf("%-30s : %d\n",
+	       "OpenLoop PowerControl",
+	       (pBase->openLoopPwrCntl & 0x1));
+
+	if (edump->eep_ops->get_eeprom_rev(edump) >= AR5416_EEP_MINOR_VER_3) {
+		printf("%-30s : %s\n",
+		       "Device Type",
+		       sDeviceType[(pBase->deviceType & 0x7)]);
+	}
+
+	printf("\nCustomer Data in hex:\n");
+	for (i = 0; i < 64; i++) {
+		printf("%02X ", eep->custData[i]);
+		if ((i % 16) == 15)
+			printf("\n");
+	}
+}
+
+static void modal_eeprom_9287(struct edump *edump)
+{
+#define PR(_token, _p, _val_fmt, _val)			\
+	do {						\
+		printf("%-23s %-2s", (_token), ":");	\
+		printf("%s%"_val_fmt, _p, (_val));	\
+		printf("\n");				\
+	} while(0)
+
+	struct ar9287_eeprom *eep = &edump->eeprom.map9287;
+	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
+
+	printf("\n\n-----------------------\n");
+	printf("| EEPROM Modal Header |\n");
+	printf("-----------------------\n\n");
+
+	PR("Chain0 Ant. Control", "0x", "X", pModal->antCtrlChain[0]);
+	PR("Chain1 Ant. Control", "0x", "X", pModal->antCtrlChain[1]);
+	PR("Ant. Common Control", "0x", "X", pModal->antCtrlCommon);
+	PR("Chain0 Ant. Gain", "", "d", pModal->antennaGainCh[0]);
+	PR("Chain1 Ant. Gain", "", "d", pModal->antennaGainCh[1]);
+	PR("Switch Settle", "", "d", pModal->switchSettling);
+	PR("Chain0 TxRxAtten", "", "d", pModal->txRxAttenCh[0]);
+	PR("Chain1 TxRxAtten", "", "d", pModal->txRxAttenCh[1]);
+	PR("Chain0 RxTxMargin", "", "d", pModal->rxTxMarginCh[0]);
+	PR("Chain1 RxTxMargin", "", "d", pModal->rxTxMarginCh[1]);
+	PR("ADC Desired size", "", "d", pModal->adcDesiredSize);
+	PR("txEndToXpaOff", "", "d", pModal->txEndToXpaOff);
+	PR("txEndToRxOn", "", "d", pModal->txEndToRxOn);
+	PR("txFrameToXpaOn", "", "d", pModal->txFrameToXpaOn);
+	PR("CCA Threshold)", "", "d", pModal->thresh62);
+	PR("Chain0 NF Threshold", "", "d", pModal->noiseFloorThreshCh[0]);
+	PR("Chain1 NF Threshold", "", "d", pModal->noiseFloorThreshCh[1]);
+	PR("xpdGain", "", "d", pModal->xpdGain);
+	PR("External PD", "", "d", pModal->xpd);
+	PR("Chain0 I Coefficient", "", "d", pModal->iqCalICh[0]);
+	PR("Chain1 I Coefficient", "", "d", pModal->iqCalICh[1]);
+	PR("Chain0 Q Coefficient", "", "d", pModal->iqCalQCh[0]);
+	PR("Chain1 Q Coefficient", "", "d", pModal->iqCalQCh[1]);
+	PR("pdGainOverlap", "", "d", pModal->pdGainOverlap);
+	PR("xPA Bias Level", "", "d", pModal->xpaBiasLvl);
+	PR("txFrameToDataStart", "", "d", pModal->txFrameToDataStart);
+	PR("txFrameToPaOn", "", "d", pModal->txFrameToPaOn);
+	PR("HT40 Power Inc.", "", "d", pModal->ht40PowerIncForPdadc);
+	PR("Chain0 bswAtten", "", "d", pModal->bswAtten[0]);
+	PR("Chain1 bswAtten", "", "d", pModal->bswAtten[1]);
+	PR("Chain0 bswMargin", "", "d", pModal->bswMargin[0]);
+	PR("Chain1 bswMargin", "", "d", pModal->bswMargin[1]);
+	PR("HT40 Switch Settle", "", "d", pModal->swSettleHt40);
+	PR("AR92x7 Version", "", "d", pModal->version);
+	PR("DriverBias1", "", "d", pModal->db1);
+	PR("DriverBias2", "", "d", pModal->db1);
+	PR("CCK OutputBias", "", "d", pModal->ob_cck);
+	PR("PSK OutputBias", "", "d", pModal->ob_psk);
+	PR("QAM OutputBias", "", "d", pModal->ob_qam);
+	PR("PAL_OFF OutputBias", "", "d", pModal->ob_pal_off);
+
+}
+
+static void power_info_eeprom_9287(struct edump *edump)
+{
+}
+
+struct eeprom_ops eep_9287_ops = {
+	.fill_eeprom  = fill_eeprom_9287,
+	.check_eeprom = check_eeprom_9287,
+	.get_eeprom_ver = get_eeprom_ver_9287,
+	.get_eeprom_rev = get_eeprom_rev_9287,
+	.dump_base_header = base_eeprom_9287,
+	.dump_modal_header = modal_eeprom_9287,
+	.dump_power_info = power_info_eeprom_9287,
+};
diff --git a/tools/edump/src/eep_9287.h b/tools/edump/src/eep_9287.h
new file mode 100644
index 0000000..f2cb5d7
--- /dev/null
+++ b/tools/edump/src/eep_9287.h
@@ -0,0 +1,133 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef EEP_9287_H
+#define EEP_9287_H
+
+#define AR9287_EEP_VER                  0xE
+#define AR9287_EEP_START_LOC            128
+#define AR9287_DATA_SZ                  32
+#define AR9287_MAX_CHAINS               2
+#define AR9287_NUM_2G_CAL_PIERS         3
+#define AR9287_NUM_2G_CCK_TARGET_POWERS 3
+#define AR9287_NUM_2G_20_TARGET_POWERS  3
+#define AR9287_NUM_2G_40_TARGET_POWERS  3
+#define AR9287_NUM_CTLS              	12
+#define AR9287_NUM_BAND_EDGES        	4
+#define AR9287_PD_GAIN_ICEPTS           1
+#define AR9287_EEPMISC_WOW              0x02
+
+struct base_eep_ar9287_header {
+	uint16_t length;
+	uint16_t checksum;
+	uint16_t version;
+	uint8_t opCapFlags;
+	uint8_t eepMisc;
+	uint16_t regDmn[2];
+	uint8_t macAddr[6];
+	uint8_t rxMask;
+	uint8_t txMask;
+	uint16_t rfSilent;
+	uint16_t blueToothOptions;
+	uint16_t deviceCap;
+	uint32_t binBuildNumber;
+	uint8_t deviceType;
+	uint8_t openLoopPwrCntl;
+	int8_t pwrTableOffset;
+	int8_t tempSensSlope;
+	int8_t tempSensSlopePalOn;
+	uint8_t futureBase[29];
+} __attribute__ ((packed));
+
+struct modal_eep_ar9287_header {
+	uint32_t antCtrlChain[AR9287_MAX_CHAINS];
+	uint32_t antCtrlCommon;
+	int8_t antennaGainCh[AR9287_MAX_CHAINS];
+	uint8_t switchSettling;
+	uint8_t txRxAttenCh[AR9287_MAX_CHAINS];
+	uint8_t rxTxMarginCh[AR9287_MAX_CHAINS];
+	int8_t adcDesiredSize;
+	uint8_t txEndToXpaOff;
+	uint8_t txEndToRxOn;
+	uint8_t txFrameToXpaOn;
+	uint8_t thresh62;
+	int8_t noiseFloorThreshCh[AR9287_MAX_CHAINS];
+	uint8_t xpdGain;
+	uint8_t xpd;
+	int8_t iqCalICh[AR9287_MAX_CHAINS];
+	int8_t iqCalQCh[AR9287_MAX_CHAINS];
+	uint8_t pdGainOverlap;
+	uint8_t xpaBiasLvl;
+	uint8_t txFrameToDataStart;
+	uint8_t txFrameToPaOn;
+	uint8_t ht40PowerIncForPdadc;
+	uint8_t bswAtten[AR9287_MAX_CHAINS];
+	uint8_t bswMargin[AR9287_MAX_CHAINS];
+	uint8_t swSettleHt40;
+	uint8_t version;
+	uint8_t db1;
+	uint8_t db2;
+	uint8_t ob_cck;
+	uint8_t ob_psk;
+	uint8_t ob_qam;
+	uint8_t ob_pal_off;
+	uint8_t futureModal[30];
+	struct spur_chan spurChans[AR_EEPROM_MODAL_SPURS];
+} __attribute__ ((packed));
+
+struct cal_data_op_loop_ar9287 {
+	uint8_t pwrPdg[2][5];
+	uint8_t vpdPdg[2][5];
+	uint8_t pcdac[2][5];
+	uint8_t empty[2][5];
+} __attribute__ ((packed));
+
+struct cal_data_per_freq_ar9287 {
+	uint8_t pwrPdg[AR5416_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
+	uint8_t vpdPdg[AR5416_NUM_PD_GAINS][AR9287_PD_GAIN_ICEPTS];
+} __attribute__ ((packed));
+
+union cal_data_per_freq_ar9287_u {
+	struct cal_data_op_loop_ar9287 calDataOpen;
+	struct cal_data_per_freq_ar9287 calDataClose;
+} __attribute__ ((packed));
+
+struct cal_ctl_data_ar9287 {
+	struct cal_ctl_edges
+	ctlEdges[AR9287_MAX_CHAINS][AR9287_NUM_BAND_EDGES];
+} __attribute__ ((packed));
+
+struct ar9287_eeprom {
+	struct base_eep_ar9287_header baseEepHeader;
+	uint8_t custData[AR9287_DATA_SZ];
+	struct modal_eep_ar9287_header modalHeader;
+	uint8_t calFreqPier2G[AR9287_NUM_2G_CAL_PIERS];
+	union cal_data_per_freq_ar9287_u
+	calPierData2G[AR9287_MAX_CHAINS][AR9287_NUM_2G_CAL_PIERS];
+	struct cal_target_power_leg
+	calTargetPowerCck[AR9287_NUM_2G_CCK_TARGET_POWERS];
+	struct cal_target_power_leg
+	calTargetPower2G[AR9287_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	calTargetPower2GHT20[AR9287_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	calTargetPower2GHT40[AR9287_NUM_2G_40_TARGET_POWERS];
+	uint8_t ctlIndex[AR9287_NUM_CTLS];
+	struct cal_ctl_data_ar9287 ctlData[AR9287_NUM_CTLS];
+	uint8_t padding;
+} __attribute__ ((packed));
+
+#endif /* EEP_9287_H */
diff --git a/tools/edump/src/eep_common.h b/tools/edump/src/eep_common.h
new file mode 100644
index 0000000..6b9dd61
--- /dev/null
+++ b/tools/edump/src/eep_common.h
@@ -0,0 +1,87 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef EEP_COMMON_H
+#define EEP_COMMON_H
+
+#if __BYTE_ORDER == __BIG_ENDIAN
+#define AR5416_EEPROM_MAGIC 0x5aa5
+#else
+#define AR5416_EEPROM_MAGIC 0xa55a
+#endif
+
+#define AR5416_EEPROM_MAGIC_OFFSET      0x0
+#define AR5416_EEP_NO_BACK_VER          0x1
+#define AR5416_EEP_VER                  0xE
+
+#define AR5416_EEPROM_S         2
+#define AR5416_EEPROM_OFFSET    0x2000
+
+#define AR_EEPROM_STATUS_DATA                    0x407c
+#define AR_EEPROM_STATUS_DATA_VAL                0x0000ffff
+#define AR_EEPROM_STATUS_DATA_VAL_S              0
+#define AR_EEPROM_STATUS_DATA_BUSY               0x00010000
+#define AR_EEPROM_STATUS_DATA_BUSY_ACCESS        0x00020000
+#define AR_EEPROM_STATUS_DATA_PROT_ACCESS        0x00040000
+#define AR_EEPROM_STATUS_DATA_ABSENT_ACCESS      0x00080000
+
+#define AR5416_OPFLAGS_11A           0x01
+#define AR5416_OPFLAGS_11G           0x02
+#define AR5416_OPFLAGS_N_5G_HT40     0x04
+#define AR5416_OPFLAGS_N_2G_HT40     0x08
+#define AR5416_OPFLAGS_N_5G_HT20     0x10
+#define AR5416_OPFLAGS_N_2G_HT20     0x20
+
+#define AR5416_EEPMISC_BIG_ENDIAN    0x01
+#define AR5416_EEP_MINOR_VER_3       0x3
+
+#define AR_EEPROM_MODAL_SPURS   5
+#define AR5416_PD_GAIN_ICEPTS   5
+
+static char *sDeviceType[] = {
+	"UNKNOWN [0] ",
+	"Cardbus     ",
+	"PCI         ",
+	"MiniPCI     ",
+	"Access Point",
+	"PCIExpress  ",
+	"UNKNOWN [6] ",
+	"UNKNOWN [7] ",
+};
+
+enum eep_map {
+	EEP_MAP_DEFAULT = 0x0,
+	EEP_MAP_4K,
+	EEP_MAP_9287,
+	EEP_MAP_MAX
+};
+
+struct cal_ctl_edges {
+	uint8_t bChannel;
+	uint8_t ctl;
+} __attribute__ ((packed));
+
+struct cal_target_power_leg {
+	uint8_t bChannel;
+	uint8_t tPow2x[4];
+} __attribute__ ((packed));
+
+struct cal_target_power_ht {
+	uint8_t bChannel;
+	uint8_t tPow2x[8];
+} __attribute__ ((packed));
+
+#endif /* EEP_COMMON_H */
diff --git a/tools/edump/src/eep_def.c b/tools/edump/src/eep_def.c
new file mode 100644
index 0000000..24026cf
--- /dev/null
+++ b/tools/edump/src/eep_def.c
@@ -0,0 +1,382 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "edump.h"
+
+static int get_eeprom_ver_def(struct edump *edump)
+{
+	return ((edump->eeprom.def.baseEepHeader.version >> 12) & 0xF);
+}
+
+static int get_eeprom_rev_def(struct edump *edump)
+{
+	return ((edump->eeprom.def.baseEepHeader.version) & 0xFFF);
+}
+
+static bool fill_eeprom_def(struct edump *edump)
+{
+#define SIZE_EEPROM_DEF (sizeof(struct ar5416_eeprom_def) / sizeof(uint16_t))
+
+	uint16_t *eep_data = (uint16_t *)&edump->eeprom.def;
+	int addr, ar5416_eep_start_loc = 0x100;
+
+	for (addr = 0; addr < SIZE_EEPROM_DEF; addr++) {
+		if (!pci_eeprom_read(edump, addr + ar5416_eep_start_loc,
+				     eep_data)) {
+			fprintf(stderr, "Unable to read eeprom region\n");
+			return false;
+		}
+		eep_data++;
+	}
+	return true;
+
+#undef SIZE_EEPROM_DEF
+}
+
+static bool check_eeprom_def(struct edump *edump)
+{
+	struct ar5416_eeprom_def *eep = (struct ar5416_eeprom_def *)&edump->eeprom.def;
+	uint16_t *eepdata, temp, magic, magic2;
+	uint32_t sum = 0, el;
+	bool need_swap = false;
+	int i, addr, size;
+
+	if (!pci_eeprom_read(edump, AR5416_EEPROM_MAGIC_OFFSET, &magic)) {
+		fprintf(stderr, "Reading Magic # failed\n");
+		return false;
+	}
+
+	if (magic != AR5416_EEPROM_MAGIC) {
+		printf("Read Magic = 0x%04X\n", magic);
+
+		magic2 = bswap_16(magic);
+
+		if (magic2 == AR5416_EEPROM_MAGIC) {
+			size = sizeof(struct ar5416_eeprom_def);
+			need_swap = true;
+			eepdata = (uint16_t *) (&edump->eeprom);
+
+			for (addr = 0; addr < size / sizeof(uint16_t); addr++) {
+				temp = bswap_16(*eepdata);
+				*eepdata = temp;
+				eepdata++;
+			}
+		} else {
+			fprintf(stderr, "Invalid EEPROM Magic, endianness mismatch\n");
+			return false;
+		}
+	}
+
+	if (need_swap)
+		el = bswap_16(edump->eeprom.def.baseEepHeader.length);
+	else
+		el = edump->eeprom.def.baseEepHeader.length;
+
+	if (el > sizeof(struct ar5416_eeprom_def))
+		el = sizeof(struct ar5416_eeprom_def) / sizeof(uint16_t);
+	else
+		el = el / sizeof(uint16_t);
+
+	eepdata = (uint16_t *)(&edump->eeprom);
+
+	for (i = 0; i < el; i++)
+		sum ^= *eepdata++;
+
+	if (need_swap) {
+		uint32_t integer, j;
+		uint16_t word;
+
+		printf("EEPROM Endianness is not native.. Changing.\n");
+
+		word = bswap_16(eep->baseEepHeader.length);
+		eep->baseEepHeader.length = word;
+
+		word = bswap_16(eep->baseEepHeader.checksum);
+		eep->baseEepHeader.checksum = word;
+
+		word = bswap_16(eep->baseEepHeader.version);
+		eep->baseEepHeader.version = word;
+
+		word = bswap_16(eep->baseEepHeader.regDmn[0]);
+		eep->baseEepHeader.regDmn[0] = word;
+
+		word = bswap_16(eep->baseEepHeader.regDmn[1]);
+		eep->baseEepHeader.regDmn[1] = word;
+
+		word = bswap_16(eep->baseEepHeader.rfSilent);
+		eep->baseEepHeader.rfSilent = word;
+
+		word = bswap_16(eep->baseEepHeader.blueToothOptions);
+		eep->baseEepHeader.blueToothOptions = word;
+
+		word = bswap_16(eep->baseEepHeader.deviceCap);
+		eep->baseEepHeader.deviceCap = word;
+
+		for (j = 0; j < ARRAY_SIZE(eep->modalHeader); j++) {
+			struct modal_eep_header *pModal = &eep->modalHeader[j];
+
+			integer = bswap_32(pModal->antCtrlCommon);
+			pModal->antCtrlCommon = integer;
+
+			for (i = 0; i < AR5416_MAX_CHAINS; i++) {
+				integer = bswap_32(pModal->antCtrlChain[i]);
+				pModal->antCtrlChain[i] = integer;
+			}
+
+			for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
+				word = bswap_16(pModal->spurChans[i].spurChan);
+				pModal->spurChans[i].spurChan = word;
+			}
+		}
+	}
+
+	if (sum != 0xffff || edump->eep_ops->get_eeprom_ver(edump) != AR5416_EEP_VER ||
+	    edump->eep_ops->get_eeprom_rev(edump) < AR5416_EEP_NO_BACK_VER) {
+		fprintf(stderr, "Bad EEPROM checksum 0x%x or revision 0x%04x\n",
+			sum, edump->eep_ops->get_eeprom_ver(edump));
+		return false;
+	}
+
+	return true;
+}
+
+static void base_eeprom_def(struct edump *edump)
+{
+	struct ar5416_eeprom_def *ar5416Eep = &edump->eeprom.def;
+	struct base_eep_header *pBase = &ar5416Eep->baseEepHeader;
+	uint16_t i;
+
+	pBase = &(ar5416Eep->baseEepHeader);
+
+	printf("\n----------------------\n");
+	printf("| EEPROM Base Header |\n");
+	printf("----------------------\n\n");
+
+	printf("%-30s : %2d\n", "Major Version",
+	       pBase->version >> 12);
+	printf("%-30s : %2d\n", "Minor Version",
+	       pBase->version & 0xFFF);
+	printf("%-30s : 0x%04X\n", "Checksum",
+	       pBase->checksum);
+	printf("%-30s : 0x%04X\n", "Length",
+	       pBase->length);
+	printf("%-30s : 0x%04X\n", "RegDomain1",
+	       pBase->regDmn[0]);
+	printf("%-30s : 0x%04X\n", "RegDomain2",
+	       pBase->regDmn[1]);
+	printf("%-30s : %02X:%02X:%02X:%02X:%02X:%02X\n",
+	       "MacAddress",
+	       pBase->macAddr[0], pBase->macAddr[1], pBase->macAddr[2],
+	       pBase->macAddr[3], pBase->macAddr[4], pBase->macAddr[5]);
+	printf("%-30s : 0x%04X\n",
+	       "TX Mask", pBase->txMask);
+	printf("%-30s : 0x%04X\n",
+	       "RX Mask", pBase->rxMask);
+	printf("%-30s : %d\n",
+	       "OpFlags(5GHz)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_11A));
+	printf("%-30s : %d\n",
+	       "OpFlags(2GHz)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_11G));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 2GHz HT20)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT20));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 2GHz HT40)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_2G_HT40));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 5Ghz HT20)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT20));
+	printf("%-30s : %d\n",
+	       "OpFlags(Disable 5Ghz HT40)",
+	       !!(pBase->opCapFlags & AR5416_OPFLAGS_N_5G_HT40));
+	printf("%-30s : %d\n",
+	       "Big Endian",
+	       !!(pBase->eepMisc & AR5416_EEPMISC_BIG_ENDIAN));
+	printf("%-30s : %d\n",
+	       "Cal Bin Major Ver",
+	       (pBase->binBuildNumber >> 24) & 0xFF);
+	printf("%-30s : %d\n",
+	       "Cal Bin Minor Ver",
+	       (pBase->binBuildNumber >> 16) & 0xFF);
+	printf("%-30s : %d\n",
+	       "Cal Bin Build",
+	       (pBase->binBuildNumber >> 8) & 0xFF);
+
+	if (edump->eep_ops->get_eeprom_rev(edump) >= AR5416_EEP_MINOR_VER_3) {
+		printf("%-30s : %s\n",
+		       "Device Type",
+		       sDeviceType[(pBase->deviceType & 0x7)]);
+	}
+
+	printf("\nCustomer Data in hex:\n");
+	for (i = 0; i < 64; i++) {
+		printf("%02X ", ar5416Eep->custData[i]);
+		if ((i % 16) == 15)
+			printf("\n");
+	}
+}
+
+static void modal_eeprom_def(struct edump *edump)
+{
+#define PR(_token, _p, _val_fmt, _val)				\
+	do {							\
+		printf("%-23s %-8s", (_token), ":");		\
+		if (pBase->opCapFlags & AR5416_OPFLAGS_11G) {	\
+			pModal = &(ar5416Eep->modalHeader[1]);	\
+			printf("%s%-6"_val_fmt, _p, (_val));	\
+		}						\
+		if (pBase->opCapFlags & AR5416_OPFLAGS_11A) {	\
+			pModal = &(ar5416Eep->modalHeader[0]);	\
+			printf("%8s%"_val_fmt"\n", _p, (_val)); \
+		} else {					\
+			printf("\n");				\
+		}						\
+	} while(0)
+
+	struct ar5416_eeprom_def *ar5416Eep = &edump->eeprom.def;
+	struct base_eep_header *pBase = &ar5416Eep->baseEepHeader;
+	struct modal_eep_header *pModal = NULL;
+
+	pBase = &(ar5416Eep->baseEepHeader);
+
+	printf("\n\n-----------------------\n");
+	printf("| EEPROM Modal Header |\n");
+	printf("-----------------------\n\n");
+
+	if (pBase->opCapFlags & AR5416_OPFLAGS_11G)
+		printf("%34s", "2G");
+	if (pBase->opCapFlags & AR5416_OPFLAGS_11A)
+		printf("%16s", "5G\n\n");
+	else
+		printf("\n\n");
+
+	PR("Ant Chain 0", "0x", "X", pModal->antCtrlChain[0]);
+	PR("Ant Chain 1", "0x", "X", pModal->antCtrlChain[1]);
+	PR("Ant Chain 2", "0x", "X", pModal->antCtrlChain[2]);
+	PR("Antenna Common", "0x", "X", pModal->antCtrlCommon);
+	PR("Antenna Gain Chain 0", "", "d", pModal->antennaGainCh[0]);
+	PR("Antenna Gain Chain 1", "", "d", pModal->antennaGainCh[1]);
+	PR("Antenna Gain Chain 2", "", "d", pModal->antennaGainCh[2]);
+	PR("Switch Settling", "", "d", pModal->switchSettling);
+	PR("TxRxAttenuation Ch 0", "", "d", pModal->txRxAttenCh[0]);
+	PR("TxRxAttenuation Ch 1", "", "d", pModal->txRxAttenCh[1]);
+	PR("TxRxAttenuation Ch 2", "", "d", pModal->txRxAttenCh[2]);
+	PR("RxTxMargin Chain 0", "", "d", pModal->rxTxMarginCh[0]);
+	PR("RxTxMargin Chain 1", "", "d", pModal->rxTxMarginCh[1]);
+	PR("RxTxMargin Chain 2", "", "d", pModal->rxTxMarginCh[2]);
+	PR("ADC Desired Size", "", "d", pModal->adcDesiredSize);
+	PR("PGA Desired Size", "", "d", pModal->pgaDesiredSize);
+	PR("TX end to xlna on", "", "d", pModal->txEndToRxOn);
+	PR("xlna gain Chain 0", "", "d", pModal->xlnaGainCh[0]);
+	PR("xlna gain Chain 1", "", "d", pModal->xlnaGainCh[1]);
+	PR("xlna gain Chain 2", "", "d", pModal->xlnaGainCh[2]);
+	PR("TX end to xpa off", "", "d", pModal->txEndToXpaOff);
+	PR("TX frame to xpa on", "", "d", pModal->txFrameToXpaOn);
+	PR("THRESH62", "", "d", pModal->thresh62);
+	PR("NF Thresh 0", "", "d", pModal->noiseFloorThreshCh[0]);
+	PR("NF Thresh 1", "", "d", pModal->noiseFloorThreshCh[1]);
+	PR("NF Thresh 2", "", "d", pModal->noiseFloorThreshCh[2]);
+	PR("Xpd Gain Mask", "0x", "X", pModal->xpdGain);
+	PR("Xpd", "", "d", pModal->xpd);
+	PR("IQ Cal I Chain 0", "", "d", pModal->iqCalICh[0]);
+	PR("IQ Cal I Chain 1", "", "d", pModal->iqCalICh[1]);
+	PR("IQ Cal I Chain 2", "", "d", pModal->iqCalICh[2]);
+	PR("IQ Cal Q Chain 0", "", "d", pModal->iqCalQCh[0]);
+	PR("IQ Cal Q Chain 1", "", "d", pModal->iqCalQCh[1]);
+	PR("IQ Cal Q Chain 2", "", "d", pModal->iqCalQCh[2]);
+	PR("Analog Output Bias(ob)", "", "d", pModal->ob);
+	PR("Analog Driver Bias(db)", "", "d", pModal->db);
+	PR("Xpa bias level", "", "d", pModal->xpaBiasLvl);
+	PR("Xpa bias level Freq 0", "", "d", pModal->xpaBiasLvlFreq[0]);
+	PR("Xpa bias level Freq 1", "", "d", pModal->xpaBiasLvlFreq[1]);
+	PR("Xpa bias level Freq 2", "", "d", pModal->xpaBiasLvlFreq[2]);
+	PR("LNA Control", "0x", "X", pModal->lna_ctl);
+
+	printf("%-23s %-7s", "pdGain Overlap (dB)", ":");
+	if (pBase->opCapFlags & AR5416_OPFLAGS_11G) {
+		pModal = &(ar5416Eep->modalHeader[1]);
+		printf("%2d.%-6d", pModal->pdGainOverlap / 2,
+		       (pModal->pdGainOverlap % 2) * 5);
+	}
+	if (pBase->opCapFlags & AR5416_OPFLAGS_11A) {
+		pModal = &(ar5416Eep->modalHeader[0]);
+		printf("%7d.%d\n", pModal->pdGainOverlap / 2,
+		       (pModal->pdGainOverlap % 2) * 5);
+	} else {
+		printf("\n");
+	}
+
+	printf("%-23s %-7s", "PWR dec 2 chain", ":");
+	if (pBase->opCapFlags & AR5416_OPFLAGS_11G) {
+		pModal = &(ar5416Eep->modalHeader[1]);
+		printf("%2d.%-6d", pModal->pwrDecreaseFor2Chain / 2,
+		       (pModal->pwrDecreaseFor2Chain % 2) * 5);
+	}
+	if (pBase->opCapFlags & AR5416_OPFLAGS_11A) {
+		pModal = &(ar5416Eep->modalHeader[0]);
+		printf("%7d.%d\n", pModal->pwrDecreaseFor2Chain / 2,
+		       (pModal->pwrDecreaseFor2Chain % 2) * 5);
+	} else {
+		printf("\n");
+	}
+
+	printf("%-23s %-7s", "PWR dec 3 chain", ":");
+	if (pBase->opCapFlags & AR5416_OPFLAGS_11G) {
+		pModal = &(ar5416Eep->modalHeader[1]);
+		printf("%2d.%-6d", pModal->pwrDecreaseFor3Chain / 2,
+		       (pModal->pwrDecreaseFor3Chain % 2) * 5);
+	}
+	if (pBase->opCapFlags & AR5416_OPFLAGS_11A) {
+		pModal = &(ar5416Eep->modalHeader[0]);
+		printf("%7d.%d\n", pModal->pwrDecreaseFor3Chain / 2,
+		       (pModal->pwrDecreaseFor3Chain % 2) * 5);
+	} else {
+		printf("\n");
+	}
+
+	if (AR_SREV_9280_20_OR_LATER(edump)) {
+		PR("xatten2Db Chain 0", "", "d", pModal->xatten2Db[0]);
+		PR("xatten2Db Chain 1", "", "d", pModal->xatten2Db[1]);
+		PR("xatten2Margin Chain 0", "", "d", pModal->xatten2Margin[0]);
+		PR("xatten2Margin Chain 1", "", "d", pModal->xatten2Margin[1]);
+		PR("ob_ch1", "", "d", pModal->ob_ch1);
+		PR("db_ch1", "", "d", pModal->db_ch1);
+	}
+
+	if (edump->eep_ops->get_eeprom_rev(edump) >= AR5416_EEP_MINOR_VER_3) {
+		PR("txFrameToDataStart", "", "d", pModal->txFrameToDataStart);
+		PR("txFrameToPaOn", "", "d", pModal->txFrameToPaOn);
+		PR("HT40PowerIncForPDADC", "", "d", pModal->ht40PowerIncForPdadc);
+		PR("bswAtten Chain 0", "", "d", pModal->bswAtten[0]);
+	}
+
+#undef PR
+}
+
+static void power_info_eeprom_def(struct edump *edump)
+{
+}
+
+struct eeprom_ops eep_def_ops = {
+	.fill_eeprom  = fill_eeprom_def,
+	.check_eeprom = check_eeprom_def,
+	.get_eeprom_ver = get_eeprom_ver_def,
+	.get_eeprom_rev = get_eeprom_rev_def,
+	.dump_base_header = base_eeprom_def,
+	.dump_modal_header = modal_eeprom_def,
+	.dump_power_info = power_info_eeprom_def,
+};
diff --git a/tools/edump/src/eep_def.h b/tools/edump/src/eep_def.h
new file mode 100644
index 0000000..e078fb6
--- /dev/null
+++ b/tools/edump/src/eep_def.h
@@ -0,0 +1,148 @@
+/*
+ * Copyright (c) 2012 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef EEP_DEF_H
+#define EEP_DEF_H
+
+#define AR5416_MAX_CHAINS       3
+#define AR5416_NUM_PD_GAINS     4
+#define AR5416_NUM_BAND_EDGES   8
+#define AR5416_NUM_5G_CAL_PIERS 8
+#define AR5416_NUM_2G_CAL_PIERS 4
+#define AR5416_NUM_CTLS         24
+#define AR5416_NUM_5G_20_TARGET_POWERS  8
+#define AR5416_NUM_5G_40_TARGET_POWERS  8
+#define AR5416_NUM_2G_CCK_TARGET_POWERS 3
+#define AR5416_NUM_2G_20_TARGET_POWERS  4
+#define AR5416_NUM_2G_40_TARGET_POWERS  4
+
+struct base_eep_header {
+	uint16_t length;
+	uint16_t checksum;
+	uint16_t version;
+	uint8_t opCapFlags;
+	uint8_t eepMisc;
+	uint16_t regDmn[2];
+	uint8_t macAddr[6];
+	uint8_t rxMask;
+	uint8_t txMask;
+	uint16_t rfSilent;
+	uint16_t blueToothOptions;
+	uint16_t deviceCap;
+	uint32_t binBuildNumber;
+	uint8_t deviceType;
+	uint8_t pwdclkind;
+	uint8_t futureBase_1[2];
+	uint8_t rxGainType;
+	uint8_t dacHiPwrMode_5G;
+	uint8_t openLoopPwrCntl;
+	uint8_t dacLpMode;
+	uint8_t txGainType;
+	uint8_t rcChainMask;
+	uint8_t desiredScaleCCK;
+	uint8_t power_table_offset;
+	uint8_t frac_n_5g;
+	uint8_t futureBase_3[21];
+} __attribute__ ((packed));
+
+struct spur_chan {
+	uint16_t spurChan;
+	uint8_t spurRangeLow;
+	uint8_t spurRangeHigh;
+} __attribute__ ((packed));
+
+struct modal_eep_header {
+	uint32_t antCtrlChain[AR5416_MAX_CHAINS];
+	uint32_t antCtrlCommon;
+	uint8_t antennaGainCh[AR5416_MAX_CHAINS];
+	uint8_t switchSettling;
+	uint8_t txRxAttenCh[AR5416_MAX_CHAINS];
+	uint8_t rxTxMarginCh[AR5416_MAX_CHAINS];
+	uint8_t adcDesiredSize;
+	uint8_t pgaDesiredSize;
+	uint8_t xlnaGainCh[AR5416_MAX_CHAINS];
+	uint8_t txEndToXpaOff;
+	uint8_t txEndToRxOn;
+	uint8_t txFrameToXpaOn;
+	uint8_t thresh62;
+	uint8_t noiseFloorThreshCh[AR5416_MAX_CHAINS];
+	uint8_t xpdGain;
+	uint8_t xpd;
+	uint8_t iqCalICh[AR5416_MAX_CHAINS];
+	uint8_t iqCalQCh[AR5416_MAX_CHAINS];
+	uint8_t pdGainOverlap;
+	uint8_t ob;
+	uint8_t db;
+	uint8_t xpaBiasLvl;
+	uint8_t pwrDecreaseFor2Chain;
+	uint8_t pwrDecreaseFor3Chain;
+	uint8_t txFrameToDataStart;
+	uint8_t txFrameToPaOn;
+	uint8_t ht40PowerIncForPdadc;
+	uint8_t bswAtten[AR5416_MAX_CHAINS];
+	uint8_t bswMargin[AR5416_MAX_CHAINS];
+	uint8_t swSettleHt40;
+	uint8_t xatten2Db[AR5416_MAX_CHAINS];
+	uint8_t xatten2Margin[AR5416_MAX_CHAINS];
+	uint8_t ob_ch1;
+	uint8_t db_ch1;
+	uint8_t lna_ctl;
+	uint8_t miscBits;
+	uint16_t xpaBiasLvlFreq[3];
+	uint8_t futureModal[6];
+	struct spur_chan spurChans[AR_EEPROM_MODAL_SPURS];
+} __attribute__ ((packed));
+
+struct cal_data_per_freq {
+	uint8_t pwrPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+	uint8_t vpdPdg[AR5416_NUM_PD_GAINS][AR5416_PD_GAIN_ICEPTS];
+} __attribute__ ((packed));
+
+struct cal_ctl_data {
+	struct cal_ctl_edges
+	ctlEdges[AR5416_MAX_CHAINS][AR5416_NUM_BAND_EDGES];
+} __attribute__ ((packed));
+
+struct ar5416_eeprom_def {
+	struct base_eep_header baseEepHeader;
+	uint8_t custData[64];
+	struct modal_eep_header modalHeader[2];
+	uint8_t calFreqPier5G[AR5416_NUM_5G_CAL_PIERS];
+	uint8_t calFreqPier2G[AR5416_NUM_2G_CAL_PIERS];
+	struct cal_data_per_freq
+	 calPierData5G[AR5416_MAX_CHAINS][AR5416_NUM_5G_CAL_PIERS];
+	struct cal_data_per_freq
+	 calPierData2G[AR5416_MAX_CHAINS][AR5416_NUM_2G_CAL_PIERS];
+	struct cal_target_power_leg
+	 calTargetPower5G[AR5416_NUM_5G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower5GHT20[AR5416_NUM_5G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower5GHT40[AR5416_NUM_5G_40_TARGET_POWERS];
+	struct cal_target_power_leg
+	 calTargetPowerCck[AR5416_NUM_2G_CCK_TARGET_POWERS];
+	struct cal_target_power_leg
+	 calTargetPower2G[AR5416_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower2GHT20[AR5416_NUM_2G_20_TARGET_POWERS];
+	struct cal_target_power_ht
+	 calTargetPower2GHT40[AR5416_NUM_2G_40_TARGET_POWERS];
+	uint8_t ctlIndex[AR5416_NUM_CTLS];
+	struct cal_ctl_data ctlData[AR5416_NUM_CTLS];
+	uint8_t padding;
+} __attribute__ ((packed));
+
+#endif /* EEP_DEF_H */
-- 
1.7.11.2

