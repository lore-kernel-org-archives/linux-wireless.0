Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55828 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932366AbeGIJ0j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 05:26:39 -0400
Message-ID: <1531128396.3298.25.camel@sipsolutions.net> (sfid-20180709_112651_398261_4D8D0664)
Subject: Re: [PATCH] mac80211: restrict delayed tailroom needed decrement
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2018 11:26:36 +0200
In-Reply-To: <99231cb4-8977-c9c4-ff11-0c57899e30b7@codeaurora.org>
References: <1531126681-5146-1-git-send-email-mpubbise@codeaurora.org>
         <1531126957.3298.23.camel@sipsolutions.net>
         <99231cb4-8977-c9c4-ff11-0c57899e30b7@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-07-09 at 14:54 +0530, Manikanta Pubbisetty wrote:

> > This describes a scenario where there's *unnecessary* work done, but not
> > really one where we have something that's *incorrect*?
> > 
> 
> To me at least doing unnecessary things is incorrect :-D, may be we can 
> change the statement.

Well, I guess it's a question of semantics, but this doesn't really
result in any observable incorrect behaviour.

> > Are you saying that you found a problem with this? Did this show up in
> > some sort of measurements?
> 
> Not really, I have observed in my testing that there were warnings 
> whenever a AP_VLAN was brought down; this is done in ieee80211_free_keys.
> Warnings show up every time we bring down the AP_VLAN interface(using 
> ifconfig); warnings apart but I thought there would be unnecessary 
> overhead in the tailroom expansion though the overhead may be trivial.

Except for that maybe :-)

> > > +++ b/net/mac80211/key.c
> > > @@ -583,7 +583,8 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
> > >   
> > >   		ieee80211_debugfs_key_remove(key);
> > >   
> > > -		if (delay_tailroom) {
> > > +		if (delay_tailroom &&
> > > +		    sdata->vif.type == NL80211_IFTYPE_STATION) {
> > >   			/* see ieee80211_delayed_tailroom_dec */
> > >   			sdata->crypto_tx_tailroom_pending_dec++;
> > >   			schedule_delayed_work(&sdata->dec_tailroom_needed_wk,
> > 
> > I think you'd better change the caller, i.e. ieee80211_del_key(), and a
> > add a comment there that explains what's going on.
> 
> Not really sure what you were trying to tell here.

I think you should do

ieee80211_key_destroy(..., type == STATION);

in the caller, instead of hard-coding the thing here.

There may be more places that want the delay, perhaps for other reasons?

johannes
