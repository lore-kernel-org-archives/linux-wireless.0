Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:46632 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbcGLM5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 08:57:34 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Dave Taht <dave.taht@gmail.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: Re: TCP performance regression in mac80211 triggered by the fq code
References: <11fa6d16-21e2-2169-8d18-940f6dc11dca@nbd.name>
	<87shvfujl4.fsf@toke.dk>
	<CAA93jw6z53P+JCPsjYD-vaY+9vq9ZO-Ob_cXm0AE76uVcM=F9g@mail.gmail.com>
Date: Tue, 12 Jul 2016 14:57:28 +0200
In-Reply-To: <CAA93jw6z53P+JCPsjYD-vaY+9vq9ZO-Ob_cXm0AE76uVcM=F9g@mail.gmail.com>
	(Dave Taht's message of "Tue, 12 Jul 2016 14:44:05 +0200")
Message-ID: <87bn23ui87.fsf@toke.dk> (sfid-20160712_145742_670511_9AA03FC7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave Taht <dave.taht@gmail.com> writes:

>> As for why this would happen... There could be a bug in the dequeue code
>> somewhere, but since you get better performance from sticking everything
>> into one queue, my best guess would be that the client is choking on the
>> interleaved packets? I.e. expending more CPU when it can't stick
>> subsequent packets into the same TCP flow?
>
> I share this concern.
>
> The quantum is? I am not opposed to a larger quantum (2 full size
> packets = 3028 in this case?).

The quantum is hard-coded to 300 bytes in the current implementation
(see net/fq_impl.h).

-Toke
