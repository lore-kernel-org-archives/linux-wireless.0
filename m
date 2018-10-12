Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C7ADC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:41:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D79F2086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D79F2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbeJLSNk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:13:40 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47406 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbeJLSNk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 14:13:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAutD-0001Ie-32; Fri, 12 Oct 2018 12:41:51 +0200
Message-ID: <1539340898.3141.11.camel@sipsolutions.net>
Subject: Re: [RFC v3] cfg80211: add peer measurement with FTM API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Lior David <liord@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Fri, 12 Oct 2018 12:41:38 +0200
In-Reply-To: <dc9bc6d3-6a95-3ca5-a231-14ed3e2fe302@broadcom.com> (sfid-20181012_123207_395276_6619BC73)
References: <20181012100827.24195-1-johannes@sipsolutions.net>
         <dc9bc6d3-6a95-3ca5-a231-14ed3e2fe302@broadcom.com>
         (sfid-20181012_123207_395276_6619BC73)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> You have no recollection what happened in the earlier versions, right? :-p

v1 was very incomplete, it didn't have any results reporting, etc.

> > v3:
> >  - add a bit to report "final" for partial results
> >  - remove list keeping etc. and just unicast out the results
> >    to the requester (big code reduction ...)
> >  - also send complete message unicast, and as a result
> >    remove the multicast group
> >  - separate out struct cfg80211_pmsr_ftm_request_peer
> >    from struct cfg80211_pmsr_request_peer
> >  - document timeout == 0 if no timeout
> >  - disallow setting timeout nl80211 attribute to 0,
> >    must not include attribute for no timeout
> 
> All these negations make my head spin (a little). Let's look at the 
> actual documentation further down...

:-)

> > +struct cfg80211_pmsr_ftm_result {
> > +	const u8 *lci;
> > +	const u8 *civicloc;
> > +	unsigned int lci_len;
> > +	unsigned int civicloc_len;
> > +	enum nl80211_peer_measurement_ftm_failure_reasons failure_reason;
> > +	u32 num_ftmr_attempts, num_ftmr_successes;
> 
> Maybe there is a good reason, but can we move the above line a bit down...

The reason was to avoid having padding for alignment.

> > +	NL80211_ATTR_TIMEOUT,
> > +
> 
> Guess you consider reuse of the TIMEOUT attribute? 

Yes, I was actually surprised we don't have one already :-)

> I checked the policy 
> definition in nl80211_policy so it disallows 0 value as mentioned in the 
> changelog. How about adding that to the documentation here, ie. "when 
> timeout attribute is not provided the timeout is disabled for the given 
> operation" or something like that.

Sure, that makes sense, will do.

johannes
