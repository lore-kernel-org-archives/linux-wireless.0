Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab2AKI1X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 03:27:23 -0500
Date: Wed, 11 Jan 2012 09:26:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: fix rx->key NULL pointer dereference in
 promiscuous mode
Message-ID: <20120111082639.GA2624@redhat.com> (sfid-20120111_092727_097962_1BDE0147)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since:

commit 816c04fe7ef01dd9649f5ccfe796474db8708be5
Author: Christian Lamparter <chunkeey@googlemail.com>
Date:   Sat Apr 30 15:24:30 2011 +0200

    mac80211: consolidate MIC failure report handling

is possible to that we dereference rx->key == NULL when driver set
RX_FLAG_MMIC_STRIPPED and not RX_FLAG_IV_STRIPPED and we are in
promiscuous mode. This happen with rt73usb and rt61pci at least.

Before the commit we always check rx->key against NULL, so I assume
fix should be done in mac80211 (also mic_fail path has similar check).

References:
https://bugzilla.redhat.com/show_bug.cgi?id=769766
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2012-January/004395.html

Cc: stable@vger.kernel.org # 3.0+
Reported-by: Stuart D Gathman <stuart@gathman.org>
Reported-by: Kai Wohlfahrt <kai.scorpio@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/wpa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 93aab07..422b798 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -106,7 +106,7 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
 		if (status->flag & RX_FLAG_MMIC_ERROR)
 			goto mic_fail;
 
-		if (!(status->flag & RX_FLAG_IV_STRIPPED))
+		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key)
 			goto update_iv;
 
 		return RX_CONTINUE;
-- 
1.7.1

