Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 1.mo6.mail-out.ovh.net ([46.105.56.136]:41809 "EHLO
	1.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbbCIKej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 06:34:39 -0400
Received: from mail187.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo6.mail-out.ovh.net (Postfix) with SMTP id 7459DFFA1C0
	for <linux-wireless@vger.kernel.org>; Mon,  9 Mar 2015 11:16:06 +0100 (CET)
From: clement.perrochaud@effinnov.com
To: linux-nfc@lists.01.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20Perrochaud?=
	<clement.perrochaud@effinnov.com>, sunil.jogi@nxp.com,
	jerome.pele@nxp.com, Charles.Gorand-Effinnov@nxp.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, robh+dt@kernel.org, pawel.moll@arm.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, davem@davemloft.net, grant.likely@linaro.org,
	clement.perrochaud@nxp.com, lefrique@marvell.com,
	christophe.ricard@gmail.com, cuissard@marvell.com,
	bzhao@marvell.com, hirent@marvell.com, akarwar@marvell.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	anda-maria.nicolae@intel.com
Subject: [PATCH v2 0/3] NFC: nxp-nci: Add support for NXP-NCI NFC controllers
Date: Mon,  9 Mar 2015 11:12:02 +0100
Message-Id: <1425895925-20593-1-git-send-email-clement.perrochaud@effinnov.com> (sfid-20150309_113444_011466_62F7ED4C)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Clément Perrochaud <clement.perrochaud@effinnov.com>

This patch brings support for the NXP-NCI NFC controllers family.

It has been successfully tested on the following SoC boards:
 - BeagleBone
 - BeagleBone Black
 - Raspberry Pi B
 - Raspberry Pi B+

The submission is broken into three patches:
 - The first one adds firmware download support to NCI ;
 - The second one adds the NXP-NCI driver's core ;
 - The third one adds I2C support to the driver.

It is based on fa00e8fed457841cb24219dbe3cfba7d56de6317 (NFC: nci: Move NFCEE
discovery logic) from the nfc-next master branch.

Clément Perrochaud (3):
  NFC: nci: Add firmware download support
  NFC: nxp-nci: Add support for NXP NCI chips
  NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver

 .../devicetree/bindings/net/nfc/nxp-nci.txt        |  35 ++
 MAINTAINERS                                        |   7 +
 drivers/nfc/Kconfig                                |   1 +
 drivers/nfc/Makefile                               |   1 +
 drivers/nfc/nxp-nci/Kconfig                        |  25 ++
 drivers/nfc/nxp-nci/Makefile                       |  11 +
 drivers/nfc/nxp-nci/core.c                         | 186 +++++++++
 drivers/nfc/nxp-nci/firmware.c                     | 324 ++++++++++++++++
 drivers/nfc/nxp-nci/i2c.c                          | 415 +++++++++++++++++++++
 drivers/nfc/nxp-nci/nxp-nci.h                      |  89 +++++
 include/linux/platform_data/nxp-nci.h              |  27 ++
 include/net/nfc/nci_core.h                         |   1 +
 net/nfc/nci/core.c                                 |  11 +
 13 files changed, 1133 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp-nci.txt
 create mode 100644 drivers/nfc/nxp-nci/Kconfig
 create mode 100644 drivers/nfc/nxp-nci/Makefile
 create mode 100644 drivers/nfc/nxp-nci/core.c
 create mode 100644 drivers/nfc/nxp-nci/firmware.c
 create mode 100644 drivers/nfc/nxp-nci/i2c.c
 create mode 100644 drivers/nfc/nxp-nci/nxp-nci.h
 create mode 100644 include/linux/platform_data/nxp-nci.h

-- 
Clément Perrochaud

Eff'Innov Technologies
Caen, Aix-En-Provence, Grenoble

Eff'Innov Technologies
Campus EffiScience
2, Esplanade Anton Philips
14460 Colombelles, FRANCE

http://www.effinnov.com

