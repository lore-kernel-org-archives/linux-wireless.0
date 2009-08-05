Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35125 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZHEUdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:33:06 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so291644ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:33:07 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 2/4] orinoco: add cfg80211 join_ibss and leave_ibss
Date: Wed,  5 Aug 2009 21:32:50 +0100
Message-Id: <1249504372-17063-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
References: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Basic ad-hoc support.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/cfg.c |   51 ++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 56bd4f1..84a7884 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -390,9 +390,60 @@ static int orinoco_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	return err;
 }
 
+static int orinoco_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+			     struct cfg80211_ibss_params *params)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	unsigned long lock;
+	int err;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	/* Setup the requested parameters in priv. If the card is not
+	 * capable, then the driver will just ignore the settings that
+	 * it can't do. */
+
+	err = __orinoco_connect(wiphy, params->channel, params->bssid,
+				params->ssid, params->ssid_len);
+	if (err)
+		goto out;
+
+	/* Ignore information elements and beacon interval */
+
+	err = orinoco_commit(priv);
+ out:
+	orinoco_unlock(priv, &lock);
+
+	return err;
+}
+
+static int orinoco_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	unsigned long lock;
+	int err;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	/* Do we need to disassociate as well? */
+
+	memset(priv->desired_bssid, 0, ETH_ALEN);
+	memset(priv->desired_essid, 0, sizeof(priv->desired_essid));
+
+	err = orinoco_commit(priv);
+
+	orinoco_unlock(priv, &lock);
+
+	return err;
+}
+
 const struct cfg80211_ops orinoco_cfg_ops = {
 	.change_virtual_intf = orinoco_change_vif,
 	.scan = orinoco_scan,
 	.connect = orinoco_connect,
 	.disconnect = orinoco_disconnect,
+	.join_ibss = orinoco_join_ibss,
+	.leave_ibss = orinoco_leave_ibss,
 };
-- 
1.6.3.3

