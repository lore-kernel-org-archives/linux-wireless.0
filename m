Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab0CSLBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 07:01:16 -0400
Date: Fri, 19 Mar 2010 11:59:07 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [RFC PATCH 2/2] iwlwifi: implement disabling QoS
Message-ID: <20100319105906.GB4915@dhcp-lab-161.englab.brq.redhat.com>
References: <20100309132113.GA2462@dhcp-lab-161.englab.brq.redhat.com> <20100310152024.GB2969@dhcp-lab-161.englab.brq.redhat.com> <1268265597.4192.3.camel@jlt3.sipsolutions.net> <20100311095656.GB4682@dhcp-lab-161.englab.brq.redhat.com> <1268319960.4413.1.camel@jlt3.sipsolutions.net> <20100316145114.GA2496@dhcp-lab-161.englab.brq.redhat.com> <1268774282.4054.1.camel@jlt3.sipsolutions.net> <20100317092612.GB3726@dhcp-lab-161.englab.brq.redhat.com> <1268841106.5989.1.camel@jlt3.sipsolutions.net> <20100319105612.GA4915@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100319105612.GA4915@dhcp-lab-161.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 112149e..75436b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2409,6 +2409,15 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
 		dev_kfree_skb(priv->ibss_beacon);
 		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
 	}
+	
+	if (changes & BSS_CHANGED_QOS_DISABLED) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->qos_data.qos_active = 0;
+		iwl_activate_qos(priv, 1);
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
 
 	if (changes & BSS_CHANGED_BEACON_INT) {
 		priv->beacon_int = bss_conf->beacon_int;
-- 
1.6.2.5

