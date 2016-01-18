Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:27488 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbcARJeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 04:34:11 -0500
Subject: Re: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT
 command
To: Johannes Berg <johannes@sipsolutions.net>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
 <1452678583-20086-3-git-send-email-arend@broadcom.com>
 <1452769832.2444.14.camel@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend@broadcom.com>
Message-ID: <569CB190.1000901@broadcom.com> (sfid-20160118_103415_301511_EC70727B)
Date: Mon, 18 Jan 2016 10:34:08 +0100
MIME-Version: 1.0
In-Reply-To: <1452769832.2444.14.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 14-1-2016 12:10, Johannes Berg wrote:
> On Wed, 2016-01-13 at 10:49 +0100, Arend van Spriel wrote:
>>  
>> +/**
>> + * enum nl80211_attr_bss_select - attributes for bss selection.
> 
> I'd prefer nl80211_bss_select_attr in this name and the constants too,
> so it's more obvious that it doesn't belong to the top-level namespace.

Ok. Did not know that convention so it was not that obvious to me ;-)
Will change it.

>> + * @__NL80211_ATTR_BSS_SELECT_INVALID: reserved.
>> + * @NL80211_ATTR_BSS_SELECT_PRIMITIVE: Indicates what criteria are to
>> + *> 	> be used for bss selection. Value according
>> + *	%enum nl80211_bss_select_primitive.
> 
> This I don't understand now. Wouldn't the given attributes just be
> used?

The primitive just indicates the requested bss selection criteria and
determines what other attributes are to be expected. Could determine it
by looking at the other attributes, but that would make it harder to
validate the request. This way it also makes them mutually exclusive.

> I was thinking you'd keep the NLA_FLAG "RSSI" preference, and use the
> attribute values for the bitmap ...

You lost me here.

> But still I think this isn't described very well.
> 
> Perhaps a good way of documenting this would be to say each primitive
> has a priority? E.g.
> 
>     Primitives with a lower document priority are executed first while
>     selecting a BSS:
> 
>     RSSI (priority 100)
>     BAND_PREF (priority 1)
>     RSSI_ADJUST (priority 1) [since it's mutually exclusive with
>     BAND_PREF]

Not sure about the priority. What I should document is that BAND_PREF
and RSSI_ADJUST also do RSSI based selection as a second step. As a
(possibly important) side note our firmware api allows multiple
primitives, but RSSI must be one of them as it will reject the
configuration otherwise. As such I could combine RSSI and RSSI_ADJUST as
RSSI would be RSSI_ADJUST(band=unspec, delta=0).

>> + * @NL80211_ATTR_BSS_SELECT_BAND_PREF: Required attribute indicating the
>> + *	preferred band. Value according %enum nl80211_band.
> 
> Why required?
> 
>> + * @NL80211_ATTR_BSS_SELECT_RSSI_ADJUST: When present the value is to be
>> + *	added to the RSSI level for BSS-es in the preferred band (s8).
> 
> Oh, ok, I see. It's necessary with this too. Still, I wouldn't say
> required, in case future extensions don't need it.
> 
> You should also more clearly document this though, I think, since in
> this case the preferred band isn't really a preferred band any more, it
> becomes just the "adjusted band".

Indeed. Will change it.

> I wonder if it'd be simpler to define two band attributes, and make
> RSSI_ADJUST and BAND_PREF mutually exclusive, adding RSSI_ADJUST_BAND.
> We could also use a complex struct value for the contents of
> RSSI_ADJUST, but that doesn't seem great either.

They are mutually exclusive as user-space can only give a single primitive.

Regards,
Arend
