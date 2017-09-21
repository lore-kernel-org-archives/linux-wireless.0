Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0068.outbound.protection.outlook.com ([104.47.37.68]:13952
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751728AbdIUVen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 17:34:43 -0400
From: igor.mitsyanko.os@quantenna.com
To: linux-wireless@vger.kernel.org
Cc: sergey.matyukevich.os@quantenna.com, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: [PATCH V3 0/9] qtnfmac: more info on current channel from device
Date: Thu, 21 Sep 2017 14:34:28 -0700
Message-Id: <20170921213437.27457-1-igor.mitsyanko.os@quantenna.com> (sfid-20170921_233448_230050_5FD83789)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

This patchset has a goal to start using full current channel information
as reported by wireless device (specifically, center freq 1 and 2 and
operational BW).

It was part of bigger changeset when it was V1.

Changelist V2->V3:
Do not leave commit messages empty

Changelist V1->V2:
PATCH 2:
  - do not rename "chandef" local variable with no purpose
  - report secondary center frequency in info messages
PATCH 3:
  - report secondary center frequency in info messages

Igor Mitsyanko (9):
  qtnfmac: convert channel width from bitfiled to simple enum
  qtnfmac: make "Channel change" event report full channel info
  qtnfmac: retrieve current channel info from EP
  qtnfmac: do not cache channel info from "connect" command
  qtnfmac: let wifi card handle channel switch request to the same
    chan
  qtnfmac: pass VIF info to SendChannel command
  qtnfmac: do not cache CSA chandef info
  qtnfmac: remove unused mac::status field
  qtnfmac: do not report channel changes until wiphy is registered

 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 69 +++++-----------------
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 52 +++++++++++++---
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |  3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  6 --
 drivers/net/wireless/quantenna/qtnfmac/event.c     | 34 ++++-------
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 45 ++++++++++----
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    | 68 ++++++++++++++++++---
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  4 ++
 8 files changed, 175 insertions(+), 106 deletions(-)

-- 
2.9.5
