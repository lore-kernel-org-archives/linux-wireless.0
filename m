Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46590 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab1LVIgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 03:36:38 -0500
Received: by wgbdr13 with SMTP id dr13so15521713wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 00:36:37 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ivdoorn@gmail.com, gwingerde@gmail.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] rt2x00: Mark active channel's survey data as "in use"
Date: Thu, 22 Dec 2011 09:36:29 +0100
Message-Id: <1324542989-25212-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111222_093642_088127_9EB69C59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is just a cosmetical fix since we only return survey data for the
active channel but it allows iw to show that the survey data is
for the currently used channel.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 14fc8d1..bb70e89 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4686,6 +4686,9 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 		survey->channel_time_ext_busy = busy_ext / 1000;
 	}
 
+	if (!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
+		survey->filled |= SURVEY_INFO_IN_USE;
+
 	return 0;
 
 }
-- 
1.7.7

