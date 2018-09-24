Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbeIXLNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:49 -0400
From: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 00/11] qtnfmac_pcie: extract device-independent PCIe driver
 code
Date: Mon, 24 Sep 2018 05:13:24 +0000
Message-ID: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com> (sfid-20180924_071403_665528_33B2C210)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Purpose of the patch series is to extract a portion of PCIe driver sources
that is common among Quantenna wifi devices. It will later be used to add
support for additional wifi card.

As a result, majority of changes here are moving code blocks around and
renaming without functional changes + several minor improvements.

Igor Mitsyanko (11):
  qtnfmac_pcie: do not store FW name in driver state structure
  qtnfmac_pcie: move Pearl pcie sources to pcie-specific directory
  qtnfmac_pcie: rename private Pearl PCIe state structure
  qtnfmac_pcie: indicate pearl-specific structures by their names
  qtnfmac_pcie: pearl: rename spinlock tx0_lock to tx_lock
  qtnfmac_pcie: separate platform-independent PCIe structure
  qtnfmac_pcie: rename platform-specific functions
  qtnfmac: add missing header includes to bus.h
  qtnfmac_pcie: extract platform-independent PCIe code
  qtnfmac: wait for FW load work to finish at PCIe remove
  qtnfmac_pcie: check for correct CHIP ID at pcie probe

 drivers/net/wireless/quantenna/qtnfmac/Makefile    |    3 +-
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |    5 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  404 ++++++
 .../{pearl/pcie_bus_priv.h =3D> pcie/pcie_priv.h}    |   71 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 1261 ++++++++++++++++=
+
 .../{pearl/pcie_ipc.h =3D> pcie/pearl_pcie_ipc.h}    |   58 -
 .../pcie_regs_pearl.h =3D> pcie/pearl_pcie_regs.h}   |    0
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 1494 ----------------=
----
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    |   14 +
 9 files changed, 1723 insertions(+), 1587 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_bus_priv.h =3D> =
pcie/pcie_priv.h} (51%)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.=
c
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_ipc.h =3D> pcie/=
pearl_pcie_ipc.h} (68%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_regs_pearl.h =3D=
> pcie/pearl_pcie_regs.h} (100%)
 delete mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c

--=20
2.9.5
