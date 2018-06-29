Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36406 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933560AbeF2KBz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 06:01:55 -0400
Message-ID: <1530266512.3481.68.camel@sipsolutions.net> (sfid-20180629_120201_244457_8A2F023B)
Subject: Re: Proper SET_KEY usage?
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Fri, 29 Jun 2018 12:01:52 +0200
In-Reply-To: <dbca726e-44c8-9a2f-2bb5-8a83c31f98e3@gmail.com> (sfid-20180621_040002_224851_B364C057)
References: <dbca726e-44c8-9a2f-2bb5-8a83c31f98e3@gmail.com>
         (sfid-20180621_040002_224851_B364C057)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

Hope you don't mind me adding the list to the explanations, so they're
recorded. Your questions are completely reasonable, after all :-)

> So I've been poking around a bit more in nl80211/mac80211 stuff and I 
> was curious how exactly NEW_KEY/SET_KEY are supposed to be used.  The 
> documentation is lets say... less than stellar.

Yeah. This stuff grew out of WEXT mostly, and what things wpa_s did at
the time...

> So here's a excerpts from a capture of wpa_supplicant 2.6 connecting to 
> a PSK (CCMP + MFP-enabled) BSS.  So first thing it does is creates the 
> pairwise key via CMD_NEW_KEY:
> 
> < Request: New Key (0x0b) len 68 [ack]
>      Interface Index: 3 (0x00000003)
>      Key Data: len 16
>          [...]
>      Key Cipher: CCMP (00:0f:ac) suite  04
>      Key Sequence: len 6
>          00 00 00 00 00 00
>      MAC Address [...]
>      Key Index: 0 (0x00)
>  > Response: New Key (0x0b) len 4 [0x100]
>      Status: Success (0)
> 
> So far so good.

Yeah, that seems reasonable :-)

> The next thing it does is:
> < Request: Set Key (0x0a) len 28 [ack]
>      Interface Index: 3 (0x00000003)
>      Key Index: 0 (0x00)
>      Key Default: true
>      Key Default Types: len 4
>          Unicast: true
>  > Response: Set Key (0x0a) len 4 [0x100]
>      Status: Success (0)
> 
> This part is a bit bizarre.

Yeah. Maybe Jouni can chime in why this happens. I suspect the reason is
some legacy with wext or ancient drivers.

> First it seems to be a complete no-op on 
> mac80211 because mac80211 puts the key into sta->ptk, while 
> ieee80211_set_default_key is fully ignorant of the sta and only operates 
> on struct ieee80211_sub_if_data.  

Indeed. PTKs are also immediately selected for TX.

> Is this really intended to be used 
> this way?  Is SET_KEY useful / necessary in an STA context?  What is the 
> intended usage here?

Even if we implement, in the future, PTK rekeying properly with non-zero 
key index, I think we could still set the key for TX immediately, and
keep the other for RX, so it shouldn't be necessary in any way for a PTK
(or actually for a per-station key, which differs slightly) context.

(The difference between them is that in IBSS you will have per-station
GTKs, but that's also irrelevant because those are only used for RX -
your own GTK on the netdev/wdev/sdata/vif level is used for TX.)

> Okay, then wpa_s sets the Group key:
> < Request: New Key (0x0b) len 64 [ack]
>      Interface Index: 3 (0x00000003)
>      Key Data: len 16
>          [...]
>      Key Cipher: CCMP (00:0f:ac) suite  04
>      Key Sequence: len 6
>          c8 08 00 00 00 00
>      Key Default Types: len 4
>          Multicast: true
>      Key Index: 1 (0x01)
>  > Response: New Key (0x0b) len 4 [0x100]
>      Status: Success (0)
> 
> wpa_s doesn't use CMD_SET_KEY at all for the key created above.  Notice 
> the completely superfluous 'Key Default Types' attribute.  This will be 
> ignored by nl80211 when invoking the add_key driver method.

CMD_SET_KEY is only used in contexts where you might transmit with the
key, this isn't true for the GTK in client-mode.

The key types is an artifact of the IBSS I described I think, in this
case you don't have a station MAC address for the key, but for GTK in
IBSS you will have a MAC address (because the GTK for RX is per station)
but you still need to tag it as being a GTK and not PTK.

> Finally, the IGTK:
> < Request: New Key (0x0b) len 64 [ack]
>      Interface Index: 3 (0x00000003)
>      Key Data: len 16
>          06 2f e6 cf cf 3d ac 01 a4 4d 32 53 ef 45 2d df
>      Key Cipher: BIP (00:0f:ac) suite  06
>      Key Sequence: len 6
>          2e ae 8c 67 0d 33
>      Key Default Types: len 4
>          Multicast: true
>      Key Index: 4 (0x04)
> 
> Again, no SET_KEY and the superfluous 'Key Default Types'.

Same considerations as for the GTK.

> So I wonder what is the purpose of NL80211_ATTR_KEY_DEFAULT_MGMT?  And 
> how is it supposed to be used?

This should be used only in AP mode though I think mac80211 doesn't
because it just assumes once you get a new key you want to use it, but
in theory you could switch back to an old key with it I think? At least
from an API POV, perhaps not from an implementation POV.

> It seems this was intended for SET_KEY to 
> be used with that attribute to enable protected management frame 
> transmission (see commit 3cfcf6ac6d69d).  And default_mgmt_key is still 
> being referenced in ieee80211_tx_h_select_key().  However, at least 
> according to this behavior it is never set.

Not in client mode. But in client mode you don't TX with the management
key at all - you only RX with the multicast keys (GTK/IGTK).

> The same question is also relevant for default_multicast_key...

In AP/IBSS (and mesh?) modes this becomes relevant though, and then
these do get set. nl80211_set_key() will call through if the key is
default or default mgmt, and that will - in mac80211 - set these
pointers to use for TX.

Hope that helps a bit!

johannes
