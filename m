Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45867 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759540Ab0I1AHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 20:07:41 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath9k:  Check for identical channels when changing channels.
Date: Mon, 27 Sep 2010 17:07:36 -0700
Message-Id: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Don't do un-needed work.  Should be useful when scanning on
only the working channel.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 a133878... 4d34ba5... M	drivers/net/wireless/ath/ath9k/main.c
 drivers/net/wireless/ath/ath9k/main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a133878..4d34ba5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1602,6 +1602,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
 
+		/* If channels are the same, then don't actually do anything.
+		 */
+		if (sc->sc_ah->curchan == &sc->sc_ah->channels[pos])
+			goto skip_chan_change;
+
 		aphy->chan_idx = pos;
 		aphy->chan_is_ht = conf_is_ht(conf);
 		if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
-- 
1.7.2.2

