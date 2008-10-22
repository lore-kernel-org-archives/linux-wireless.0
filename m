Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:20482 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYJVLlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 07:41:14 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2984994wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 04:41:13 -0700 (PDT)
Message-ID: <1ba2fa240810220441o5b86e29co183deb7dc273fb0a@mail.gmail.com> (sfid-20081022_134119_353106_784D1CE9)
Date: Wed, 22 Oct 2008 13:41:13 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <m.sujith@gmail.com>, Sujith <Sujith.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <1224669612.28639.49.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1224669612.28639.49.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2008 at 12:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-20 at 23:33 +0530, Sujith wrote:
>
>> > Can you explain the way it currently works in ath9k?
>> >
>>
>> Alright, it goes something like this:
>
> Thanks.
>
>> * mac80211 sends down a frame
>>    * Initiate an aggregation session for the <RA,TID> if one isn't already in progress.
>
> It seems that should be a rate control decision? Possibly taking into
> account more than just always doing aggregation sessions. Then again, I
> suppose aggregation sessions are cheap. What about latency here?

Aggregation has it's overhead, both computing resources and on the
air. Obvious that it has negative affect on latency so if the 'minimum
HW queue depth'  is not satisfied the  packets
are delayed till the queue is full enough.
In iwl-agn-rs scale we keep track of  current tpt to take decision
about starting aggregation. The throughput watch  can be viewed as
different entity it was just convenient and conceptually fit  to
incorporate into rate scale.


>
>>    * Pause the TID, i.e, add further frames to the TID's queue.
>>       * If ADDBA exchange is successful, resume TID.
>>          * Form aggregates from the TID's buffer list, send them out.
>>            ( Take care to maintain minimum HW queue depth for aggregation )
>
> "maintain minimum HW queue depth"? In what way? You mean put in enough
> frames?
>
>>       * If ADDBA exchange fails, flush TID.
>>          * Send TID's pending frames as normal frames (non-ampdu)
>
> Obviously. But why isn't this done in parallel? I mean, why not send out
> the frame and do addba and don't aggregate until addba was successful,
> that would mean no latency for those frames... addba could even time out
> which would add a lot of latency, no?

The negotiation is done on starting sequence number.


Tomas
