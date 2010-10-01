Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53617 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0JAVFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 17:05:22 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org
Subject: [PATCH v3 3/3] mac80211: move to the home channel for disassociation when roaming
Date: Fri,  1 Oct 2010 17:05:21 -0400
Message-Id: <1285967121-16665-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1285967121-16665-1-git-send-email-lrodriguez@atheros.com>
References: <1285967121-16665-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we roam from one AP to another within an ESS we keep
our association alive with the old AP while we we authenticate
with the new AP. Once we have been authenticated we then proceed
to associate with the new AP but prior to that we disassociate
with the AP, which includes tearing down our BA agreements if
we had any.

mac80211 uses a queue for authentication and association frames
in case we have to go offchannel for them. In case two work items
happen to be offchannel on the same channel we remain offchannel.
This works well unless we need to send some frames to the old
AP when doing some of this work. In the case of roaming we will
try to disassociate from the old AP right before we associate
but need to ensure we go back to the operating channel prior to
trying to disassociating from the old AP.

This patch has a fix for kernels >= v2.6.34

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7eff124..a833255 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2185,6 +2185,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_work *wk;
 	const u8 *ssid;
 	int i;
@@ -2203,6 +2204,14 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			return -EALREADY;
 		}
 
+		/*
+		 * right before this was authentication, that was on
+		 * the same the wk->chan so we need to ensure we temporarily
+		 * go back to the operating channel to send the disassocation.
+		 */
+		local->tmp_channel = NULL;
+		ieee80211_hw_config(local, 0);
+
 		/* Trying to reassociate - clear previous association state */
 		ieee80211_set_disassoc(sdata, true);
 	}
-- 
1.7.0.4

