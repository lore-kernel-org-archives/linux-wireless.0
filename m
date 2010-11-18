Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44528 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0KRFqP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 00:46:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 21:46:02 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <mark@moxienet.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] cfg80211: fix bug with multiple cards and a CRDA delay
Date: Wed, 17 Nov 2010 21:46:05 -0800
Message-ID: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series addresses the bug pointed out by Mark Mentovai <mark@moxienet.com>
when there is a delay on CRDA and you use multiple cards with the same regulatory
domain. After some testing I realized this also introduced an issue when using
multiple cards with different regulatory settings. The issue is present only
when there is a delay in CRDA so technically this is not a regression so I am
not marking these as stable fixes. It also does not seem to be a regulatory bug
as when the issue is present you'd end up with an intersected regulatory domain
(same alpha2s) or get the regulatory domain rejected for the second card if
the alpha2 was different.

Thanks to Mark for his testing, good ideas on alternative ways to resolve this
and thorough reports.

Luis R. Rodriguez (4):
  cfg80211: put core regulatory request into queue
  cfg80211: move reg_work and reg_todo above
  cfg80211: move mutex locking to reg_process_pending_hints()
  cfg80211: Fix regulatory bug with multiple cards and delays

 include/net/regulatory.h |    7 ++++
 net/wireless/reg.c       |   80 +++++++++++++++++++++++++++++++--------------
 2 files changed, 62 insertions(+), 25 deletions(-)

-- 
1.7.3.2.90.gd4c43

