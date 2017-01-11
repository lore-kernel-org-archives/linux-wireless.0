Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32830 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936903AbdAKNWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 08:22:51 -0500
Message-ID: <1484140967.29931.6.camel@sipsolutions.net> (sfid-20170111_142256_936935_B097B3B4)
Subject: Re: [PATCH v3 1/3] cfg80211: Add support to sched scan to report
 better BSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 11 Jan 2017 14:22:47 +0100
In-Reply-To: <54d6fd2bc55f4c9290402e692ed27005@aphydexm01b.ap.qualcomm.com>
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
         <25527a43-0458-f9f4-9afb-f5986dffbae1@broadcom.com>
         <54d6fd2bc55f4c9290402e692ed27005@aphydexm01b.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 07:48 +0000, Vamsi, Krishna wrote:
> > -----Original Message-----
> 
>  
> > > + * @relative_rssi_set: Indicates whether @relative_rssi is set
> > > or not.
> > 
> > So you see a use-case for doing a scan with @relative_rssi being
> > zero, right?
> 
> Yes. Zero value for relative_rssi is also valid.

Or negative even, I guess?

> > > + * @relative_rssi: Relative RSSI threshold in dB to restrict
> > > scan result
> > > + *	reporting in connected state to cases where a matching
> > > BSS is
> > 
> > determined
> > > + *	to have better RSSI than the current connected BSS.
> > > The relative RSSI
> > > + *	threshold values are ignored in disconnected state.
> > 
> > The description says "better RSSI" so I suppose it could be typed
> > as u8. The last sentence is intended driver behavior
> 
> I like to leave this as s8 only. This will leave more flexibility to
> userspace especially in case of more than two bands in future.

I guess you should reword that - instead of "better" it should say how
this value is applied, as a delta to the current RSSI, and then
reporting the result.

However, I don't understand your comment about this being related to
multiple bands, can you clarify? The relative_rssi just determines the
filter after the adjustment(s) done with rssi_adjust, but how could it
be relevant?

The only use case for relative_rssi being negative would be when you
actually *want* to see slightly worse networks than the one you're
connected to, e.g. to determine if you should use them because they
have better parameters (e.g. HT/VHT or soon HE).

> > > +	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI]) {
> > > +		request->relative_rssi = nla_get_s8(
> > > +			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_R
> > > SSI]);
> > > +		request->relative_rssi_set = true;
> > > +	}
> > > +
> > > +	if (attrs[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST]) {
> > 
> > Maybe I misread but I thought this attribute to be applicable only
> > if
> > request->relative_rssi_set is true.
> 
> @relative_rssi is valid only when @relative_rssi_set is set to true
> and @rssi_adjust is valid only when @relative_rssi is valid. I think
> that is understandable to drivers and there is no need of explicit
> check here.

It wouldn't be problematic to parse the RSSI_ADJUST only when the
others are present though, so that a driver could apply the rssi_adjust
unconditionally (since, if it's not parsed, the delta will be 0.)

johannes
