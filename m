Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:35110 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbeF2SQN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 14:16:13 -0400
Received: by mail-ot0-f179.google.com with SMTP id j8-v6so8119306otl.2
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 11:16:13 -0700 (PDT)
Subject: Re: Proper SET_KEY usage?
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
References: <dbca726e-44c8-9a2f-2bb5-8a83c31f98e3@gmail.com>
 <1530266512.3481.68.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <0ce17959-d930-a563-242c-da24145e39f0@gmail.com> (sfid-20180629_201620_974680_67D7C753)
Date: Fri, 29 Jun 2018 13:16:10 -0500
MIME-Version: 1.0
In-Reply-To: <1530266512.3481.68.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 06/29/2018 05:01 AM, Johannes Berg wrote:
> Hi Denis,
> 
> Hope you don't mind me adding the list to the explanations, so they're
> recorded. Your questions are completely reasonable, after all :-)
> 

Absolutely do not mind.

>> So I've been poking around a bit more in nl80211/mac80211 stuff and I
>> was curious how exactly NEW_KEY/SET_KEY are supposed to be used.  The
>> documentation is lets say... less than stellar.
> 
> Yeah. This stuff grew out of WEXT mostly, and what things wpa_s did at
> the time...

Right.  My main intent with this was to see if I could understand things 
enough to actually start fixing some of the docs, see if we need to 
deprecate some things and/or maybe fix bits inside nl80211.

> 
>> So here's a excerpts from a capture of wpa_supplicant 2.6 connecting to
>> a PSK (CCMP + MFP-enabled) BSS.  So first thing it does is creates the
>> pairwise key via CMD_NEW_KEY:
>>
>> < Request: New Key (0x0b) len 68 [ack]
>>       Interface Index: 3 (0x00000003)
>>       Key Data: len 16
>>           [...]
>>       Key Cipher: CCMP (00:0f:ac) suite  04
>>       Key Sequence: len 6
>>           00 00 00 00 00 00
>>       MAC Address [...]
>>       Key Index: 0 (0x00)
>>   > Response: New Key (0x0b) len 4 [0x100]
>>       Status: Success (0)
>>
>> So far so good.
> 
> Yeah, that seems reasonable :-)
> 
>> The next thing it does is:
>> < Request: Set Key (0x0a) len 28 [ack]
>>       Interface Index: 3 (0x00000003)
>>       Key Index: 0 (0x00)
>>       Key Default: true
>>       Key Default Types: len 4
>>           Unicast: true
>>   > Response: Set Key (0x0a) len 4 [0x100]
>>       Status: Success (0)
>>
>> This part is a bit bizarre.
> 
> Yeah. Maybe Jouni can chime in why this happens. I suspect the reason is
> some legacy with wext or ancient drivers.
> 
>> First it seems to be a complete no-op on
>> mac80211 because mac80211 puts the key into sta->ptk, while
>> ieee80211_set_default_key is fully ignorant of the sta and only operates
>> on struct ieee80211_sub_if_data.
> 
> Indeed. PTKs are also immediately selected for TX.
> 
>> Is this really intended to be used
>> this way?  Is SET_KEY useful / necessary in an STA context?  What is the
>> intended usage here?
> 
> Even if we implement, in the future, PTK rekeying properly with non-zero
> key index, I think we could still set the key for TX immediately, and
> keep the other for RX, so it shouldn't be necessary in any way for a PTK
> (or actually for a per-station key, which differs slightly) context.

So it sounds like SET_KEY is completely unnecessary for a unicast key in 
an RSN/WPA association for an STA.  Should we update mac80211 (and 
possibly nl80211, though likely it doesn't have enough info) to issue a 
warning when someone tries to use set_key on such a key?

What about AP/IBSS?  Aren't unicast keys also per-station in this case? 
It sounds like SET_KEY isn't useful in this context either, right?

What about WEP?

Put another way, should we deprecate the whole 
NL80211_KEY_DEFAULT_TYPE_UNICAST attribute?

And since you went off on a tangent (maybe this needs a separate 
discussion?) but... Can you elaborate about PTK rekeying with a non-zero 
key index?  Are you saying that in IBSS/AP mode we can't support PTK rekey?

> 
> (The difference between them is that in IBSS you will have per-station
> GTKs, but that's also irrelevant because those are only used for RX -
> your own GTK on the netdev/wdev/sdata/vif level is used for TX.)

Okay, so for GTKs we would have a per-station RX GTK and a 'default' TX 
GTK.  So in this case a SET_KEY would be needed only on the 'default' TX 
GTK index.

Okay, maybe a tangent, but this brings up a question: Why do we have 
separate steps for this operation?  Can't we just issue a NEW_KEY and 
have the kernel figure this out?

> 
>> Okay, then wpa_s sets the Group key:
>> < Request: New Key (0x0b) len 64 [ack]
>>       Interface Index: 3 (0x00000003)
>>       Key Data: len 16
>>           [...]
>>       Key Cipher: CCMP (00:0f:ac) suite  04
>>       Key Sequence: len 6
>>           c8 08 00 00 00 00
>>       Key Default Types: len 4
>>           Multicast: true
>>       Key Index: 1 (0x01)
>>   > Response: New Key (0x0b) len 4 [0x100]
>>       Status: Success (0)
>>
>> wpa_s doesn't use CMD_SET_KEY at all for the key created above.  Notice
>> the completely superfluous 'Key Default Types' attribute.  This will be
>> ignored by nl80211 when invoking the add_key driver method.
> 
> CMD_SET_KEY is only used in contexts where you might transmit with the
> key, this isn't true for the GTK in client-mode.
> 
> The key types is an artifact of the IBSS I described I think, in this
> case you don't have a station MAC address for the key, but for GTK in
> IBSS you will have a MAC address (because the GTK for RX is per station)
> but you still need to tag it as being a GTK and not PTK.
> 

Well, that's what I was pointing out earlier, the whole Multicast 
attribute is ignored and should not be sent in the first place:

 >>       Key Default Types: len 4
 >>           Multicast: true

The proof :) follows:

add_key has the following signature:
         int     (*add_key)(struct wiphy *wiphy, struct net_device *netdev,
                            u8 key_index, bool pairwise, const u8 *mac_addr,
                            struct key_params *params);


and struct key_params is:
struct key_params {
         const u8 *key;
         const u8 *seq;
         int key_len;
         int seq_len;
         u32 cipher;
};

So while nl80211_new_key actually parses this information (stored in 
struct key_parse) it never forwards any of it to the driver.  The group 
key vs pairwise key determination seems to be predicated on presence of 
NL80211_ATTR_KEY_TYPE and the following fallback:

         if (key.type == -1) {
                 if (mac_addr)
                         key.type = NL80211_KEYTYPE_PAIRWISE;
                 else
                         key.type = NL80211_KEYTYPE_GROUP;
         }


>> Finally, the IGTK:
>> < Request: New Key (0x0b) len 64 [ack]
>>       Interface Index: 3 (0x00000003)
>>       Key Data: len 16
>>           06 2f e6 cf cf 3d ac 01 a4 4d 32 53 ef 45 2d df
>>       Key Cipher: BIP (00:0f:ac) suite  06
>>       Key Sequence: len 6
>>           2e ae 8c 67 0d 33
>>       Key Default Types: len 4
>>           Multicast: true
>>       Key Index: 4 (0x04)
>>
>> Again, no SET_KEY and the superfluous 'Key Default Types'.
> 
> Same considerations as for the GTK.
> 
>> So I wonder what is the purpose of NL80211_ATTR_KEY_DEFAULT_MGMT?  And
>> how is it supposed to be used?
> 
> This should be used only in AP mode though I think mac80211 doesn't
> because it just assumes once you get a new key you want to use it, but
> in theory you could switch back to an old key with it I think? At least
> from an API POV, perhaps not from an implementation POV.

Okay, so the drivers are expected to distinguish between a GTK and IGTK 
based on the cipher type, right?

So do we need a driver feature bit for NL80211_ATTR_KEY_DEFAULT_MGMT?

> 
>> It seems this was intended for SET_KEY to
>> be used with that attribute to enable protected management frame
>> transmission (see commit 3cfcf6ac6d69d).  And default_mgmt_key is still
>> being referenced in ieee80211_tx_h_select_key().  However, at least
>> according to this behavior it is never set.
> 
> Not in client mode. But in client mode you don't TX with the management
> key at all - you only RX with the multicast keys (GTK/IGTK).

Okay, that makes sense

> 
>> The same question is also relevant for default_multicast_key...
> 
> In AP/IBSS (and mesh?) modes this becomes relevant though, and then
> these do get set. nl80211_set_key() will call through if the key is
> default or default mgmt, and that will - in mac80211 - set these
> pointers to use for TX.
> 

Okay, so to summarize, SET_KEY should only be called on GTK/IGTK keys 
which are not per-MAC.  So in IBSS/AP mode we set this for our transmit 
GTK/IGTK key.

In IBSS mode, SET_KEY on peer's GTK shouldn't be issued.  In fact it may 
even be an error to do so since we might be messing with the wrong key 
unintentionally.

So I'd like to bring up a point I mentioned in the original message, 
should ieee80211_set_default_key() be made to return an error if 
userspace is trying to mess with a non-existent key?  That is 
effectively what happens in the STA log provided...

> Hope that helps a bit!
> 

Yep, thanks.
