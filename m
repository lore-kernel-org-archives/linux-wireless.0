Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52481 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab0GEGOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 02:14:43 -0400
Received: by bwz1 with SMTP id 1so2498569bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jul 2010 23:14:42 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Subject: Re: rt61pci AP performance issues
Date: Mon, 5 Jul 2010 08:14:07 +0200
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	wireless <linux-wireless@vger.kernel.org>
References: <AANLkTimZTGvPuWPTXSOfOjvxzQh5tSnlqNBpueASLAUF@mail.gmail.com> <AANLkTikRH3YEoZ47ihcZyqBiwfxdBPAEgZdAzAWES8x-@mail.gmail.com>
In-Reply-To: <AANLkTikRH3YEoZ47ihcZyqBiwfxdBPAEgZdAzAWES8x-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007050814.07863.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 29 Juni 2010 schrieb David Ellingsworth:
> I haven't conducted any other tests beyond what was bisected in the
> attached log. Performance across all those revisions remained somewhat
> fast, and my markings were based solely on client link failure. Each
> bad commit resulted in the link failing after about 10s while
> transferring a file. At which point, the transfer would stop, the AP
> would be unreachable via pings, but the client remained associated to
> the AP. About 30s after that point, the client would timeout and
> re-associate to the AP reactivating the link.

Could you please check if the queues get stuck in that situation? I was
able to sometimes observe queues getting stuck on rt2800.

Just do the following (on the AP mode machine):

mount -t debugfs none /sys/debug
cat /sys/debug/ieee80211/phy0/queues

That should give you something like:

00: 0x00000000/0
01: 0x00000000/0
02: 0x00000000/0
03: 0x00000000/0

And if there's somewhere a 1 instead of a 0 it means that this queue is
stopped (which can/and must actually happen in some scenarios without
causing problems). If that 1 stays there for longer that means something
didn't start the queue anymore and your connection is most likely stuck.

Helmut
