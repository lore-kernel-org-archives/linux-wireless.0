Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab0FRJ2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 05:28:52 -0400
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1275395142.14385.6.camel@maxim-laptop>
References: <1275395142.14385.6.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 11:28:47 +0200
Message-ID: <1276853327.3638.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim,

> 2. mulicast/broadcast is broken.
> this results in DHCP non working on open access point.
> It seems that DHCP does work on my home wireless, but avahi-autoipd
> doesn't see any neighbours, and this is annoying.
> It can be worked around by doing (sudo ifconfig wlan0 promisc)

Reinette has reverted the patch in iwlwifi-2.6, but I think I actually
just now identified the problem. Can you try one or two things for me?

 1) with the patch reverted, which is what presumably you're running
    now, can you try
    ifconfig wlan0 allmulti
    ifconfig wlan0 -allmulti

    I think this will *break* the driver right now.

 2) with the patch *not* reverted, apply the patch below and see if that
    fixes the problem as well (if it gets mangled, just remove the one
    CHK() line manually)

Actually, (2) is obviously more important to me, but (1) would indicate
that my guess is correct wrt. what's causing the problem

Thanks,
Johannes

---
 drivers/net/wireless/iwlwifi/iwl-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2010-06-18 11:22:34.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2010-06-18 11:27:00.000000000 +0200
@@ -1331,7 +1331,6 @@ void iwl_configure_filter(struct ieee802
 			changed_flags, *total_flags);
 
 	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
-	CHK(FIF_ALLMULTI, RXON_FILTER_ACCEPT_GRP_MSK);
 	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
 	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
 
@@ -1346,6 +1345,12 @@ void iwl_configure_filter(struct ieee802
 
 	mutex_unlock(&priv->mutex);
 
+	/*
+	 * Receiving all multicast frames is always enabled by the
+	 * default flags setup in iwl_connection_init_rx_config()
+	 * since we currently do not support programming multicast
+	 * filters into the device.
+	 */
 	*total_flags &= FIF_OTHER_BSS | FIF_ALLMULTI | FIF_PROMISC_IN_BSS |
 			FIF_BCN_PRBRESP_PROMISC | FIF_CONTROL;
 }



