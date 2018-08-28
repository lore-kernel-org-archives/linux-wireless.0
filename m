Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50888 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbeH1M5E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:57:04 -0400
Message-ID: <1535447171.5895.21.camel@sipsolutions.net> (sfid-20180828_110630_899963_F7A36388)
Subject: Re: Proper SET_KEY usage?
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Date: Tue, 28 Aug 2018 11:06:11 +0200
In-Reply-To: <2195bc60-8e33-b74a-fa27-ffda653ee814@gmail.com> (sfid-20180710_211648_538942_EDF95DAD)
References: <dbca726e-44c8-9a2f-2bb5-8a83c31f98e3@gmail.com>
         <1530266512.3481.68.camel@sipsolutions.net>
         <0ce17959-d930-a563-242c-da24145e39f0@gmail.com>
         <1530879434.3197.32.camel@sipsolutions.net>
         <2195bc60-8e33-b74a-fa27-ffda653ee814@gmail.com>
         (sfid-20180710_211648_538942_EDF95DAD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-07-10 at 14:16 -0500, Denis Kenzior wrote:

> > I'm not sure I see much point, since we'll have to deal with older wpa_s
> > basically forever?
> 
> Do we though?  I can understand not breaking userspace APIs, but it 
> seems like this API had only a single user (up until recently) and it 
> 'should' be acceptable to break ancient versions of it.  Whether we can 
> or not is a question for the wider community though...

I don't think so. It'll be hurting various consumers like Android,
Chrome, etc.

"Ancient" versions is also relative - there hasn't been a release of
wpa_s in a long time, for example.

> > > Put another way, should we deprecate the whole
> > > NL80211_KEY_DEFAULT_TYPE_UNICAST attribute?
> > 
> > Perhaps. I'm not sure I see much point in it. The WEP case above is
> > pretty fringe, and wext didn't support it, so ... probably not needed?
> 
> Should we at least take this out of the driver API then and have it 
> ignored by nl80211?  And maybe mark this deprecated in the docs?

I guess we could do that, yeah.

> > > And since you went off on a tangent (maybe this needs a separate
> > > discussion?) but... Can you elaborate about PTK rekeying with a non-zero
> > > key index?  Are you saying that in IBSS/AP mode we can't support PTK rekey?
> > 
> > We can't properly support PTK rekeying in any mode, see Alexander
> > Wetzel's patch and the whole discussion on the different versions I had
> > with him. I'll merge his patch soon I think, but it doesn't really work
> > properly.
> 
> I think we had this conversation before.  Up to 802.11-2012, PTK Rekey 
> was not really explicitly mentioned as possible.  There were hints and 
> stuff, but no explicit language.

Actually it was sort of forbidden - key index had to be 0 for PTK, and
so you couldn't do a proper hand-over.

> I think in 802.11-2016 they finally explicitly say that this is possible.

Yes.

> However, we seem to have networks that perform PTK Rekey and even full 
> 802.1X re-auth every hour (eduroam for example).  How is this working? 
> Or is it a case of it not always working?

It's not working well in practice, see Alexander's patchset.

> > Some time relatively recently (802.11-2016 I think) the spec has
> > introduced a method to indicate that you support what was previously not
> > allowed at all: using non-zero key index for a PTK. This way, you can do
> > transparent PTK rekeying like you do with GTK now, by switching to a new
> > key index when you rekey.
> 
> And keep the old one for whatever packets are in process, right?  That 
> makes more sense.

Like GTK - you just keep it "forever" (until the next rekey round) for
RX, but nobody uses it for TX anymore.

> > We don't - currently - support this in mac80211 or even wpa_supplicant,
> > and I expect many devices would have issues with this with hardware
> > offload. I'm also not aware of any certification program for it, but I
> > also haven't followed the WPA3 efforts (but I don't think they're
> > focused here, they're focused on algorithms and higher layers IIRC.)
> 
> Does the recent PMK handshake offload support proposal take into 
> consideration PTK rekeying?

No, I don't think the two are related? If you offload the handshake, you
may or may not implement PTK rekeying in the 802.11-2016 or in the non-
working way ...

> > > > (The difference between them is that in IBSS you will have per-station
> > > > GTKs, but that's also irrelevant because those are only used for RX -
> > > > your own GTK on the netdev/wdev/sdata/vif level is used for TX.)
> > > 
> > > Okay, so for GTKs we would have a per-station RX GTK and a 'default' TX
> > > GTK.  So in this case a SET_KEY would be needed only on the 'default' TX
> > > GTK index.
> > > 
> > > Okay, maybe a tangent, but this brings up a question: Why do we have
> > > separate steps for this operation?  Can't we just issue a NEW_KEY and
> > > have the kernel figure this out?
> > 
> > I think the only case would be WEP?
> 
> So can we expect all drivers to operate this way?  Or should we maybe 
> also have nl80211 call set_key operation on a key with no associated STA 
> implicitly?

I don't know what drivers do, but I guess you could find out pretty
easily and then do that, yeah. I suspect they just all ignore it because
they couldn't figure out what the point was :)

> > > So I'd like to bring up a point I mentioned in the original message,
> > > should ieee80211_set_default_key() be made to return an error if
> > > userspace is trying to mess with a non-existent key?  That is
> > > effectively what happens in the STA log provided...
> > 
> > Perhaps, though that might break wpa_s?
> > 
> 
> Doesn't wpa_s ignore most errors anyway? :)

Many, but you never really know without trying :)

johannes
