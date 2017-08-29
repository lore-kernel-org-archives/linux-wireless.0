Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:55935
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752962AbdH2MRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 08:17:06 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH 0/5] qtnfmac: pcie datapath updates and fixes
Date: Tue, 29 Aug 2017 15:16:18 +0300
Message-Id: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com> (sfid-20170829_141714_588932_2163C95F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle, Igor, and all

This patches introduces further updates and fixes
for pcie datapath in qtnfmac driver:

- implement 64-bit dma for hosts enabling CONFIG_ARCH_DMA_ADDR_T_64BIT
- sanity check for module params: circ_buf queues should be power-of-2
- misc cleanup according to previous reviews

Sergey Matyukevich (5):

qtnfmac: drop -D__CHECK_ENDIAN from cflags
qtnfmac: module param sanity check
qtnfmac: modify qtnf_map_bar not to return NULL
qtnfmac: fix free_xfer_buffer cleanup
qtnfmac: implement 64-bit dma support

Makefile		| 4 -
pearl/pcie.c		| 101 +++++++++++++++++++++++++++++++++++++++---------
pearl/pcie_ipc.h	| 10 +---
pearl/pcie_regs_pearl.h | 1
4 files changed, 88 insertions(+), 28 deletions(-)
