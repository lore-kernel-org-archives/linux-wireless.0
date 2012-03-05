Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 93-97-239-3.zone5.bethere.co.uk ([93.97.239.3]:34751 "EHLO
	pond-weed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571Ab2CEWCn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 17:02:43 -0500
Date: Mon, 5 Mar 2012 21:39:56 +0000
From: John Williams <john@pond-weed.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8192cu driver ignores eeprom channel plan
Message-ID: <20120305213956.7c383096@buffy.scoobygang> (sfid-20120305_230247_565691_38120BA1)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,

The various rtl8192xx drivers read the manufacturer-set channel plan
into efuse.eeprom_channelplan, but ignore this and use
efuse.channel_plan (which is never initialized) when deciding which
channels to allow. The patch below allowed my device, purchased in
Europe, to see channels 12 and 13 when configured with "iw reg set EC"

It needs more work in order to accept being configured for arbitrary countries: would you like me to work on a more comprehensive patch?

Signed-off-by John Williams <john@pond-weed.com>

--- linux-3.2/drivers/net/wireless/rtlwifi/regd.c.orig
+++ linux-3.2/drivers/net/wireless/rtlwifi/regd.c
@@ -405,7 +405,7 @@
 		return -EINVAL;
 
 	/* init country_code from efuse channel plan */
-	rtlpriv->regd.country_code = rtlpriv->efuse.channel_plan;
+	rtlpriv->regd.country_code = rtlpriv->efuse.eeprom_channelplan;
 
 	RT_TRACE(rtlpriv, COMP_REGD, DBG_TRACE,
 		 (KERN_DEBUG "rtl: EEPROM regdomain: 0x%0x\n",

