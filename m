Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:48364 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3JUR10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:27:26 -0400
Received: by mail-wi0-f179.google.com with SMTP id hm4so4403484wib.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:27:25 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH] cfg80211: clarify DFS / CAC case for the new NO-IR flag
Date: Mon, 21 Oct 2013 19:27:20 +0200
Message-Id: <1382376440-25838-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192729_557396_FCCB061A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the no-ibss and passive-scan flags are bundled
together its a lot easier to deal with the case of when
we support DFS. If DFS is supported on the wiphy and if
the Channel availability check (CAC) has been cleared on
the channel (dfs_state is NL80211_DFS_AVAILABLE) we can
ignore the no-ir flag.

This simplifies the paranoid requirement of bundling
together DFS and NO-IR cases by placing onus on the
DFS implementation. If code paths also want to reuse
knowledge from DFS state machines they must also ensure
that they always look at and monitor the dfs_state.

Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---

This depends on the 2 series I posted just before, the ath
driver updates and the wlan driver merge of consolidating flags.

 include/net/cfg80211.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 54cc9f8..b5cee04 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -92,7 +92,11 @@ enum ieee80211_band {
  *
  * @IEEE80211_CHAN_DISABLED: This channel is disabled.
  * @IEEE80211_CHAN_NO_IR: do not initiate radiation, this includes
- * 	sending probe requests or beaconing.
+ * 	sending probe requests or beaconing. Channels that have
+ * 	%IEEE80211_CHAN_RADAR enabled can ignore this flag if
+ * 	and only if the Channel availability check (CAC) has
+ * 	been cleared on it, that is when the channel's dfs_state
+ * 	is %NL80211_DFS_AVAILABLE.
  * @IEEE80211_CHAN_RADAR: Radar detection is required on this channel.
  * @IEEE80211_CHAN_NO_HT40PLUS: extension channel above this channel
  * 	is not permitted.
-- 
1.8.4.rc3

