Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:33658 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758628Ab0EUSaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 14:30:25 -0400
Date: Fri, 21 May 2010 11:28:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: fix mac80211.h kernel-doc warnings
Message-Id: <20100521112833.316ccc60.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in mac80211.h:

Warning(include/net/mac80211.h:838): No description found for parameter 'ap_addr'
Warning(include/net/mac80211.h:1726): No description found for parameter 'get_survey'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/net/mac80211.h |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.34-git6.orig/include/net/mac80211.h
+++ linux-2.6.34-git6/include/net/mac80211.h
@@ -815,6 +815,7 @@ enum ieee80211_key_flags {
  *	encrypted in hardware.
  * @alg: The key algorithm.
  * @flags: key flags, see &enum ieee80211_key_flags.
+ * @ap_addr: AP's MAC address
  * @keyidx: the key index (0-3)
  * @keylen: key material length
  * @key: key material. For ALG_TKIP the key is encoded as a 256-bit (32 byte)
@@ -1638,6 +1639,8 @@ enum ieee80211_ampdu_mlme_action {
  *	Returns a negative error code on failure.
  *	The callback must be atomic.
  *
+ * @get_survey: Return per-channel survey information
+ *
  * @rfkill_poll: Poll rfkill hardware state. If you need this, you also
  *	need to set wiphy->rfkill_poll to %true before registration,
  *	and need to call wiphy_rfkill_set_hw_state() in the callback.
