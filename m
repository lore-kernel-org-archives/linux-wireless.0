Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:33958 "EHLO
	mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678AbcEDIdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 04:33:23 -0400
Message-ID: <1462350799.2546.31.camel@strongswan.org> (sfid-20160504_103328_505235_CACA25F4)
Subject: Re: [PATCH 2/2] mac80211_hwsim: Allow managing radios from
 non-initial namespaces
From: Martin Willi <martin@strongswan.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 04 May 2016 10:33:19 +0200
In-Reply-To: <1462302992.10444.11.camel@sipsolutions.net>
References: <1462258398-6749-1-git-send-email-martin@strongswan.org>
	 <1462258398-6749-3-git-send-email-martin@strongswan.org>
	 <1462302992.10444.11.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> > +static __net_init int hwsim_init_net(struct net *net)
> > +{
> > +	struct mac80211_hwsim_data *data;
> > +	bool exists = true;
> > +	int netgroup = 0;
> > +
> > +	spin_lock_bh(&hwsim_radio_lock);
> > +	while (exists) {
> > +		exists = false;
> > +		list_for_each_entry(data, &hwsim_radios, list) {
> > +			if (netgroup == data->netgroup) {
> > +				exists = true;
> > +				netgroup++;
> > +				break;
> > +			}
> > +		}
> > +	}
> > +	spin_unlock_bh(&hwsim_radio_lock);
> > +
> > +	*(int *)net_generic(net, hwsim_net_id) = netgroup;
> 
> This seems somewhat awkward. Why not just take the maximum of all the
> netgroup IDs + 1? We'd run out of memory and radio IDs long before
> netgroup IDs even that way

My intention was to reuse netgroups for the case many namespaces come
and go, but I agree that it is not optimal.

> consider a new netns that doesn't have any hwsim radios yet.
> Now you create *another* one, but it would get the same netgroup.

Correct, that is indeed broken if there are no radios.

> IOW, you should simply use a global counter. Surprising (net)
> namespaces don't have an index like that already, but I don't see
> one.

Ok, will do that in a v2.

> > +static void __net_exit hwsim_exit_net(struct net *net)
> > +{
> > +	struct mac80211_hwsim_data *entry, *tmp;
> > +
> > +	spin_lock_bh(&hwsim_radio_lock);
> > +	list_for_each_entry_safe(entry, tmp, &hwsim_radios, list) {
> > +		if (net_eq(wiphy_net(entry->hw->wiphy), net)) {
> > +			list_del(&entry->list);
> > +			INIT_WORK(&entry->destroy_work, destroy_radio);
> > +			schedule_work(&entry->destroy_work);
> > +		}
> > +	}
> > +	spin_unlock_bh(&hwsim_radio_lock);
> > +}

> This changes today's default behaviour of moving the wiphys to the
> default namespace. Did you intend to destroy them based on the
> netgroup, i.e. based on the namespace that created them? Actually,
> maybe they should move back to the namespace that created them, if
> the namespace they are in is destroyed? But that's difficult, I don't
> mind this behaviour, but I'm not sure it's what we want by default
> for radios created in the init_net.

With the proposed approach I destroy all radios if the owning namespace
gets deleted, because we probably don't want them landing in init_net
if they are created from a (unprivileged) userns process. I think this
is what other "virtual" interfaces do (gre tunnels, veth etc.). If we
think of hwsim radios as such a "virtual" device, that makes IMO sense
to delete them.

If we want to keep the existing behavior, we could move radios
belonging to the init_net-associated netgroup back to init_net, that
shouldn't be too difficult.

Moving the radio back to the creators namespace would be the most
consistent behavior, so I'll check how difficult such a reverse lookup
is. We then would delete the radio only if it is in the creators
namespace, or if the creators namespace is gone. Does that make sense?

Martin
