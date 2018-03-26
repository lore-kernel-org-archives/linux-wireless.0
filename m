Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41454 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750885AbeCZFhZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 01:37:25 -0400
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH v3 00/12] *** Add support for wifi QMI client driver ***
Date: Mon, 26 Mar 2018 11:07:16 +0530
Message-Id: <1522042636-25516-1-git-send-email-govinds@codeaurora.org> (sfid-20180326_073733_835171_060843EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add QMI client driver for Q6 integrated WLAN connectivity subsystem.
This module is responsible for communicating WLAN control messages to FW
over QMI interface.

“QUALCOMM Messaging Interface”(QMI) provides the control interface between
components running b/w remote processors with underlying transport layer
based on integrated chipset(shared memory) or discrete chipset(PCI/USB/SDIO/UART).

QMI client driver implementation is based on qmi frmework https://lwn.net/Articles/729924/.

Below is the sequence of qmi handshake.

       QMI CLIENT(APPS)                                         QMI SERVER(FW in Q6)

                         <------wlan service discoverd----

                       -----connect to wlam qmi service----->

                       ------------wlan info request----->

                       <------------wlan info resp------------

                       ------------msa info req-------->

                     <------------msa info resp------------

                     ------------msa ready req-------->

                     <------------msa ready resp------------

                     <------------msa ready indication-------

                     ------------capability req------->

                    <------------capability resp------------

                    ------------qmi bdf req--------->

                     <------------qmi bdf resp------------

                      ------------qmi cal trigger------->

                  <------------ QMI FW ready indication-------

Govind Singh (12):
  ath10k: Add qmi service for wlan qmi client
  dt: bindings: add bindings for ath10k qmi client
  ath10k: Add WCN3990 QMI client driver
  ath10k: add support to start and stop qmi service
  ath10k: Add support of QMI indication message
  firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM interface
  ath10k: Add MSA handshake QMI mgs support
  ath10k: Add QMI CAP request support
  ath10k: Add QMI HOST CAP request support
  ath10k: add bdf/cal indication support
  ath10k: Add wlan mode on/off qmi message
  ath10k: Add qmi wlan enable/disable support for WCN3990

 .../bindings/net/wireless/qcom,ath10k.txt          |    8 +
 drivers/net/wireless/ath/ath10k/Makefile           |    4 +
 drivers/net/wireless/ath/ath10k/qmi.c              | 1188 ++++++++++
 drivers/net/wireless/ath/ath10k/qmi.h              |  102 +
 drivers/net/wireless/ath/ath10k/qmi_svc_v01.c      | 2323 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/qmi_svc_v01.h      |  685 ++++++
 drivers/net/wireless/ath/ath10k/snoc.c             |  179 +-
 include/linux/qcom_scm.h                           |    4 +-
 8 files changed, 4491 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi_svc_v01.c
 create mode 100644 drivers/net/wireless/ath/ath10k/qmi_svc_v01.h

-- 
1.9.1
