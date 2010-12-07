Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:35311 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab0LGSl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 13:41:58 -0500
Received: by gwb20 with SMTP id 20so254835gwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 10:41:57 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bruno Randolf <br1@einfach.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix compilation error when mesh is disabled
Date: Tue,  7 Dec 2010 10:41:47 -0800
Message-Id: <1291747307-15159-1-git-send-email-javier@cozybit.com>
In-Reply-To: <1291746592.3607.53.camel@jlt3.sipsolutions.net>
References: <1291746592.3607.53.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wrap mesh sections inside CONFIG_MAC80211_MESH to fix compilation
problems reported by Stephen Rothwell, Larry Finger and Bruno Randolf.
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
1.7.1

