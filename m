Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0065.outbound.protection.outlook.com ([104.47.41.65]:24496
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752541AbdIRIFD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 04:05:03 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH RESEND 0/2] qtnfmac: misc fixes intended for 4.14
Date: Mon, 18 Sep 2017 11:04:44 +0300
Message-Id: <20170918080446.21763-1-sergey.matyukevich.os@quantenna.com> (sfid-20170918_100549_928521_34A67E7E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle, Igor, and all

Here are two patches intended for 4.14. The first patch fixes tx path
regression. Lock should be held when queuing packets to h/w fifos in order to
properly handle configurations with two enabled interfaces or multiple enabled
mbss. The second patch fixes scan issues addressing a review comment
from K.Valo regarding pending active scans upon device removal.

Regards,
Sergey

Sergey Matyukevich (2):

qtnfmac: lock access to h/w in tx path
qtnfmac: abort scans on wireless interface changes

cfg80211.c            |    9 ++++++---
cfg80211.h            |    3 +++
core.c                |    2 +-
event.c               |    2 --
pearl/pcie.c          |    9 ++++++++-
pearl/pcie_bus_priv.h |    2 ++
6 files changed, 20 insertions(+), 7 deletions(-)
