Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:32821 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbZGaTLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:11:03 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1215028qwh.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 12:11:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com>
References: <20090731181020.GE7963@makis>
	 <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com>
	 <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com>
Date: Fri, 31 Jul 2009 15:11:02 -0400
Message-ID: <b6c5339f0907311211w4d810b23uc6ec8027924da647@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 2:25 PM, Nick Kossifidis<mickflemm@gmail.com> wrote:
>    Also we don't need to run calibration if we are idle (no interrupts).

I think this is the big win right now...

> c) Having calibration on a tasklet is better since during calibration
>    we can't transmit or receive (antennas are detached to measure
>    noise floor), previously calibration could run in parallel with tx/rx
>    and interfere (packet loss).

This can still happen, no?  Two tasklets can run in parallel on
different processors, as long as they are different tasklets.

In practice, this won't happen much because tasklets run on the
cpu that scheduled them, and irq affinity is such (at least on my
hardware) that it's almost always the same CPU.  But I think to
make the above true it needs to stop the queues etc when doing
calibration.

Also we are missing tasklet_kill()?

-- 
Bob Copeland %% www.bobcopeland.com
