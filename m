Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45248 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZERNnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 09:43:11 -0400
Received: by bwz22 with SMTP id 22so3212216bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 06:43:11 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Scan while TX/RX'ing a lot of data
Date: Mon, 18 May 2009 15:43:14 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com, David Miller <davem@davemloft.net>,
	Jouni Malinen <j@w1.fi>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com> <43e72e890905152312m2077cc1dqd743cf7f625e9a49@mail.gmail.com> <1242478657.10005.72.camel@johannes.local>
In-Reply-To: <1242478657.10005.72.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905181543.15266.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 16. Mai 2009 schrieb Johannes Berg:
> Anyway, bottom line is that I don't think we should change the APIs in
> any way, we should instead make the scan smarter by spreading it out if
> we're active.

That's what I've tried with the patch at [1]. I used a fixed time schedule
for switching back to the operating channel after each scanned channel.
However, that could of course be done somewhat dynamic based on the current
traffic characteristics.

The basic problem I had was that I couldn't check if the nullfunc frame
indicating the new "powersave" state to the AP was already sent out (or
ACKed by the AP). This resulted in lost frames sometimes: if the device's
tx queue contained a lot of data frames the nullfunc frame was sent out
_after_ the channel switch occured.

If anybody has a good idea on how to fix this issue I'm glad to provide an
updated version of the bg-scan patch.

One solution would be to force all drivers to report the tx status. Another
one would be to just wait until the device's queue is empty. At that point
we know that all pending data frames were sent out and additionally the
nullfunc frame was also sent out, so we can safely switch to the next
to-be-scanned channel.

Comments?

Helmut

[1] http://marc.info/?l=linux-wireless&m=122226702331135&w=2
