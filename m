Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51385 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaKJJfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:35:00 -0500
Message-ID: <1415612097.1847.8.camel@sipsolutions.net> (sfid-20141110_103504_648504_798B54A5)
Subject: Re: [PATCH 2/2] mac80211-hwsim: Add HWSIM_CMD_GET_RADIO command
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrik Flykt <patrik.flykt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Nov 2014 10:34:57 +0100
In-Reply-To: <1415348520-28558-3-git-send-email-patrik.flykt@linux.intel.com> (sfid-20141107_092210_311728_E4CAFF7C)
References: <1415348520-28558-1-git-send-email-patrik.flykt@linux.intel.com>
	 <1415348520-28558-3-git-send-email-patrik.flykt@linux.intel.com>
	 (sfid-20141107_092210_311728_E4CAFF7C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-07 at 10:22 +0200, Patrik Flykt wrote:

> +static int hwsim_dump_radio_nl(struct sk_buff *skb,
> +			       struct netlink_callback *cb)
> +{
> +	struct mac80211_hwsim_data *data = NULL;
> +
> +	spin_lock_bh(&hwsim_radio_lock);
> +
> +	list_for_each_entry(data, &hwsim_radios, list)
> +		mac80211_hwsim_get_radio(skb, data,
> +					 NETLINK_CB(cb->skb).portid,
> +					 cb->nlh->nlmsg_seq, cb, NLM_F_MULTI);
> +
> +	spin_unlock_bh(&hwsim_radio_lock);

Err, I don't think this is how dump works?

Try dumping a few hundred radios this way.

johannes

