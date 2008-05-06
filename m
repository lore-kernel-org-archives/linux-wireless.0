Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57284 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYEFKwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 06:52:39 -0400
Message-ID: <48203857.8060901@trash.net> (sfid-20080506_125151_645871_697F2737)
Date: Tue, 06 May 2008 12:52:07 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: mac80211: mesh hwmp: fix kfree(skb)
Content-Type: multipart/mixed;
 boundary="------------090608040106090900090802"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090608040106090900090802
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------090608040106090900090802
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 02de8f1..a8b2920 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -121,7 +121,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		*pos++ = WLAN_EID_PREP;
 		break;
 	default:
-		kfree(skb);
+		kfree_skb(skb);
 		return -ENOTSUPP;
 		break;
 	}

--------------090608040106090900090802--
