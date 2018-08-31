Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:61270 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727203AbeIAAGD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 20:06:03 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH v2 0/3] support ftm responder configuration/statistics
Date: Fri, 31 Aug 2018 12:56:55 -0700
Message-Id: <1535745418-31336-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180831_215707_135456_A3E00913)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ftm_responder parameter in hostapd.conf is only used for fine
timing measurement (FTM) capability advertisement and actual control of
the functionality is with low-level device/driver. This leads to confusion
to the user when the capability advertisement is different from actual FTM
responder functionality.

For example, FTM responder capability advertisement is set to 'enabled',
but the functionality is disabled or not supported by the driver.

The patch set allows userspace to enable FTM responder functionality
with the addition of new Netlink flag attribute NL80211_ATTR_FTM_RESPONDER
with configurable lci/civic ocation parameters. Also extended feature flag
is added for the drivers to advertise the support. Setting the flag to
enable FTM responder would imply that AP responds to all FTM requests.
Default is considered to be disabled.

changes in V2:
- updated version number
- rebased patches

Johannes Berg, Pradeep Kumar Chitrapu (1):
  cfg80211: support FTM responder configuration/statistics

David Spinadel, Johannes Berg, Pradeep Kumar Chitrapu (1):
  mac80211: support FTM responder configuration/statistics

Pradeep Kumar Chitrapu (1):
  ath10k: Add support to configure ftm responder role

 drivers/net/wireless/ath/ath10k/core.h |   1 +
 drivers/net/wireless/ath/ath10k/mac.c  |  29 +++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |   4 ++
 drivers/net/wireless/ath/ath10k/wmi.h  |  10 +++
 include/net/cfg80211.h                 |  66 +++++++++++++++++++
 include/net/mac80211.h                 |  12 ++++
 include/uapi/linux/nl80211.h           |  71 ++++++++++++++++++++
 net/mac80211/cfg.c                     |  74 +++++++++++++++++++++
 net/mac80211/driver-ops.h              |  16 +++++
 net/mac80211/trace.h                   |  23 +++++++
 net/mac80211/util.c                    |   3 +
 net/wireless/nl80211.c                 | 115 +++++++++++++++++++++++++++++++--
 net/wireless/rdev-ops.h                |  15 +++++
 net/wireless/trace.h                   |  44 +++++++++++++
 14 files changed, 478 insertions(+), 5 deletions(-)

-- 
1.9.1
