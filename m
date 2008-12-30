Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:51303 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbYL3IOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2008 03:14:38 -0500
Received: by bwz14 with SMTP id 14so17053663bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2008 00:14:36 -0800 (PST)
Message-ID: <1ba2fa240812300014q40aa3402ie4251b38eb017610@mail.gmail.com> (sfid-20081230_091502_398542_5166D375)
Date: Tue, 30 Dec 2008 10:14:30 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: clean up set_key callback
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1230597160.3116.74.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1230551709.3116.30.camel@johannes>
	 <1ba2fa240812291417w6e99dd17t3ffc2973774ed824@mail.gmail.com>
	 <1230597160.3116.74.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 30, 2008 at 2:32 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-12-30 at 00:17 +0200, Tomas Winkler wrote:
>
>> > @@ -3038,6 +3039,9 @@ static int iwl_mac_set_key(struct ieee80
>> >        int ret = 0;
>> >        u8 sta_id = IWL_INVALID_STATION;
>> >        u8 is_default_wep_key = 0;
>> > +       static const u8 bcast_addr[ETH_ALEN] =
>> > +               { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
>> > +       static const u8 *addr;
>>
>> >        IWL_DEBUG_MAC80211("enter\n");
>> >
>> > @@ -3046,9 +3050,7 @@ static int iwl_mac_set_key(struct ieee80
>> >                return -EOPNOTSUPP;
>> >        }
>> >
>> > -       if (is_zero_ether_addr(addr))
>> > -               /* only support pairwise keys */
>> > -               return -EOPNOTSUPP;
>> > +       addr = sta ? sta->addr : bcast_addr;
>> >
>>
>> Please use this code instead in both iwlwifi drivers.
>>
>> +sta_id = sta ? iwl_find_station(priv, sta->addr) :
>> priv->hw_params.bcast_sta_id;
>> - sta_id = iwl_find_station(priv, addr);
>
> Should probably be a separate patch though since this particular patch
> isn't meant to change semantics here, I think.

Whatever, we can patch it over.
Tomas
