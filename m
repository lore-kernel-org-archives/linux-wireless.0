Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:12922 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYJHMiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 08:38:19 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2694045fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 08 Oct 2008 05:38:18 -0700 (PDT)
Message-ID: <1ba2fa240810080538i864b901kc8e6e694004dbade@mail.gmail.com> (sfid-20081008_143824_568286_86D7AA14)
Date: Wed, 8 Oct 2008 14:38:17 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <1223452923.3618.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
	 <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com>
	 <1223408085.3618.2.camel@johannes.berg>
	 <1223408342.3618.7.camel@johannes.berg>
	 <1ba2fa240810071306sb282e06h9d29ea2c36f5c3d5@mail.gmail.com>
	 <1223410226.3618.13.camel@johannes.berg>
	 <1ba2fa240810071346n506b8f1clffaebb7f1f72a10f@mail.gmail.com>
	 <1223452923.3618.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 8, 2008 at 10:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-07 at 22:46 +0200, Tomas Winkler wrote:
>> >> > bytes (with nibbles): | . | . | . | . | . | . || . | . | . | . | . | . |
>> >> >                      | addr 1          |len1 || addr 2          |len2 |
>> >> > your forced layout:   |               |                |               |
>> >> > my layout:            |               |       ||               |       |
>> >> >
>> >> > Note how this actually matches the border between the border between the
>> >> > two descriptors, the || border.
>> >>
>> >> Your layout put addr2 (which is 32 bit) sits on 16 bit boundary
>> >
>> > So? Yours makes it need two words, which is even less efficient to
>> > access. And since the struct is packed, on those architectures that
>> > don't do unaligned accesses efficiently won't need any put_unaligned
>> > either.
>> >
>> > Also, keep in mind that address 2 is _never_ used at all anyway
>
>> This is not correct we always use first 2 pointers. First for tx command
>> second for the actual packet.
>
> Ok so you use two.

My only point is just to make sure that you understand that __never__
is not correct

 Writing three words in total. I strongly suggest that
> you have WAY more trouble in iwlwifi than an imagined performance issue
> coming from a corrected and understandable struct layout.

You are rally trying breaking into open doors Currently I'm more
concern with correctness then performance so I wanted to rise
hopefully all issues.
I'm testing your layout it's work so far in my home setup. I'm on
holidays till EOW so I will be able to give it some more stress in Lab
only next week.

>
>> > because
>> > we don't and cannot do fragmented frames due to the lack of IP
>> > checksumming in hardware, as I and davem have tried to explain to you
>> > multiple times already.
>>
>> This is bad side of current Linux implementation
>
> Look, we've tried to explain it to you so many times that it simply is
> not possible to enable fragment collection without IP checksumming in
> hardware that I don't know what to tell you. This may sound offensive,
> but are you really too stupid to understand it?

Okay not fair from my side I just couldn't resist ... I just really
like the subject :)
Tomas
