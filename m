Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37783 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754201AbbILH21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 03:28:27 -0400
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>
Subject: [[linux-nfc] PATCH v1.0 0/3] Add support for ST95HF
Date: Sat, 12 Sep 2015 03:21:32 -0400
Message-ID: <1442042495-2407-1-git-send-email-shikha.singh@st.com> (sfid-20150912_092831_804793_50E6ABA1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,
	This series of patch provide support of STMicroelectronics
NFC Transceiver "ST95HF".

This series include below 3 patches:
1. Modification in file of NFC digital layer to provide support of
ISO14443 Type4A tags.
2. Patch includes all ST95HF driver related files.
This release of driver supports ST95HF in initiator mode to support
read/write mode for IS014443 Type A and ISO14443 Type B tags.
3. Patch to provide binding doc of ST95HF to guide how to make node
entry of ST95HF in DT file.

To Do: ISO15693 tags read/write will be supported in upcoming release of driver.

This series of patch is based on Linux kernel 4.1.

Any feedbacks are most welcome.

Thanks & Regards,
Shikha

Shikha Singh (3):
  NFC: digital: Type4A tags support
  driver: nfc: st95hf: ST NFC Transceiver support
  DT: bindings: net: nfc: ST95HF binding doc

 .../devicetree/bindings/net/nfc/st95hf.txt         |   55 +
 drivers/nfc/Kconfig                                |    1 +
 drivers/nfc/Makefile                               |    1 +
 drivers/nfc/st95hf/Kconfig                         |   11 +
 drivers/nfc/st95hf/Makefile                        |    6 +
 drivers/nfc/st95hf/spi.c                           |  159 +++
 drivers/nfc/st95hf/spi.h                           |   45 +
 drivers/nfc/st95hf/st95hf.c                        | 1134 ++++++++++++++++++++
 net/nfc/digital_core.c                             |    3 +-
 9 files changed, 1414 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt
 create mode 100644 drivers/nfc/st95hf/Kconfig
 create mode 100644 drivers/nfc/st95hf/Makefile
 create mode 100644 drivers/nfc/st95hf/spi.c
 create mode 100644 drivers/nfc/st95hf/spi.h
 create mode 100644 drivers/nfc/st95hf/st95hf.c

-- 
1.8.2.1

