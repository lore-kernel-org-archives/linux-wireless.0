Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58854 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbXJHKXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 06:23:11 -0400
Subject: [PATCH] mac80211: fix set_channel regression
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Adam Baker <linux@baker-net.org.uk>
In-Reply-To: <1191837339.4063.25.camel@johannes.berg> (sfid-20071008_105523_182608_B8F8BB3E)
References: <200710052319.10600.linux@baker-net.org.uk>
	 (sfid-20071005_231916_055041_CD49F30E)  <1191837339.4063.25.camel@johannes.berg>
	 (sfid-20071008_105523_182608_B8F8BB3E)
Content-Type: text/plain
Date: Mon, 08 Oct 2007 12:23:44 +0200
Message-Id: <1191839024.4063.29.camel@johannes.berg> (sfid-20071008_112313_337156_8CFCB9AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adam Baker reported that the prism2 ioctl removal changed behaviour
in that now the selection order was the other way around as before.
New API is planned but not done yet, so for now just use the first
matching channel in any mode as was previous behaviour with an unset
next_mode.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
NB: untested patch, but I'm confident it will "fix" this behaviour change.

 net/mac80211/ieee80211_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-10-08 12:19:36.565111702 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-10-08 12:20:33.185111702 +0200
@@ -306,6 +306,7 @@ int ieee80211_set_channel(struct ieee802
 				local->oper_channel = chan;
 				local->oper_hw_mode = mode;
 				set++;
+				break;
 			}
 		}
 	}


