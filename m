Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63210 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab0GLSzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 14:55:44 -0400
Received: by bwz1 with SMTP id 1so2542475bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 11:55:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100712152058.GB2442@tuxdriver.com>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
	<4C3B321F.2020609@openwrt.org>
	<20100712152058.GB2442@tuxdriver.com>
Date: Mon, 12 Jul 2010 20:55:42 +0200
Message-ID: <AANLkTimktg67e-wES_8nkOrgEuKXVqkMHYQWLgzAiJ20@mail.gmail.com>
Subject: Re: Rate control & USB
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 12, 2010 at 5:20 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Jul 12, 2010 at 05:17:51PM +0200, Felix Fietkau wrote:
>> On 2010-07-12 12:48 PM, Ivo Van Doorn wrote:
>> > The problem here is that we have lost the per-sta statistics. However using the
>> > single TX status reports, we can count the number of frames which are sent for
>> > a given STA during the poll interval. We can then determine the percentage of
>> > frames sent for that STA, We can then add the percentage of the retry and ACK
>> > count to each STA. Throughout poll interval the rate algorithm would send all
>> > frames to the same STA with the same TX rate, but between polls, the rate will
>> > be updated.
>> >
>> > Overall these changes will not make the optimal use of PID or
>> > Minstrel, but it would
>> > at least improve the situation for USB.
>> >
>> > Any thoughts about this solution?
>> I don't know how minstrel could work with this approach. Before it
>> starts to use a rate, it has to sample it first. How can you sample
>> rates with your tx status feedback approach?
>
> You would have to commit to that rate for at least one polling period, no?

Exactly, it does mean that the sampled rate might be used longer then with
the regular TX status reporting, but I don't think that would be a too big of a
problem. If it reaslly is a problem, it might be changed that for
sampling shorter
polling periods are used, but that will make the interface a bit uglier... :(

Ivo
