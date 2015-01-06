Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58604 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbbAFKli (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:41:38 -0500
Message-ID: <1420540894.1966.13.camel@sipsolutions.net> (sfid-20150106_114141_279460_B27B72DA)
Subject: Re: [PATCHv3] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de
Date: Tue, 06 Jan 2015 11:41:34 +0100
In-Reply-To: <1419412868-28938-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141224_102111_602160_7438652E)
References: <1419412868-28938-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20141224_102111_602160_7438652E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-24 at 10:21 +0100, Lorenzo Bianconi wrote:
> -	list_for_each_entry(sdata, &local->interfaces, list)
> +	list_for_each_entry(sdata, &local->interfaces, list) {
>  		sdata->user_power_level = local->user_power_level;
> +		if (!update_tpc && type != sdata->vif.bss_conf.txpower_type)
> +			update_tpc = true;

Why bother checking - if it's already true then setting it to true won't
matter, and IMHO makes the code easier to read.

I also think "update_tpc" is a bad name - transmit power control is the
actual usage here, but you really mean "update_txp_type" or so.

johannes

