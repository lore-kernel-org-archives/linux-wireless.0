Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AF4C43382
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31DE3204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31DE3204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbeIYETv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:19:51 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46859 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728724AbeIYETv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:51 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOA012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 00/11] qtnfmac_pcie: extract device-independent PCIe driver code
Date:   Mon, 24 Sep 2018 15:15:03 -0700
Message-Id: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Purpose of the patch series is to extract a portion of PCIe driver sources
that is common among Quantenna wifi devices. It will later be used to add
support for additional wifi card.

As a result, majority of changes here are moving code blocks around and
renaming without functional changes + several minor improvements.

Changelist V1->V2:
PATCH 6:
  1. Add SPDX license tag to a new file pcie_priv.h
PATCH 7:
  1. Fix line over 80 character and opening bracket on a wrong line.
PATCH 9:
  1. Add SPDX license tag to a new file pcie.c

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
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  391 +++++
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |   85 ++
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 1262 +++++++++++++++++
 .../{pearl/pcie_ipc.h => pcie/pearl_pcie_ipc.h}    |   58 -
 .../pcie_regs_pearl.h => pcie/pearl_pcie_regs.h}   |    0
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 1494 --------------------
 .../quantenna/qtnfmac/pearl/pcie_bus_priv.h        |   91 --
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    |   14 +
 10 files changed, 1757 insertions(+), 1646 deletions(-)
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_ipc.h => pcie/pearl_pcie_ipc.h} (68%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_regs_pearl.h => pcie/pearl_pcie_regs.h} (100%)
 delete mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
 delete mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h

-- 
2.9.5

