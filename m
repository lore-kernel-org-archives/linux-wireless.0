Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:47790 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbaICNVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 09:21:45 -0400
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XPAVK-0001FC-60
	for linux-wireless@vger.kernel.org; Wed, 03 Sep 2014 15:21:42 +0200
Received: from sesse by pannekake.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1XPAVJ-0005a4-Ua
	for linux-wireless@vger.kernel.org; Wed, 03 Sep 2014 15:21:41 +0200
Date: Wed, 3 Sep 2014 15:21:41 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 1/2] mac80211: split 802.11h parsing from transmit
 power policy
Message-ID: <20140903132141.GB18933@sesse.net> (sfid-20140903_152148_848656_4FFE7BD1)
References: <20140830184516.GA31497@sesse.net>
 <E1XONJ6-0005Kl-Nz@pannekake.samfundet.no>
 <1409745400.911.10.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1409745400.911.10.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for reviewing. I'll send out a new patch series as soon as I'm
through all of your comments.

On Wed, Sep 03, 2014 at 01:56:40PM +0200, Johannes Berg wrote:
> Please format the code like this:
> 
> static bool
> ieee80211_find_80211h_pwr_constr(struct ieee80211_sub_if_data *sdata, 
>                                  struct ieee80211_channel *channel,
>                                  const u8 *country_ie, u8
> country_ie_len,
>                                  const u8 *pwr_constr_elem,
>                                  int *chan_pwr, int *pwr_reduction)

Done.

> Do we need the pwr_reduction? Couldn't we just return it? We don't
> handle 0/negative anyway, do we?

We could do the calculation directly in ieee80211_find_80211h_pwr_constr;
however, then we couldn't message the calculation in the printk (it currently
says e.g. 0 (17 - 23) dBm). I don't know if that is important or not, but I
opted to let it stay as-is.

>> -static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
> 
>> +static bool ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
> 
> I think you meant to keep u32 here? Otherwise return values from the
> function simply get converted to 0/1 which doesn't seem right.

You're right; this function is supposed to return a bitmask. Fixed.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
