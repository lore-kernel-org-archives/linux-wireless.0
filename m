Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaCGO3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 09:29:53 -0500
Message-ID: <1394202590.4653.8.camel@jlt4.sipsolutions.net> (sfid-20140307_152956_979305_A044F525)
Subject: Re: [RFC PATCH 6/8] nl80211: Support for 5/10 MHz channels when
 reporting BW restrictions
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michal Sojka <sojkam1@fel.cvut.cz>,
	s.sander@nordsys.de, jan-niklas.meier@volkswagen.de
Date: Fri, 07 Mar 2014 15:29:50 +0100
In-Reply-To: <1394199475-5208-7-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143812_856469_1F424A6E)
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1394199475-5208-7-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140307_143812_856469_1F424A6E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 14:37 +0100, Rostislav Lisovy wrote:

> +		if ((chan->flags & IEEE80211_CHAN_NO_20MHZ) &&
> +		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_20MHZ))
> +			goto nla_put_failure;
> +		if ((chan->flags & IEEE80211_CHAN_NO_10MHZ) &&
> +		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_10MHZ))
> +			goto nla_put_failure;

This is the part of the code that I was referring to before, you should
skip these channels if (!large) to not break older tools with too much
data.

johannes

