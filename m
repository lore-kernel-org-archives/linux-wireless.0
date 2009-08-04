Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.211.177]:54436 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbZHDPnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 11:43:45 -0400
Received: by ywh7 with SMTP id 7so5239744ywh.21
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 08:43:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A7855B3.1040007@erley.org>
References: <4A74D5F5.8090409@erley.org> <1249201869.2007.45.camel@johannes.local>
	<4A77AA0A.2030205@gmail.com> <4A7855B3.1040007@erley.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 4 Aug 2009 08:43:23 -0700
Message-ID: <43e72e890908040843m41780592of63a0b5e5df1225c@mail.gmail.com>
Subject: Re: [DISCUSS] Implement non standard channel widths
To: Pat Erley <pat-lkml@erley.org>, Felix Fietkau <nbd@openwrt.org>
Cc: Richard Farina <sidhayn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 4, 2009 at 8:37 AM, Pat Erley<pat-lkml@erley.org> wrote:
> Richard Farina wrote:
>> Johannes Berg wrote:
>>> Then, finally, I'd add a new channel type, NL80211_CHANNEL_TYPE_5MHZ.
>>> Document it to imply that HT is being turned off, of course. Now this
>>> bit should be really simple.
>>>
>>>
>> But why? There is no reason mcs rates can't be used on 5/10 Mhz channels
>> as far as I know. Bad enough these channels are running at half and
>> quarter rates, if you can use mcs why not?
>>
>> Just my 0.02
>>
>> thanks,
>> Rick Farina
>
> My thought on this topic is: design everything so these COULD be supported,
> but wait until someone tests/implements this functionality with a driver
> and needs support for them.  If I understood Johannes' description of things
> correctly, if it was found that a driver could do mcs rates in other channel
> widths, it'd be as simple as adding the values to the bitfields and that
> driver testing/implementing that functionality.
>
> What I guess it's come around to is:
>
> 1.  Change the way the current functionality is implemented
> 2.  Add additional values as it's added.
>
> What I believe johannes was saying is, during the implementation of 5/10mhz
> channels, disable ht/mcs modes up front, until someone shows/implements it.

You won't get support from vendors if the feature used is non-standard
though. Just keep that in mind. In fact I'm not sure its a good idea
to simply enable this off hand. We may want to consider a way to
annotate unsupported features if they are in fact very easy to
implement. So far we have simply opted to not support non-standard
features. I don't think we should strive away from that as I think it
has helped keep our code base clean and simple.

  Luis
