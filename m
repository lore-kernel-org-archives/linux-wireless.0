Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCFFC04EB9
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 07:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C1C920989
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 07:32:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C1C920989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbeLFHcX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 02:32:23 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:32796 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbeLFHcX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 02:32:23 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gUo8z-0008GQ-Al; Thu, 06 Dec 2018 08:32:21 +0100
Message-ID: <61c9ed7fc16517991cda3c9d930b53c24306234e.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 2/2] mac80211: Add support for Extended Key ID
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 06 Dec 2018 08:32:20 +0100
In-Reply-To: <d20b43fc-408c-d3fb-75b2-9c2bffd37264@wetzel-home.de>
References: <20181111110235.14213-1-alexander@wetzel-home.de>
         <20181111110235.14213-3-alexander@wetzel-home.de>
         <24665c3e0e7e970eb8cd63dad57e2b0b3097cfcc.camel@sipsolutions.net>
         <d20b43fc-408c-d3fb-75b2-9c2bffd37264@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> > > -	/* PTK only using key ID 0 needs special handling on rekey */
> > > -	if (new_key && sta && ptk0rekey) {
> > > +	/* PTK rekey without Extended Key ID needs special handling */
> > > +	if (new_key && pairwise && sta &&
> > > +	    !test_sta_flag(sta, WLAN_STA_EXT_KEY_ID)) {
> > >   		local = old_key->local;
> > >   		sdata = old_key->sdata;
> > 
> > This seems wrong, even if you have ext key ID support and everything,
> > but you do 0 -> 0 rekeying, then you still need all the special handling
> > (in fact also then if you go 1->1!). So it seems you'd instead want to
> > see if you're going from a TX key to a TX key with the same key ID, and
> > then you don't need this flag at all.
> > 
> 
> The intention for Extended Key ID is, to have a comparable short time 
> frame where both key IDs can be used. When replacing e.g. key ID 0 again 
> it should be idle for a long time. I guess if someone starts re-keying 
> in 1s intervals it may become an issue, but then anyone re-keying that 
> often can't be helped...

Sure. But ... not sure how that's related?

> With Extended Key IDs it's impossible to directly switch from a TX key 
> with one key ID to another one with the same id.
> 
> 1) Association
> 2) key ID 0 installed RX only
> 3) key Id 0 set_tx
> 4) rekey timeout passes
> 5) key ID 1 installed RX only
> 6) key ID 1 set_tx (also making key ID 0 RX only)
> 7) rekey timeout passes
> 8) key ID 0 replaced with new RX only key
> 9) key ID 0 set_tx
> 10) rekey timeout passes
> ...
> 
> So nobody will use the key being replaced, we don't have to protect 
> against PN poisoning.

Exactly.

> And when a driver supports Extended Key ID we 
> don't care about if the driver is able to rekey PTK0 correctly.

Strictly speaking, that's false, since you don't know if wpa_s actually
used it, and the peer STA allowed it.

It's also not what you implemented, you implemented checking if
NL80211_KEY_RX_ONLY was ever used.

However, what I'm trying to say is that I'm not sure this makes sense?

It seems to me it would be safer, and easier (no station flag), to just
check

 if ("we're replacing the current TX key")

and trigger the workarounds in that case. No?

Yes, parts of the issue also manifest themselves on the RX side, but if
you're not replacing the current key then you were using extended key ID
support?

> > > +++ b/net/mac80211/sta_info.c
> > > @@ -350,6 +350,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
> > >   	sta->sta.max_rx_aggregation_subframes =
> > >   		local->hw.max_rx_aggregation_subframes;
> > >   
> > > +	sta->ptk_idx = NUM_DEFAULT_KEYS - 1;
> > 
> > That makes no sense? Why should it be 3? That's invalid anyway?
> 
> Yes, that's the whole reason for that change:-) Setting it to 2 would 
> also be fine, as long as it's not 0 or 1.

Hmm, ok. So that probably wants a big comment saying that it relies on
key idx 2/3 being invalid. I'm not sure I like the NUM_DEFAULT_KEYS-1,
better perhaps to do something like

	/* comment saying why */
	BUILD_BUG_ON(ARRAY_SIZE(sta->ptks) > 2);
	sta->ptk_idx = 2;

or so?

> ieee80211_tx_h_select_key starts encrypting packets as soon as 
> sta->ptk[tx->sta->ptk_idx] is not null.

Right, so I guess this makes sense.

johannes

