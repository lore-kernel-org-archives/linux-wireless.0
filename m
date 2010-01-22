Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0AVUxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 15:53:46 -0500
Subject: Re: Starting hostapd causes kernel panic
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Baier <Markus_Baier@web.de>
Cc: linux-wireless@vger.kernel.org, kalle.valo@iki.fi
In-Reply-To: <loom.20100122T205326-794@post.gmane.org>
References: <loom.20100122T205326-794@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 21:53:43 +0100
Message-ID: <1264193623.2593.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-01-22 at 20:14 +0000, Markus Baier wrote:
> After the latest git pull from wireless-testing
> master-2010-01-14 to master-2010-01-19
> the start of hostapd causes kernel panic.
> 
> Tested with wireless-testing master-2010-01-19
> and hostapd 0.6.9 / 0.7.0

Alright, managed to reproduce it in kvm -- hostapd was useful for that.

Try this please.

johannes

--- wireless-testing.orig/net/mac80211/tx.c	2010-01-22 21:44:40.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2010-01-22 21:49:50.000000000 +0100
@@ -557,7 +557,7 @@ ieee80211_tx_h_select_key(struct ieee802
 			break;
 		}
 
-		if (!skip_hw &&
+		if (!skip_hw && tx->key &&
 		    tx->key->conf.flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 			info->control.hw_key = &tx->key->conf;
 	}


