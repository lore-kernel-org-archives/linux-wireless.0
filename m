Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0057.outbound.protection.outlook.com ([104.47.33.57]:13340
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751184AbdIOLxY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 07:53:24 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: [PATCH 0/2] qtnfmac: misc fixes intended for 4.14
Date: Fri, 15 Sep 2017 14:52:58 +0300
Message-Id: <20170915115300.12719-1-sergey.matyukevich.os@quantenna.com> (sfid-20170915_135333_761825_3FD5A22D)
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
