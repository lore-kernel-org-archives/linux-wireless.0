Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36260 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751138AbdIEOaQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 10:30:16 -0400
Message-ID: <1504621814.12380.23.camel@sipsolutions.net> (sfid-20170905_163019_460271_F124111D)
Subject: Re: [PATCH 06/10] cfg80211: honor NL80211_RRF_NO_HT40{MINUS,PLUS}
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 05 Sep 2017 16:30:14 +0200
In-Reply-To: <20170805084438.12550-7-luca@coelho.fi>
References: <20170805084438.12550-1-luca@coelho.fi>
         <20170805084438.12550-7-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-08-05 at 11:44 +0300, Luca Coelho wrote:

> +	regd = get_wiphy_regdom(wiphy);
> +	if (regd) {
> +		const struct ieee80211_reg_rule *reg_rule =
> +			freq_reg_info_regd(MHZ_TO_KHZ(channel-
> >center_freq),
> +					   regd, MHZ_TO_KHZ(20));
> 

This could return an error, how can you be sure it doesn't?

johannes
