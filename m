Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:56319 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZETLll (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 07:41:41 -0400
Received: by bwz22 with SMTP id 22so347721bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 04:41:42 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Scan while TX/RX'ing a lot of data
Date: Wed, 20 May 2009 13:41:46 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com, David Miller <davem@davemloft.net>,
	Jouni Malinen <j@w1.fi>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com> <200905181543.15266.helmut.schaa@gmail.com> <1242724000.17164.10.camel@johannes.local>
In-Reply-To: <1242724000.17164.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905201341.47185.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 19. Mai 2009 schrieb Johannes Berg:
> On Mon, 2009-05-18 at 15:43 +0200, Helmut Schaa wrote:

> > One solution would be to force all drivers to report the tx status. Another
> > one would be to just wait until the device's queue is empty. At that point
> > we know that all pending data frames were sent out and additionally the
> > nullfunc frame was also sent out, so we can safely switch to the next
> > to-be-scanned channel.
> 
> Some drivers now flush queues at channel switch time, but there's no way
> to guarantee that the software queues are actually empty and the
> nullfunc frame isn't queued up behind other traffic. Also, waiting for
> any driver to report a status will lead to problems because the driver
> might just have dropped the frame for various reasons like being out of
> memory.

Hmm, the problem is basically (from a mac80211 perspective) that the
mdev tx queue could still contain data frames when the nullfunc frame
gets queued, right? And we do not assure that these frames are sent
out before the channel switch.

Hence, would it be possible to:
1) Stop all sub_if tx queues (afterwards no new data frames should
   appear in the mdev tx queue)
2) Queue the nullfunc frame
3) Flush the mdev's tx queue
4) Switch the channel
?

Helmut
