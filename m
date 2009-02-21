Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZBUFYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:24:18 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] cfg80211: few minor enhancements based on reg requests
Date: Sat, 21 Feb 2009 00:24:12 -0500
Message-Id: <1235193856-3524-1-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062422_951958_15FB8C0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are a few cleanups based on the new strategy to use regutory requests
structures from the workqueue. We still pass the wiphy directly to
__regulatory_hint() and ignore_request() as its used often.

Luis R. Rodriguez (4):
  cfg80211: make __regulatory_hint() static
  cfg80211: pass the regulatory_request struct in __regulatory_hint()
  cfg80211: do not kzalloc() again for a new request on
    __regulatory_hint
  cfg80211: pass the regulatory_request to ignore_request

 net/wireless/reg.c |  106 ++++++++++++++++++++++-----------------------------
 net/wireless/reg.h |   23 -----------
 2 files changed, 46 insertions(+), 83 deletions(-)

