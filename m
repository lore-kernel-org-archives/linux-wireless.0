Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 16.mo1.mail-out.ovh.net ([178.33.104.224]:42165 "EHLO
	16.mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbbAVURs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:17:48 -0500
Received: from mail434.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id 31E7EFFA041
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 16:30:53 +0100 (CET)
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
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] NFC: nxp-nci: Add support for NXP-NCI NFC controllers
Date: Thu, 22 Jan 2015 16:27:36 +0100
Message-Id: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com> (sfid-20150122_211753_356800_DB063FBE)
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

The submission is broken into four patches:
 - The first one adds firmware download support to NCI ;
 - The second one adds the NXP-NCI driver's core ;
 - The third one adds I2C support to the driver ;
 - The fourth one allows for module removal during download.

It is based on 767dec21d7f5a9787401ff44568852cb3782de64 (Merge tag
'nfc-next-3.19-1' of nfc-next into wireless-next) from the nfc-next master
branch.

Clément Perrochaud (4):
  NFC: nci: Add FWDL support
  NFC: nxp-nci: Add support for NXP NCI chips
  NFC: nxp-nci_i2c: Add I2C support to NXP NCI driver
  NFC: nxp-nci: Allow module removal during download

 .../devicetree/bindings/net/nfc/nxp-nci.txt        |  35 ++
 MAINTAINERS                                        |   9 +-
 drivers/nfc/Kconfig                                |   2 +
 drivers/nfc/Makefile                               |   1 +
 drivers/nfc/nxp-nci/Kconfig                        |  24 ++
 drivers/nfc/nxp-nci/Makefile                       |  11 +
 drivers/nfc/nxp-nci/core.c                         | 186 ++++++++
 drivers/nfc/nxp-nci/firmware.c                     | 324 ++++++++++++++
 drivers/nfc/nxp-nci/i2c.c                          | 468 +++++++++++++++++++++
 drivers/nfc/nxp-nci/nxp-nci.h                      |  91 ++++
 include/linux/platform_data/nxp-nci.h              |  27 ++
 include/net/nfc/nci_core.h                         |   1 +
 net/nfc/nci/core.c                                 |  11 +
 13 files changed, 1189 insertions(+), 1 deletion(-)
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

