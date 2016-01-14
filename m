Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33470 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbcANLKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 06:10:36 -0500
Message-ID: <1452769832.2444.14.camel@sipsolutions.net> (sfid-20160114_121044_346336_2FC9C7ED)
Subject: Re: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Jan 2016 12:10:32 +0100
In-Reply-To: <1452678583-20086-3-git-send-email-arend@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
	 <1452678583-20086-3-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-13 at 10:49 +0100, Arend van Spriel wrote:
> 
> +/**
> + * enum nl80211_attr_bss_select - attributes for bss selection.

I'd prefer nl80211_bss_select_attr in this name and the constants too,
so it's more obvious that it doesn't belong to the top-level namespace.

> + * @__NL80211_ATTR_BSS_SELECT_INVALID: reserved.
> + * @NL80211_ATTR_BSS_SELECT_PRIMITIVE: Indicates what criteria are to
> + *> 	> be used for bss selection. Value according
> + *	%enum nl80211_bss_select_primitive.

This I don't understand now. Wouldn't the given attributes just be
used?

I was thinking you'd keep the NLA_FLAG "RSSI" preference, and use the
attribute values for the bitmap ...

But still I think this isn't described very well.

Perhaps a good way of documenting this would be to say each primitive
has a priority? E.g.

    Primitives with a lower document priority are executed first while
    selecting a BSS:

    RSSI (priority 100)
    BAND_PREF (priority 1)
    RSSI_ADJUST (priority 1) [since it's mutually exclusive with
    BAND_PREF]

> + * @NL80211_ATTR_BSS_SELECT_BAND_PREF: Required attribute indicating the
> + *	preferred band. Value according %enum nl80211_band.

Why required?

> + * @NL80211_ATTR_BSS_SELECT_RSSI_ADJUST: When present the value is to be
> + *	added to the RSSI level for BSS-es in the preferred band (s8).

Oh, ok, I see. It's necessary with this too. Still, I wouldn't say
required, in case future extensions don't need it.

You should also more clearly document this though, I think, since in
this case the preferred band isn't really a preferred band any more, it
becomes just the "adjusted band".

I wonder if it'd be simpler to define two band attributes, and make
RSSI_ADJUST and BAND_PREF mutually exclusive, adding RSSI_ADJUST_BAND.
We could also use a complex struct value for the contents of
RSSI_ADJUST, but that doesn't seem great either.

johannes
