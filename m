Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:41744 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732337AbeGJTRN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 15:17:13 -0400
Received: by mail-oi0-f44.google.com with SMTP id k12-v6so44736808oiw.8
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2018 12:16:47 -0700 (PDT)
Subject: Re: Proper SET_KEY usage?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
References: <dbca726e-44c8-9a2f-2bb5-8a83c31f98e3@gmail.com>
 <1530266512.3481.68.camel@sipsolutions.net>
 <0ce17959-d930-a563-242c-da24145e39f0@gmail.com>
 <1530879434.3197.32.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <2195bc60-8e33-b74a-fa27-ffda653ee814@gmail.com> (sfid-20180710_211650_749998_E724F2D1)
Date: Tue, 10 Jul 2018 14:16:45 -0500
MIME-Version: 1.0
In-Reply-To: <1530879434.3197.32.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 07/06/2018 07:17 AM, Johannes Berg wrote:
> Hi,
> 
>>> Yeah. This stuff grew out of WEXT mostly, and what things wpa_s did at
>>> the time...
>>
>> Right.  My main intent with this was to see if I could understand things
>> enough to actually start fixing some of the docs, see if we need to
>> deprecate some things and/or maybe fix bits inside nl80211.
> 
> :-)
> That'd be very welcome!
> 
>> So it sounds like SET_KEY is completely unnecessary for a unicast key in
>> an RSN/WPA association for an STA.  Should we update mac80211 (and
>> possibly nl80211, though likely it doesn't have enough info) to issue a
>> warning when someone tries to use set_key on such a key?
> 
> I'm not sure I see much point, since we'll have to deal with older wpa_s
> basically forever?

Do we though?  I can understand not breaking userspace APIs, but it 
seems like this API had only a single user (up until recently) and it 
'should' be acceptable to break ancient versions of it.  Whether we can 
or not is a question for the wider community though...

> 
>> What about AP/IBSS?  Aren't unicast keys also per-station in this case?
>> It sounds like SET_KEY isn't useful in this context either, right?
> 
> Yes, same situation really.
> 
>> What about WEP?
> 
> WEP is a special case, you typically use the same key for all traffic,
> and may switch around between them.
> 
> In theory though, and I think this API allows you to do it, you can have
> multiple WEP keys and use different ones for unicast/multicast TX. Or
> the same. Or switch them around as you like.
> 
>> Put another way, should we deprecate the whole
>> NL80211_KEY_DEFAULT_TYPE_UNICAST attribute?
> 
> Perhaps. I'm not sure I see much point in it. The WEP case above is
> pretty fringe, and wext didn't support it, so ... probably not needed?

Should we at least take this out of the driver API then and have it 
ignored by nl80211?  And maybe mark this deprecated in the docs?

> 
>> And since you went off on a tangent (maybe this needs a separate
>> discussion?) but... Can you elaborate about PTK rekeying with a non-zero
>> key index?  Are you saying that in IBSS/AP mode we can't support PTK rekey?
> 
> We can't properly support PTK rekeying in any mode, see Alexander
> Wetzel's patch and the whole discussion on the different versions I had
> with him. I'll merge his patch soon I think, but it doesn't really work
> properly.

I think we had this conversation before.  Up to 802.11-2012, PTK Rekey 
was not really explicitly mentioned as possible.  There were hints and 
stuff, but no explicit language.

I think in 802.11-2016 they finally explicitly say that this is possible.

However, we seem to have networks that perform PTK Rekey and even full 
802.1X re-auth every hour (eduroam for example).  How is this working? 
Or is it a case of it not always working?

> 
> Some time relatively recently (802.11-2016 I think) the spec has
> introduced a method to indicate that you support what was previously not
> allowed at all: using non-zero key index for a PTK. This way, you can do
> transparent PTK rekeying like you do with GTK now, by switching to a new
> key index when you rekey.

And keep the old one for whatever packets are in process, right?  That 
makes more sense.

> 
> We don't - currently - support this in mac80211 or even wpa_supplicant,
> and I expect many devices would have issues with this with hardware
> offload. I'm also not aware of any certification program for it, but I
> also haven't followed the WPA3 efforts (but I don't think they're
> focused here, they're focused on algorithms and higher layers IIRC.)
> 

Does the recent PMK handshake offload support proposal take into 
consideration PTK rekeying?

>>> (The difference between them is that in IBSS you will have per-station
>>> GTKs, but that's also irrelevant because those are only used for RX -
>>> your own GTK on the netdev/wdev/sdata/vif level is used for TX.)
>>
>> Okay, so for GTKs we would have a per-station RX GTK and a 'default' TX
>> GTK.  So in this case a SET_KEY would be needed only on the 'default' TX
>> GTK index.
>>
>> Okay, maybe a tangent, but this brings up a question: Why do we have
>> separate steps for this operation?  Can't we just issue a NEW_KEY and
>> have the kernel figure this out?
> 
> I think the only case would be WEP?

So can we expect all drivers to operate this way?  Or should we maybe 
also have nl80211 call set_key operation on a key with no associated STA 
implicitly?

> 
>> Well, that's what I was pointing out earlier, the whole Multicast
>> attribute is ignored and should not be sent in the first place:
>>
>>   >>       Key Default Types: len 4
>>   >>           Multicast: true
>>
>> The proof :) follows:
> 
> :)
> 
>> So while nl80211_new_key actually parses this information (stored in
>> struct key_parse) it never forwards any of it to the driver.  The group
>> key vs pairwise key determination seems to be predicated on presence of
>> NL80211_ATTR_KEY_TYPE and the following fallback:
>>
>>           if (key.type == -1) {
>>                   if (mac_addr)
>>                           key.type = NL80211_KEYTYPE_PAIRWISE;
>>                   else
>>                           key.type = NL80211_KEYTYPE_GROUP;
>>           }
> 
> Yeah.
> 
>> Okay, so the drivers are expected to distinguish between a GTK and IGTK
>> based on the cipher type, right?
> 
> Not needed, IGTK also uses key index 4/5, while GTK uses 0-3.
> 
>> So do we need a driver feature bit for NL80211_ATTR_KEY_DEFAULT_MGMT?
> 
> I don't see why, the driver should support it if it has support for IGTK
> in the first place? And for AP mode, since otherwise it doesn't matter
> (IGTK like GTK is RX-only for the client)
> 
>> Okay, so to summarize, SET_KEY should only be called on GTK/IGTK keys
>> which are not per-MAC.  So in IBSS/AP mode we set this for our transmit
>> GTK/IGTK key.
> 
> I suspect you don't even *need* SET_KEY on GTK/IGTK since they're set to
> be TX when installed, I think?
> 
>> In IBSS mode, SET_KEY on peer's GTK shouldn't be issued.  In fact it may
>> even be an error to do so since we might be messing with the wrong key
>> unintentionally.
> 
> I don't think we would mess with the wrong key, since we need to give
> the station MAC address and then it's not our TX key. But certainly
> doing SET_KEY for a GTK that you expect to *receive* with isn't useful.

Right.

> 
>> So I'd like to bring up a point I mentioned in the original message,
>> should ieee80211_set_default_key() be made to return an error if
>> userspace is trying to mess with a non-existent key?  That is
>> effectively what happens in the STA log provided...
> 
> Perhaps, though that might break wpa_s?
> 

Doesn't wpa_s ignore most errors anyway? :)

Regards,
-Denis
