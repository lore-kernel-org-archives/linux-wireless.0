Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56315 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab2GIQtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 12:49:47 -0400
Received: by weyx8 with SMTP id x8so1353605wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 09:49:46 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] mac80211: fix invalid band deref building preq IEs
Date: Mon,  9 Jul 2012 19:49:41 +0300
Message-Id: <1341852581-8456-1-git-send-email-arik@wizery.com> (sfid-20120709_184950_825071_1323F040)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function building probe-request IEs does not validate the band is
supported before dereferencing it. This can result in a panic when
all bands are traversed, as done during sched-scan start.

Warn when this happens and return an empty probe request. Also fix
sched-scan to not waste memory on unsupported bands.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
This is not cc stable since the panic only started happening once
the 60Ghz band was added. Apparently all sched-scan drivers supported
all possible bands until then.


 net/mac80211/scan.c |    3 +++
 net/mac80211/util.c |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 379f178..1ff04f6 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -928,6 +928,9 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 	}
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		if (!local->hw.wiphy->bands[i])
+			continue;
+
 		local->sched_scan_ies.ie[i] = kzalloc(2 +
 						      IEEE80211_MAX_SSID_LEN +
 						      local->scan_ies_len +
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 64493a7..503412a 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -999,6 +999,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	int ext_rates_len;
 
 	sband = local->hw.wiphy->bands[band];
+	if (!WARN_ON_ONCE(sband))
+		return 0;
 
 	pos = buffer;
 
-- 
1.7.9.5

