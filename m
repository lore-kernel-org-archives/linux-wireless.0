Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:41506 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbZBMITm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 03:19:42 -0500
Received: by yw-out-2324.google.com with SMTP id 5so586227ywh.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 00:19:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234512529.1327.38.camel@johannes.local>
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234508187.1327.19.camel@johannes.local>
	 <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com>
	 <43e72e890902122314m2966471dm3a9485a91e8e927@mail.gmail.com>
	 <43e72e890902122314r6b9e881cg5538523780e808ef@mail.gmail.com>
	 <1234509436.1327.25.camel@johannes.local>
	 <43e72e890902122335l6580dbc1m44702996cc8200e4@mail.gmail.com>
	 <1234511334.1327.34.camel@johannes.local>
	 <43e72e890902122357g26bf3dd4j930de7c1f6c28280@mail.gmail.com>
	 <1234512529.1327.38.camel@johannes.local>
Date: Fri, 13 Feb 2009 00:19:41 -0800
Message-ID: <43e72e890902130019y3c7106ecqffcc68e53df8514b@mail.gmail.com> (sfid-20090213_091945_776035_9712F145)
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 13, 2009 at 12:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-02-12 at 23:57 -0800, Luis R. Rodriguez wrote:
>
>> To answer that question -- reg_mutex just protects the
>> reg_requests_list linked list. That's it. Without that you could
>> potentially have two userspace reg hints while the workqueue runs.
>> Remember that the hints no longer lock except to just add a new
>> regulatory_request into the reg_requests_list.
>
> Right, ok.
>
>> >> Driver hint also does the same so it seems your fix on nl80211 would
>> >> probably just tap this series on the nl80211_req_set_reg().
>> >
>> > Yeah, I think I'll work on top of your series anyway so I don't clash
>> > with the cleanups.
>>
>> Any other comments on the series?
>
> Not really, looks pretty good to me. It does seem a little dubious to
> return an error from a hint function and then not attach the hardware,
> but that's up to you what you want to do in ath9k I guess -- seems it
> should work ok even if the hint failed, though of course then you'll not
> have memory for anything else either...

The only error is -ENOMEM so yeah we certainly should propagate that
down to the driver. An alternative is to use a few regulatory_requests
on the stack for queuing purposes but it just seemed silly on second
thought.

  Luis
