Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0073.outbound.protection.outlook.com ([104.47.41.73]:40347
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751113AbdG0XHV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 19:07:21 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH v2] qtnfmac: add more features to driver
Date: Fri, 28 Jul 2017 02:06:42 +0300
Message-Id: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com> (sfid-20170728_010726_825737_92E0D3A9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds more features and fixes to qtnfmac driver:
- regulatory support updates
- get_channel handler
- dump_survey handler
- channel_switch handler
- update message structures to prepare for adding AP_VLAN
- cleanup and fixes

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Avinash Patil <avinashp@quantenna.com>

v1 -> v2
- remove AP_VLAN support: to be submitted separately as RFC
- split patches with multiple changes into a smaller chunks

cfg80211.c   |  315 ++++++++++++++++++++++++++++++--------
cfg80211.h   |    4 
commands.c   |  486 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
commands.h   |    5 
core.c       |    5 
core.h       |   27 ++-
event.c      |   67 +++++++-
qlink.h      |  202 ++++++++++++++++++++++--
qlink_util.c |   26 +--
qlink_util.h |   10 -
10 files changed, 992 insertions(+), 155 deletions(-)
