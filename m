Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:36231 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753546AbdHUREP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Aug 2017 13:04:15 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: sameo@linux.intel.com, clement.perrochaud@effinnov.com,
        charles.gorand@effinnov.com, r.baldyga@samsung.com,
        k.opasiak@samsung.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/8] constify nfc i2c_device_id
Date: Mon, 21 Aug 2017 22:33:52 +0530
Message-Id: <1503335040-27101-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170821_190647_604202_EA01EE68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Arvind Yadav (8):
  [PATCH 1/8] nfc: microread: constify i2c_device_id
  [PATCH 2/8] nfc: nfcmrvl: constify i2c_device_id
  [PATCH 3/8] nfc: nxp-nci: constify i2c_device_id
  [PATCH 4/8] nfc: pn533: constify i2c_device_id
  [PATCH 5/8] nfc: pn544: constify i2c_device_id
  [PATCH 6/8] nfc: s3fwrn5: constify i2c_device_id
  [PATCH 7/8] nfc: st-nci: constify i2c_device_id
  [PATCH 8/8] nfc: st21nfca: constify i2c_device_id

 drivers/nfc/microread/i2c.c | 2 +-
 drivers/nfc/nfcmrvl/i2c.c   | 2 +-
 drivers/nfc/nxp-nci/i2c.c   | 2 +-
 drivers/nfc/pn533/i2c.c     | 2 +-
 drivers/nfc/pn544/i2c.c     | 2 +-
 drivers/nfc/s3fwrn5/i2c.c   | 2 +-
 drivers/nfc/st-nci/i2c.c    | 2 +-
 drivers/nfc/st21nfca/i2c.c  | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.7.4
