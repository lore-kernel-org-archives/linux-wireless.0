Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:28753 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYG2MfN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:35:13 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1489952ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 05:35:12 -0700 (PDT)
Message-ID: <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com> (sfid-20080729_143517_830821_15F82B0D)
Date: Tue, 29 Jul 2008 15:35:11 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217334452.10489.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 <1217334452.10489.42.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 3:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-07-29 at 15:25 +0300, Tomas Winkler wrote:
>
>> > Never mind, the queue won't get reassigned. I was just confused by a
>> > bunch of superfluous code in iwl-tx.c. You cannot ever run into having
>> > IWL_EMPTYING_HW_QUEUE_ADDBA set because you wait for the queue to drain
>> > before fully disabling it.
>>
>> Correct.
>
> I suppose you won't mind me removing that particular code then? I'm
> working on the agg refactoring right now.

Sorry for misleading I'm not in focus today :). You cannot remove this
code. This is form
This is required for emptying packets from legacy queue before
starting aggregation queue.
You cannot transmit from both queues for the same tid  Aggregation is
sensitive on ordering.
Tomas
