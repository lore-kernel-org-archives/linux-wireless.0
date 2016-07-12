Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36827 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbcGLMNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 08:13:50 -0400
Received: by mail-oi0-f53.google.com with SMTP id w18so19221040oiw.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jul 2016 05:13:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
From: Dave Taht <dave.taht@gmail.com>
Date: Tue, 12 Jul 2016 14:13:48 +0200
Message-ID: <CAA93jw6=_pemSUjk3dje1GmnTzrs+=pEdza4j1Wjtrw+VKNdNg@mail.gmail.com> (sfid-20160712_141400_750420_A22DDC45)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: Felix Fietkau <nbd@nbd.name>, make-wifi-fast@lists.bufferbloat.net
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	=?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 12, 2016 at 12:09 PM, Felix Fietkau <nbd@nbd.name> wrote:
> Hi,
>
> With Toke's ath9k txq patch I've noticed a pretty nasty performance
> regression when running local iperf on an AP (running the txq stuff) to
> a wireless client.

Your kernel? cpu architecture?

What happens when going through the AP to a server from the wireless client?

Which direction?

> Here's some things that I found:
> - when I use only one TCP stream I get around 90-110 Mbit/s

with how much cpu left over?

> - when running multiple TCP streams, I get only 35-40 Mbit/s total

with how much cpu left over?
context switch difference between the two tests?
tcp_limit_output_bytes is?

got perf?

> - fairness between TCP streams looks completely fine

A codel will get to long term fairness pretty fast. Packet captures
from a fq will show much more regular interleaving of packets,
regardless.

> - there's no big queue buildup, the code never actually drops any packets

A "trick" I have been using to observe codel behavior has been to
enable ecn on server and client, then checking in wireshark for ect(3)
marked packets.

> - if I put a hack in the fq code to force the hash to a constant value

You could also set "flows" to 1 to keep the hash being generated, but
not actually use it.

> (effectively disabling fq without disabling codel), the problem
> disappears and even multiple streams get proper performance.

Meaning you get 90-110Mbits ?

Do you have a "before toke" figure for this platform?

> Please let me know if you have any ideas.

I am in berlin, packing hardware...

>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
