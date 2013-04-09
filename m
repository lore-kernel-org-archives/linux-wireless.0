Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55483 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3DIGva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 02:51:30 -0400
Message-ID: <1365490278.8465.1.camel@jlt4.sipsolutions.net> (sfid-20130409_085133_634901_B72A0BBF)
Subject: Re: [wireless-regdb] [PATCH 2/3] wireless-regdb: enable VHT80 when
 world roaming
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linville@tuxdriver.com, wireless-regdb@lists.infradead.org,
	kandala@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	qca_vkondrat@qca.qualcomm.com, green@qca.qualcomm.com,
	yunsenw@qca.qualcomm.com
Date: Tue, 09 Apr 2013 08:51:18 +0200
In-Reply-To: <1365486778-2336-3-git-send-email-mcgrof@do-not-panic.com>
References: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com>
	 <1365486778-2336-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 22:52 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> For VHT, the wider bandwidths (up to 160 MHz) need
> to be allowed. Since world roaming only covers the
> case of connecting to an AP, it can be opened up
> there, we will rely on the AP to know the local
> regulations.
> 
> Based on a patch by Johannes Berg for upstream Linux.

> --- a/db.txt
> +++ b/db.txt
> @@ -6,10 +6,10 @@ country 00:
>  	# Channel 14. Only JP enables this and for 802.11b only
>  	(2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
>  	# Channel 36 - 48
> -	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
> +	(5170 - 5250 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
>  	# NB: 5260 MHz - 5700 MHz requies DFS
>  	# Channel 149 - 165
> -	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
> +	(5735 - 5835 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS

I also have a separate upstream patch that I haven't sent here yet to
enable 160 MHz by enabling the radar channels (passively), see below;
any thoughts on that?

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -184,11 +184,21 @@ static const struct ieee80211_regdomain
world_regdom = {
                        NL80211_RRF_NO_IBSS |
                        NL80211_RRF_NO_OFDM),
                /* IEEE 802.11a, channel 36..48 */
-               REG_RULE(5180-10, 5240+10, 80, 6, 20,
+               REG_RULE(5180-10, 5240+10, 160, 6, 20,
                         NL80211_RRF_PASSIVE_SCAN |
                         NL80211_RRF_NO_IBSS),
 
-               /* NB: 5260 MHz - 5700 MHz requires DFS */
+               /* IEEE 802.11a, channel 52..64 - DFS required */
+               REG_RULE(5260-10, 5320+10, 160, 6, 20,
+                       NL80211_RRF_PASSIVE_SCAN |
+                       NL80211_RRF_NO_IBSS |
+                       NL80211_RRF_DFS),
+
+               /* IEEE 802.11a, channel 100..144 - DFS required */
+               REG_RULE(5500-10, 5720+10, 160, 6, 20,
+                       NL80211_RRF_PASSIVE_SCAN |
+                       NL80211_RRF_NO_IBSS |
+                       NL80211_RRF_DFS),
 
                /* IEEE 802.11a, channel 149..165 */
                REG_RULE(5745-10, 5825+10, 80, 6, 20,

johannes

