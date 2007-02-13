Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:56614 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105AbXBMGrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 01:47:14 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HGrQI-0000Fz-NY
	for linux-wireless@vger.kernel.org; Tue, 13 Feb 2007 01:45:54 -0500
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
From: Pavel Roskin <proski@gnu.org>
To: "Hesse, Christian" <mail@earthworm.de>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <200702111417.38336.mail@earthworm.de>
References: <45CCE3CA.4050904@linux.intel.com>
	 <200702101424.00156.mail@earthworm.de> <1171155323.5573.7.camel@dv>
	 <200702111417.38336.mail@earthworm.de>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 01:47:09 -0500
Message-Id: <1171349229.2326.91.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On Sun, 2007-02-11 at 14:17 +0100, Hesse, Christian wrote:
> lsmod shows a use count of 4294967295 (2^32 - 1), no oopses or the like. This 
> is reproducable all the time.

Although I cannot reproduce the problem (I'm on current wireless-dev),
here's my interpretation.

The iwlwifi driver includes both a driver and a rate control algorithm.
It passes THIS_MODULE (i.e. a handle to itself) to the generic rate
control code, which locks the caller i.e. iwlwifi.  Therefore, iwlwifi
has locked itself in memory.

To counteract that, the driver "puts" the module, i.e. decreases its use
count after the rate control is registered.  Conversely, the module
"gets" itself when the rate control is unregistered.

One thing that is clearly wrong is that try_module_get() comes after
ieee80211_rate_control_unregister(), not before.  This means that the
use count would go negative between those calls.  If the kernel starts
checking for this, the driver is in trouble.

Further, why do we need this self-locking/unlocking trick?  The driver
can just set priv->rate_control.module to NULL and prevent self-locking.

It would only make sense to put THIS_MODULE there is the rate control
were implemented as a separate module, which it probably a good idea in
the long term.

But a simple fix would be just to get rid of all references to
THIS_MODULE and let the kernel do the right thing.

Most likely, your kernel doesn't use the priv->rate_control.module field
to lock the module, so it would help in your case.

Please try this patch:

diff --git a/origin/base.c b/origin/base.c
index 8f97491..62751e5 100644
--- a/origin/base.c
+++ b/origin/base.c
@@ -9771,8 +9771,6 @@ static void ipw_bg_alive_start(struct work_struct *work)
 			return;
 		}
 
-		module_put(THIS_MODULE);
-
 		mutex_lock(&priv->mutex);
 		priv->netdev_registered = 1;
 
@@ -11966,7 +11964,7 @@ static struct ieee80211_rate *ipw_get_tx_rate(void *priv_rate,
 static char* rate_scale_name = "iwlwifi rate-scale";
 void ipw_set_rate_scale_handlers(struct ipw_priv *priv)
 {
-	priv->rate_control.module = THIS_MODULE;
+	priv->rate_control.module = NULL;
 	priv->rate_control.name = rate_scale_name;
 	priv->rate_control.tx_status = ipw_rate_scale_tx_resp_handle;
 	priv->rate_control.get_rate = ipw_get_tx_rate;
@@ -12338,7 +12336,6 @@ static void ipw_pci_remove(struct pci_dev *pdev)
 
 	if (priv->netdev_registered) {
 		ieee80211_rate_control_unregister(&priv->rate_control);
-		try_module_get(THIS_MODULE);
 
 		ieee80211_unregister_hw(priv->ieee);
 	}

-- 
Regards,
Pavel Roskin

