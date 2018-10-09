Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBF9C64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 14:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D01D21479
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 14:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JRCrPGud";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lYJv0qRE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D01D21479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbeJIV6Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 17:58:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeJIV6Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 17:58:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B0F0660769; Tue,  9 Oct 2018 14:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539096060;
        bh=EzPbcyuWDG4U1QA6zepZ9vZmGBqGWzdPR9vQtL/BM1s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=JRCrPGudGRoHrKlUh02UKWflSmwuARqHjYrXu9ZM4EFZQIbNhFtNJUqbFFaLWSMfg
         RI5fErMLfLmeIBd6uEy1Si1QR+RvIwZsIZUsQneESegzA4Apap4MFaKCX1X7jj9F2F
         8BFZ5RMlnuSFgPfqaUNjN3a9u60+fqrHwRoA9W+4=
Received: from [10.18.172.66] (unknown [185.23.60.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: liord@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B2543605A2;
        Tue,  9 Oct 2018 14:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539096059;
        bh=EzPbcyuWDG4U1QA6zepZ9vZmGBqGWzdPR9vQtL/BM1s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=lYJv0qREtzB0HQ9sOUAnjDraM+we2qIvlJ6sVlmunhhLIe5YcMUryLGCxUT9ilPpw
         8tyoo+2Hto0TknWTBbPQ+XJkBQCi7Bi0cfYTWatdtOQ+gpeqB8ksCMwvO1AXLGMv+C
         wg/xNRl+taYNlj4msDgP4I5BUC+ARqvKEfbkRcYU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B2543605A2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=liord@codeaurora.org
Subject: Re: [RFC v2] cfg80211: add peer measurement with FTM API
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
References: <20181001133511.25046-1-johannes@sipsolutions.net>
 <b72e2702-64dd-4ac9-89a4-6fd4d03363ed@codeaurora.org>
 <1538942338.2928.21.camel@sipsolutions.net>
From:   Lior David <liord@codeaurora.org>
Message-ID: <0c64b665-5dc6-df94-4d49-a3adfc12f745@codeaurora.org>
Date:   Tue, 9 Oct 2018 17:40:55 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1538942338.2928.21.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/7/2018 10:58 PM, Johannes Berg wrote:
>>
>> Just curious, what's the advantage of this compared to sending the reply only on
>> the socket that started the measurement?
> 
> TBH, I don't really see any. Some people really wanted this for things
> like "let's do something in iw for measurements", though even that is
> not strictly necessary since you can always start listening for events
> as (before) you send off your request. It's slightly more complicated in
> terms of socket handling (as you need to be able to handle events while
> waiting for the netlink ACK message) but that's not so bad.
> 
> I'm all for it, so perhaps I'll change that.
Thanks for the explanation. The send to same socket does sound more efficient.
(In our internal implementation with vendor commands we were forced
to send the results as broadcast...)

> 
> In that case, it might even make sense to continue with the simple "send
> out results to userspace as we get them" approach, since the application
> that made the request will know to dedicate a socket with socket buffer
> to it, and handle it quickly, avoiding the problems with running out of
> socket buffer space and losing the "measurement complete" event (that I
> was worried about with our [Intel] original code of just multicasting
> the results).
> 
Sounds good. That way you may be able to pre-allocate memory for results... In
our implementation we pre-allocated and sent results for each burst as we
received it from FW (though not sure if it works for generic measurement types).


>>> + * @lci_len: length of LCI information (if present)
>>> + * @civicloc_len: length of civic location information (if present)
>>
>> Consider naming lcr (location civic report) instead of civicloc (this is what we
>> used in our QCA vendor API)
> 
> Hmm. I guess we already did "civic location" in the FTM-responder side
> API, but perhaps we can change it.
> 
Ok with either naming. lcr has just a small advantage since it is shorter :-)

>>> + * @rtt_avg: average of RTTs measured (must have either this or @dist_avg)
> 
>> For debugging it might be useful to report the distance in each measurement,
> 
> We did in fact originally report the distance unconditionally (rather
> than RTT and/or distance) but it ends up a multiplication by the speed
> of light (in air, but it was approximate enough this didn't matter), but
> I felt that such a calculation is so easy to do we may as well do it in
> iw/userspace?
> 
> Unless I'm misunderstanding?
Yes as far as I remember rtt<->distance is a trivial calculation. What I meant
here, you return the average of few measurements done in a burst, and for
debugging we could return all the measurements done in the burst. For example if
there were 4 measurements per burst return the 4 distance measurements done.

[...]
>> Also, Wigig chip has multiple antennas in a single array each covering a sector,
>> and WiFi may have multiple antenna arrays where one or more will be used for
>> measurement, this means we may provide low-accuracy AoA result - at minimum this
>> may tell you on which side of the AP you are... Consider adding this as optional
>> reporting, not critical for initial patch...
> 
> Hmm. I'm not sure we have the ability to distinguish the TOA by antenna,
> but I don't know. Frankly, I'm not even sure what you'd want to add
> here? Timestamp per antenna?
> 
I meant we could have an AoA value (angle in degrees or other units) which
drivers can fill up if they want. For example if the driver has 2 antennas on
both sides it can report either 90 or 270 degrees. It will be usually very low
accuracy but at least can provide some information like from which side of the
AP you are. This can certainly be added later if at all (hopefully we will have
AoA measurement with higher accuracy in the future)

>>> +/**
>>> + * struct cfg80211_pmsr_request_peer - peer data for a peer measurement request
>>> + * @addr: MAC address
>>> + * @chandef: channel to use
>>
>> For connected station, usually you will want to do the measurement on the
>> connected channel (possibly some chips will not be able to do otherwise)
>> Maybe add option to use default channel?
> 
> Perhaps. It's somewhat complicated to look up in general, userspace
> generally has a decent idea, and making it optional means you end up
> with an invalid chandef?
> 
> I'll take a look, perhaps just leaving all the fields 0/NULL can work
> reasonably well, but drivers would have to support it.
> 
As I remember the driver/FW can easily find the connected channel for connected
station. For unconnected station we should probably force this parameter.

>>> + * @report_ap_tsf: report the associated AP's TSF
>>> + * @ftm: FTM data, see in particular @ftm.requested
>>> + */
>>> +struct cfg80211_pmsr_request_peer {
>>> +	u8 addr[ETH_ALEN];
>>> +	struct cfg80211_chan_def chandef;
>>> +	bool report_ap_tsf;
>>> +	struct {
>>> +		enum nl80211_preamble preamble;
>>> +		u16 burst_period;
>>> +		bool requested;
>>
>> Maybe "requested" should be the first field? it is common for all measurement
>> structures?
> 
> It's required in all measurement types, but I don't think we care what
> offset it has inside each, since they're not some kind of union where we
> could treat it "generically" (and even if we could I certainly wouldn't
> want to since that's just asking for trouble).
> 
> So I don't really see the point - I ordered it this way to avoid any
> padding (yes, I could also count and put 4 bytes before the enum, but
> that's 'harder')
Ok with me.

>>> +		if (WARN_ON(wiphy->pmsr_capa->ftm.bandwidths &
>>> +				~(BIT(NL80211_CHAN_WIDTH_20_NOHT) |
>>> +				  BIT(NL80211_CHAN_WIDTH_20) |
>>> +				  BIT(NL80211_CHAN_WIDTH_40) |
>>> +				  BIT(NL80211_CHAN_WIDTH_80) |
>>> +				  BIT(NL80211_CHAN_WIDTH_80P80) |
>>> +				  BIT(NL80211_CHAN_WIDTH_160) |
>>> +				  BIT(NL80211_CHAN_WIDTH_5) |
>>> +				  BIT(NL80211_CHAN_WIDTH_10))))
>>
>> What should Wigig report here? it uses 2160Hz channel width. Maybe we need to
>> add additional width constant in separate patch, something like
>> NL80211_CHAN_WIDTH_2160_DMG
> 
> Oh, good point. I guess we need *something* even if this is the only
> context where we're using a width...
> 
> Hmm. What happens in a chandef struct for DMG? Surely those must be used
> somewhere to specify channels, so is that using some sort of invalid
> "20_NOHT" right now?
> 
> If so, that sounds like something that generally needs improvement?
> 
Good point. I see we currently use 20_NOHT for DMG, guess we can continue using it.


>>> +	if (!out->ftm.asap && !capa->ftm.non_asap) {
>>> +		NL_SET_ERR_MSG(info->extack,
>>> +			       "FTM: non-ASAP mode not supported");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	out->ftm.num_bursts_exp = 15;
>>
>> I prefer the default to be a single burst and not the maximum 2^15 bursts,
>> but not critical.
> 
> 15 means "no preference" - which means it'll be up to the FTM responder
> to decide what it wants to do. Then it can return 2^0 ... 2^15,
> whichever it likes.
Ok I thought 15 meant to actually request 65535 bursts :-)
I still prefer the default to be 1 burst. Supporting the "no preference" means
it will be difficult to pre-allocate memory for burst results. Also all drivers
should know to do one burst.

Thanks,
Lior
