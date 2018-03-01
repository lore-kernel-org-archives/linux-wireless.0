Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0083.outbound.protection.outlook.com ([104.47.37.83]:58674
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966675AbeCAJjf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 04:39:35 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: [PATCH v3 0/2] cfg80211/nl80211: prepare DFS offload
Date: Thu,  1 Mar 2018 12:39:14 +0300
Message-Id: <20180301093916.14096-1-sergey.matyukevich.os@quantenna.com> (sfid-20180301_103944_734039_DF934F06)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes and all,

Here is a patch set preparing DFS offload feature. The final purpose is
to enable DFS offload when hardware/driver does all the DFS activities
on its own without any support from user-space tools, e.g. hostapd.
In this case user-space will be only informed about results, e.g.
when CAC started/stopped, radar detected, etc...

User-space functionality is already available in hostapd in the form
of  vendor-specific (QCA) OUI advertising DFS offload support. The
idea is to add missing pieces to kernel and then to convert relevant
hostapd functionality into a vendor neutral form.

Thanks,
Sergey

Changes v2 -> v3
- add patch with CAC_STARTED event

Dmitrii Lebed (2):
  cfg80211/nl80211: add DFS offload flag
  cfg80211/nl80211: add CAC_STARTED event

 include/uapi/linux/nl80211.h |   10 ++++++++++
 net/wireless/mlme.c          |    7 +++++--
 net/wireless/nl80211.c       |   12 ++++++++----
 3 files changed, 23 insertions(+), 6 deletions(-)
