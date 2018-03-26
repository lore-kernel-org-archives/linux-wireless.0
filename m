Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0058.outbound.protection.outlook.com ([104.47.32.58]:44249
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751141AbeCZNgu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 09:36:50 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: [PATCH 0/3] cfg80211: further work on DFS offload enablement
Date: Mon, 26 Mar 2018 16:36:30 +0300
Message-Id: <20180326133633.8771-1-sergey.matyukevich.os@quantenna.com> (sfid-20180326_153655_023044_A4789788)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes and all,

Here is a patch set with minor cleanups/updates needed to enable
DFS offload in cfg80211. 

Note that the third patch enables DFS offload for qtnfmac driver.
We assume that it should go through wireless-drivers tree after
all cfg80211/nl80211 changes are reviewed and merged. So it is
posted here for reference purposes only.

Besides, minimal set of user-space changes for hostapd has been
already posted to hostapd mailing list.

Thanks,
Sergey

Dmitrii Lebed (3):
  cfg80211: fix CAC_STARTED event handling
  cfg80211: enable use of non-cleared DFS channels for DFS
  qtnfmac: add DFS offload support

 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |    9 +++++++++
 drivers/net/wireless/quantenna/qtnfmac/event.c    |   11 +++++++++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |    7 +++++--
 net/wireless/chan.c                               |    9 +++++++--
 net/wireless/mlme.c                               |    2 +-
 5 files changed, 33 insertions(+), 5 deletions(-)
