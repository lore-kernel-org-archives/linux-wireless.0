Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:40864 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab3LaPax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Dec 2013 10:30:53 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 0/2] modify the inclusion of supported channels IE
Date: Tue, 31 Dec 2013 17:32:24 +0200
Message-Id: <1388503946-25862-1-git-send-email-ilan.peer@intel.com> (sfid-20131231_163057_240832_93C05121)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 80211-2012 specification defines in 8.4.2.20 that the supported
channels information element should contain a list of the channel subbands
in which the station is capable to operate. Change the mac80211 implementation
to add all the channels currently enabled by the device (excluding disabled
channels).

Note: the implementation is not complete as it missing an better handling
for subband in bands other than 2.4 GHz.

Ilan Peer (2):
  cfg80211: Add a function to get the number of enabled channels
  mac80211: Add all enabled channels to the supported channels element

 include/net/cfg80211.h |    9 ++++++
 net/mac80211/mlme.c    |   80 ++++++++++++++++++++++++++++++++++++++++++------
 net/wireless/util.c    |   21 +++++++++++++
 3 files changed, 100 insertions(+), 10 deletions(-)

-- 
1.7.10.4

