Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41647 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZAHBnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 20:43:55 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 17:43:55 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/6] cfg80211: few fixes and adds support for multiple reg hints
Date: Wed, 7 Jan 2009 17:43:31 -0800
Message-ID: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com> (sfid-20090108_024400_552052_4E9BE0D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series fixes a couple of issues with the current 11d code and also
adds support for multiple devices providing a regulatory_hint().

Luis R. Rodriguez (6):
  cfg80211: call reg_notifier() once
  cfg80211: make handle_band() and handle_channel() wiphy specific
  cfg80211: allow multiple driver regulatory_hints()
  cfg80211: fix typo on message after intersection
  cfg80211: Fix regression with 11d on bands
  cfg80211: Fix parsed country IE info for 5 GHz

 include/net/wireless.h |    6 +
 net/wireless/reg.c     |  238 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 218 insertions(+), 26 deletions(-)

