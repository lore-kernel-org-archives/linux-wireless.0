Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:58989 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1LSOPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 09:15:06 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH 0/2] add support for mcs masks
Date: Mon, 19 Dec 2011 15:14:55 +0100
Message-Id: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111219_151512_066585_6A9A47F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for fixed HT datarates. The configuration is
set through nl80211, and now accepts MCS masks next to the legacy masks.

A user may also choose to only use HT datarates and no legacy rates at all -
as always when fiddling with datarates, he should know what he's doing,
and a fallback in the rate matching functions allow to use the rate controls
selected rate if no matching rate was found. The rate matching was enhanced
to consider MCS rates as well.

I have tested this feature in IBSS mode with ath9k devices and with and without
NoAcks, and (at least for me) it works as expected.

There is an iw patch as well to make use of this feature.

It should apply well on the latest wireless-testing kernel.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

Simon Wunderlich (2):
  nl80211: add support for mcs masks
  mac80211: add support for mcs masks

 include/linux/nl80211.h       |    4 +
 include/net/cfg80211.h        |    3 +-
 include/net/mac80211.h        |    1 +
 net/mac80211/cfg.c            |    5 +-
 net/mac80211/debugfs_netdev.c |   34 +++++++++++
 net/mac80211/ieee80211_i.h    |    1 +
 net/mac80211/iface.c          |    3 +
 net/mac80211/rate.c           |  129 +++++++++++++++++++++++++++++++++++++----
 net/mac80211/tx.c             |    5 ++
 net/wireless/nl80211.c        |   54 +++++++++++++++++-
 10 files changed, 223 insertions(+), 16 deletions(-)

-- 
1.7.7.3

