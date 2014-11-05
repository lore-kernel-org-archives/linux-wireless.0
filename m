Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13222 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKEB3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 20:29:19 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH v2] ath10k: handle ieee80211 header and payload tracing separately
References: <1414661336-20764-1-git-send-email-rmanohar@qti.qualcomm.com>
	<874muf7t9u.fsf@kamboji.qca.qualcomm.com>
	<20141104051643.GA14509@qca.qualcomm.com>
Date: Wed, 5 Nov 2014 03:29:13 +0200
In-Reply-To: <20141104051643.GA14509@qca.qualcomm.com> (Rajkumar Manoharan's
	message of "Tue, 4 Nov 2014 10:46:45 +0530")
Message-ID: <87k33a1lli.fsf@kamboji.qca.qualcomm.com> (sfid-20141105_022922_953309_CFE5C32D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> On Tue, Nov 04, 2014 at 01:34:37AM +0200, Kalle Valo wrote:
>> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
>> 
>> > For packet log, the transmitted frame 802.11 header alone is sufficient.
>> > Recording entire packet is also consuming lot of disk space. To optimize
>> > this, tx and rx data tracepoints are splitted into header and payload
>> > tracepoints.
>> >  
>> > -DECLARE_EVENT_CLASS(ath10k_data_event,
>> > +#define ATH10K_FRM_HDR_LEN  \
>> > +	ieee80211_hdrlen(((struct ieee80211_hdr *)data)->frame_control)
>> 
>> This macro does not look good. I would recommend to follow what Johannes
>> suggested:
>>
>> "It would be worth hiding that inside the tracepoint's assign function,
>> so instead of passing data/len here you'd pass the full skb, or the full
>> skb data/skb len, like this:
>> 
>> ar, skb->data, skb->len
>> 
>> to both tracers. Then inside the tracer you can do the hdrlen check, and
>> that way move the code into the tracing so it's not hit when tracing is
>> disabled."
>
> v2 does the same. tracing functions just take ar, skb->data and skb->len.
> header check is handled inside tracing funtions.
>
> I do not understand your concerns. :(

Sorry, I was confusing. I meant that wouldn't it be better to pass the
skb pointer instead of skb-data and skb->len? I understood that was what
Johannes suggested.

But ATH10K_FRM_HDR_LEN is the problem. To simplify this, what if you
just always send the first 30 bytes (or whatever would be the max header
length)? Also should you check that skb->len is at least the length
defined by ieee80211_hdrlen()?

-- 
Kalle Valo
