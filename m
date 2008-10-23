Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:14868 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYJWRdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 13:33:04 -0400
Received: by rn-out-0910.google.com with SMTP id k40so252688rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2008 10:33:01 -0700 (PDT)
Message-ID: <43e72e890810231033i20c411aat2926c8fffdc0a5cf@mail.gmail.com> (sfid-20081023_193308_615531_E0ADE74E)
Date: Thu, 23 Oct 2008 10:33:01 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [PATCH v3] mac80211: Re-enable aggregation
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	Jouni.Malinen@atheros.com, johannes@sipsolutions.net,
	tomasw@gmail.com
In-Reply-To: <18688.43984.384332.787060@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18685.37489.577735.596008@gargle.gargle.HOWL>
	 <43e72e890810222010w215b278bya788e0c94250b517@mail.gmail.com>
	 <20081023145102.GA5816@tuxdriver.com>
	 <18688.43984.384332.787060@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 23, 2008 at 9:52 AM, Sujith <m.sujith@gmail.com> wrote:
> John W. Linville wrote:
>> > Poke.
>>
>> Just waiting to see comments from those who understand aggregation
>> better than I do...
>
> It doesn't change the existing behaviour in any way, ath9k doesn't need
> all the extra queue stuff, so this is only a temporary fix until
> we have a decent model in mac80211 to support HW with
> no ampdu_queues.

Just to give some perspective, the reason this has been painful is we
are dealing with the two most distinct type of wireless devices you
could get and we deal with aggregation in different ways. Aggregation
is also very new to mac80211 but its implementation was designed
specifically for cases where you have "amdpu queues". Our design
requires everything done in software and as such the real clean
solution is to eventually try to move *as much as is possible* to
mac80211 to allow other devices which behave the same to be able to
use the same aggregation code. For now though for the non amdpu queue
case we only have Atheros 11n though and we are trying to resolve that
case first.

We will commit to move as much stuff up as we can, and this will
become more important as we get another device supported using the
same design. I've been trying hard to review and ask about the design
details of the other devices out in the market. In any case I think
this is the right step forward in the meantime, I also made a
suggestion as to how the ampdu queue case might be resolved. We just
need to be sure we keep in mind what needs to be done and move towards
it.

That's my two colones.

  Luis
