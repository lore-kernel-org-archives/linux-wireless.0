Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60911 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbaICL4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 07:56:48 -0400
Message-ID: <1409745400.911.10.camel@jlt4.sipsolutions.net> (sfid-20140903_135651_447300_82CD4D2D)
Subject: Re: [PATCH v5 1/2] mac80211: split 802.11h parsing from transmit
 power policy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 03 Sep 2014 13:56:40 +0200
In-Reply-To: <E1XONJ6-0005Kl-Nz@pannekake.samfundet.no> (sfid-20140901_104956_330419_87FE5F12)
References: <20140830184516.GA31497@sesse.net>
	 <E1XONJ6-0005Kl-Nz@pannekake.samfundet.no>
	 (sfid-20140901_104956_330419_87FE5F12)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-08-29 at 19:27 +0200, Steinar H. Gunderson wrote:

> ieee80211_find_80211h_pwr_constr

Please format the code like this:

static bool
ieee80211_find_80211h_pwr_constr(struct ieee80211_sub_if_data *sdata, 
                                 struct ieee80211_channel *channel,
                                 const u8 *country_ie, u8
country_ie_len,
                                 const u8 *pwr_constr_elem,
                                 int *chan_pwr, int *pwr_reduction)

Do we need the pwr_reduction? Couldn't we just return it? We don't
handle 0/negative anyway, do we?

> -static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,

> +static bool ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,

I think you meant to keep u32 here? Otherwise return values from the
function simply get converted to 0/1 which doesn't seem right.

johannes


