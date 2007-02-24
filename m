Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:36897 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbXBXBk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 20:40:28 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HKlsG-0005qY-KI
	for linux-wireless@vger.kernel.org; Fri, 23 Feb 2007 20:38:56 -0500
Received: from localhost ([127.0.0.1] helo=dv.roinet.com)
	by gnu.org with esmtp (Exim 4.66)
	(envelope-from <proski@gnu.org>)
	id 1HKlti-0000qN-Q2
	for linux-wireless@vger.kernel.org; Fri, 23 Feb 2007 20:40:26 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] Suppress sparse message about keyidx - make it signed
To: linux-wireless@vger.kernel.org
Date: Fri, 23 Feb 2007 20:40:26 -0500
Message-ID: <20070224014026.3230.70166.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse reports:
error: dubious bitfield without explicit `signed' or `unsigned'

keyidx should be signed for consistency with definitions in d80211.h,
and it doesn't need to be a bitfield - s8 would do the right thing. 
Reorder the fields to keep the one-bit flags together.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 net/d80211/ieee80211_key.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/d80211/ieee80211_key.h b/net/d80211/ieee80211_key.h
index 5b5c564..2889b10 100644
--- a/net/d80211/ieee80211_key.h
+++ b/net/d80211/ieee80211_key.h
@@ -79,9 +79,9 @@ struct ieee80211_key {
 	/* if the low level driver can provide hardware acceleration it should
 	 * clear this flag */
 	unsigned int force_sw_encrypt:1;
-	int keyidx:8; /* WEP key index */
 	unsigned int default_tx_key:1; /* This key is the new default TX key
 					* (used only for broadcast keys). */
+	s8 keyidx; /* WEP key index */
 
 	u8 key[0];
 };


