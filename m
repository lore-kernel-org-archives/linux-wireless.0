Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:52980
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751201AbdJEBiT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 21:38:19 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V2 0/8] qtnfmac: get rid of redundant state caching in driver
Date: Wed,  4 Oct 2017 18:38:05 -0700
Message-Id: <20171005013813.13332-1-igor.mitsyanko.os@quantenna.com> (sfid-20171005_033829_761413_59AB5172)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

In many cases qtnfmac driver stores state info (like current channel,
interface state) in driver's internal state that is either unused or
duplicates information that is available elsewhere. Cleanup driver
to get rid of not needed cached data.

It was part of bigger changeset when it was V1.

Changelist V1->V2:
PATCH 3:
  - add missing cpu_to_le16() to CMD len field initialization.

Igor Mitsyanko (8):
  qtnfmac: do not cache AP settings in driver structures
  qtnfmac: pass all AP settings to wireless card for processing
  qtnfmac: pass channel definition to WiFi card on START_AP command
  qtnfmac: get rid of QTNF_STATE_AP_CONFIG
  qtnfmac: get rid of QTNF_STATE_AP_START flag
  qtnfmac: do not cache BSS state in per-VIF structure
  qtnfmac: make encryption info a part of CONNECT command.
  qtnfmac: do not cache current channel info in driver's state

 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 110 ++------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 163 +++++++++++----------
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  24 +--
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  14 --
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  92 +++++++++---
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |  45 ++++++
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   3 +
 8 files changed, 224 insertions(+), 230 deletions(-)

-- 
2.9.5
