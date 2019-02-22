Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D4EC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0530220700
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfBVImB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:42:01 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:33346 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfBVImB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 03:42:01 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gx6P8-0005ns-A5; Fri, 22 Feb 2019 09:41:58 +0100
Message-ID: <767ada740d984e180d0ac799487722293a50367c.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 03/12] mac80211: IEEE 802.11 Extended Key ID
 support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Feb 2019 09:41:56 +0100
In-Reply-To: <171d2db4-7639-4738-2a6d-c899f0247aee@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-4-alexander@wetzel-home.de>
         <f4d8db23bc3804fdc98f2ce7a702215bd82fd4e3.camel@sipsolutions.net>
         <e27bffe8-4c75-34d9-b326-39ffb05b73eb@wetzel-home.de>
         <171d2db4-7639-4738-2a6d-c899f0247aee@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-02-21 at 20:47 +0100, Alexander Wetzel wrote:
> > > > 
> > > >   - Enforce cipher does not change when replacing a key.
> > > 
> > > is that actually required somehow?
> > 
> > The code is silently assuming a rekey is using the same cipher. Someone 
> > e.g. switching from WEP to CCMP with a rekey would pass all sanity 
> > checks and allow to use the code in a way never intended or tested.
> > With the current handling the userspace e.g. should be able to install a 
> > WEB key using keyid 3 and then rekey it with a CCMP key, claiming keyid 
> > 0 bit mac80211 will copy the keyid from the old and use keyid 3. 
> > Something not possible otherwise.
> > 
> > That said I do not see how this could be exploited, I simply try to 
> > enforce all assumptions to be on the safe side. (I did not dig deeper 
> > into potential exploits after finding out how keyids are used during 
> > rekey.)

Ok. That's fair, but it'd be good to add that reasoning to the commit
log or even a comment where the validation happens.


> > Second, I spend quite some time finding good names for the calls and one 
> > of the last tweaks to this patch was replacing SET_KEY_RX_ONLY to 
> > EXT_SET_KEY...

:)

> > So here the reasoning for why I named them as they are and why I  prefer 
> > the names used in the patch.
> > First, many drivers will handle SET_KEY and SET_KEY_RX_ONLY with the 
> > same code and not differentiate between those at all. Using EXT_as a 
> > prefix for the "normal" command is therefore a nice way to imply the 
> > command can only be used with Extended Key ID and still link it to the 
> > original command.
> > But more important for me was the clash between what the command spells 
> > and what it does in the COMPAT mode: SET_KEY_RX_ONLY would then be used 
> > to install a TX only key which never can be used by the card for Rx.
> > So I decided to rename it to EXT_SET_KEY, just indicating that this 
> > command adds a new key to the card for Extended Key ID and drop the 
> > confusing reference to Rx.

Wait, what? In compat mode SET_KEY_RX_ONLY installs a TX-only key? Ah,
you mean before you changed this.

Why don't we split out compat mode then?

But I see where you're coming from with the EXT_ now. I need to think of
it less as an "extension" now, but as "extended key ID". I'm not really
entirely sure that makes sense - even what we think of as "extended key
ID" now might be the new normal soon? But then again the spec does the
same thing.

> > Long story short: Using SET_KEY_RXONLY and SET_KEY_TX is not wrong, but 
> > I would rate them more confusing.

Fair enough.

> > > > +static int ieee80211_set_tx_key(struct ieee80211_sub_if_data *sdata,
> > > > +                const u8 *mac_addr, u8 key_idx)
> > > > +{
> > > > +    struct ieee80211_local *local = sdata->local;
> > > > +    struct ieee80211_key *key;
> > > > +    struct sta_info *sta;
> > > > +    int ret;
> > > > +
> > > > +    if (!wiphy_ext_feature_isset(local->hw.wiphy,
> > > > +                     NL80211_EXT_FEATURE_EXT_KEY_ID))
> > > > +        return -EINVAL;
> > > 
> > > You set this, wouldn't it make more sense to check EXT_KEY_ID_NATIVE?
> > > 
> > > Or maybe this is because of the next patch?

> Exactly. With COMPAT we would have to check for EXT_KEY_ID_NATIVE and 
> EXT_KEY_ID_COMPAT. Since we have already done that and set 
> NL80211_EXT_FEATURE_EXT_KEY_ID I check that here.
> Assuming we merge NATIVE and drop COMPAT it may make sense to keep the 
> check here and drop EXT_KEY_ID_NATIVE altogether.
> The drivers than can set NL80211_EXT_FEATURE_EXT_KEY_ID directly.

Yes, I think I get it. I don't think we need to drop compat, it seems
somewhat useful for some drivers - I think I mostly just got confused
here because compat support only comes later, and I wasn't really
thinking about it yet in the context of this patch.

> > I have to look at that again. It will change some assumptions for sure 
> > but still could work out with some slight differences. I'll have to look 
> > deeper into that since I remember two moments where I was sure needing 
> > the flag. That may well be outdated, but at a first glance it would at 
> > least open the door to first install two key in legacy mode and then 
> > switch between them. (Which should be no problem, of course)
> > I'll follow up on that separately, but that may take some time. When it 
> > works you'll get a new RFC.

No worries :-)
I don't really mind the flag, but much of the use I've seen now here
seemed equivalent, and then it doesn't seem necessary.

> > > > +    key->flags &= ~KEY_FLAG_RX_ONLY;
[snip]
> > > > +    if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
> > > > +        ret = drv_set_key(local, EXT_KEY_RX_TX, sdata,
> > > > +                  &sta->sta, &key->conf);
> > > > +        if (ret) {
> > > > +            sdata_err(sdata,
> > > > +                  "failed to activate key for Tx (%d, %pM)\n",
> > > > +                  key->conf.keyidx, sta->sta.addr);
> > > > +            return ret;
> > > 
> > > You've already cleared the RX_ONLY flag, which gets you inconsistent
> > > data now.
> > > 
> > 
> > I don't think so, it looks ok for me. But the delay_tailroom logic took 
> > a surprisingly large chunk of time and I should explain how the updated 
> > logic is intended to work. Maybe I've messed it up somehow and just do 
> > not see it:

My comment wasn't related to tailroom accounting at all. I've snipped
more code above to hopefully make it clearer.

If you fail to activate the key in the driver, then the key is not
actually enabled for TX, and thus you should not have cleared the
KEY_FLAG_RX_ONLY? You'll be returning this error all the way to
userspace, I assume.

(Maybe, btw, the driver should be allowed to return something like
"oops, I now want to use TX software crypto" like it can do for other
operations?)

> > > >   #define NUM_DEFAULT_KEYS 4
> > > >   #define NUM_DEFAULT_MGMT_KEYS 2
> > > > +#define INVALID_PTK_KEYIDX 2 /* Existing key slot never used by PTK 
> > > > keys */
> > > 
> > > We could also use something obviously wrong like 0xff?
> > 
> > No, not without some undesired modifications. We actually fetch the 
> > referenced key and the key slot must exist and be NULL. We (mostly) 
> > discussed that in the previous RFC, I just decided to use a define 
> > instead the numeric value. (Mostly due the fact that A-MPDU also needs 
> > an "invalid" ID and using the same looks like a good idea.

Hm, yeah, I vaguely remember. OK.

> > That's only right for the push path but can send out wrong packets when 
> > the driver is using the pull path:
> > 
> > 1) ieee80211_xmit_fast() will use fast_tx structure to fill in the 
> > "cached" keyid and queue the packet. (let's say 0)
> > 
> > 2) ieee80211_check_fast_xmit is called due to a rekey (and keyid change 
> > from 0 -> 1)
> > 
> > 3) ieee80211_tx_dequeue() will then dequeue the prepared skb from 1), 
> > refresh the key information but keep keyid 0 in the skb and instruct the 
> > driver to encrypt it for keyid 1 -> WRONG
> > 
> > 4) The remote sta tries to decrypt the packet using the key 0, as 
> > referenced by the keyid. Which will of course not work.
> > 
> > With Extended Key ID (and some debugging) I added a simple rule: When 
> > you assign the pn you also set the matching keyid.

OK.

johannes

