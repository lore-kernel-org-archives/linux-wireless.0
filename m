Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:14754 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZHSAEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 20:04:30 -0400
Received: by ey-out-2122.google.com with SMTP id 22so862866eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 17:04:32 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 2/5] orinoco: add cfg80211 join_ibss and leave_ibss
Date: Wed, 19 Aug 2009 01:04:10 +0100
Message-Id: <1250640253-18434-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Basic ad-hoc support.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/cfg.c  |   57 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/main.c |   12 +++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 09b38e9..253cb4e 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -438,10 +438,67 @@ static int orinoco_disconnect(struct wiphy *wiphy, struct net_device *dev,
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
+	/* Enable cfg80211 notification */
+	priv->connect_commanded = 1;
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
+	/* Disable cfg80211 notification */
+	priv->connect_commanded = 0;
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
 	.set_channel = orinoco_set_channel,
 	.scan = orinoco_scan,
 	.connect = orinoco_connect,
 	.disconnect = orinoco_disconnect,
+	.join_ibss = orinoco_join_ibss,
+	.leave_ibss = orinoco_leave_ibss,
 };
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 5542173..78ef22e 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1283,7 +1283,19 @@ static void orinoco_send_wevents(struct work_struct *work)
 			break;
 		}
 		break;
+
 	case NL80211_IFTYPE_ADHOC:
+		switch (linkstatus) {
+		case HERMES_LINKSTATUS_CONNECTED:
+		case HERMES_LINKSTATUS_AP_IN_RANGE:
+			cfg80211_ibss_joined(priv->ndev, bssid, GFP_KERNEL);
+			break;
+
+		default:
+			break;
+		}
+		break;
+
 	case NL80211_IFTYPE_MONITOR:
 	default:
 		break;
-- 
1.6.3.3

