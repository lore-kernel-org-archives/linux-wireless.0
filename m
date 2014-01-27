Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:49231 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaA0N15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 08:27:57 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Sujith Manoharan <sujith@msujith.org>
Subject: Re: IBSS can't beacon after rejoin / regression in TSF syncing code?
Date: Mon, 27 Jan 2014 14:27:51 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
References: <201401241826.45121.sw@simonwunderlich.de> <21221.57261.792711.70974@gargle.gargle.HOWL>
In-Reply-To: <21221.57261.792711.70974@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201401271427.51372.sw@simonwunderlich.de> (sfid-20140127_142800_509485_5413F4C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Sujith,

> Simon Wunderlich wrote:
> > we have found a regression in the IBSS creation/joining part of mac80211
> > which is appearently connected to the TSF-syncing patches introduced
> > last year[1]. It prevents beaconing of an adhoc member after rejoining a
> > cell when this cell is currently empty. The problem is present in at
> > least 3.10 and 3.13.
> > 
> > To reproduce, use two adhoc peers and let them join/leave in the
> > following order:
> > 
> > station 1: join
> > station 2: join
> > station 2: leave
> > station 1: leave
> > station 1: join
> > 
> > now we would expect that station 1 sends beacons, but it doesn't. After
> > inspecting the code, station 1 actually selected the "old" ibss network
> > and waits for a beacon to sync the tsf which is never received, as all
> > members already left the network. An easy workaround is to set the IBSS
> > creator always to true.
> 
> The race condition is that station-1 (the creator) removes station-2 only
> after a while, based on the expiration/inactive timer.
> 
> The small window that IEEE80211_IBSS_MERGE_INTERVAL introduces when
> ieee80211_ibss_disconnect() is called causes the race, since we assume that
> station-2 is still active and do not remove the BSS from cfg80211.
> 
> I am not sure why we have to keep the BSS around when we are leaving the
> network.
> 
> Is this patch the right approach ?

Thanks for the prompt answer!

Yeah, this patch works for my case. I'm not completely sure why we only unlink 
for this special case (no stations & bssid = zero), I don't see why it would 
hurt to always throw away that BSS and rescan on the next join?

I'm CCing Teemu, who introduced this roughly 3.5 years ago ("mac80211: remove 
BSS from cfg80211 list when leaving IBSS", 
5ea096c0c85e80335889539899af9a4717976e0b) , maybe he can explain it more.  I 
couldn't understand that from the commit message and the corresponding mail 
thread.

If we don't hear anything or there aren't any further objections, I think we 
can clean this patch and merge it. :)

Thanks a lot!
     Simon

> 
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 771080e..e1688cd 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -688,17 +688,18 @@ static int ieee80211_sta_active_ibss(struct
> ieee80211_sub_if_data *sdata) return active;
>  }
> 
> -static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
> +static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata,
> bool leave) {
>  	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
>  	struct ieee80211_local *local = sdata->local;
>  	struct cfg80211_bss *cbss;
>  	struct beacon_data *presp;
>  	struct sta_info *sta;
> -	int active_ibss;
> +	int active_ibss = 0;
>  	u16 capability;
> 
> -	active_ibss = ieee80211_sta_active_ibss(sdata);
> +	if (!leave)
> +		active_ibss = ieee80211_sta_active_ibss(sdata);
> 
>  	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
>  		capability = WLAN_CAPABILITY_IBSS;
> @@ -765,7 +766,7 @@ static void ieee80211_csa_connection_drop_work(struct
> work_struct *work)
> 
>  	sdata_lock(sdata);
> 
> -	ieee80211_ibss_disconnect(sdata);
> +	ieee80211_ibss_disconnect(sdata, false);
>  	synchronize_rcu();
>  	skb_queue_purge(&sdata->skb_queue);
> 
> @@ -1721,7 +1722,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data
> *sdata) {
>  	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
> 
> -	ieee80211_ibss_disconnect(sdata);
> +	ieee80211_ibss_disconnect(sdata, true);
>  	ifibss->ssid_len = 0;
>  	memset(ifibss->bssid, 0, ETH_ALEN);
> 
> 
> Sujith
