Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ananke.telenet-ops.be ([195.130.137.78]:42669 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbXI2NIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 09:08:34 -0400
Message-ID: <46FE4E50.2010300@telenet.be>
Date: Sat, 29 Sep 2007 15:08:32 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi scan question
References: <1190815228.4204.9.camel@johannes.berg>
In-Reply-To: <1190815228.4204.9.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
> When iwlwifi scans in firmware, which MAC address does it use? What if
> you've added multiple virtual interfaces as you said you could support?
> 
> johannes

I couldn't follow all the rest of this thread but i think the patch below
is what you were initially after.
I'll also send this patch to ipw3945-devel mailinglist, so it can take the
same route as my other patches.


Signed-off-by: Ian Schram <ischram@telenet.be>

diff --git a/origin/iwl3945-base.c b/origin/iwl3945-base.c
index 90ad47f..0cdfbd7 100644
--- a/origin/iwl3945-base.c
+++ b/origin/iwl3945-base.c
@@ -6915,7 +6915,7 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,

 	spin_lock_irqsave(&priv->lock, flags);
 	priv->interface_id = conf->if_id;
-
+	memcpy(priv->mac_addr,conf->mac_addr, ETH_ALEN);
 	spin_unlock_irqrestore(&priv->lock, flags);

 	mutex_lock(&priv->mutex);
diff --git a/origin/iwl4965-base.c b/origin/iwl4965-base.c
index e40c159..c3d0845 100644
--- a/origin/iwl4965-base.c
+++ b/origin/iwl4965-base.c
@@ -7305,7 +7305,7 @@ static int iwl_mac_add_interface(struct ieee80211_hw *hw,

 	spin_lock_irqsave(&priv->lock, flags);
 	priv->interface_id = conf->if_id;
-
+	memcpy(priv->mac_addr,conf->mac_addr, ETH_ALEN);
 	spin_unlock_irqrestore(&priv->lock, flags);

 	mutex_lock(&priv->mutex);
