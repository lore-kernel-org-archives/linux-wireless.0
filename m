Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXH0LAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 07:00:01 -0400
Subject: Re: [PATCH 05/15] mac80211: remove HW_KEY_IDX_INVALID
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46CF327F.4050002@lwfinger.net>
References: <20070824122705.549190000@sipsolutions.net>
	 <20070824122905.350213000@sipsolutions.net> <46CF327F.4050002@lwfinger.net>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 13:00:59 +0200
Message-Id: <1188212460.7837.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-24 at 14:33 -0500, Larry Finger wrote:

> This patch breaks software encryption in my tests - WPA for b43, WPA and WEP for b43legacy. I 
> haven't looked for the cause yet. That is my next step.

The patch below appears necessary for b43 when I enable sw crypto, but
you shouldn't be having such problems in b43legacy since you don't
support crypto at all; or have you not removed the crypto related code
from xmit.c?

johannes

---
 net/mac80211/tx.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- wireless-dev.orig/net/mac80211/tx.c	2007-08-27 12:06:10.844650841 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-08-27 12:12:46.094650841 +0200
@@ -722,6 +722,15 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 		}
 	}
 
+	/*
+	 * Tell hardware to not encrypt when we had sw crypto.
+	 * Because we use the same flag to internally indicate that
+	 * no encryption should be done, we have to set it after all
+	 * crypto handlers to indicate that we want encryption.
+	 */
+	if (tx->key && !(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		tx->u.tx.control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
+
 	return TXRX_CONTINUE;
 }
 


