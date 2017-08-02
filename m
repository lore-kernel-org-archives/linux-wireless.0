Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752954AbdHBKy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 06:54:26 -0400
Date: Wed, 2 Aug 2017 12:53:10 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Michael Skeffington <mike@astro.ai>
Subject: [PATCH v2] mac80211: remove mic_fail_no_key label
Message-ID: <20170802105310.GB4777@redhat.com> (sfid-20170802_125429_754563_1668FB33)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For historic reasons we have separate cases for mic_fail and
mic_fail_no_key. But with current code we can merge those cases,
as we already have NULL key check since commit a66b98db570a
("mac80211: fix rx->key NULL dereference during mic failure").

Patch makes the rx->key->u.tkip.mic_failures statistics
increase on all cases when RX_FLAG_MMIC_ERROR is set.

Reported-by: Michael Skeffington <mike@astro.ai>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2 : use preferred commit format in the changelog.

 net/mac80211/wpa.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 0d722ea..98fd9a0 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -111,7 +111,7 @@
 	 */
 	if (status->flag & (RX_FLAG_MMIC_STRIPPED | RX_FLAG_IV_STRIPPED)) {
 		if (status->flag & RX_FLAG_MMIC_ERROR)
-			goto mic_fail_no_key;
+			goto mic_fail;
 
 		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key &&
 		    rx->key->conf.cipher == WLAN_CIPHER_SUITE_TKIP)
@@ -170,7 +170,6 @@
 mic_fail:
 	rx->key->u.tkip.mic_failures++;
 
-mic_fail_no_key:
 	/*
 	 * In some cases the key can be unset - e.g. a multicast packet, in
 	 * a driver that supports HW encryption. Send up the key idx only if
-- 
1.7.1
