Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87F25C65C24
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 19:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F69B2087D
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 19:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F69B2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbeJHDHf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 23:07:35 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45378 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeJHDHf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 23:07:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9FCn-00061H-LC; Sun, 07 Oct 2018 21:59:09 +0200
Message-ID: <1538942338.2928.21.camel@sipsolutions.net>
Subject: Re: [RFC v2] cfg80211: add peer measurement with FTM API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Sun, 07 Oct 2018 21:58:58 +0200
In-Reply-To: <b72e2702-64dd-4ac9-89a4-6fd4d03363ed@codeaurora.org>
References: <20181001133511.25046-1-johannes@sipsolutions.net>
         <b72e2702-64dd-4ac9-89a4-6fd4d03363ed@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Lior,

Thanks for taking the time :-)

> > Results availability is multicast on a new "peer-measurement"
> > multicast group, and results can be retrieved by dumping the
> > data given the measurement cookie. Note that dumping it from
> > the netlink socket that started the measurement will delete
> > data, to allow not hanging on to measurement data forever when
> > the measurement is long-running and only updates periodically.
> 
> Just curious, what's the advantage of this compared to sending the reply only on
> the socket that started the measurement?

TBH, I don't really see any. Some people really wanted this for things
like "let's do something in iw for measurements", though even that is
not strictly necessary since you can always start listening for events
as (before) you send off your request. It's slightly more complicated in
terms of socket handling (as you need to be able to handle events while
waiting for the netlink ACK message) but that's not so bad.

I'm all for it, so perhaps I'll change that.

In that case, it might even make sense to continue with the simple "send
out results to userspace as we get them" approach, since the application
that made the request will know to dedicate a socket with socket buffer
to it, and handle it quickly, avoiding the problems with running out of
socket buffer space and losing the "measurement complete" event (that I
was worried about with our [Intel] original code of just multicasting
the results).

> > + * @lci_len: length of LCI information (if present)
> > + * @civicloc_len: length of civic location information (if present)
> 
> Consider naming lcr (location civic report) instead of civicloc (this is what we
> used in our QCA vendor API)

Hmm. I guess we already did "civic location" in the FTM-responder side
API, but perhaps we can change it.

> > + * @rtt_avg: average of RTTs measured (must have either this or @dist_avg)

> For debugging it might be useful to report the distance in each measurement,

We did in fact originally report the distance unconditionally (rather
than RTT and/or distance) but it ends up a multiplication by the speed
of light (in air, but it was approximate enough this didn't matter), but
I felt that such a calculation is so easy to do we may as well do it in
iw/userspace?

Unless I'm misunderstanding?

> and
> also the raw T1-T4 values. 

Makes sense.

> Having T1-T4 in user space also allow running clock
> drift correction algorithm, if only final value is reported the FW/driver should
> probably perform the correction. Anyhow guess this can be added in the future.

Yeah, we can add more fields - although then they're sort of immediately
optional ones :-)

> Also, Wigig chip has multiple antennas in a single array each covering a sector,
> and WiFi may have multiple antenna arrays where one or more will be used for
> measurement, this means we may provide low-accuracy AoA result - at minimum this
> may tell you on which side of the AP you are... Consider adding this as optional
> reporting, not critical for initial patch...

Hmm. I'm not sure we have the ability to distinguish the TOA by antenna,
but I don't know. Frankly, I'm not even sure what you'd want to add
here? Timestamp per antenna?

> > + * @partial: indicates that this is a partial result for this type
> 
> Is partial set to false for the last result of this measurement type? This may
> be useful, for example if requesting multiple measurement types, user space can
> start processing one measurement type before the entire session is completed.

Yes, that was the intent, e.g. for multiple FTM bursts, but I see how
this might be misleading at this level. I'll clarify the documentation
(and probably over in nl80211.h as well)

> > +/**
> > + * struct cfg80211_pmsr_request_peer - peer data for a peer measurement request
> > + * @addr: MAC address
> > + * @chandef: channel to use
> 
> For connected station, usually you will want to do the measurement on the
> connected channel (possibly some chips will not be able to do otherwise)
> Maybe add option to use default channel?

Perhaps. It's somewhat complicated to look up in general, userspace
generally has a decent idea, and making it optional means you end up
with an invalid chandef?

I'll take a look, perhaps just leaving all the fields 0/NULL can work
reasonably well, but drivers would have to support it.

> > + * @report_ap_tsf: report the associated AP's TSF
> > + * @ftm: FTM data, see in particular @ftm.requested
> > + */
> > +struct cfg80211_pmsr_request_peer {
> > +	u8 addr[ETH_ALEN];
> > +	struct cfg80211_chan_def chandef;
> > +	bool report_ap_tsf;
> > +	struct {
> > +		enum nl80211_preamble preamble;
> > +		u16 burst_period;
> > +		bool requested;
> 
> Maybe "requested" should be the first field? it is common for all measurement
> structures?

It's required in all measurement types, but I don't think we care what
offset it has inside each, since they're not some kind of union where we
could treat it "generically" (and even if we could I certainly wouldn't
want to since that's just asking for trouble).

So I don't really see the point - I ordered it this way to avoid any
padding (yes, I could also count and put 4 bytes before the enum, but
that's 'harder')

> Also maybe make this a separate structure, as we add measurement
> types the generic structure will get quite large...

Makes sense, though I guess we can also still do that later. I didn't
because I didn't have a need to reference just this part, but changing
it also doesn't really cost anything (but coming up with a name ;-) )

> > + * @mac_addr: MAC address used for (randomised) request
> > + * @mac_addr_mask: MAC address mask used for randomisation, bits that
> > + *	are 0 in the mask should be randomised, bits that are 1 should
> > + *	be taken from the @mac_addr
> 
> Our wil6210 driver does not support MAC randomization currently (we plan to add
> this hopefully soon, needed for other features as well). This should be
> optional, maybe there should be capability so user space can know if this is
> supported.

Uh, OK. I was hoping that by now everyone really supported that and I
wouldn't have to worry about it ... :-)

> > + * @list: used by cfg80211 to hold on to the request
> > + * @timeout: timeout (in milliseconds) for the whole operation
> > + * @n_peers: number of peers to do measurements with
> > + * @peers: per-peer measurement request data
> > + * @results: used by cfg80211 to store the reported results
> > + */
> > +struct cfg80211_pmsr_request {
> > +	u64 cookie;
> > +	void *drv_data;
> > +	u32 n_peers;
> > +	u32 nl_portid;
> > +
> > +	u32 timeout;
> 
> We might have a need to support continuous measurements that do not timeout,
> does 0 mean no timeout?

I should document that, but yeah, that would make sense.

> > +	struct cfg80211_pmsr_request_peer peers[];
> 
> Add comment "must be last"...

Not needed, it doesn't compile if you put something after a variable
array :-)

[snip - you really could've snipped a bit more :-) ]

> > +		if (WARN_ON(wiphy->pmsr_capa->ftm.bandwidths &
> > +				~(BIT(NL80211_CHAN_WIDTH_20_NOHT) |
> > +				  BIT(NL80211_CHAN_WIDTH_20) |
> > +				  BIT(NL80211_CHAN_WIDTH_40) |
> > +				  BIT(NL80211_CHAN_WIDTH_80) |
> > +				  BIT(NL80211_CHAN_WIDTH_80P80) |
> > +				  BIT(NL80211_CHAN_WIDTH_160) |
> > +				  BIT(NL80211_CHAN_WIDTH_5) |
> > +				  BIT(NL80211_CHAN_WIDTH_10))))
> 
> What should Wigig report here? it uses 2160Hz channel width. Maybe we need to
> add additional width constant in separate patch, something like
> NL80211_CHAN_WIDTH_2160_DMG

Oh, good point. I guess we need *something* even if this is the only
context where we're using a width...

Hmm. What happens in a chandef struct for DMG? Surely those must be used
somewhere to specify channels, so is that using some sort of invalid
"20_NOHT" right now?

If so, that sounds like something that generally needs improvement?

> > +	if (!out->ftm.asap && !capa->ftm.non_asap) {
> > +		NL_SET_ERR_MSG(info->extack,
> > +			       "FTM: non-ASAP mode not supported");
> > +		return -EINVAL;
> > +	}
> > +
> > +	out->ftm.num_bursts_exp = 15;
> 
> I prefer the default to be a single burst and not the maximum 2^15 bursts,
> but not critical.

15 means "no preference" - which means it'll be up to the FTM responder
to decide what it wants to do. Then it can return 2^0 ... 2^15,
whichever it likes.

I guess we could say "we prefer a single burst" by putting 0 default
here, I don't think it matters so much, I just copied what we had in our
API right now. I can change it to 0 by default.

Thanks,
johannes
