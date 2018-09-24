Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726400AbeIXLNu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:50 -0400
From: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 02/11] qtnfmac_pcie: move Pearl pcie sources to pcie-specific
 directory
Date: Mon, 24 Sep 2018 05:13:25 +0000
Message-ID: <20180924051246.13371-3-igor.mitsyanko.os@quantenna.com> (sfid-20180924_071404_266480_1C0FDD59)
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation to extract common qtnfmac PCIe driver sources into a
separate file, move existing Pearl-specific pcie driver sources to pcie/
directory.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/Makefile                       | 2 =
+-
 .../wireless/quantenna/qtnfmac/{pearl/pcie.c =3D> pcie/pearl_pcie.c}    | =
2 +-
 .../qtnfmac/{pearl/pcie_bus_priv.h =3D> pcie/pearl_pcie_bus_priv.h}     | =
4 ++--
 .../quantenna/qtnfmac/{pearl/pcie_ipc.h =3D> pcie/pearl_pcie_ipc.h}     | =
0
 .../qtnfmac/{pearl/pcie_regs_pearl.h =3D> pcie/pearl_pcie_regs.h}       | =
0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie.c =3D> pcie/pear=
l_pcie.c} (99%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_bus_priv.h =3D> =
pcie/pearl_pcie_bus_priv.h} (97%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_ipc.h =3D> pcie/=
pearl_pcie_ipc.h} (100%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_regs_pearl.h =3D=
> pcie/pearl_pcie_regs.h} (100%)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/Makefile b/drivers/net/=
wireless/quantenna/qtnfmac/Makefile
index 97f760a..9eeddea 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/Makefile
+++ b/drivers/net/wireless/quantenna/qtnfmac/Makefile
@@ -23,6 +23,6 @@ obj-$(CONFIG_QTNFMAC_PEARL_PCIE) +=3D qtnfmac_pearl_pcie.=
o
=20
 qtnfmac_pearl_pcie-objs +=3D \
 	shm_ipc.o \
-	pearl/pcie.o
+	pcie/pearl_pcie.o
=20
 qtnfmac_pearl_pcie-$(CONFIG_DEBUG_FS) +=3D debug.o
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/=
net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
similarity index 99%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 97cc7f2..269a6e4 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -29,7 +29,7 @@
 #include <linux/log2.h>
=20
 #include "qtn_hw_ids.h"
-#include "pcie_bus_priv.h"
+#include "pearl_pcie_bus_priv.h"
 #include "core.h"
 #include "bus.h"
 #include "debug.h"
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h b=
/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
similarity index 97%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
index 397875a..986b957 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_bus_priv.h
@@ -20,8 +20,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
=20
-#include "pcie_regs_pearl.h"
-#include "pcie_ipc.h"
+#include "pearl_pcie_regs.h"
+#include "pearl_pcie_ipc.h"
 #include "shm_ipc.h"
=20
 struct bus;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h b/driv=
ers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
similarity index 100%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_ipc.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_ipc.h
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h=
 b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
similarity index 100%
rename from drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_regs_pearl.h
rename to drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie_regs.h
--=20
2.9.5
