Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:44265 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760733AbXGZQWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 12:22:38 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IE68X-0005y1-Fh
	for linux-wireless@vger.kernel.org; Thu, 26 Jul 2007 12:24:25 -0400
Subject: Re: Request for help...
From: Pavel Roskin <proski@gnu.org>
To: Axj <axjslack@bluebottle.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200707261511.l6QFB2jK015121@mi0.bluebottle.com>
References: <1185289332.46a61474a444c@mail.bluebottle.com>
	 <1185355931.3131.13.camel@debian.sh.intel.com>
	 <200707261511.l6QFB2jK015121@mi0.bluebottle.com>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 12:22:34 -0400
Message-Id: <1185466954.14557.5.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-07-26 at 08:10 -0700, Axj wrote:

> I  saw onother exit of thje driver, 1.0.0, but I don't trust so much
> (at the momente the compination of mac80211 ver 8.0.2 and
> iwlwifi-0.0.42 work, even if the led doesn't work ad It's impossible
> to set an "Ad-Hoc" connection. )

Actually, it's direct continuation of the 0.0.x series.  It's
unfortunate that the complexity of the build system makes you mistrust
the recent code, although I can relate.  I hope it will be remedied
quickly.

It's possible to compile the 1.0.x driver against recent unpatched
kernels, even against the standard Fedora 7 kernel, by stripping support
for Intel's rate control algorithm:

diff --git a/origin/Makefile b/origin/Makefile
index 8c0bdc7..c5d966f 100644
--- a/origin/Makefile
+++ b/origin/Makefile
@@ -10,7 +10,7 @@
 # -jpk
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
-iwl3945-objs		= base-3945.o iwl-3945.o iwl-3945-rs.o
+iwl3945-objs		= base-3945.o iwl-3945.o
 CFLAGS_iwl-3945.o	= -DIWL=3945
 CFLAGS_iwl-3945-rs.o	= -DIWL=3945
 CFLAGS_base-3945.o	= -DIWL=3945 -D"KBUILD_MODNAME=KBUILD_STR(iwl3945)"
@@ -19,7 +19,7 @@ $(obj)/base-3945.o: $(src)/base.c FORCE
 	$(call if_changed_rule,cc_o_c)
 
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
-iwl4965-objs		= base-4965.o iwl-4965.o iwl-4965-rs.o
+iwl4965-objs		= base-4965.o iwl-4965.o
 CFLAGS_iwl-4965.o	= -DIWL=4965
 CFLAGS_iwl-4965-rs.o	= -DIWL=4965
 CFLAGS_base-4965.o	= -DIWL=4965 -D"KBUILD_MODNAME=KBUILD_STR(iwl4965)"
diff --git a/origin/base.c b/origin/base.c
index eda467e..ee6ac8f 100644
--- a/origin/base.c
+++ b/origin/base.c
@@ -6284,7 +6284,6 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		/* Unlock so any user space entry points can call back into
 		 * the driver without a deadlock... */
 		mutex_unlock(&priv->mutex);
-		iwl_rate_control_register();
 		rc = ieee80211_register_hw(priv->hw);
 		priv->hw->conf.beacon_int = 100;
 		mutex_lock(&priv->mutex);
@@ -6950,7 +6949,6 @@ static void iwl_bg_post_associate(struct work_struct *data)
 				  (priv->phymode == MODE_ATHEROS_TURBO)) ?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
 				 CMD_ASYNC);
-		iwl_rate_scale_init(priv->hw, IWL_AP_ID);
 
 		break;
 
@@ -6967,7 +6965,6 @@ static void iwl_bg_post_associate(struct work_struct *data)
 				  (priv->phymode == MODE_ATHEROS_TURBO)) ?
 				 IWL_RATE_6M_PLCP : IWL_RATE_1M_PLCP,
 				 CMD_ASYNC);
-		iwl_rate_scale_init(priv->hw, IWL_STA_ID);
 		iwl_send_beacon_cmd(priv);
 
 		break;
@@ -7915,8 +7912,7 @@ static ssize_t show_rs_window(struct device *d,
 			      struct device_attribute *attr,
 			      char *buf)
 {
-	struct iwl_priv *priv = d->driver_data;
-	return iwl_fill_rs_info(priv->hw, buf, IWL_AP_ID);
+	return 0;
 }
 static DEVICE_ATTR(rs_window, S_IRUGO, show_rs_window, NULL);
 
@@ -8851,7 +8847,6 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 
 	if (priv->mac80211_registered) {
 		ieee80211_unregister_hw(priv->hw);
-		iwl_rate_control_unregister();
 	}
 
 	/* ieee80211_unregister_hw calls d_stop, which flushes


-- 
Regards,
Pavel Roskin

