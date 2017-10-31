Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0048.outbound.protection.outlook.com ([104.47.42.48]:45504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751776AbdJaBFC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 21:05:02 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, vulyanov@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 0/9] qtnfmac: allow to configure channel, BW, HT/VHT caps
Date: Mon, 30 Oct 2017 18:04:46 -0700
Message-Id: <20171031010455.27772-1-igor.mitsyanko.os@quantenna.com> (sfid-20171031_020517_783548_4962A090)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

This patchset has a goal to make operational parameters (channel, BW,
HT/VHT capabilities) configuration possible for qtnfmac driver.

It was part of bigger changeset when it was V1, rest are already applied.

Changelist V1->V2:
PATCH 8:
  - fix a typo causing initialization of HT capabilities with VHT data.

Igor Mitsyanko (9):
  qtnfmac: use per-band HT/VHT info from wireless device
  qtnfmac: initialize HT/VHT caps "can override" masks
  qtnfmac: get rid of PHYMODE capabilities flags
  qtnfmac: extend "IE set" TLV to include frame type info
  qtnfmac: SCAN results: retreive frame type information from "IE set"
    TLV
  qtnfmac: convert "Append IEs" command to QTN_TLV_ID_IE_SET usage
  qtnfmac: configure and start AP interface with a single command
  qtnfmac: include HTCAP and VHTCAP into config AP command
  qtnfmac: pass all CONNECT cmd params to wireless card for processing

 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  64 +----
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 276 +++++++++++++++-------
 drivers/net/wireless/quantenna/qtnfmac/commands.h |   9 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c     |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h     |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c    |  83 ++++---
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    | 138 ++++++-----
 7 files changed, 330 insertions(+), 248 deletions(-)

-- 
2.9.5
