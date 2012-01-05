Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:46103 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab2AET6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:58:16 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv2 0/2] add support for mcs masks
Date: Thu,  5 Jan 2012 20:58:06 +0100
Message-Id: <1325793490-21501-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20120105_205821_307648_542673FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for fixed HT datarates. The configuration is
set through nl80211, and now accepts MCS masks next to the legacy masks.

A user may also choose to only use HT datarates and no legacy rates at all -
- as always when fiddling with datarates, he should know what he's doing,
and a fallback in the rate matching functions allow to use the rate controls
selected rate if no matching rate was found. The rate matching was enhanced
to consider MCS rates as well.

I have tested this feature in IBSS mode with ath9k devices and with and without
NoAcks, and (at least for me) it works as expected.

There is an iw patch as well to make use of this feature.

It should apply well on the latest wireless-testing kernel.

Changes to previous versions:
 * fix NL80211_MAX_SUPP_HT_RATES and add bug assertion
 * copy mcs rates from sband into mask
 * add sanity check for rate index
 * various formatting clean up

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
 net/mac80211/iface.c          |    7 ++
 net/mac80211/rate.c           |  124 ++++++++++++++++++++++++++++++++++++++---
 net/mac80211/tx.c             |    5 ++
 net/wireless/nl80211.c        |   61 ++++++++++++++++++++-
 10 files changed, 233 insertions(+), 12 deletions(-)

-- 
1.7.7.3

