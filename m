Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:37851 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932539AbdA0M1z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:27:55 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 0/5] nl802111/brcmfmac: wowlan netdetect fixes
Date: Fri, 27 Jan 2017 12:27:43 +0000
Message-Id: <1485520068-5807-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170127_133123_580846_F84036DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series has a fix for nl80211 regarding validation of wowlan
netdetect. It has been discussed with Johannes to take this through
the wireless-drivers-next repository so here it is.

* fix validation of wowlan netdetect parameters in nl80211.
* fix wowlan netdetect support.
* add new cfg80211 callback.

The series is intended for 4.11 and applies to the master branch of the
wireless-drivers-next repository.

changelog:
 V2: fix checkpatch error in patch 4/5.

Arend van Spriel (5):
  nl80211: fix validation of scheduled scan info for wowlan netdetect
  brcmfmac: provide a value for struct wowlan_support::max_nd_match_sets
  brcmfmac: fix handling firmware results for wowl netdetect
  brcmfmac: allow wowlan support to be per device
  brcmfmac: add .update_connect_params() callback

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 52 ++++++++++++++++++----
 net/wireless/nl80211.c                             | 10 +++--
 2 files changed, 50 insertions(+), 12 deletions(-)

--
1.9.1
