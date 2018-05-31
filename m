Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0071.outbound.protection.outlook.com ([104.47.34.71]:24955
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754091AbeEaJLQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 05:11:16 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: [PATCH 0/6] qtnfmac: enable more features
Date: Thu, 31 May 2018 12:10:56 +0300
Message-Id: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com> (sfid-20180531_111122_071530_9305FB9A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle and all,

Here is the next update for qtnfmac driver which enables more wireless
features. The major changes include the following items:
- cfg80211 power management callback
- net_device_ops set MAC addr callback
- advanced scan features: multiple SSIDs and randomized source MACs
- basic WoWLAN support: disconnect/magic/pattern triggers
  -- not yet: PCIe backend suspend/resume, reporting wakeup reason

Regards,
Sergey

Sergei Maksimenko (1)
  qtnfmac: implement cfg80211 power management callback

Sergey Matyukevich (1)
  qtnfmac: implement basic WoWLAN support

Igor Mitsyanko (1)
  qtnfmac: implement net_device_ops callback to set MAC address

Andrey Shevchenko (3)
  qtnfmac: add support for PTA configuration
  qtnfmac: enable multiple SSIDs scan support
  qtnfmac: enable source MAC address randomization support


 Makefile   |    4 -
 cfg80211.c |  107 ++++++++++++++++++++++++++++
 commands.c |  230 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 commands.h |    5 +
 core.c     |   26 ++++++
 core.h     |    3 
 qlink.h    |  165 +++++++++++++++++++++++++++++++++++++++++++
 vendor.c   |  145 ++++++++++++++++++++++++++++++++++++++
 vendor.h   |   35 +++++++++
 9 files changed, 711 insertions(+), 9 deletions(-)
