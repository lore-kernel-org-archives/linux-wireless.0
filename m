Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43660 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2ENFYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 01:24:14 -0400
Received: by dady13 with SMTP id y13so5440428dad.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 May 2012 22:24:13 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH] mac80211: allow channel change while mesh is down
Date: Sun, 13 May 2012 22:24:08 -0700
Message-Id: <1336973048-11173-1-git-send-email-thomas@cozybit.com> (sfid-20120514_072418_000796_11ECDD52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow channel change on a mesh interface if the interface is up and no
mesh is started.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/chan.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c76cf72..f0f87e5 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -41,6 +41,10 @@ __ieee80211_get_channel_mode(struct ieee80211_local *local,
 			if (!sdata->u.ap.beacon)
 				continue;
 			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			if (!sdata->wdev.mesh_id_len)
+				continue;
+			break;
 		default:
 			break;
 		}
-- 
1.7.5.4

