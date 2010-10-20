Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33431 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab0JTRTE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 13:19:04 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 10:18:54 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <easwar.krishnan@atheros.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/7] cfg80211: few regulatory fixes and debugging enhancements
Date: Wed, 20 Oct 2010 10:18:52 -0700
Message-ID: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Easwar reported some odd issues with ath9k regarding regulatory
while during the 2.6.36-rc cycles. Unfortunately I was only able
to address the issues for these reported issues until now as I had
other higher priority items on my plate. It turns out that some of
these issues are pretty serious, mostly the one that does not apply
regulatory updates for disabling a band when that is the intention.

These issues were simply overlooked but they are part of the design,
so we target a few of these fixes to stable. The new debugging stuff
is left only for the development series on the next kernel.

There is one world regulatory domain update we are considering now
for the Atheros cards, but we haven't yet decided on this. I'll send
the patch if we agree on it next. Thanks to Easwar for his reports
and work on this.

Luis R. Rodriguez (7):
  cfg80211: pass the reg hint initiator to helpers
  cfg80211: fix allowing country IEs for WIPHY_FLAG_STRICT_REGULATORY
  cfg80211: fix disabling channels based on hints
  cfg80211: add debug prints for when we ignore regulatory hints
  cfg80211: add debug print when disabling a channel on a custom regd
  cfg80211: add debug print when processing a channel
  cfg80211: prefix REG_DBG_PRINT() with cfg80211

 include/linux/nl80211.h |    6 ++-
 include/net/cfg80211.h  |   15 +++---
 net/wireless/reg.c      |  133 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 130 insertions(+), 24 deletions(-)

