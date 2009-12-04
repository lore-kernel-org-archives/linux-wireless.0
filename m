Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbZLDOve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 09:51:34 -0500
Message-Id: <20091204143544.034718060@sipsolutions.net>
Date: Fri, 04 Dec 2009 15:35:44 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 0/4] off-channel work
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new work stuff was just a stepping stone, now
we can support telling an interface to go to a
different channel than the operating channel, sit
there for a while listening to frames (eventually
also sending frames like public action) and then
come back.

johannes
---
 include/linux/nl80211.h    |   36 +++++
 include/net/cfg80211.h     |   47 +++++++
 net/mac80211/Makefile      |    2 
 net/mac80211/cfg.c         |   24 +++
 net/mac80211/ieee80211_i.h |   28 ++++
 net/mac80211/main.c        |    3 
 net/mac80211/mlme.c        |   17 --
 net/mac80211/offchannel.c  |  160 ++++++++++++++++++++++++++
 net/mac80211/scan.c        |  144 -----------------------
 net/mac80211/work.c        |  271 +++++++++++++++++++++++++++++++++++----------
 net/wireless/chan.c        |   41 ++++--
 net/wireless/core.h        |    3 
 net/wireless/mlme.c        |   27 ++++
 net/wireless/nl80211.c     |  218 ++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h     |   11 +
 15 files changed, 803 insertions(+), 229 deletions(-)

