Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:33160 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbYG2NEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 09:04:34 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1496221ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 06:04:33 -0700 (PDT)
Message-ID: <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com> (sfid-20080729_150443_989981_B03BBC58)
Date: Tue, 29 Jul 2008 16:04:32 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217336023.10489.51.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 <1217336023.10489.51.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 3:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 15:35 +0300, Tomas Winkler wrote:
>
>> Sorry for misleading I'm not in focus today :). You cannot remove this
>> code. This is form
>> This is required for emptying packets from legacy queue before
>> starting aggregation queue.
>> You cannot transmit from both queues for the same tid  Aggregation is
>> sensitive on ordering.
>
> I see, it's required because mac80211 would otherwise start putting
> packets into the new agg queue and then that could be used by the hw
> before all frames from that sta/tid in the regular queue were sent,
> right?

Correct.
Other thing is you probably not seeing the latest code as well. Yi is
not publish new code before John is merging what we've already sent
out. I also have something still in the drawer.
This quite bad position still have to fix bugs on old MQ because the
new one cannot be ported at all to old kernels and already face the
breakage in the new one.
I'm starting to be frustrated about this development model it looks
like there is no single stable point of this code base.

Tomas
