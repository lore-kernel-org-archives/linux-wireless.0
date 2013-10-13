Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55543 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3JMDa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Oct 2013 23:30:56 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so5958910pde.38
        for <linux-wireless@vger.kernel.org>; Sat, 12 Oct 2013 20:30:55 -0700 (PDT)
From: Mihir Shete <smihir@qti.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: Mihir Shete <smihir@qti.qualcomm.com>
Subject: [PATCH 0/2] cfg80211: changes to add the country IE preferences
Date: Sun, 13 Oct 2013 09:00:44 +0530
Message-Id: <1381635046-15123-1-git-send-email-smihir@qti.qualcomm.com> (sfid-20131013_053114_626939_9984BF4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

802.11 cards may have different country IE parsing preferences
and vendors have to support these. We currently provide support
for country IE behavioural preferences by using the flags
WIPHY_FLAG_STRICT_REGULATORY, WIPHY_FLAG_CUSTOM_REGULATORY and
their combination.

Instead of extending the definition by using the existing
regulatory flags, split out the desired behaviours into a new
wiphy flag. This will allow us to add more customizations in a
more easily maintainable fashion.

Mihir Shete (2):
  cfg80211: add flags to define country IE processing rules
  cfg80211: add an option to disable processing country IEs

 drivers/net/wireless/ath/regd.c |  1 +
 include/net/cfg80211.h          | 36 +++++++++++++++++++++++-------------
 include/uapi/linux/nl80211.h    | 34 ++++++++++++++++++++++++++++++++++
 net/wireless/reg.c              | 11 ++++++-----
 4 files changed, 64 insertions(+), 18 deletions(-)

-- 
1.8.2.1

