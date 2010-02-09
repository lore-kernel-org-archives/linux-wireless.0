Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plexity.net ([206.123.115.38]:59505 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230Ab0BIVfv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 16:35:51 -0500
Date: Tue, 9 Feb 2010 13:35:43 -0800
From: Deepak Saxena <dsaxena@plexity.net>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH] Add Station and AdHoc mode support to libertas_tf
Message-ID: <20100209213543.GA31890@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Add support for using the libertas_tf driver on a managed 
or ad-hoc network.

Signed-off-by: Deepak Saxena <dsaxena@laptop.org>

---
Ran basic network tests on an OLPC XO-1 laptop. Suspend/resume causes a 
crash but w/o this patch, the driver does not present a configureable 
interface.  (wmaster0 appears but is listed as having no "wireless 
extensions". Fixing this is on my queue).

diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 26a1abd..9123d86 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -555,6 +555,9 @@ struct lbtf_private *lbtf_add_card(void *card, struct device *dmdev)
 	priv->band.n_channels = ARRAY_SIZE(lbtf_channels);
 	priv->band.channels = priv->channels;
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+        hw->wiphy->interface_modes =
+                BIT(NL80211_IFTYPE_STATION) |
+                BIT(NL80211_IFTYPE_ADHOC);
 	skb_queue_head_init(&priv->bc_ps_buf);
 
 	SET_IEEE80211_DEV(hw, dmdev);
