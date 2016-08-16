Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33038 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbcHPGww (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 02:52:52 -0400
Message-ID: <1471330367.16783.23.camel@sipsolutions.net> (sfid-20160816_085255_768522_3BA91654)
Subject: Re: [PATCH] cfg80211: Add HT and VHT information in start_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Peng Xu <pxu@qca.qualcomm.com>
Date: Tue, 16 Aug 2016 08:52:47 +0200
In-Reply-To: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com>
References: <1471284424-12142-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-08-15 at 21:07 +0300, Jouni Malinen wrote:
> From: Peng Xu <pxu@qca.qualcomm.com>
> 
> Add HT and VHT information in struct cfg80211_ap_settings when
> starting ap so that driver does not need to parse IE to obtain
> the information.

> +enum ht_vht_support {
> +	HT_VHT_DISABLED,
> +	HT_VHT_ENABLED,
> +	HT_VHT_NOT_INDICATED
> +};

So if you get HT_VHT_NOT_INDICATED in the driver, don't you *still*
have to parse the IEs?

Arguably, cfg80211 could know itself by parsing though, so it could
already fall back to that, no?

But if you do that, you already need the parsing code, so then perhaps
it would make sense to just always use the parsing in cfg80211? Or
export a parsing function to use in driver(s)?

> @@ -719,6 +729,11 @@ struct cfg80211_ap_settings {
>  	bool p2p_opp_ps;
>  	const struct cfg80211_acl_data *acl;
>  	bool pbss;
> +	enum ht_vht_support ht_enabled;
> +	enum ht_vht_support vht_enabled;
> +	enum ht_vht_support require_ht;
> +	enum ht_vht_support require_vht;
> +

(nit - extra blank line)

johannes
