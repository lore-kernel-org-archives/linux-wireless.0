Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:31912 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab0FNJ4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 05:56:45 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH v2 0/3] mac80211: Add support for configuring ibss basic rates
Date: Mon, 14 Jun 2010 12:55:30 +0300
Message-Id: <1276509333-19023-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set implements support for configuring basic rates for ibss network when joining/creating one. First two patches are basically patch proposed by Johannes Berg on linux-wireless posting list split in two. These implement interface to nl80211 to do actual configuration from user space. Last patch impelents removal of the BSS information from the cfg80211 when leaving the IBSS and there is no other active STA's.

Teemu Paasikivi (3):
  mac80211: Set basic rates while joining ibss network
  mac80211: Set changed basic rates flag
  mac80211: remove BSS from cfg80211 list when leaving IBSS

 include/net/cfg80211.h     |    2 +
 net/mac80211/ibss.c        |   30 ++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |    2 +
 net/wireless/nl80211.c     |   49 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+), 1 deletions(-)

