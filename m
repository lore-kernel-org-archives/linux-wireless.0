Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D2FC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1514C214C5
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1514C214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbeIZQhr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:37:47 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39495 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbeIZQhr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:47 -0400
X-IronPort-AV: E=Sophos;i="5.54,306,1534834800"; 
   d="scan'208";a="21366756"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 26 Sep 2018 03:25:31 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 CHN-SV-EXCH01.mchp-main.com (10.10.76.37) with Microsoft SMTP Server id
 14.3.352.0; Wed, 26 Sep 2018 03:25:30 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RFC 00/19] wilc: added driver for wilc module
Date:   Wed, 26 Sep 2018 15:55:06 +0530
Message-ID: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch set contains the driver files from 'driver/staging/wilc1000'.
Renamed the driver from 'wilc1000' to 'wilc' to have generic name, as
the same driver will be used by other wilc family members.

The patch series is based on 'wireless-driver-next'.

This driver will add support for SDIO/SPI interface for wilc family.
For now only wilc1000 module support has been intergrated in this driver.


Ajay Singh (19):
  wilc: add coreconfigurator.h
  wilc: add coreconfigurator.c
  wilc: add host_interface.h
  wilc: add host_interface.c
  wilc: add wilc_wlan_if.h
  wilc: add wilc_wlan_cfg.h
  wilc: add wilc_wlan_cfg.c
  wilc: add wilc_wlan.h
  wilc: add wilc_wlan.c
  wilc: add wilc_wfi_netdevice.h
  wilc: add wilc_wfi_cfgoperations.h
  wilc: add wilc_wfi_cfgoperations.c
  wilc: add linux_wlan.c
  wilc: add linux_mon.c
  wilc: add wilc_spi.c
  wilc: add wilc_sdio.c
  wilc: updated DT device binding for wilc device
  wilc: add Makefile and Kconfig files for  wilc compilation
  wilc: added wilc module compilation in wireless Makefile & Kconfig

 .../net/wireless/microchip,wilc1000,sdio.txt       |   32 +
 .../net/wireless/microchip,wilc1000,spi.txt        |   26 +
 drivers/net/wireless/Kconfig                       |    1 +
 drivers/net/wireless/Makefile                      |    1 +
 drivers/net/wireless/microchip/Kconfig             |   14 +
 drivers/net/wireless/microchip/Makefile            |    1 +
 drivers/net/wireless/microchip/wilc/Kconfig        |   42 +
 drivers/net/wireless/microchip/wilc/Makefile       |   15 +
 .../net/wireless/microchip/wilc/coreconfigurator.c |  287 ++
 .../net/wireless/microchip/wilc/coreconfigurator.h |   81 +
 .../net/wireless/microchip/wilc/host_interface.c   | 3927 ++++++++++++++++++++
 .../net/wireless/microchip/wilc/host_interface.h   |  362 ++
 drivers/net/wireless/microchip/wilc/linux_mon.c    |  273 ++
 drivers/net/wireless/microchip/wilc/linux_wlan.c   | 1161 ++++++
 drivers/net/wireless/microchip/wilc/wilc_sdio.c    | 1124 ++++++
 drivers/net/wireless/microchip/wilc/wilc_spi.c     | 1137 ++++++
 .../microchip/wilc/wilc_wfi_cfgoperations.c        | 2216 +++++++++++
 .../microchip/wilc/wilc_wfi_cfgoperations.h        |   23 +
 .../wireless/microchip/wilc/wilc_wfi_netdevice.h   |  230 ++
 drivers/net/wireless/microchip/wilc/wilc_wlan.c    | 1350 +++++++
 drivers/net/wireless/microchip/wilc/wilc_wlan.h    |  297 ++
 .../net/wireless/microchip/wilc/wilc_wlan_cfg.c    |  497 +++
 .../net/wireless/microchip/wilc/wilc_wlan_cfg.h    |   54 +
 drivers/net/wireless/microchip/wilc/wilc_wlan_if.h |  830 +++++
 drivers/staging/wilc1000/wilc_sdio.c               |    4 +-
 25 files changed, 13983 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,sdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/microchip,wilc1000,spi.txt
 create mode 100644 drivers/net/wireless/microchip/Kconfig
 create mode 100644 drivers/net/wireless/microchip/Makefile
 create mode 100644 drivers/net/wireless/microchip/wilc/Kconfig
 create mode 100644 drivers/net/wireless/microchip/wilc/Makefile
 create mode 100644 drivers/net/wireless/microchip/wilc/coreconfigurator.c
 create mode 100644 drivers/net/wireless/microchip/wilc/coreconfigurator.h
 create mode 100644 drivers/net/wireless/microchip/wilc/host_interface.c
 create mode 100644 drivers/net/wireless/microchip/wilc/host_interface.h
 create mode 100644 drivers/net/wireless/microchip/wilc/linux_mon.c
 create mode 100644 drivers/net/wireless/microchip/wilc/linux_wlan.c
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_sdio.c
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_spi.c
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wfi_cfgoperations.c
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wfi_cfgoperations.h
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wfi_netdevice.h
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wlan.c
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wlan.h
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wlan_cfg.c
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wlan_cfg.h
 create mode 100644 drivers/net/wireless/microchip/wilc/wilc_wlan_if.h

-- 
2.7.4

