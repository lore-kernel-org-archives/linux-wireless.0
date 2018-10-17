Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4827ECDE32
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67D5721526
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67D5721526
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbeJQTyc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 15:54:32 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44788 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbeJQTyc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 15:54:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCkTj-0000Vf-RU; Wed, 17 Oct 2018 13:59:08 +0200
Message-ID: <8d5facacec024ed76f943a043d7a596003fa550d.camel@sipsolutions.net>
Subject: Re: [PATCH v4 1/2] cfg80211: add peer measurement with FTM
 initiator API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lior David <liord@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Wed, 17 Oct 2018 13:58:54 +0200
In-Reply-To: <a0958f28-6466-a339-1b04-a003fac8cc10@codeaurora.org>
References: <20181016093049.28771-1-johannes@sipsolutions.net>
         <a0958f28-6466-a339-1b04-a003fac8cc10@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-17 at 14:52 +0300, Lior David wrote:
> 
> On 10/16/2018 12:30 PM, Johannes Berg wrote:
> 
> [...]
> > + * @rtt_avg: average of RTTs measured (must have either this or @dist_avg)
> > + * @rtt_variance: variance of RTTs measured (note that standard deviation is
> > + *	the square root of the variance)
> > + * @rtt_spread: spread of the RTTs measured
> > + * @dist_avg: average of distances (mm) measured
> > + *	(must have either this or @rtt_avg)
> > + * @dist_variance: variance of distances measured (see also @rtt_variance)
> > + * @dist_spread: spread of distances measured (see also @rtt_spread)
> 
> I don't remember much from my statistics class, can you please provide some
> details about the variance and spread fields? Alternatively I can look at the
> first driver implementation for reference, unless it is calculated by FW :-)

It can only be calculated by firmware, unless the firmware reports all
measurements.

Spread here is just "highest value - lowest value.

Variance is a more complicated measure of the distribution... What do
you want to know? Here we have a finite set of values, so 

https://en.wikipedia.org/wiki/Variance#Population_variance

> > + * @partial: indicates that this is a partial result for this type
> > + * @final: if reporting partial results, mark this as the last one
> 
> Maybe it is enough to have just the "final" bit? I mean if final bit is clear
> doesn't this imply the result is partial since more results will follow?

Hmm, good point.

> > +/**
> > + * struct cfg80211_pmsr_capabilities - cfg80211 peer measurement capabilities
> > + * @max_peers: maximum number of peers in a single measurement
> > + * @report_ap_tsf: can report assoc AP's TSF for radio resource measurement
> > + * @randomize_mac_addr: can randomize MAC address for measurement
> > + * @ftm.supported: FTM measurement is supported
> > + * @ftm.asap: ASAP-mode is supported
> > + * @ftm.non_asap: non-ASAP-mode is supported
> > + * @ftm.request_lci: can request LCI data
> > + * @ftm.request_civicloc: can request civic location data
> > + * @ftm.preambles: bitmap of preambles supported (&enum nl80211_preamble)
> > + * @ftm.bandwidths: bitmap of bandwidths supported (&enum nl80211_chan_width)
> 
> Consider adding ftm.max_bursts (or max_bursts_exponent) 

Ok.

> and
> ftm.max_measurements_per_burst (is this the same as frames_per_burst?). For
> example in our implementation we can't do more than 6 measurements per burst
> because of resource limitations.

I guess measurements per burst are frames per burst? I'm not counting 4x
the frames because those are exchanged.

The spec says "FTMs per Burst", so perhaps I should align with that.

I suppose we can add that.

> Ok I see variance and spread are better documented here, maybe move the units
> information to the above structure definitions?

Well, they may seem above - but I thought it was more important to
document it better in the userspace API.

> > +/* multicast groups */
> > +enum nl80211_multicast_groups {
> > +	NL80211_MCGRP_CONFIG,
> > +	NL80211_MCGRP_SCAN,
> > +	NL80211_MCGRP_REGULATORY,
> > +	NL80211_MCGRP_MLME,
> > +	NL80211_MCGRP_VENDOR,
> > +	NL80211_MCGRP_NAN,
> > +	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
> > +};
> > +
> 
> Are these changes needed anymore since you don't send results as multicast?

No, good point.

johannes

