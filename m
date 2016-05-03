Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36628 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbcECTQg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 15:16:36 -0400
Message-ID: <1462302992.10444.11.camel@sipsolutions.net> (sfid-20160503_211645_818190_EDA027B1)
Subject: Re: [PATCH 2/2] mac80211_hwsim: Allow managing radios from
 non-initial namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Martin Willi <martin@strongswan.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Tue, 03 May 2016 21:16:32 +0200
In-Reply-To: <1462258398-6749-3-git-send-email-martin@strongswan.org>
References: <1462258398-6749-1-git-send-email-martin@strongswan.org>
	 <1462258398-6749-3-git-send-email-martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-03 at 08:53 +0200, Martin Willi wrote:
> 
> +static __net_init int hwsim_init_net(struct net *net)
> +{
> +	struct mac80211_hwsim_data *data;
> +	bool exists = true;
> +	int netgroup = 0;
> +
> +	spin_lock_bh(&hwsim_radio_lock);
> +	while (exists) {
> +		exists = false;
> +		list_for_each_entry(data, &hwsim_radios, list) {
> +			if (netgroup == data->netgroup) {
> +				exists = true;
> +				netgroup++;
> +				break;
> +			}
> +		}
> +	}
> +	spin_unlock_bh(&hwsim_radio_lock);
> +
> +	*(int *)net_generic(net, hwsim_net_id) = netgroup;


This seems somewhat awkward. Why not just take the maximum of all the
netgroup IDs + 1? We'd run out of memory and radio IDs long before
netgroup IDs even that way, and they're not actually visible anywhere
so it doesn't matter.

Actually though, *both* your approach and my suggestion don't seem
safe: consider a new netns that doesn't have any hwsim radios yet. Now
you create *another* one, but it would get the same netgroup.

IOW, you should simply use a global counter. Surprising (net)
namespaces don't have an index like that already, but I don't see one.

> +static void __net_exit hwsim_exit_net(struct net *net)
> +{
> +	struct mac80211_hwsim_data *entry, *tmp;
> +
> +	spin_lock_bh(&hwsim_radio_lock);
> +	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
> +		if (net_eq(wiphy_net(entry->hw->wiphy), net)) {
> +			list_del(&entry->list);
> +			INIT_WORK(&entry->destroy_work,
> destroy_radio);
> +			schedule_work(&entry->destroy_work);
> +		}
> +	}
> +	spin_unlock_bh(&hwsim_radio_lock);
> +}

This changes today's default behaviour of moving the wiphys to the
default namespace. Did you intend to destroy them based on the
netgroup, i.e. based on the namespace that created them? Actually,
maybe they should move back to the namespace that created them, if the
namespace they are in is destroyed? But that's difficult, I don't mind
this behaviour, but I'm not sure it's what we want by default for
radios created in the init_net.

johannes
