Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbXJLTX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 15:23:57 -0400
Subject: [PATCH v2] mac80211: fix set_channel regression
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Marcus Better <marcus@better.se>
In-Reply-To: <1192216713.4770.58.camel@johannes.berg> (sfid-20071012_201826_454397_3502935A)
References: <fdqhn4$qab$1@sea.gmane.org>
	 <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
	 <1192094159.4770.21.camel@johannes.berg>
	 <200710112005.56101.IvDoorn@gmail.com>
	 <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com>
	 <1192216713.4770.58.camel@johannes.berg>
	 (sfid-20071012_201826_454397_3502935A)
Content-Type: text/plain
Date: Fri, 12 Oct 2007 21:24:07 +0200
Message-Id: <1192217047.4770.61.camel@johannes.berg> (sfid-20071012_202400_396535_913529DE)
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
Michael Wu just pointed out the error in my previous patch. I missed the
outer loop, we need to break from it as well.

 net/mac80211/ieee80211_ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-10-10 12:29:49.330680979 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-10-12 21:22:20.838530346 +0200
@@ -305,9 +305,12 @@ int ieee80211_set_channel(struct ieee802
 			    ((chan->chan == channel) || (chan->freq == freq))) {
 				local->oper_channel = chan;
 				local->oper_hw_mode = mode;
-				set++;
+				set = 1;
+				break;
 			}
 		}
+		if (set)
+			break;
 	}
 
 	if (set) {


