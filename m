Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51468 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbYKCHme (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:42:34 -0500
Subject: Re: 2.6.28-rc2-wl: network lockups with iwl3945
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225697173.3619.23.camel@johannes.berg>
References: <871vxuh70u.fsf@nokia.com>  <87iqr5ri67.fsf@nokia.com>
	 (sfid-20081102_212342_548781_60CD5960)  <1225697173.3619.23.camel@johannes.berg>
Content-Type: multipart/mixed; boundary="=-3Y8Un59AksdYGUECZfvT"
Date: Mon, 03 Nov 2008 15:41:43 +0800
Message-Id: <1225698103.2917.312.camel@debian.sh.intel.com> (sfid-20081103_084238_512133_0D888928)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3Y8Un59AksdYGUECZfvT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2008-11-03 at 15:26 +0800, Johannes Berg wrote:
> I think this has been fixed for iwlagn recently, but I guess iwl3945
> will always be forgotten ;)

Yup. Please try attached patch.

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c
b/drivers/net/wireless/
index 813662f..9787736 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5769,7 +5769,6 @@ static void iwl3945_alive_start(struct
iwl3945_priv *priv)
        if (priv->error_recovering)
                iwl3945_error_recovery(priv);
 
-       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
        return;
 
  restart:
@@ -6014,6 +6013,7 @@ static void iwl3945_bg_alive_start(struct
work_struct *dat
        mutex_lock(&priv->mutex);
        iwl3945_alive_start(priv);
        mutex_unlock(&priv->mutex);
+       ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl3945_bg_rf_kill(struct work_struct *work)



--=-3Y8Un59AksdYGUECZfvT
Content-Disposition: attachment; filename=3945-suspend-fix.patch
Content-Type: text/x-patch; name=3945-suspend-fix.patch; charset=GB2312
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 813662f..9787736 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5769,7 +5769,6 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
 
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 	return;
 
  restart:
@@ -6014,6 +6013,7 @@ static void iwl3945_bg_alive_start(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 	iwl3945_alive_start(priv);
 	mutex_unlock(&priv->mutex);
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl3945_bg_rf_kill(struct work_struct *work)

--=-3Y8Un59AksdYGUECZfvT--

