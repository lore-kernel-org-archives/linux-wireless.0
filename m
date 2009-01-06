Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63606 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZAFPWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 10:22:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 07:22:06 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC 0/4] cfg80211: add support multiple regulatory_hint()s
Date: Tue, 6 Jan 2009 07:21:58 -0800
Message-ID: <1231255322-13100-1-git-send-email-lrodriguez@atheros.com> (sfid-20090106_162211_669769_40F5ADE2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for multiple regulatory_hint()s. We support
this by allowing each driver to claim its own regulatory domain and stick
to it. Should a country IE be received and processed that is followed
instead. If three devices are present with different, two with separate
regulatory_hint()s the first two will adhere to their own regulatory domain,
the third one will adhere to the intersection of the first two.

With this patches applied we can then do away with our own interntal tables
for regulatory control in ath9k.

I've only started to test this, so would like comments on the general approach
taken here.

Luis R. Rodriguez (4):
  cfg80211: add a wiphy specific regulatory domain cache
  cfg80211: call reg_notifier() once
  cfg80211: make handle_band() and handle_channel() wiphy specific
  cfg80211: allow multiple driver regulatory_hints()

 include/net/wireless.h |    6 +++
 net/wireless/reg.c     |   92 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 79 insertions(+), 19 deletions(-)

