Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080AbZKXPZV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 10:25:21 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [RFC 0/3] PMKSA support
Date: Tue, 24 Nov 2009 16:26:51 +0100
Message-Id: <cover.1259075573.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This patchset is an RFC for a new PMKSA API. This is needed for fullmac
devices that run firmwares which set the re-association frames IEs. Those
devices need to get a correct PMKID from wpa_supplicant in order to do faster
WPA2 roaming. mac80211 based drivers wont need to use this API, wpa_supplicant
does all the work for them.

The patchset defines the nl80211 API, adds a wext compatibility handler, and
finally provides the corresponding iwmc3200wifi implementation. 

Samuel Ortiz (3):
  nl80211: PMKSA caching support
  cfg80211: Add PMKSA wext compatibility handler
  iwmc3200wifi: Implement cfg80211 PMKSA API

 drivers/net/wireless/iwmc3200wifi/cfg80211.c |   30 +++++++
 drivers/net/wireless/iwmc3200wifi/commands.c |   22 +++++
 drivers/net/wireless/iwmc3200wifi/commands.h |   13 +++
 drivers/net/wireless/iwmc3200wifi/umac.h     |    1 +
 include/linux/ieee80211.h                    |    2 +
 include/linux/nl80211.h                      |    6 ++
 include/net/cfg80211.h                       |   26 ++++++
 net/wireless/nl80211.c                       |  117 ++++++++++++++++++++++++++
 net/wireless/wext-compat.c                   |   42 +++++++++
 9 files changed, 259 insertions(+), 0 deletions(-)

