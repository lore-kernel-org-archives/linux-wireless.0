Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab2CBVkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:40:01 -0500
Subject: Re: [PATCHv3 1/2] mac80211_hwsim:  Add tsf to beacons, probe
 responses and radiotap header.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330722280-28879-1-git-send-email-javier@cozybit.com> (sfid-20120302_220521_770334_56729013)
References: <1330722280-28879-1-git-send-email-javier@cozybit.com>
	 (sfid-20120302_220521_770334_56729013)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 22:39:59 +0100
Message-ID: <1330724399.9652.2.camel@jlt3.sipsolutions.net> (sfid-20120302_224005_858771_7E02E04A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, just saw something else:

>  struct hwsim_radiotap_hdr {
>  	struct ieee80211_radiotap_header hdr;
> +	u64 rt_tsft;

That should be __le64

> @@ -779,6 +805,11 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
>  		return;
>  	info = IEEE80211_SKB_CB(skb);
>  
> +	/* add the timestamp to the beacon */
> +	hdr = (struct ieee80211_hdr_3addr *) skb->data;
> +	tsfpos = (__le64 *) (hdr + 1);
> +	put_unaligned(__mac80211_hwsim_get_tsf(data), tsfpos);
> +

And I saw this but wondered ... maybe it should just be

struct ieee80211_mgmt *mgmt = skb->data;

mgmt->u.beacon.timestamp = __mac80211_hwsim_get_tsf(data);

as you then also don't need the unaligned trick since the struct is
packed.

johannes

