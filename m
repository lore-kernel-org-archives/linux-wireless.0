Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468ECC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D66B207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 08:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfBVIvF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 03:51:05 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:33462 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbfBVIvF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 03:51:05 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gx6Xu-0005zw-IY; Fri, 22 Feb 2019 09:51:02 +0100
Message-ID: <fbe9234012f91ba6a209f426e95a284f482554c1.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 05/12] mac80211: Mark A-MPDU keyid borders for
 drivers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 22 Feb 2019 09:51:00 +0100
In-Reply-To: <a4cf7a7a-104d-b685-8fd4-a9dfac97ecb9@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-6-alexander@wetzel-home.de>
         <c64a7a722fefe698e86dbc61ab4d6d2e087ae853.camel@sipsolutions.net>
         <a4cf7a7a-104d-b685-8fd4-a9dfac97ecb9@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-02-21 at 22:20 +0100, Alexander Wetzel wrote:

> > I think it may make sense - reprogramming the hardware engines may take
> > some time, and doing that in the middle of the A-MPDU may not be
> > feasible? You don't just have to load the key (that you need to do
> > anyway) but also extract the status? I dunno, I'm more handwaving, but
> > it doesn't make sense to add such a requirement when only one key index
> > can be used to start with.
> > 
> 
> I'm pretty new to all that and I know I have still huge gaps everywhere.

And I'm just handwaving ;-)

But I know that for example we have A-MPDU spacing rules, ie. sometimes
padding must be inserted by the transmitter to give the receiver's HW or
FW enough time to program crypto engines. It thus stands to reason that
in order to minimise the spacing you'd want to keep the key material at
hand in the engine while processing the whole A-MPDU.

> But the card must be able to process MPDUs using both KeyIDs at that 
> moment already. When receiving a A-MPDU it should not be very hard to 
> check each MPDU and process it accordingly. (TX should even be simpler: 
> The driver simply can decide if he want's to have a key border in the 
> A-MPDU or not and switch to key when it wants.)

I tend to agree, but you never know in what surprising ways hardware
engines work :-)

> > > The code is assuming that the driver is not aggregating MPDUs more than
> > > 5s apart. We probably don't have wait nearly so long but I'm not sure
> > > what is the minimum time.
> > 
> > OTOH, if you have a lot of BE/VI/VO traffic BK might be starved even
> > longer than that, technically indefinitely.
> > 
> 
> Hm, there is nothing preventing us to drop this "idle" switch as long as 
> we also drop the 10s Rx accel offload when idle fallback in the COMPAT 
> patch. (We have to drop the RX idle accel patch or get a small risk of 
> dropping packets in unlikely but possible scenarios. If that are eapol 
> packets things will become hairy, probably disconnecting the sta.)
> 
> It just feels strange to potentially still use the old key for one 
> packet more without time limit. It could be, that the first EAPOL packet 
> we send for the next rekey would still use the previous key, the second 
> eapol packet the current.

Not sure I understand this. If we have no TX going on at all, then
surely we can switch with the next packet, before we encrypt it?

And if we have a packet sitting on hardware queues forever, then we
can't do anything about it anyway?

> > > +	if (sta->ptk_idx_next == sta->ptk_idx) {
> > > +		/* First packet using new key with A-MPDU active*/
> > > +		sta->ptk_idx_next = INVALID_PTK_KEYIDX;
> > > +		ieee80211_check_fast_xmit(tx->sta);
> > 
> > I'm not convinced you can call this from this context? It looks safe
> > though, but it's really strange in a way.
> > 
> 
> Well, it's seems to work fine, no warnings or problems so far:-)
> 
> But I also had doubts and only after finding out that 
> ieee80211_check_fast_xmit() is already being called from the same 
> context I dared to use it, see ieee80211_tx_prepare().

OK :-)
I guess I misremembered then.

> > > +	info->flags &= ~IEEE80211_TX_CTL_AMPDU;
> > 
> > Like you say above, I don't think this really makes a lot of sense. If
> > we don't have any free bits I guess we should try to find some ...
> 
> Well, all I can think of is quite invasive, so I hoped you would have a 
> better idea:

I think we have free bits in enum mac80211_tx_control_flags, so that
should be workable? They won't be preserved until TX status, but that's
OK for this purpose, no?

johannes

