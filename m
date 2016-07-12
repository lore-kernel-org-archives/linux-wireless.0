Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35887 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbcGLNDn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 09:03:43 -0400
Received: by mail-oi0-f49.google.com with SMTP id w18so21076963oiw.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jul 2016 06:03:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bn23ui87.fsf@toke.dk>
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
 <87shvfujl4.fsf@toke.dk> <CAA93jw6z53P+JCPsjYD-vaY+9vq9ZO-Ob_cXm0AE76uVcM=F9g@mail.gmail.com>
 <87bn23ui87.fsf@toke.dk>
From: Dave Taht <dave.taht@gmail.com>
Date: Tue, 12 Jul 2016 15:03:42 +0200
Message-ID: <CAA93jw7eZv+rdZ-q1svG4nQsYVPNM9+hwcWE+-iFLo3p968i1Q@mail.gmail.com> (sfid-20160712_150347_320995_19137884)
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>,
	make-wifi-fast@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 12, 2016 at 2:57 PM, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
> Dave Taht <dave.taht@gmail.com> writes:
>
>>> As for why this would happen... There could be a bug in the dequeue code
>>> somewhere, but since you get better performance from sticking everything
>>> into one queue, my best guess would be that the client is choking on the
>>> interleaved packets? I.e. expending more CPU when it can't stick
>>> subsequent packets into the same TCP flow?
>>
>> I share this concern.
>>
>> The quantum is? I am not opposed to a larger quantum (2 full size
>> packets = 3028 in this case?).
>
> The quantum is hard-coded to 300 bytes in the current implementation
> (see net/fq_impl.h).

don't do that. :)

A single full size packet is preferable, and saves going around the
main dequeue loop 5-6 times per flow on this workload.

My tests on the prior patch set were mostly at the larger quantum.


> -Toke



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
