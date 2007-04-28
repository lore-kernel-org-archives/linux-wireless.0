Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:26019 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965971AbXD1QmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 12:42:08 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 5/7] mac80211: set event_capa in iw_range
Date: Sat, 28 Apr 2007 12:36:02 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070428163602.27203.37008.stgit@magic.sourmilk.net>
In-Reply-To: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
References: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This fills in the event capability bitfield in struct iw_range.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211_ioctl.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 91bc633..9f4bde6 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1599,6 +1599,11 @@ static int ieee80211_ioctl_giwrange(struct net_device *dev,
 	range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
 			  IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
 
+	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
+	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWTHRSPY);
+	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
+	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
+
 	return 0;
 }
 

