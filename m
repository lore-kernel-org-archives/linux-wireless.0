Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab1BWLrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 06:47:08 -0500
Subject: Re: IBSS merge
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	Bruno Randolf <br1@einfach.org>
In-Reply-To: <1298460913.4122.2.camel@jlt3.sipsolutions.net>
References: <1298460913.4122.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 12:47:05 +0100
Message-ID: <1298461625.4122.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-23 at 12:35 +0100, Johannes Berg wrote:
> Hi,
> 
> I'm confused about our IBSS merge code.
> 
> ieee80211_rx_bss_info:
> 
> ...
>         /* same BSSID */
>         if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
>                 goto put_bss;
> ...
>         /* give slow hardware some time to do the TSF sync */
>         if (rx_timestamp < IEEE80211_IBSS_MERGE_DELAY)
>                 goto put_bss;
> ...
> 
> 
> Both of this was added by Alina, but why did the patch adding the first
> part not remove the second part again? If we suddenly need to adopt a
> new BSSID due to higher TSF why wait for the HW to sync first?
> 
> It seems the latter was a workaround for syncing over and over again
> when the HW hadn't caught up yet, but that doesn't seem worthwhile any
> more since we no longer re-sync with the same BSSID?

So why not do

---
 net/mac80211/ibss.c |    5 -----
 1 file changed, 5 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2011-02-23 12:30:32.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2011-02-23 12:46:22.000000000 +0100
@@ -31,7 +31,6 @@
 #define IEEE80211_IBSS_JOIN_TIMEOUT (7 * HZ)
 
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
-#define IEEE80211_IBSS_MERGE_DELAY 0x400000
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
@@ -397,10 +396,6 @@ static void ieee80211_rx_bss_info(struct
 	       jiffies);
 #endif
 
-	/* give slow hardware some time to do the TSF sync */
-	if (rx_timestamp < IEEE80211_IBSS_MERGE_DELAY)
-		goto put_bss;
-
 	if (beacon_timestamp > rx_timestamp) {
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "%s: beacon TSF higher than "


