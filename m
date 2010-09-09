Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0IIWvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 18:51:25 -0400
To: Ben Greear <greearb@candelatech.com>
Subject: Re: RFC:  Allow multiple STA connected to same AP.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Sep 2010 00:51:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
In-Reply-To: <4C8959BC.7040501@candelatech.com>
References: <4C8959BC.7040501@candelatech.com>
Message-ID: <7fa0decef9a717c1562ee155bba78ce9@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 09 Sep 2010 15:03:40 -0700, Ben Greear <greearb@candelatech.com>
wrote:
> With the patch below against latest wireless-testing, I can create two
> STA on the same ath9k phy0 and have them send traffic to each other.
> I tested only un-encrypted STAs at this point.

After connecting them to the same AP, presumably?

> It seems the tx logic hangs after a bit, so there are still issues, but
> I'm not sure if that is something introduced by my patch or some
> existing ath9k bug.
> 
> Please let me know if this is a viable approach.

> +       /* If we have more than one virtual station, turn on
PROMISC_IN_BSS
> +        *  --Ben
> +        */
> +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +               if (!sdata->dev || !netif_running(sdata->dev))
> +                       continue;
> +
> +               if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> +                       avifs++;
> +                       if (avifs > 1)
> +                               break;
> +               }
> +       }
> +       if (avifs > 1)
> +               new_flags |= FIF_PROMISC_IN_BSS;
> +

This seems weird. Why do you need to be *promisc* within a given
BSS if you are multiple stations? You already have two MAC addrs
that you need to accept, so that should be fine, i.e. you don't
need to be promisc in the BSS. If ath9k needs to, it should be in
the driver. So NAK on this change for sure.

> @@ -440,7 +440,7 @@ int sta_info_insert_rcu(struct sta_info *sta)
> __acquires(RCU)
> 
>          spin_lock_irqsave(&local->sta_lock, flags);
>          /* check if STA exists already */
> -       if (sta_info_get_bss(sdata, sta->sta.addr)) {
> +       if (sta_info_get(sdata, sta->sta.addr)) {

I don't understand this change. These functions are the same
if sdata is in managed mode.

johannes
