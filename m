Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1FUOkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 10:40:20 -0400
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <20110621141017.GC32464@hertz.marvell.com>
References: <20110616102707.GB24458@hertz.marvell.com>
	 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
	 <20110617132527.GA27436@hertz.marvell.com>
	 <1308331485.7329.2.camel@Nokia-N900-51-1>
	 <20110620143051.GA31035@hertz.marvell.com>
	 <1308583799.4322.9.camel@jlt3.sipsolutions.net>
	 <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
	 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
	 <20110621130305.GB32464@hertz.marvell.com>
	 <1308663814.4276.3.camel@jlt3.sipsolutions.net>
	 <20110621141017.GC32464@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 16:40:15 +0200
Message-ID: <1308667215.4276.7.camel@jlt3.sipsolutions.net> (sfid-20110621_164105_750882_9D97577B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 19:40 +0530, Yogesh Ashok Powar wrote:

> @@ -455,6 +496,8 @@ int ieee80211_key_link(struct ieee80211_key *key,
>  	__ieee80211_key_replace(sdata, sta, pairwise, old_key, key);
>  	__ieee80211_key_destroy(old_key);
>  
> +	increment_tailroom_need_count(key->local);
> +

This doesn't seem right -- it links the key in first and then does the
update, the mechanism I described relies on doing it the other way
around.

> @@ -498,8 +541,12 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
>  
>  	mutex_lock(&sdata->local->key_mtx);
>  
> -	list_for_each_entry(key, &sdata->key_list, list)
> +	sdata->local->crypto_tx_tailroom_needed_cnt = 0;
> +

That doesn't seem right either -- only if you have a single sdata that
will work, I think?

johannes

