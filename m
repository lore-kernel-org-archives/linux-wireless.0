Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:20129 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333AbYJJOi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 10:38:27 -0400
Received: by fg-out-1718.google.com with SMTP id 19so355276fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 07:38:25 -0700 (PDT)
Message-ID: <1ba2fa240810100738t66afce30va60b2f883e5153b8@mail.gmail.com> (sfid-20081010_163830_562643_C2BC4254)
Date: Fri, 10 Oct 2008 16:38:25 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi TX reply bug
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223645283.3748.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223629897.3930.69.camel@johannes.berg>
	 <1ba2fa240810100545o79b70feay9c2da4fa6aa48a6b@mail.gmail.com>
	 <1223645283.3748.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 3:28 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-10-10 at 14:45 +0200, Tomas Winkler wrote:
>> On Fri, Oct 10, 2008 at 11:11 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> >        sta_id = iwl_get_ra_sta_id(priv, hdr);
>> >        if (txq->sched_retry && unlikely(sta_id == IWL_INVALID_STATION)) {
>> >                IWL_ERROR("Station not known\n");
>> >                return;
>> >        }
>> >
>> >        if (txq->sched_retry) {
>> > [...]
>> >        } else {
>> > [...]
>> >                if (index != -1) {
>> >                    int freed = iwl_tx_queue_reclaim(priv, txq_id, index);
>> >                    if (tid != MAX_TID_COUNT)
>> >                        priv->stations[sta_id].tid[tid].tfds_in_queue -= freed;
>> > [...]
>> >
>> >
>> > priv->stations has 32 entries, IWL_INVALID_STATION is 255.
>>
>> Don't see a problem this is what iwl_find_station returns if it cannot find
>
> The last line I quoted uses the sta_id regardless of what was returned.

Thanks, I'll check if this is a problem also in new code.
Tomas
