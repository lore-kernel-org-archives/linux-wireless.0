Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZCJCFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:05:07 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] wireless: use channel bandwidth
Date: Mon,  9 Mar 2009 22:04:55 -0400
Message-Id: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com> (sfid-20090310_030513_132536_B7949C08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Few patches which actually make use of the channel bandwidth, lets
also send this to userspace as it useful to tell which channels you'll
be able to use HT40 or not on as a client.

Luis R. Rodriguez (4):
  cfg80211: check allowed channel max bandwidth before setting HT40
  mac80211: move early error branch check on ieee80211_set_freq()
  mac80211: disallow HT40 if max channel bandwidth is less than 40 MHz
  cfg80211: send channel max bandwidth to userspace

 include/linux/nl80211.h |    3 +++
 net/mac80211/util.c     |   30 +++++++++++++++++-------------
 net/wireless/nl80211.c  |    9 ++++++++-
 3 files changed, 28 insertions(+), 14 deletions(-)

