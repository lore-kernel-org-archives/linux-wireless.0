Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52373 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751948AbdFORqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 13:46:22 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 0/3] NFC: Misc. kernel updates and trf7970a erratum handling
Date: Thu, 15 Jun 2017 10:46:14 -0700
Message-Id: <20170615174617.1817-1-mgreer@animalcreek.com> (sfid-20170615_194628_067625_76ED0585)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a couple minor fixups and remove the trf7970a erratum handling
in which the last byte in the response to a Type 5 Read Multiple Blocks
command is discarded.  That handling is moved to the neard daemon where
there is enough context to do it properly.

Mark Greer (3):
  NFC: digital: NFC-A SEL_RES must be one byte
  NFC: digital: NFC-DEP Target WT(nfcdep,max) is now 14
  Revert "NFC: trf7970a: Handle extra byte in response to Type 5 RMB
    commands"

 .../devicetree/bindings/net/nfc/trf7970a.txt       |  4 ----
 drivers/nfc/trf7970a.c                             | 25 ++++------------------
 net/nfc/digital_dep.c                              |  2 +-
 net/nfc/digital_technology.c                       |  3 ++-
 4 files changed, 7 insertions(+), 27 deletions(-)

-- 
2.13.0
