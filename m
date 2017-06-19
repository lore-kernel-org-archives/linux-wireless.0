Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:36871 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753975AbdFSKJR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 06:09:17 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 00/13] NFC: clean up for ACPI GPIO usage
Date: Mon, 19 Jun 2017 13:08:45 +0300
Message-Id: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com> (sfid-20170619_120945_488071_FE298D38)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This clean up series to NFC drivers that are using GPIOs on ACPI enabled
platforms. Since GPIO ACPI library goes stricter about requesting
resources we need to amend drivers for that. Here we are for NFC
subsystem.

While doing above, get rid of legacy and unused platform data as well as
some artificial IDs.

Changelog v3:
- incorporate Samuel's fixes
- fix the bug kbuild bot complains about
- add MAINTAINERS patch

Changelog v2:
- add patches 1,4-12

Andy Shevchenko (13):
  NFC: pn544: Switch to devm_acpi_dev_add_driver_gpios()
  NFC: st21nfca: Add GPIO ACPI mapping table
  NFC: st21nfca: Get rid of code duplication in ->probe()
  NFC: fdp: Convert I2C driver to ->probe_new()
  NFC: fdp: Convert to use devres API
  NFC: fdp: Add GPIO ACPI mapping table
  NFC: st-nci: Get rid of platform data
  NFC: st-nci: Get rid of "interesting" use of interrupt polarity
  NFC: st-nci: Covert to use GPIO descriptor
  NFC: st-nci: Use unified device properties API meaningfully
  NFC: st-nci: Add GPIO ACPI mapping table
  NFC: st-nci: Get rid of code duplication in ->probe()
  MAINTAINERS: Remove non-existing NFC platform data files

 MAINTAINERS                          |   3 -
 drivers/nfc/fdp/fdp.c                |  15 +---
 drivers/nfc/fdp/i2c.c                |  38 ++++----
 drivers/nfc/pn544/i2c.c              |   3 +-
 drivers/nfc/st-nci/i2c.c             | 164 ++++++-----------------------------
 drivers/nfc/st-nci/spi.c             | 162 ++++++----------------------------
 drivers/nfc/st21nfca/i2c.c           |  62 ++++---------
 include/linux/platform_data/st-nci.h |  31 -------
 8 files changed, 90 insertions(+), 388 deletions(-)
 delete mode 100644 include/linux/platform_data/st-nci.h

-- 
2.11.0
