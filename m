Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:57279 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177Ab0JAPUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 11:20:55 -0400
Received: by qyk9 with SMTP id 9so1079767qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 08:20:54 -0700 (PDT)
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Bill Jordan <bjordan@rajant.com>
Subject: [PATCH 0/3] patches for WDS interfaces
Date: Fri,  1 Oct 2010 11:20:38 -0400
Message-Id: <1285946441-20152-1-git-send-email-bjordan@rajant.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apologies to Luis Rodriguez and Johannes Berg.  Thanks for bearing with me.
I think I've got it right this time.

With these patches, I'm able to interoperate over WDS between
linux-wireless and MadWifi. I'm running wireless-testing plus OpenWRT
patches on a Cambria board with an AR9160 radio.

Bill Jordan (3):
  Patches to ath9k for WDS.
  Patches to cfg80211 to allow setting the WDS peer.
  Patches to mac80211 to allow WDS interfaces to pass packets.

 drivers/net/wireless/ath/ath9k/init.c |    1 +
 drivers/net/wireless/ath/ath9k/main.c |    3 ++
 include/linux/nl80211.h               |    3 ++
 net/mac80211/iface.c                  |    3 ++
 net/mac80211/main.c                   |    3 ++
 net/mac80211/rx.c                     |    1 +
 net/mac80211/tx.c                     |    3 ++
 net/wireless/nl80211.c                |   49 +++++++++++++++++++++++++++++++++
 8 files changed, 66 insertions(+), 0 deletions(-)

-- 
1.7.2.3

