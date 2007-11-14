Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:43375 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbXKNPOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 10:14:07 -0500
Received: by fk-out-0910.google.com with SMTP id z23so199771fkz
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 07:14:06 -0800 (PST)
Message-ID: <c85cb4470711140714n173224f9i2c22e5afe87e71f7@mail.gmail.com> (sfid-20071114_151417_597253_236B5589)
Date: Wed, 14 Nov 2007 17:14:06 +0200
From: "Ron Rindzonski" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 06/14] mac80211: adding 802.11n essential A-MSDURxcapability
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	flamingice@sourmilk.net, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1194971563.9116.72.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1879838866982C46A9CB3D56BA49ADEB0403BC4E@hasmsx411.ger.corp.intel.com>
	 <1194971563.9116.72.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> The one thing I'm not sure about here is the EAPOL frame handling
>>> johannes

>> I agree. Good point and thanks for the catch.
>> assuming I identify A-MSDU, I'll loop for each internal MSDU on:
>>   ieee80211_rx_h_802_1x_pae
>>   ieee80211_rx_h_drop_unencrypted
>>   ieee80211_rx_h_data
>> return value of ieee80211_rx_h_data_agg to
>> __ieee80211_invoke_rx_handlers will be this small loop's return value
>> Do you think this approach makes sense?
>> ron

> I'm not convinced. That seems fairly ad-hoc and likely to break in the
> future because only parts of the 802.11 header can be reconstructed.
> incorporates all the three callbacks you list above.That'd be similar
> what I did with the crypto code (where we now only have a single hndler
> doing it all rather than a bunch doing different pieces of the
> functionality)
>
> It'd basically look like this
>
> handle_data_frame
> {
>       result = handle_pae()
>       if (result == ...)
>
>       if (should_drop_unencrypted && is_unencrypted())
>               return DROP
>
>       ...
> }
>
> and rx_h_data would simply reframe the frame and pass it to this
> function, and your deaggregation handler would loop over this function.
> johannes

okay. looking in the architecture i think your approach is better, and
this bug should be fixed the way you suggested.
ron
