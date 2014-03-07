Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaCGO1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 09:27:07 -0500
Message-ID: <1394202423.4653.3.camel@jlt4.sipsolutions.net> (sfid-20140307_152712_025083_3A9E7E3A)
Subject: Re: [RFC PATCH 1/8] nl80211: Add new channel types -- 5MHz and 10MHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michal Sojka <sojkam1@fel.cvut.cz>,
	s.sander@nordsys.de, jan-niklas.meier@volkswagen.de
Date: Fri, 07 Mar 2014 15:27:03 +0100
In-Reply-To: <1394199475-5208-2-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143804_480067_373F318E)
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1394199475-5208-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140307_143804_480067_373F318E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 14:37 +0100, Rostislav Lisovy wrote:
> These attributes are necessary to provide a way how to
> set a channel type of '5MHz' or '10MHz' from userspace.
> This is necessary for future 802.11p implementation.

>  enum nl80211_channel_type {
>  	NL80211_CHAN_NO_HT,
>  	NL80211_CHAN_HT20,
>  	NL80211_CHAN_HT40MINUS,
> -	NL80211_CHAN_HT40PLUS
> +	NL80211_CHAN_HT40PLUS,
> +	NL80211_CHAN_5MHZ,
> +	NL80211_CHAN_10MHZ,

I think that this is completely unnecessary since all APIs that take
channel types also take channel width with the new chandef framework.

johannes

