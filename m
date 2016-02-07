Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40852 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbcBGHJG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Feb 2016 02:09:06 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Monitor interface TX performance boost
References: <CALGY4fuC7CHHFtp3VYtEZe_UFb_frHWK+_C+LWQVrC+0fzn4Kg@mail.gmail.com>
Date: Sun, 07 Feb 2016 09:09:00 +0200
In-Reply-To: <CALGY4fuC7CHHFtp3VYtEZe_UFb_frHWK+_C+LWQVrC+0fzn4Kg@mail.gmail.com>
	(Nikolay Martynov's message of "Sat, 6 Feb 2016 23:21:45 -0500")
Message-ID: <87k2mhro8j.fsf@purkki.adurom.net> (sfid-20160207_080910_872596_981AF150)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nikolay Martynov <mar.kolya@gmail.com> writes:

>   I'm seeing strange behavior on my intel 6300 card.
>
>   If I measure TX performance just after boot (iperf in tcp mode), I get this:
>
> [  3]  0.0-10.1 sec  11.2 MBytes  9.32 Mbits/sec
>
>   But if create and enable monitor interface (with command like 'sudo
> iw phy phy0 interface add moni0 type monitor && sudo ifconfig moni0
> up') I get this:
>
> [  3]  0.0-10.1 sec  34.8 MBytes  29.0 Mbits/sec
>
> That's about three times boost in throughput by just creating an
> interface (without even using it).
> Doing 'ifconfig moni0 down' bring performance back to 10Mbits range.
>
> Experiments are done with laptop being ~5m from router and not moving.
> These results are repeatable, i.e. not caused by random things like
> other stations transmitting, or channel being busy.
>
> Is this something expected? Is there any reason performance can be as
> good without monitor interface existing?

Maybe the monitor mode disables power save automatically?

-- 
Kalle Valo
