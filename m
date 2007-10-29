Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:46650 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbXJ2Q6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 12:58:25 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1ImXwW-00025L-R0
	for linux-wireless@vger.kernel.org; Mon, 29 Oct 2007 12:58:24 -0400
Subject: Re: iwl3945 lists supported rates backwards
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: dragoran <drago01@gmail.com>,
	Larry Finger <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1193667153.5197.48.camel@johannes.berg>
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	 <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
	 <4719BA96.3010609@gmail.com>  <1193644281.27622.12.camel@dv>
	 (sfid-20071029_075130_793419_DFA19205)  <1193667153.5197.48.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 12:58:15 -0400
Message-Id: <1193677095.11181.2.camel@dv> (sfid-20071029_165844_385100_2C9CD5AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-10-29 at 15:12 +0100, Johannes Berg wrote:
> > With disable_hw_scan=1, probe requests have the same problem as the
> > association requests, namely they don't have CCK rates in the supported
> > rates:
> 
> This is because mac80211 uses the order in which the rates are
> registered, and with iwlwifi that is "OFDM, CCK". See
> iwl_init_hw_rates() and iwl_init_geos().

Yes, it's working now!  Thank you!  That's the patch I actually applied:

--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5414,10 +5414,10 @@ static int iwl_init_geos(struct iwl_priv *priv)
 	 * is supported by a mode -- and the first match is taken
 	 */
 
-	if (modes[G].num_channels)
-		ieee80211_register_hwmode(priv->hw, &modes[G]);
 	if (modes[B].num_channels)
 		ieee80211_register_hwmode(priv->hw, &modes[B]);
+	if (modes[G].num_channels)
+		ieee80211_register_hwmode(priv->hw, &modes[G]);
 	if (modes[A].num_channels)
 		ieee80211_register_hwmode(priv->hw, &modes[A]);
 

Should I submit it formally?

-- 
Regards,
Pavel Roskin

