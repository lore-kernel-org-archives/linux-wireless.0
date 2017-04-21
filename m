Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:59757 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1038741AbdDUMFS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 08:05:18 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3 0/9] cfg80211: support multiple scheduled scans
Date: Fri, 21 Apr 2017 13:04:59 +0100
Message-Id: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170421_140549_856850_8DAF9363)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the RFC rounds here is multi-scheduled scan submission. What
has been added since the RFC is support for user-space to specify a
BSSID in the matchset (PATCH 3/10). As example this could be used for
roaming algorithm done in user-space. The patches for scheduled scan
notification api have been collapsed into a single patch and rtnl
locking was needed for the cfg80211_sched_scan_results() function.

This series also adds a driver implementation for the new features.
Not surprisingly being brcmfmac.

This series applies to master branch of the mac80211-next
repository. In this version some rework was needed to stop
scheduled scans owned by a specific netlink socket which
is released.
---
 changes:
  V2:
   - patch 5/10 changed to resolve kerneldoc issue.
   - patch 8/10 and 10/10 resolving uninitialized warnings.
  V3:
   - patch 1/9 changed getting rid of rdev->sched_scan_req.
---
Arend van Spriel (9):
  nl80211: allow multiple active scheduled scan requests
  nl80211: add support for BSSIDs in scheduled scan matchsets
  cfg80211: add request id parameter to .sched_scan_stop() signature
  cfg80211: add request id to cfg80211_sched_scan_*() api
  brcmfmac: add firmware feature detection for gscan feature
  brcmfmac: move scheduled scan wiphy param setting to pno module
  brcmfmac: add support multi-scheduled scan
  brcmfmac: add mutex to protect pno requests
  brcmfmac: add scheduled scan support for specified BSSIDs

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   6 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  93 +++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  22 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  76 ++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 453 ++++++++++++++++++---
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.h |  55 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  10 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   2 +-
 drivers/net/wireless/ti/wlcore/main.c              |   2 +-
 include/net/cfg80211.h                             |  39 +-
 include/uapi/linux/nl80211.h                       |  14 +-
 net/mac80211/cfg.c                                 |   3 +-
 net/mac80211/pm.c                                  |   2 +-
 net/mac80211/scan.c                                |   4 +-
 net/mac80211/util.c                                |   2 +-
 net/wireless/core.c                                |  49 ++-
 net/wireless/core.h                                |  16 +-
 net/wireless/nl80211.c                             | 120 ++++--
 net/wireless/rdev-ops.h                            |   8 +-
 net/wireless/scan.c                                | 133 ++++--
 net/wireless/trace.h                               |  54 ++-
 30 files changed, 963 insertions(+), 225 deletions(-)

-- 
1.9.1
