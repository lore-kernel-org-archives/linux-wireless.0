Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa06-05.prod.phx3.secureserver.net ([173.201.192.106]:56002
	"EHLO p3plsmtpa06-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932313AbaAaWR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 17:17:27 -0500
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org,
	"Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 0/3] NFC: trf7970a: Add driver with NFC Type 2 and Type V Support
Date: Fri, 31 Jan 2014 15:17:08 -0700
Message-Id: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com> (sfid-20140131_231731_247168_4C4F85EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a driver for the TI TRF7970A RFID/NFC/15693 Transceiver.
The driver was started by Erick Macias and Felipe Balbi but has
been changed significantly by me.  Because of that, Felipe has
allowed me to replace his name by mine in the MODULE_AUTHOR()
line.

The trf7970a has a low-level interface so it requires the NFC
digital layer.

It has been tested on a couple different consumer Type 2 tags
and 3 different types of TI Tag-it HF-I tags.  It seems stable
but the device often reports a CRC or collision error when moving
a tag into the RF field while actively polling.  That means that
an EIO error will be reported and you'll have to retry the poll
in order to communicate with the tag.

The driver is broken into two patches: one for the majority of
the driver which includes 14443 Type 2 (MIFARE Ultralight and
Ultralight C) tags and another for 15693 Type V support.  The
third patch adds DTS documentation.

Mark A. Greer (3):
  NFC: trf7970a: Add driver with ISO/IEC 14443 Type 2 Tag Support
  NFC: trf7970a: Add ISO/IEC 15693 Support
  NFC: trf7970a: Add DTS Documentation

 .../devicetree/bindings/net/nfc/trf7970a.txt       |   37 +
 drivers/nfc/Kconfig                                |   12 +
 drivers/nfc/Makefile                               |    1 +
 drivers/nfc/trf7970a.c                             | 1338 ++++++++++++++++++++
 4 files changed, 1388 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt
 create mode 100644 drivers/nfc/trf7970a.c

-- 
1.8.3.4

