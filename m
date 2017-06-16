Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42153 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750981AbdFPDky (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 23:40:54 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 0/2] NFC: Add deactivate target functionality
Date: Thu, 15 Jun 2017 20:34:20 -0700
Message-Id: <20170616033422.18484-1-mgreer@animalcreek.com> (sfid-20170616_054104_764357_CC4CAE6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is currently no way for userspace to deactivate an active target.
Since the target is active, the adapter cannot be powered down which
wastes wastes power when the target has been read and isn't needed
anymore (but remains within range).  To solve this, add a way to
deactivate a currently active target which will then allow the adapter
to be powered down.

To be fully operational, this requires companion patches for neard.
Those patches will be submitted shortly.

Mark Greer (2):
  NFC: digital: Abort cmd when deactivating target
  NFC: Add NFC_CMD_DEACTIVATE_TARGET support

 include/uapi/linux/nfc.h |  2 ++
 net/nfc/digital_core.c   |  1 +
 net/nfc/netlink.c        | 29 +++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

-- 
2.13.0
