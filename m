Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45657 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1953163AbdDYWn6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 18:43:58 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        devicetree@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH v5 0/9] NFC: trf7970a: Fixups & convert to desc-based GPIO
Date: Tue, 25 Apr 2017 15:43:47 -0700
Message-Id: <20170425224356.11498-1-mgreer@animalcreek.com> (sfid-20170426_004409_647620_E3C28A15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These trf7970a driver patches do the following things:
 - add Mark Greer as the maintainer of the trf7970a driver
 - some minor fixups
 - remove support for 'vin-voltage-override' DT property
 - change the DTS example to indicate that EN and EN2 are active high GPIOs
 - convert the driver to use the descriptor-based GPIO interface
 - apply Lindent coding style fixes

Based on nfc-next/master 4ea206395d3a ("nfc: fix get_unaligned_...() misuses")

v4->v5:
 - Fixed whitespace issue in "NFC: trf7970a: Clean up coding style issues"

v3->v4:
 - Rebased on nfc-next/master because patches in that branch conflict
   with the v3 version of this patch series.
 - Removed "NFC: trf7970a: Don't manage EN2 when not specified in DT"
   because a similar patch has already been accepted.
 - Added "NFC: trf7970a: Clean up coding style issues" because the reason
   I removed it in v3 no longer exists.
 - Reordered the patches to make more sense (I think)

v2->v3:
 - Removed "[PATCH v2 5/7] NFC: trf7970a: Clean up coding style issues"
   because it will make merging patches from Geoff Lansberry and others
   hard to apply.  I will resubmit once those patches have been merged
   or rejected.
 - Added a patch to remove 'vin-voltage-override' DT property support as
   proper DT regulator set up makes it unnecessary.

v1->v2:
 - Commit description fixups only; no functional changes.

Mark Greer (9):
  MAINTAINERS: NFC: trf7970a: Add Mark Greer as maintainer
  NFC: trf7970a: Don't de-assert EN2 unless it was asserted
  NFC: trf7970a: Fix inaccurate comment in trf7970a_probe()
  NFC: trf7970a: Only check 'en2-rf-quirk' if EN2 is specified
  NFC: trf7970a: Remove useless comment
  NFC: trf7970a: Remove support for 'vin-voltage-override' DT property
  NFC: trf7970a: Enable pins are active high not active low
  NFC: trf7970a: Convert to descriptor based GPIO interface
  NFC: trf7970a: Clean up coding style issues

 .../devicetree/bindings/net/nfc/trf7970a.txt       |   6 +-
 MAINTAINERS                                        |   8 +
 drivers/nfc/Kconfig                                |   2 +-
 drivers/nfc/trf7970a.c                             | 363 ++++++++++-----------
 4 files changed, 185 insertions(+), 194 deletions(-)

-- 
2.12.0
