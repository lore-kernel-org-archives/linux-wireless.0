Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:28165 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965584AbbKFTed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 14:34:33 -0500
From: Shikha Singh <shikha.singh@st.com>
To: <sameo@linux.intel.com>, <aloisio.almeida@openbossa.org>,
	<lauro.venancio@openbossa.org>, <linux-wireless@vger.kernel.org>,
	<linux-nfc@lists.01.org>
CC: <raunaque.quaiser@st.com>, <manoj.kumar@st.com>,
	<sylvain.fidelis@st.com>, <patrick.sohn@st.com>,
	<shikha.singh@st.com>, <MMS_MMY_Applications_SW@list.st.com>
Subject: [[linux-nfc] PATCH v3 0/3] *** ST95HF driver v3 ***
Date: Fri, 6 Nov 2015 14:33:59 -0500
Message-ID: <1446838442-10964-1-git-send-email-shikha.singh@st.com> (sfid-20151106_203440_668853_E3BACBFE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New patch series of ST95HF Linux Driver v3

Changelog:
v3:
Address feedbacks from Lars Steubesand:
	i)Included modification in drivers/nfc/Kconfig and
	drivers/nfc/Makefile to build ST95HF driver.
	ii)Included header file linux/property.h explicitely in core.c
	and all header files are included in sorted order.
	iii)GPL version is modified in MODULE_LICENSE to match with header.

v2.0:
1.Address feedbacks from Samuel:
	i)Code improvement and code optimization
2.Address feedbacks from Lars Steubesand:
	i)Code improvement and code optimization
	ii)Bug fix : Kernel crash due to race between irq_thread_handler()
	and  st95hf_remove() is resolved.
3.Address feedback from Christophe Henri Ricard:
	i)Correction in file headers.

v1.0:
First release of ST95HF driver.

Shikha Singh (3):
  NFC: digital: Type4A tags support
  driver: nfc: Add ST95HF NFC Transceiver support
  DT: bindings: net: nfc: Add ST95HF binding doc

 .../devicetree/bindings/net/nfc/st95hf.txt         |   50 +
 drivers/nfc/Kconfig                                |    1 +
 drivers/nfc/Makefile                               |    1 +
 drivers/nfc/st95hf/Kconfig                         |   10 +
 drivers/nfc/st95hf/Makefile                        |    6 +
 drivers/nfc/st95hf/core.c                          | 1240 ++++++++++++++++++++
 drivers/nfc/st95hf/spi.c                           |  167 +++
 drivers/nfc/st95hf/spi.h                           |   59 +
 net/nfc/digital_core.c                             |    3 +-
 9 files changed, 1536 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/st95hf.txt
 create mode 100644 drivers/nfc/st95hf/Kconfig
 create mode 100644 drivers/nfc/st95hf/Makefile
 create mode 100644 drivers/nfc/st95hf/core.c
 create mode 100644 drivers/nfc/st95hf/spi.c
 create mode 100644 drivers/nfc/st95hf/spi.h

-- 
1.8.2.1

