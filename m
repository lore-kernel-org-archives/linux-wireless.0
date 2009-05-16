Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34423 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZEPWAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2009 18:00:42 -0400
Received: by ewy24 with SMTP id 24so3263140ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2009 15:00:42 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 0/2] cfg80211: allow drivers to mark certain objects const
Date: Sat, 16 May 2009 23:13:45 +0100
Message-Id: <1242512027-15682-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is likely that the cfg80211_ops and privid data setup by wireless
drivers will not need to change. Drivers may therefore want to mark
these objects const. This patch ensures that the cfg80211 interface does
not preclude this.

I sent these as part of an RFC titled 'orinoco: initiate cgf80211
conversion'. The core of that patch is being reworked, but there's no
reason these can't go in independently.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
David Kilroy (2):
  cfg80211: mark ops as pointer to const
  cfg80211: mark wiphy->privid as pointer to const

 include/net/cfg80211.h |    4 ++--
 net/wireless/core.c    |    2 +-
 net/wireless/core.h    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

