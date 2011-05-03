Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:58814 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419Ab1ECSkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 14:40:23 -0400
Received: by mail-ew0-f43.google.com with SMTP id 20so153344ewy.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 11:40:20 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	ido@wizery.com
Subject: [PATCH] mac80211: don't start the dynamic ps timer if not associated
Date: Tue,  3 May 2011 21:40:08 +0300
Message-Id: <1304448008-7816-1-git-send-email-coelho@ti.com> (sfid-20110503_204025_199020_48E5A151)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we are disconnecting, we set PS off, but this happens before we
send the deauth/disassoc request.  When the deauth/disassoc frames are
sent, we trigger the dynamic ps timer, which then times out and turns
PS back on.  Thus, PS remains on after disconnecting, causing problems
when associating again.

This can be fixed by preventing the timer to start when we're not
associated anymore.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 net/mac80211/tx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e3e3aa1..21accf8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -237,6 +237,10 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 				     &local->dynamic_ps_disable_work);
 	}
 
+	/* Don't restart the timer if we're not disassociated */
+	if (!ifmgd->associated)
+		return TX_CONTINUE;
+
 	mod_timer(&local->dynamic_ps_timer, jiffies +
 		  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 
-- 
1.7.1

