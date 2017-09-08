Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36792 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755382AbdIHOZY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:25:24 -0400
Message-ID: <1504880723.20347.2.camel@sipsolutions.net> (sfid-20170908_162629_195365_9ACCA2ED)
Subject: Re: [RFC 1/4] mac80211_hwsim: changed hwsim_radios from list to
 hashlist keyed by MAC-Address
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 08 Sep 2017 16:25:23 +0200
In-Reply-To: <9df35571-bc40-4af0-8a4f-01ba400dbb50@MAIL1.uni-rostock.de>
References: <9df35571-bc40-4af0-8a4f-01ba400dbb50@MAIL1.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-08 at 16:11 +0200, Benjamin Beichler wrote:
> Use hashlist to improve lookup speed for every received NL-message,
> especially for higher counts of radios, like 100 or more. The
> stringhash
> should be neglible for 6 Bytes MAC-Address, could be improved by
> using
> cast to 64bit integer and hash this instead.
> 
> For a more reliable implementation of radio dump, a generation count
> is inserted,
> which indicates a change while dump (this was missing before and
> could lead into problems because of inconsistent NL-dumps).

The idea seems reasonable, but you need major coding style fixes. You
should also correctly line-break your commit messages.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

should be useful.

> +static unsigned int hash_mac(const u8 *mac )
> +{
> +	return full_name_hash(&mac_hash_salt,mac,ETH_ALEN);
> +}

That really should just be using jhash() or so, why bother with string
hashing?

> +
>  static spinlock_t hwsim_radio_lock;
> -static LIST_HEAD(hwsim_radios);
> -static int hwsim_radio_idx;
> +static DEFINE_HASHTABLE(hwsim_radios,HWSIM_HT_BITS);
> +static int hwsim_radio_count;
> +static int hwsim_radio_generation=1;

Why not use rhashtable? That will size itself automatically, no need
for the bits. In fact, that also removes the whole question of the hash
algorithm, I think.

Not sure about walking there, but there's rhashtable_walk_*.

> -	list_for_each_entry(data2, &hwsim_radios, list) {
> +	hash_for_each( hwsim_radios, bucket, data2, list) {

coding style

> +struct mac_address create_mac_from_idx(int idx)
> +{
> +	struct mac_address mac;
> +	eth_zero_addr(mac.addr);
> +	mac.addr[0] = 0x42;
> +	mac.addr[3] = idx >> 8;
> +	mac.addr[4] = idx;
> +	return mac;
> +
> +}

coding style

>  static int mac80211_hwsim_new_radio(struct genl_info *info,
>  				    struct hwsim_new_radio_params
> *param)
>  {
>  	int err;
> -	u8 addr[ETH_ALEN];
> +	struct mac_address mac;
>  	struct mac80211_hwsim_data *data;
>  	struct ieee80211_hw *hw;
>  	enum nl80211_band band;
>  	const struct ieee80211_ops *ops = &mac80211_hwsim_ops;
>  	struct net *net;
> -	int idx;
> +	int idx,hashkey;
> +	bool new_id_found=true;
> +

coding style

>  	if (WARN_ON(param->channels > 1 && !param->use_chanctx))
>  		return -EINVAL;
>  
>  	spin_lock_bh(&hwsim_radio_lock);
> -	idx = hwsim_radio_idx++;
> +
> +
+	if(param->idx == -1){

etc.

[snip]

johannes
