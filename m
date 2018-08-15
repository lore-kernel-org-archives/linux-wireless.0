Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:7323 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726044AbeHOD0I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 23:26:08 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH 0/3] Add support for ftm responder configuration
Date: Tue, 14 Aug 2018 17:30:15 -0700
Message-Id: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180815_023633_346093_DFEBFA6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ftm_responder parameter in hostapd.conf is only used for fine
timing measurement (FTM) capability advertisement and actual control of
the functionality is with low-level device/driver. This leads to confusion
to the user when the capability advertisement is different from actual FTM
responder functionality.

For example, FTM responder capability advertisement is set to 'disabled',
which would imply that AP must not respond to FTM requests, but user sees
AP still responding to FTM requests, as the functionality is enabled in
the driver.

The patch set allows userspace to configure FTM responder functionality
with the addition of new Netlink attribute NL80211_ATTR_FTM_RESPONDER
and also adds extended feature flag for the drivers to advertise the
support. Sending '0' to disable FTM responder would imply AP does not
respond to FTM requests and sending '1' to enable FTM responder would
imply that AP responds to all FTM requests.

Pradeep Kumar Chitrapu (3):
  nl80211: add support to configure FTM responder functionality
  mac80211: Add support to notify ftm responder configuration to the
    driver
  ath10k: Add support to configure ftm responder role

 drivers/net/wireless/ath/ath10k/core.h |  1 +
 drivers/net/wireless/ath/ath10k/mac.c  | 29 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi.h  | 10 ++++++++++
 include/net/cfg80211.h                 |  2 ++
 include/net/mac80211.h                 |  4 ++++
 include/uapi/linux/nl80211.h           | 20 ++++++++++++++++++++
 net/mac80211/cfg.c                     |  4 ++++
 net/mac80211/util.c                    |  3 +++
 net/wireless/nl80211.c                 | 19 +++++++++++++++++++
 10 files changed, 96 insertions(+)

-- 
1.9.1
