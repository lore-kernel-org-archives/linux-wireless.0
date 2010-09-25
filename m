Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:44882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab0IYB76 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 21:59:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	Amod Bodas <amod.bodas@atheros.com>,
	Vasanth Thiagarajan <vasanth.thiagarajan@atheros.com>
Subject: [PATCH] mac80211: fix offchannel assumption upon association
Date: Fri, 24 Sep 2010 21:59:57 -0400
Message-Id: <1285379997-1544-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Association is dealt with as an atomic offchannel operation,
we do this because we don't know we are associated until we
get the associatin response from the AP. When we do get the
associatin response though we were never clearing the offchannel
state. This has a few implications, we told drivers we were
still offchannel, and the first configured TX power for the
channel does not take into account any power constraints.

For ath9k this meant ANI calibration would not start upon
association, and we'd have to wait until the first bgscan
to be triggered. There may be other issues this resolves
but I'm too lazy to colb the code to check.

Cc: stable@kernel.org
Cc: Amod Bodas <amod.bodas@atheros.com>
Cc: Vasanth Thiagarajan <vasanth.thiagarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Oops, sent to the wrong people, now adding the right folks.

 net/mac80211/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7c85426..e24fa5b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -110,7 +110,8 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		chan = scan_chan;
 		channel_type = NL80211_CHAN_NO_HT;
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
-	} else if (local->tmp_channel) {
+	} else if (local->tmp_channel &&
+		   local->oper_channel != local->tmp_channel) {
 		chan = scan_chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
-- 
1.7.0.4

