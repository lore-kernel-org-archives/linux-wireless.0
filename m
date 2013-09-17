Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:5736 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab3IQTb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Sep 2013 15:31:57 -0400
From: Chet Lanctot <clanctot@codeaurora.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Chet Lanctot <clanctot@codeaurora.org>
Subject: =?UTF-8?q?=5BPATCH=200/2=5D=20nl80211/cfg80211=3A=20Support=20PMF=20on=20drivers=20with=20integrated=20AP=20SME?=
Date: Tue, 17 Sep 2013 12:31:34 -0700
Message-Id: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org> (sfid-20130917_213236_454837_AC61DB43)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches represent a small number of changes to the
nl80211/cfg80211 interface to support Protected Management Frames
(PMF, 802.11w) on an AP.  Specifically, these changes are needed for
drivers that have the AP SME integrated.

Support is added for drivers that do not implement the SA Query procedure
that is part of PMF.  Instead, the need for upper layer software to
do this procedure is advertised.  And support is added so that  whether
PMF should be used for station connections is communicated to the driver.

The following changes are made to nl80211/cfg80211.

1.  A new nl80211_ap_sme_feature is defined which is the driver
advertising that it does not support the SA query procedure.  This
means that the upper layer software must register for Re/Association
Request frames from the driver so that these frames can be delivered
by the driver to start an SA Query procedure.  An example of code in
the driver that sets this feature is as follows:
     struct wiphy *wiphy; /* wiphy defined in cfg80211.h */
     .
     .
     .
     wiphy->ap_sme_capa |= BIT(NL80211_AP_SME_FEATURE_NO_SA_QUERY);

2.  A new entry is made in cfg80211_ap_settings that communicates
to the driver whether management frame protection should be used
for station connections.  This entry is passed by upper layer software
using NL80211_CMD_START_AP.  Existing type nl80211_mfp defines the
values that can be used for this entry.  Existing value -Y´no¡ means
that PMF connections cannot be made with stations. Existing value
´required¡ means that all station connections must be PMF protected.
A new value ´optional¡ is defined which means that a connection can
be made if the station supports it, but it is not required.

3.  A new station flag is defined that indicates to the driver that
no SA Query procedure is needed when an Re/Association Request is
received from a station with which there is already a PMF connection.
The upper layer software will set this for a station when an SA Query
procedure for that station has timed out to indicate to the driver
that the next Re/Association Request should be accepted and not passed
to upper layer software.

Chet Lanctot (2):
  nl80211/cfg80211: Driver with AP SME advertises need for PMF SA Query
  nl80211/cfg80211: PMF Requirement communicated to driver with AP SME

 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 25 ++++++++++++++++++-------
 net/wireless/nl80211.c       | 12 +++++++++++-
 3 files changed, 32 insertions(+), 8 deletions(-)

-- 
1.7.12.rc0.22.gcdd159b

