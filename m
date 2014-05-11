Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57928 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966AbaEKIxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 04:53:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 0/7] regulatory enhancements
Date: Sun, 11 May 2014 11:50:43 +0300
Message-Id: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140511_105344_830327_548A4674)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Newer Intel cards store regulatory settings in firmware.
This patch series adds support for a wiphy callback, allowing
the regulatory core to fetch driver/firmware defined redgomain
data whenever a country code change is requested.

Along with that, there is also a small fix from Eliad.

Arik Nemtsov (6):
  cfg80211: don't set reg timeout for user-handled hint
  cfg80211: introduce regulatory flags controlling bw
  cfg80211: allow drivers to provide regulatory settings
  cfg80211: treat the special "unknown" alpha2 as valid
  cfg80211: accept world/same regdom from driver/user hints
  cfg80211: leave invalid channels on regdomain change

Eliad Peller (1):
  regulatory: add NULL to alpha2

 include/net/cfg80211.h       |  17 ++++
 include/net/regulatory.h     |   2 +-
 include/uapi/linux/nl80211.h |  12 +++
 net/wireless/reg.c           | 195 ++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 205 insertions(+), 21 deletions(-)

-- 
1.8.3.2

