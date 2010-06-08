Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:28626 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab0FHMei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 08:34:38 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [RFC 0/3] mac80211: Add support for configuring ibss basic rates
Date: Tue,  8 Jun 2010 15:34:16 +0300
Message-Id: <1276000459-1121-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set implements support for configuring basic rates for ibss network when joining/creating one. First two patches are basically patch proposed by Johannes Berg on linux-wireless posting list split in two. These implement interface to nl80211 to do actual configuration from user space. Last patch is to fix a problem when leaving and joining back to self created ibss network, without this basic rates would be left unset. That is caused by the fact that the stack holds information for the self created bss and when rejoining it looks like already existing ibss network. This causes little annoyance (bug?) by preventing changing basic rates once ibss is created as long as the stack holds the information. 

Teemu Paasikivi (3):
  mac80211: Set basic rates while joining ibss network
  mac80211: Set changed basic rates flag
  mac80211: Store basic rates for bss when joining ibss network

 include/net/cfg80211.h     |    2 +
 net/mac80211/ibss.c        |   19 ++++++++++++++++-
 net/mac80211/ieee80211_i.h |    2 +
 net/wireless/nl80211.c     |   49 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 71 insertions(+), 1 deletions(-)

