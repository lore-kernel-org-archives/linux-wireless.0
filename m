Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759769AbZEMVEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:04:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] cfg80211: two reg fixes
Date: Wed, 13 May 2009 17:04:38 -0400
Message-Id: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses two very unlikely but yet possible races
with cfg80211 reg code.

Luis R. Rodriguez (4):
  cfg80211: return immediately if num reg rules >
    NL80211_MAX_SUPP_REG_RULES
  cfg80211: cleanup return calls on nl80211_set_reg()
  cfg80211: fix in nl80211_set_reg()
  cfg80211: fix race between core hint and driver's custom apply

 net/wireless/nl80211.c |   26 ++++++++++++++++++--------
 net/wireless/reg.c     |    9 +++++++++
 2 files changed, 27 insertions(+), 8 deletions(-)

