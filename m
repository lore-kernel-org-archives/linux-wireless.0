Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44622 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3LQIZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 03:25:19 -0500
Message-ID: <1387268712.4749.14.camel@jlt4.sipsolutions.net> (sfid-20131217_092522_967666_39B1BEA7)
Subject: Re: [RFC PATCH 4/8] mac80211: Use PS module for managed mode
 powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>
Date: Tue, 17 Dec 2013 09:25:12 +0100
In-Reply-To: <1387231260-2849-5-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230111_164514_93A543E7)
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
	 <1387231260-2849-5-git-send-email-seth.forshee@canonical.com>
	 (sfid-20131216_230111_164514_93A543E7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 16:00 -0600, Seth Forshee wrote:

> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -682,7 +682,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
>  	if (hw_reconf_flags)
>  		ieee80211_hw_config(local, hw_reconf_flags);
>  
> -	ieee80211_recalc_ps(local, -1);
> +	ieee80211_ps_vif_open(sdata);

I have a feeling that now that we have very regular join/leave code, and
are guaranteed to go through disassoc when the interface is stopped, we
probably don't need all the hooks in this file at all any more.

> @@ -1609,6 +1609,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>  		strlcpy(sdata->name, name, IFNAMSIZ);
>  		ieee80211_assign_perm_addr(local, wdev->address, type);
>  		memcpy(sdata->vif.addr, wdev->address, ETH_ALEN);
> +		ieee80211_ps_init_vif(sdata);

That doesn't really seem like the right place? Shouldn't it somehow be
specific for managed interfaces, and be reset when the interface changes
type, for example?

> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -732,15 +732,16 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  			local->dot11FailedCount++;
>  	}
>  
> +	sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);

This isn't safe, the interface can go away while the SKB is on some
hardware queue. Look at what we do in ieee80211_report_used_skb() and
maybe refactor that somehow.

> -	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
> +	if (sdata->vif.ps_mode == IEEE80211_VIF_PS_DOZE) {
>  		ieee80211_stop_queues_by_reason(&local->hw,
>  						IEEE80211_MAX_QUEUE_MAP,
>  						IEEE80211_QUEUE_STOP_REASON_PS);

This is a bit odd now - shouldn't you only stop the queues for that
interface? Or is this still assuming only a single interface?

> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		if (sdata->vif.type != NL80211_IFTYPE_STATION)
> +			continue;
> +		if (!sdata->u.mgd.associated)
> +			continue;
> +		if (sdata->vif.ps_mode != IEEE80211_VIF_PS_AWAKE)
> +			continue;
>  
> -			ieee80211_send_nullfunc(local, sdata, 0);
> -		}
> +		ieee80211_send_nullfunc(local, sdata, 0);

Unrelated to your patch, but we should probably send a nullfunc(PM=1)
packet for the other cases to detect if we got disconnected. Or wake up
briefly, and go back to sleep later or something ...

> +void ieee80211_recalc_ps(struct ieee80211_sub_if_data *sdata)
> +{
> +	switch (sdata->vif.type) {
> +	case NL80211_IFTYPE_STATION:
> +		ieee80211_mgd_recalc_ps(sdata);
> +		break;
> +	default:
> +		break;
> +	}
> +}

Would that make more sense in ps.c now?

> +int ieee80211_max_network_latency(struct notifier_block *nb,
> +				  unsigned long data, void *dummy)

ditto?

> +	mutex_lock(&local->iflist_mtx);
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {

locking mutex & then rcu seems weird.
johannes

