Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37920 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0LGSjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 13:39:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Bruno Randolf <br1@einfach.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] cfg80211/mac80211: fix-up mesh join/leave build breakage
Date: Tue,  7 Dec 2010 13:38:34 -0500
Message-Id: <1291747114-25476-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1291746592.3607.53.camel@jlt3.sipsolutions.net>
References: <1291746592.3607.53.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Javier Cardona <javier@cozybit.com>

Fix-up build breakage from "cfg80211/mac80211: add mesh join/leave
commands" (commit 29cbe68c516a48a9a88b3226878570c6cbd83c02).

Signed-off-by: Javier Cardona <javier@cozybit.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 2de6976..973fee9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -245,10 +245,12 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				sdata->vif.bss_conf.enable_beacon =
 					!!sdata->u.ibss.presp;
 				break;
+#ifdef CONFIG_MAC80211_MESH
 			case NL80211_IFTYPE_MESH_POINT:
 				sdata->vif.bss_conf.enable_beacon =
 					!!sdata->u.mesh.mesh_id_len;
 				break;
+#endif
 			default:
 				/* not reached */
 				WARN_ON(1);
-- 
1.7.3.2

