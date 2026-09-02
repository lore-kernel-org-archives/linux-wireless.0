Received: from smtp9.infineon.com (smtp9.infineon.com [217.10.52.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A38344D88
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367959; cv=none; b=WYa89GvtZQWci5pTarMMvD0odPRObz2FnJ5GWhzAJhAISMZhXRsfgThdcQOJSIgWsN7UPUKAPqf2H9JabUSWludvh+ClU07lyQNo5YyzCeqeR6/ATFJmxR8D5XVXn+280hOwyZrJOHayJM+pMcsMDu0Y/xYrRZxClJ/w4CRJ6OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367959; c=relaxed/simple;
	bh=74R6rEfSh4fdAVwfHAjNjLtXIb9OAl0qvHJKppyixns=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NRMsOLuBzbj5gFqZCqlhws/Jn031n5kTmtCygmXJQ0HgXzqeM2OlPMhk4OIulcMD4Z44kTM7mvkliSeQyQBdujon06Atlz21RqN0LaJTXz0+LpV2Nsk33+w9VSJ34pFMoro2oh4CYk+uZXCOm0ryasnwi0XmVlT4c4d+tx/XjJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=OmYMrr4D; arc=none smtp.client-ip=217.10.52.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="OmYMrr4D"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788367957; x=1819903957;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=74R6rEfSh4fdAVwfHAjNjLtXIb9OAl0qvHJKppyixns=;
  b=OmYMrr4DOPaZqzrFsBD7flRd9I07paMCrsH/fLCupx9I4C5Qu8mU6w+Z
   aQyKzIuGnLLaeo8dgN/zWHafjlB3T69BKe7LWsqMRY4PJyh+DocbdeEAN
   xpkYTKssEFIqkdtTnt+JUL1b3qIVp8XnEYDEDALSVv1VnPIuCFxATLWOb
   I=;
X-CSE-ConnectionGUID: BrcB8R7cSk25wIJ2PzvfcQ==
X-CSE-MsgGUID: MCUip/wETBmsq4rmegWr7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="107705676"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="107705676"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp9.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:51:25 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:51:24 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:51:22 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 00/25] wifi: inffmac: introducing a driver for Infineon's new generation chipsets
Date: Wed, 2 Sep 2026 16:50:31 +0000
Message-ID: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE806.infineon.com (172.23.29.32) To
 MUCSE827.infineon.com (172.23.29.20)

Infineon(Cypress) is introducing a new INFFMAC (WLAN FULLMAC) Linux
driver specifically for its new-generation AIROC family of Wi-Fi
Connectivity Processor (CP) chipsets (CYW5591x), the new Wi-Fi 7
(802.11be) capable chipset (ACW74xx), and also for all future chipsets.

The CYW5591x family is an AIROC Wi-Fi Connectivity Processor (CP) that
integrates a 1x1 20MHz tri-band (2.4/5/6GHz) Wi-Fi 6/6E (802.11ax) radio,
interfaced to the host over SDIO 3.0 or gSPI. Its device firmware is held
in an external QSPI flash, and as part of the secure firmware-download
sequence, the device goes through a boot firmware download, a RAM-boot
handshake, followed by a CP firmware image download and validation into
the non-volatile (flash) memory.

The ACW74xx (ACW741x) family is an ultra-low-power, single-chip tri-radio
combo that integrates a 1x1 20MHz tri-band (2.4/5/6GHz) Wi-Fi 7 (802.11be)
radio together with BLE and IEEE 802.15.4 subsystems, interfaced to the host
over SDIO 3.0 or gSPI. It is a 20MHz Wi-Fi 7 device made for IoT, which
supports MLSR for MLO and r-TWT for low-power always-connected use cases.

Infineon's full list of Wireless Connectivity product briefs and datasheets
are available in https://www.infineon.com/products/wireless-connectivity

These Infineon chipsets are tailor-made for a wide variety of IoT use cases
and provide support for multiple host BUS interfaces (eventually PCIe, gSPI,
SPI, I2C, USB, and UART support will be added in future contributions).
In addition, these new chipsets support IoT mode of operations that require
an Infineon-proprietary secured Device firmware architecture. By default,
this driver expects the device firmware/image/NVRAM/CLM_BLOB files in the
filesystem path /lib/firmware/infineon/ with the file name prefix "inffmac*",
for example: inffmac7413-sdio.trx.

Based on the review comments received in earlier submissions, the driver
size has been reduced even further in this revision. Compared to V2,
this V3 series only retains the minimal codebase needed to bring up the
device, download the firmware to the device's non-volatile/volatile
memories, perform a basic Wi-Fi scan, and do a runtime device firmware
update, so that the core architecture can be reviewed more easily before
more functionality is added incrementally in future contributions. Many
features and their associated files that were still present in V2 have
also been removed to minimize the driver footprint for code review.

More information on this driver is available in the V1 [1] and V2 [2]
cover letters.

Changes in v3:
- Reduced the driver to only the basic Wi-Fi scan functionality, keeping
  just enough code for device bring-up and firmware download.

- Added support for the new Wi-Fi 7 (802.11be) capable ACW74xx chipset.

- Skipped the CYW5557x, CYW5551x and CYW43022 chipsets, and inffmac support
  to be added later in followup patches.

- Dropped the PCIe/MSGBUF bus path, so this revision supports only the SDIO
  bus; PCIe support will be added later.

- Removed additional features and files that were still present in V2
  to further minimize the codebase for review.

- Reduced the series from 34 to 25 patches.

Changes in v2:
 - Improved support for Infineon's new type of WLAN chipsets having the
   Connectivity Processor (CP) architecture which provides wireless
   connectivity along with a host network offload. The driver communicates
   with various components (like, CP, WLAN FW) inside these devices using
   the ICDC protocol over the SDIO BUS.

 - Fully refactored the interface management functionality and added the
   Dynamic vif creation, deletion support.

 - Separated out the P2P functionality from the Management Frame TX
   functionality.

 - Improved the Device Firmware Update (DFU) support to update the Firmware
   over SDIO in Device FLASH Memory or PSRAM during runtime.

 - Started utilizing wiphy locking, wiphy work and wiphy delayed work
   scheduling infrastructure provided by cfg80211 for the WLAN Drivers.

 - Cleaned up multiple source and header files.

 - Skipped support for WLAN Sensing, XDP, Packet offloads now, to be added
   later in a separate patch with a dedicated review, as suggested in v1.

 - Also skipped the support for BT Coexistence, Shared SDIO for BT, PNO,
   Debug Logger, most of the module params, etc now to shrink the driver
   size in this version to help with the review.

[1] https://lore.kernel.org/linux-wireless/20250916221821.4387-1-gokulkumar.sivakumar@infineon.com/
[2] https://lore.kernel.org/linux-wireless/20260113203350.16734-1-gokulkumar.sivakumar@infineon.com/

Gokul Sivakumar (25):
  wifi: inffmac: add a new driver directory for infineon WLAN vendor
  wifi: inffmac: add firmware.c/h
  wifi: inffmac: add dfu.c/h
  wifi: inffmac: add trxhdr.h
  wifi: inffmac: add chip.c/h
  wifi: inffmac: add chip_{cyw5591x/acw74xx}.c/h
  wifi: inffmac: add icdc.c/h
  wifi: inffmac: add main.c/h
  wifi: inffmac: add dev_cmd.c/h
  wifi: inffmac: add dev_evt.c/h
  wifi: inffmac: add net.c/h
  wifi: inffmac: add cfg80211.c/h
  wifi: inffmac: add interface.c/h
  wifi: inffmac: add he.c/h
  wifi: inffmac: add feature.c/h
  wifi: inffmac: add bus_proto.c/h
  wifi: inffmac: add sdio.c/h
  wifi: inffmac: add fwsignal.c/h
  wifi: inffmac: add bcdc.c/h
  wifi: inffmac: add ie.c/h
  wifi: inffmac: add scan.c/h
  wifi: inffmac: add chan.c/h
  wifi: inffmac: add debug.c/h
  wifi: inffmac: add utils.c/h
  wifi: inffmac: add Kconfig, Makefile

 drivers/net/wireless/Kconfig                  |    1 +
 drivers/net/wireless/Makefile                 |    1 +
 drivers/net/wireless/infineon/Kconfig         |   25 +
 drivers/net/wireless/infineon/Makefile        |   12 +
 drivers/net/wireless/infineon/inffmac/Kconfig |   13 +
 .../net/wireless/infineon/inffmac/Makefile    |   36 +
 drivers/net/wireless/infineon/inffmac/bcdc.c  |  516 ++
 drivers/net/wireless/infineon/inffmac/bcdc.h  |   29 +
 .../net/wireless/infineon/inffmac/bus_proto.c |  162 +
 .../net/wireless/infineon/inffmac/bus_proto.h |  436 +
 .../net/wireless/infineon/inffmac/cfg80211.c  | 1418 +++
 .../net/wireless/infineon/inffmac/cfg80211.h  |  309 +
 drivers/net/wireless/infineon/inffmac/chan.c  |  795 ++
 drivers/net/wireless/infineon/inffmac/chan.h  |  365 +
 drivers/net/wireless/infineon/inffmac/chip.c  | 1483 ++++
 drivers/net/wireless/infineon/inffmac/chip.h  |  644 ++
 .../wireless/infineon/inffmac/chip_acw74xx.c  |   35 +
 .../wireless/infineon/inffmac/chip_acw74xx.h  |   19 +
 .../wireless/infineon/inffmac/chip_cyw5591x.c |   33 +
 .../wireless/infineon/inffmac/chip_cyw5591x.h |   37 +
 drivers/net/wireless/infineon/inffmac/debug.c |   59 +
 drivers/net/wireless/infineon/inffmac/debug.h |  161 +
 .../net/wireless/infineon/inffmac/dev_cmd.c   |  653 ++
 .../net/wireless/infineon/inffmac/dev_cmd.h   |  969 +++
 .../net/wireless/infineon/inffmac/dev_evt.c   |  847 ++
 .../net/wireless/infineon/inffmac/dev_evt.h   |  447 +
 drivers/net/wireless/infineon/inffmac/dfu.c   | 1084 +++
 drivers/net/wireless/infineon/inffmac/dfu.h   |  124 +
 .../net/wireless/infineon/inffmac/feature.c   |  264 +
 .../net/wireless/infineon/inffmac/feature.h   |  121 +
 .../net/wireless/infineon/inffmac/firmware.c  |  968 +++
 .../net/wireless/infineon/inffmac/firmware.h  |  100 +
 .../net/wireless/infineon/inffmac/fwsignal.c  | 3017 +++++++
 .../net/wireless/infineon/inffmac/fwsignal.h  |   53 +
 drivers/net/wireless/infineon/inffmac/he.c    |  112 +
 drivers/net/wireless/infineon/inffmac/he.h    |   27 +
 drivers/net/wireless/infineon/inffmac/icdc.c  |  346 +
 drivers/net/wireless/infineon/inffmac/icdc.h  |   29 +
 drivers/net/wireless/infineon/inffmac/ie.c    |  656 ++
 drivers/net/wireless/infineon/inffmac/ie.h    |  170 +
 .../net/wireless/infineon/inffmac/interface.c |  496 ++
 .../net/wireless/infineon/inffmac/interface.h |  155 +
 drivers/net/wireless/infineon/inffmac/main.c  |  821 ++
 drivers/net/wireless/infineon/inffmac/main.h  |  314 +
 drivers/net/wireless/infineon/inffmac/net.c   |  500 ++
 drivers/net/wireless/infineon/inffmac/net.h   |   43 +
 drivers/net/wireless/infineon/inffmac/scan.c  |  800 ++
 drivers/net/wireless/infineon/inffmac/scan.h  |  136 +
 drivers/net/wireless/infineon/inffmac/sdio.c  | 7585 +++++++++++++++++
 drivers/net/wireless/infineon/inffmac/sdio.h  |  234 +
 .../net/wireless/infineon/inffmac/trxhdr.h    |   54 +
 drivers/net/wireless/infineon/inffmac/utils.c |  291 +
 drivers/net/wireless/infineon/inffmac/utils.h |  233 +
 include/linux/mmc/sdio_ids.h                  |    2 +
 54 files changed, 28240 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/Kconfig
 create mode 100644 drivers/net/wireless/infineon/Makefile
 create mode 100644 drivers/net/wireless/infineon/inffmac/Kconfig
 create mode 100644 drivers/net/wireless/infineon/inffmac/Makefile
 create mode 100644 drivers/net/wireless/infineon/inffmac/bcdc.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/bcdc.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/bus_proto.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/bus_proto.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/cfg80211.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/cfg80211.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/chan.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/chan.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip_acw74xx.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip_acw74xx.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip_cyw5591x.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/chip_cyw5591x.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/debug.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/debug.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/dev_cmd.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/dev_cmd.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/dev_evt.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/dev_evt.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/dfu.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/dfu.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/feature.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/feature.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/firmware.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/firmware.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/fwsignal.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/fwsignal.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/he.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/he.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/icdc.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/icdc.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/ie.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/ie.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/interface.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/interface.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/main.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/main.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/net.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/net.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/scan.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/scan.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/sdio.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/sdio.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/trxhdr.h
 create mode 100644 drivers/net/wireless/infineon/inffmac/utils.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/utils.h

-- 
2.43.0

