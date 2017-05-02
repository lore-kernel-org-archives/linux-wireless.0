Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41049 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750715AbdEBGEV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2017 02:04:21 -0400
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <linux-wireless@vger.kernel.org>,
        <linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
        <sylvain.fidelis@st.com>, <raphael.collado@st.com>,
        <shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc][PATCH v1] 0/6] Support of ST NFC Transceiver
Date: Tue, 2 May 2017 02:03:37 -0400
Message-ID: <1493705023-8710-1-git-send-email-shikha.singh@st.com> (sfid-20170502_080429_380975_4C899930)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*** V1.0 ***
This patch series is generated on top of latest
code available on nfc-next.

This patch series introduces the following features:

(a) A generic Digital NFC UART framework.
The framework itself is an LDISC registered
with the tty core. Any NFC transciever implementing
the digital specs and connected on an UART
(or on an emulated tty, such as /dev/ttyUSBx, /dev/ttyACMx)
interface with the host, will require this support.

(b) An ST NFC Transciever core framework. This implements the
required digital ops and exposes an interface for the
underlying phy drivers (UART/ SPI). The services of the phy drivers
are required when the core wants to transmit/receive frames.
Also it provides helper functions for the phy drivers, for
example phy drivers registers with the core when it detects
a Transciever connected on the corresponding interface.
The framework currently supports NFC Type 2, Type 4A, Type 4B,
Type 5 tag read/write.

(c) An ST NFC UART LDisc driver that registers with the
Digital NFC UART framework, and with the ST NFC Transciever
core framework as the UART Phy driver.

(d) An ST NFC SPI driver that register with ST NFC Transceiver
core framework as SPI phy driver.

(e) Binding doc was renamed from st95hf.txt to stnfc.txt.

(f) This patch series also removes all the references of old ST
NFC transceiver driver "st95hf".

Shikha Singh (6):
  NFC: add generic UART support
  NFC: nfcst: Add ST NFC Transceiver core framework
  NFC: nfcst: Add UART LDisc Driver
  NFC: nfcst: Add ST NFC SPI Driver
  DT: bindings: net: nfc: stnfc binding doc
  DRIVERS: NFC: Remove st95hf name reference

 .../devicetree/bindings/net/nfc/st95hf.txt         |   50 -
 .../devicetree/bindings/net/nfc/stnfc.txt          |   50 +
 drivers/nfc/Kconfig                                |    2 +-
 drivers/nfc/Makefile                               |    2 +-
 drivers/nfc/nfcst/Kconfig                          |   49 +
 drivers/nfc/nfcst/Makefile                         |   12 +
 drivers/nfc/nfcst/core.c                           | 1122 +++++++++++++++++
 drivers/nfc/nfcst/spi.c                            |  493 ++++++++
 drivers/nfc/nfcst/stnfcdev.h                       |   70 ++
 drivers/nfc/nfcst/uart.c                           |  164 +++
 drivers/nfc/st95hf/Kconfig                         |   10 -
 drivers/nfc/st95hf/Makefile                        |    6 -
 drivers/nfc/st95hf/core.c                          | 1273 --------------------
 drivers/nfc/st95hf/spi.c                           |  167 ---
 drivers/nfc/st95hf/spi.h                           |   64 -
 include/net/nfc/digital_uart.h                     |  105 ++
 include/uapi/linux/tty.h                           |    1 +
 net/nfc/Kconfig                                    |   12 +
 net/nfc/Makefile                                   |    3 +
 net/nfc/digital_uart.c                             |  523 ++++++++
 20 files changed, 2606 insertions(+), 1572 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/stnfc.txt
 create mode 100644 drivers/nfc/nfcst/Kconfig
 create mode 100644 drivers/nfc/nfcst/Makefile
 create mode 100644 drivers/nfc/nfcst/core.c
 create mode 100644 drivers/nfc/nfcst/spi.c
 create mode 100644 drivers/nfc/nfcst/stnfcdev.h
 create mode 100644 drivers/nfc/nfcst/uart.c
 delete mode 100644 drivers/nfc/st95hf/Kconfig
 delete mode 100644 drivers/nfc/st95hf/Makefile
 delete mode 100644 drivers/nfc/st95hf/core.c
 delete mode 100644 drivers/nfc/st95hf/spi.c
 delete mode 100644 drivers/nfc/st95hf/spi.h
 create mode 100644 include/net/nfc/digital_uart.h
 create mode 100644 net/nfc/digital_uart.c

-- 
1.8.2.1
