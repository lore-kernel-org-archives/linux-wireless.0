Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37877 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0ILDGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 23:06:52 -0400
Received: by pwi3 with SMTP id 3so1644868pwi.19
        for <linux-wireless@vger.kernel.org>; Sat, 11 Sep 2010 20:06:51 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Steve deRosier <steve@cozybit.com>
Subject: [RFC] mac80211: Add exception for mesh on running check to set beaconing
Date: Sat, 11 Sep 2010 20:06:44 -0700
Message-Id: <1284260804-35113-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a problem with mesh not enabling beacons in select
drivers (notably libertas_tf, though others are likely affected),
due to the addition of the SDATA_STATE_RUNNING flag at the end
of ieee80211_do_open.  The problem is mesh gets started and
wants to send the beacon-enable message to the driver before
SDATA_STATE_RUNNING gets set, but ieee80211_bss_info_change_notify
has the following check before enabling beacons:
!ieee80211_sdata_running(sdata)

This patch adds an exception for mesh to the sdata running check,
to allow mesh to start beacons.

I don't know if this is the best solution, perhaps moving the
SDATA_STATE_RUNNING set, or a driver modification is in order,
but this seems the easiest and least dammaging way to do this.

For reference the SDATA_STATE_RUNNING stuff was added in commit 
34d4bc4d about two weeks ago.

Signed-off-by: Steve deRosier <steve@cozybit.com>

---
 net/mac80211/main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4935b84..d1ad7fa 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -221,7 +221,9 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
-		if (local->quiescing || !ieee80211_sdata_running(sdata) ||
+		if (local->quiescing ||
+		    (!ieee80211_sdata_running(sdata) &&
+		    sdata->vif.type != NL80211_IFTYPE_MESH_POINT) ||
 		    test_bit(SCAN_SW_SCANNING, &local->scanning)) {
 			sdata->vif.bss_conf.enable_beacon = false;
 		} else {
-- 
1.7.0

