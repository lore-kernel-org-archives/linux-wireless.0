Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58358 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934880AbeFRUvs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 16:51:48 -0400
Message-ID: <1529355107.3092.46.camel@sipsolutions.net> (sfid-20180618_225155_278726_2183464B)
Subject: Re: [PATCH v2 1/2] cfg80211: last ack signal support in station dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 18 Jun 2018 22:51:47 +0200
In-Reply-To: <72bc5a1b5136eb30baba715f891961f1@codeaurora.org>
References: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
         <1528121469-16450-2-git-send-email-bpothuno@codeaurora.org>
         <1529062873.10037.9.camel@sipsolutions.net>
         <72bc5a1b5136eb30baba715f891961f1@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-06-18 at 14:48 +0530, Balaji Pothunoori wrote:
> On 2018-06-15 17:11, Johannes Berg wrote:
> > On Mon, 2018-06-04 at 19:41 +0530, Balaji Pothunoori wrote:
> > > 
> > > +++ b/include/uapi/linux/nl80211.h
> > > @@ -3000,8 +3000,8 @@ enum nl80211_sta_bss_param {
> > >   *	received from the station (u64, usec)
> > >   * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit 
> > > alignment
> > >   * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK 
> > > frame(u8, dBm)
> > > - * @NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG: avg signal strength of 
> > > (data)
> > > - *	ACK frame (s8, dBm)
> > > + * @NL80211_STA_INFO_ACK_SIGNAL_AVG: avg signal strength of data or 
> > > management
> > > + *	ACK frames(s8, dBm)
> > >   * @__NL80211_STA_INFO_AFTER_LAST: internal
> > >   * @NL80211_STA_INFO_MAX: highest possible station info attribute
> > >   */
> > > @@ -3041,7 +3041,7 @@ enum nl80211_sta_info {
> > >  	NL80211_STA_INFO_RX_DURATION,
> > >  	NL80211_STA_INFO_PAD,
> > >  	NL80211_STA_INFO_ACK_SIGNAL,
> > > -	NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG,
> > > +	NL80211_STA_INFO_ACK_SIGNAL_AVG,
> > 
> > Wait, what happened here? You can't remove old API.
> 
> Here is my intention is to make the unique average ack signal and last 
> ack signal
> support in station dump irrespective of data or management tx ack 
> packet.
> Do you want me to add a new API for management tx ack packet?

Well, you can't remove old API.

And the data-ACK was explicitly added because of concerns about signal
varying a lot with MCS, so ACK signal is more reliable.

I suppose the original use here didn't really *need* just *data* ACK, so
perhaps we can redefine it - you'd know better? After all, you defined
the old API :-))

But still, you can't just remove it. I think we're probably OK to
redefine it but then you need to keep API compatibility by adding the
necessary defines.

johannes
