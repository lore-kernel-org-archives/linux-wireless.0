Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44040 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbcASNUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 08:20:50 -0500
Message-ID: <1453209647.3896.22.camel@sipsolutions.net> (sfid-20160119_142053_723719_CD20D90B)
Subject: Re: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 19 Jan 2016 14:20:47 +0100
In-Reply-To: <569CB190.1000901@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
	 <1452678583-20086-3-git-send-email-arend@broadcom.com>
	 <1452769832.2444.14.camel@sipsolutions.net> <569CB190.1000901@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-01-18 at 10:34 +0100, Arend van Spriel wrote:

> > I'd prefer nl80211_bss_select_attr in this name and the constants
> > too,
> > so it's more obvious that it doesn't belong to the top-level
> > namespace.
> 
> Ok. Did not know that convention so it was not that obvious to me ;-)
> Will change it.

I don't think we really follow it everywhere, and - hindsight being
20/20 - I think that we should perhaps have chosen shorter prefixes :)

> > > + * @__NL80211_ATTR_BSS_SELECT_INVALID: reserved.
> > > + * @NL80211_ATTR_BSS_SELECT_PRIMITIVE: Indicates what criteria
> > > are to
> > > + *> 	> be used for bss selection. Value according
> > > + *	%enum nl80211_bss_select_primitive.
> > 
> > This I don't understand now. Wouldn't the given attributes just be
> > used?
> 
> The primitive just indicates the requested bss selection criteria and
> determines what other attributes are to be expected. Could determine
> it by looking at the other attributes, but that would make it harder
> to validate the request. This way it also makes them mutually
> exclusive.

I still don't really understand - if a given attribute just gives data
about the remaining attributes, how does it make a difference? You get
all the attributes at once, after all, and aren't really forced to
parse them as they trickle in.

> > I was thinking you'd keep the NLA_FLAG "RSSI" preference, and use
> > the attribute values for the bitmap ...
> 
> You lost me here.

I meant: use BIT(NL80211_BSS_SELECT_ATTR_BAND_PREF) instead of the
separate NL80211_BSS_SELECT_BAND_PREF.

Keeping the NLA_FLAG and all that was just a reference to the
discussion above.

> >     RSSI (priority 100)
> >     BAND_PREF (priority 1)
> >     RSSI_ADJUST (priority 1) [since it's mutually exclusive with
> >     BAND_PREF]
> 
> Not sure about the priority. What I should document is that BAND_PREF
> and RSSI_ADJUST also do RSSI based selection as a second step. As a
> (possibly important) side note our firmware api allows multiple
> primitives, but RSSI must be one of them as it will reject the
> configuration otherwise. As such I could combine RSSI and RSSI_ADJUST
> as RSSI would be RSSI_ADJUST(band=unspec, delta=0).

Ok, that's a different way of thinking about it.

I was thinking about it as a kind of small programmable state-machine
or pipeline in the BSS selection pipeline, so if you have

 band_pref, rssi

you basically have a first "element" in the pipeline that throws away
the BSSes that don't match the right band, and a second one that picks
the one with the highest RSSI.


If I understand you correctly, you're thinking about it more in terms
of the overall behaviour. That's perfectly fine with me, but then we
should document that more clearly.

Just to make sure I understand - you're basically saying that

 band_pref

would mean
 * throw away BSSes not matching the right band
 * pick the one with the highest RSSI

which basically makes it mutually exclusive with any of the other
attributes you suggested, where I was thinking that you'd pretty much
always have to specify multiple attributes to get a proper "pipeline".


Your way definitely has advantages too, particularly that you don't
need that whole discussion about priorities/ordering, which is good.

But then I understand the whole point of the "primitive" even less,
since it should be trivial to check that of multiple attributes only a
single one is specified?

johannes
