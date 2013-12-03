Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41172 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab3LCEqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 23:46:43 -0500
From: Chet Lanctot <clanctot@codeaurora.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Chet Lanctot <clanctot@codeaurora.org>
Subject: [PATCH 0/2 V2] nl80211/cfg80211: Support PMF on drivers with integrated AP SME
Date: Mon,  2 Dec 2013 20:46:23 -0800
Message-Id: <1386045985-2398-1-git-send-email-clanctot@codeaurora.org> (sfid-20131203_054703_485161_09EF8F53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches represent a small number of extensions to the
nl80211/cfg80211 interface to support Protected Management Frames
(PMF, 802.11w) on an AP when the AP SME is integrated into the
device driver or device firmware.

Device drivers that implement AP SME handle connection requests
from stations internally.  These patches allow hostapd to specify
to the device driver the PMF state that should be used when these
connections are made.

Also, these patches allow device drivers that do not implement the
SA Query procedure (part of PMF) to communicate the need for hostapd
do this procedure.  Normally the software component handling
connection requests would do SA Query. These patches provide a way
for the device driver to shift SA Query processing to hostapd where
it is already fully implemented.

The following changes are made to nl80211/cfg80211.

1.  A new nl80211_ap_sme_feature is defined which is used by drivers
to inform hostapd that the driver does not support the SA query
procedure.  hostapd must register for Re/Association Request frames
from the driver so that these frames can be delivered by the driver
to start an SA Query procedure.  An example of code in
the driver that sets this feature is as follows:
     struct wiphy *wiphy; /* wiphy defined in cfg80211.h */
     .
     .
     .
     wiphy->ap_sme_capa |= BIT(NL80211_AP_SME_FEATURE_NO_SA_QUERY);

2.  A new entry is made in cfg80211_ap_settings to inform drivers
whether management frame protection should be used for station connections.
This entry is passed by hostapd using NL80211_CMD_START_AP and it is only
used when the device is acting as an AP.  Existing type nl80211_mfp defines the
values that can be used for this entry.  Existing value NL80211_MFP_NO
means that PMF connections cannot be made with stations. Existing value
NL80211_MFP_REQUIRED means that all station connections must be PMF
protected.  A new value NL80211_MFP_OPTIONAL is defined which means
that a connection can be made if the station supports it, but it is
not required.

3.  A new station flag is defined that indicates to the driver that
hostapd has completed the SA Query procedure for that station (SA
Query timed out) and the driver should process the next Re/Association
Request normally and not pass it to hostapd.

Chet Lanctot (2):
  nl80211/cfg80211: Add support for drivers with AP SME that require
    PMF SA Query assistance
  nl80211/cfg80211: Enable station PMF requirement to be specified to
    driver with AP SME

 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h | 26 ++++++++++++++++++++------
 net/wireless/nl80211.c       | 16 +++++++++++++---
 3 files changed, 37 insertions(+), 9 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

