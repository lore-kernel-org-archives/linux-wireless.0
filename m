Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:36747 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab2ALVhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 16:37:52 -0500
Date: Thu, 12 Jan 2012 22:37:15 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: in IBSS use the Auth frame to trigger STA
 reinsertion
Message-ID: <20120112213714.GD3077@ritirata.org> (sfid-20120112_223755_864532_6F4EB142)
References: <1326400616-1109-1-git-send-email-ordex@autistici.org>
 <1326400616-1109-2-git-send-email-ordex@autistici.org>
 <1326401451.3463.11.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1326401451.3463.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2012 at 09:50:51PM +0100, Johannes Berg wrote:
> On Thu, 2012-01-12 at 21:36 +0100, Antonio Quartulli wrote:
> 
> > +static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
> > +					struct ieee80211_mgmt *mgmt,
> > +					size_t len)
> > +{
> > +	u16 auth_alg, auth_transaction;
> > +	size_t baselen;
> > +
> > +	lockdep_assert_held(&sdata->u.ibss.mtx);
> > +
> > +	if (len < 24 + 6)
> > +		return;
> > +
> > +	baselen = (u8 *) mgmt->u.auth.variable - (u8 *) mgmt;
> > +	if (baselen > len)
> > +		return;
> > +
> > +	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
> > +	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
> > +
> > +	if (auth_alg == WLAN_AUTH_OPEN && auth_transaction == 1) {
> 
> negating & return would be easier to read & less indentation

I agree :-)

> 
> > +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> > +		printk(KERN_DEBUG "%s: RX Auth SA=%pM DA=%pM BSSID=%pM."
> > +		       "(auth_transaction=%d)\n",
> > +		       sdata->name, mgmt->sa, mgmt->da, mgmt->bssid,
> > +		       auth_transaction);
> > +#endif
> > +		if (sta_info_destroy_addr(sdata, mgmt->sa) != -ENOENT) {
> > +			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0,
> > +					       false);
> > +			rcu_read_unlock();
> > +		}
> 
> This doesn't seem to make sense, why not add the station even if we
> didn't know about it before?

mh, at the beginning the idea was to avoid to interfere with the current sta_adding mechanism,
so if a station was not there yet, then I didn't want to add it at that point.

But looking at the code now I can consider it a mistake, since it doesn't really
make sense.

I'll remove it in version 2 of this patch.

Thanks

p.s. In version 2 I will also write a more "understandable" commit message

> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Antonio Quartulli

..each of us alone is worth nothing..
Ernesto "Che" Guevara
