Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:45720 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753455Ab2FDUbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 16:31:14 -0400
Date: Mon, 4 Jun 2012 22:31:24 +0200
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: IWLWIFI should depend on SUSPEND
Message-ID: <20120604203124.GA2030@wolfgang> (sfid-20120604_223118_096766_F37A4FDD)
References: <20120519201958.GA2313@wolfgang>
 <1337540836.4585.1.camel@jlt3.sipsolutions.net>
 <1338384543.4511.18.camel@jlt3.sipsolutions.net>
 <20120603091643.GA2191@wolfgang>
 <1338735736.4972.0.camel@jlt3.sipsolutions.net>
 <20120603164905.GA2056@wolfgang>
 <1338748437.15431.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
In-Reply-To: <1338748437.15431.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 03, 2012 at 08:33:57PM +0200, Johannes Berg wrote:
> You're right, it should be CONFIG_PM_SLEEP or something ... I'll have to
> sort it out. It looks like in iwlwifi, the suspend/resume methods are
> under CONFIG_PM_SLEEP, while in mac80211 they're under CONFIG_PM.

Hello Johannes,

I changed the file iwl-agn.c according to your instructions (with #ifdef
CONFIG_PM_SLEEP) for kernel 3.2.18 (patch attached). It works, the error
is gone and wireless is available.

Thank you for your work!

Kind regards,
Sebastian

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwl-agn.c.2.6.18.suspend.diff"

--- drivers/net/wireless/iwlwifi/iwl-agn.c.orig	2012-06-04 18:02:32.996662801 +0200
+++ drivers/net/wireless/iwlwifi/iwl-agn.c	2012-06-04 18:03:10.539993094 +0200
@@ -1696,6 +1696,7 @@
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
+#ifdef CONFIG_PM_SLEEP
 	if (priv->ucode_wowlan.code.len && device_can_wakeup(bus(priv)->dev)) {
 		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 					  WIPHY_WOWLAN_DISCONNECT |
@@ -1712,6 +1713,7 @@
 		hw->wiphy->wowlan.pattern_max_len =
 					IWLAGN_WOWLAN_MAX_PATTERN_LEN;
 	}
+#endif
 
 	if (iwlagn_mod_params.power_save)
 		hw->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;

--OXfL5xGRrasGEqWY--
