Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0073.outbound.protection.outlook.com ([104.47.42.73]:15232
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751071AbdHONGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 09:06:55 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH] qtnfmac: pcie datapath optimizations and cleanups
Date: Tue, 15 Aug 2017 16:06:30 +0300
Message-Id: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com> (sfid-20170815_150659_202810_74975DC6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle and all,

This patchset implements several optimizations and cleanups for
pcie datapath in qtnfmac driver. Major changes include:
- switch to kernel circ_buf implementation
- modify tx reclaim locking
- introduce counter for rx underflow events

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

 bus.h                   |    1 
 pearl/pcie.c            |  285 +++++++++++++++++++++++++++++-------------------
 pearl/pcie_bus_priv.h   |   15 +-
 pearl/pcie_ipc.h        |    1 
 pearl/pcie_regs_pearl.h |    1 
 5 files changed, 183 insertions(+), 120 deletions(-)
