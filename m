Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:40610 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673AbYFYJuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 05:50:11 -0400
Received: by rv-out-0506.google.com with SMTP id k40so8117672rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 02:50:10 -0700 (PDT)
Message-ID: <1ba2fa240806250250k2ae66eddre00172f6bc871fcb@mail.gmail.com> (sfid-20080625_115018_541422_2E5B0243)
Date: Wed, 25 Jun 2008 12:50:10 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Broken fragmentation
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1213910734.8967.117.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com>
	 <1213878207.8967.6.camel@johannes.berg>
	 <1ba2fa240806190608h3d833dbaua412446e8a9f560d@mail.gmail.com>
	 <1213881855.8967.19.camel@johannes.berg>
	 <1ba2fa240806190745u2fe7e435y3ca207af4156767b@mail.gmail.com>
	 <1213889200.8967.26.camel@johannes.berg>
	 <1ba2fa240806191113nd6a221eiac9648edd3404a80@mail.gmail.com>
	 <1213899419.8967.59.camel@johannes.berg>
	 <1ba2fa240806191409k7200ad53y654a7f8a117c8f14@mail.gmail.com>
	 <1213910734.8967.117.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 20, 2008 at 12:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> >> Fragments are in the air but the peer is not able to reassemble them.
>> >> Something is wrong with the first fragment but I'm not sure yet.
>> >
>> > Hm, ok. got a packet capture? Maybe that was broken before, I remember
>> > having problems with fragmentation but putting it down to the
>> > known-to-be-completely-broken AP I was using.
>>
>> It is working the latest problem was caused by the driver, Yet i still
>> don't understand the regression
>> in the driver.
>
> Hmm, ok.
>
So the bug is still in mac80211. Fragments are scheduled to different
TIDs and hence to different queues.
Investigating further. If you have something in mind let me know

Thanks
Tomas
