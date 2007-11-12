Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:61839 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbXKLXRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 18:17:50 -0500
Received: by an-out-0708.google.com with SMTP id b36so232331ana
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2007 15:17:49 -0800 (PST)
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1194689500.7258.61.camel@johannes.berg>
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>
	 (sfid-20071110_022658_985099_309C7497)  <1194689500.7258.61.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 12 Nov 2007 15:17:29 -0800
Message-Id: <1194909449.6980.89.camel@localhost> (sfid-20071112_231754_087978_10ED68FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-10 at 11:11 +0100, Johannes Berg wrote:
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -474,6 +474,7 @@ enum ieee80211_if_types {
> >  	IEEE80211_IF_TYPE_AP,
> >  	IEEE80211_IF_TYPE_STA,
> >  	IEEE80211_IF_TYPE_IBSS,
> > +	IEEE80211_IF_TYPE_MESH,
> 
> What happened to Dan's suggestion of calling this MESH_STA? And maybe in
> nl80211 as well? I might've missed something, was there a conclusion?

There wasn't such suggestion, we were talking about renaming interface
state from IEEE80211_MESH to something more specific. I suggested
_ACTIVE, _ON or something like that... any preferences? As for the
interface name, we have discussed about how MAP would be a different
interface type, so it would be a good idea to be more precise with the
it. I would go for MESH_POINT though, to follow the nomenclature in the
standard.


> >  	/* FIX: what would be proper limits for MTU?
> >  	 * This interface uses 802.3 frames. */
> > -	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
> > +	if (new_mtu < 256 ||
> > +		new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6 - meshhdrlen) {
> >  		printk(KERN_WARNING "%s: invalid MTU %d\n",
> >  		       dev->name, new_mtu);
> >  		return -EINVAL;
> 
> Are you sure this is appropriate? As the comment says, interface is
> 802.3 framed. Don't the 802.11 specifications usually keep the frame
> payload length and require the device to handle longer frames?

802.11s does not modify the PHY at all, and AFAIK does not impose any
additional requirement on the devices. So regardless if the code already
there was needed, it is necessary to decrease the MTU by meshhdrlen
bytes. Another problem is that mesh headers do not always have the same
length, but that will be dealt with when support for different length
headers is added.

> 
> > +	atomic_t mesh_seqnum;
> 
> Hmm. Do we really need an atomic_t here?

We are only using this from subif_start_xmit and it is a per-interface
value, so no, not really.

>  
> > +	case IEEE80211_IF_TYPE_MESH:
> > +		if (!mesh_allocated) {
> > +			/* Allocate all mesh structures when creating the first
> > +			 * mesh interface.
> > +			 */
> > +			mesh_pathtbl_init();
> > +			mesh_allocated = 1;
> > +		}
> > +		/* fall thru */
> 
> Will there be other structures to allocate? Maybe we should instead push
> the "already" check into the _init()?
> 

Yes, there will be more soon.

> > +	/* TODO: check for expired neighbors, paths and frames to non resolved
> > +	 * hw addresses
> > +	 */
> 
> Seems dangerous to actually run the code w/o this, no?

No, right now we only add paths by manually from user space.

> 
> 
> > +	mgmt->u.beacon.beacon_int =
> > +		cpu_to_le16(local->hw.conf.beacon_int);
> 
> Hmm. This is interesting. The beacon interval is a pure beacon
> configuration after my patches, but here we're using it without having
> userspace set up a beacon. What do we do in the IBSS case?
> 
> > +static int o80211s_getmeshpath(struct sk_buff *skb, struct nlmsghdr *nlh,
> > +		void *arg)
> > +{
> > +	return 0;
> > +}
> 
> Uh huh. Why is this here? Should it be filled?

Of course. Please note this is work in progress. I guess I should return
a ENOTSUPP instead.

> > @@ -230,6 +231,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
> >  	     (tx->fc & IEEE80211_FCTL_STYPE) != IEEE80211_STYPE_PROBE_REQ))
> >  		return TXRX_DROP;
> >  
> > +	if (tx->sdata->type == IEEE80211_IF_TYPE_MESH)
> > +		return TXRX_CONTINUE;
> 
> Is this right or should there be some other "is forwarded frame" check
> to go with this? I'm not sure but it seems that frames we send via the
> netdev need to be still checked? Or not because they're just injected
> into the mesh? I think I'm confused.

I'm confused too. ieee80211_subif_start_xmit checks if the frame is
forwarded, ieee80211_tx_h_check_assoc does not care about if the frame
is forwarded or not. Since there is no interface-wide "association
state" in mesh, the association check would always be true.

> I think you should use RCU for the locking in the neighbour table. This
> code should (IIRC) be under rcu read-side lock already so the neighbour
> table reading would be lockless. Since updates are infrequent, RCU is a
> good tradeoff.

Updates are not that infrequent, every mesh path might be updated every
few seconds (about 5 or 10). Would RCU be a good trade off in this
situation?

Thanks for the comments!

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


