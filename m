Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:42151 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbYG2NnP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 09:43:15 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1507465ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 06:43:14 -0700 (PDT)
Message-ID: <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com> (sfid-20080729_154320_031565_6CE54C25)
Date: Tue, 29 Jul 2008 16:43:14 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217337819.10489.57.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 4:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 16:18 +0300, Tomas Winkler wrote:
>
>> This will require another queueing under what we already have. You
>> still need ability to stop and start the packet stream.
>> At that time it seems to be stupid not to reuse queueing.
>
> That's where you're actually wrong. If the aggregation queue is full,
> since they both go to the same FIFO, we should actually stop the queue
> that corresponds to the AC the aggregation goes into, otherwise we
> favour stations that enable aggregation over those who don't and they
> unfairly get more downstream throughput (if we are the AP).

No the mistake is on your side. FIFO is not relevant here. What is
important is whether HW queue is full or not.
Except the AC Back off scheduling done by FIFO there is BA protocol
which my stall HW queue. It doesn't mean that other packets with the
same FIFO should be stalled. You need additional SW queue that can be
stopped.
Tomas
