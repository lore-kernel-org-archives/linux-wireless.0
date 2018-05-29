Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933410AbeE2MAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:23 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Subject: [PATCH 0/9] qtnfmac: bugfixes and cleanups
Date: Tue, 29 May 2018 14:59:56 +0300
Message-Id: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140032_343331_88510439)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle and all,

Here is a patch set with various minor fixes and enhancments for qtnfmac driver.

Regards,
Sergey

Andrey Shevchenko (3)
  qtnfmac: cancel scan on disconnect
  qtnfmac: fix bg_scan_period parameter processing
  qtnfmac: remove unused function declarations

Dmitry Lebed (2)
  qtnfmac: fix firmware command error path
  qtnfmac: improve control path timeout handling

Igor Mitsyanko (1)
  qtnfmac: decode error codes from firmware replies

Sergey Matyukevich (3)
  qtnfmac: fix invalid STA state on EAPOL failure
  qtnfmac: cleanup wdev structure between its uses
  qtnfmac: simplify notation


 bus.h        |    3 ++-
 cfg80211.c   |   56 ++++++++++++++++++++++++++++++++------------------------
 commands.c   |   35 ++++++++++++++++++++++++++++-------
 commands.h   |    5 -----
 core.c       |    3 +--
 core.h       |    2 --
 event.c      |    8 +++-----
 pearl/pcie.c |   15 ++++++++++++---
 qlink.h      |    2 ++
 trans.c      |    4 +++-
 10 files changed, 83 insertions(+), 50 deletions(-)
