Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:45132 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaL3Oai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:30:38 -0500
Received: by mail-la0-f54.google.com with SMTP id pv20so12710459lab.13
        for <linux-wireless@vger.kernel.org>; Tue, 30 Dec 2014 06:30:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAk3=uvCn84yBEa+hUoX7Wp799-O-Xy6QJFgNiQwt3rH3PLsWQ@mail.gmail.com>
References: <CAAk3=uumFdCe69HVPGp0TL6-RDuk58B5qxLxAsTOBCwY43fVkA@mail.gmail.com>
	<CAAk3=uvCn84yBEa+hUoX7Wp799-O-Xy6QJFgNiQwt3rH3PLsWQ@mail.gmail.com>
Date: Tue, 30 Dec 2014 16:30:36 +0200
Message-ID: <CANUX_P2CMvw4wZnpydPprw0=VwKMXBAcONSVyKSTcsnun=OCGQ@mail.gmail.com> (sfid-20141230_153512_463873_630F7047)
Subject: Re: [iwlwifi] fail to flush all tx queues on kernel 3.17.6
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Gerlof Fokkema <gerlof.fokkema@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for the delay. This one got lost in my inbox.

On Sat, Dec 27, 2014 at 4:03 PM, Gerlof Fokkema
<gerlof.fokkema@gmail.com> wrote:
> Hi all,
>
> Since a few weeks I own a laptop with an Intel Wireless 7260 wireless adapter.
> I first noticed that my connection started dropping when I transferred
> large files over WiFi.
> Later on I noticed this problem when the signal strength was low as well.
>
> I seem to be experiencing the bug described here:
> https://bugzilla.kernel.org/show_bug.cgi?id=56581

This bug relates to dvm - which is de-facto another driver. We made
this work around because
of firmware issues. These issues aren't supposed to happen on devices
supported by iwlmvm.
Obviously, they do. You are not the only one to report this issue.
I will discuss it with our firmware team.

>
> However, if I read the changelogs correctly, this should've been fixed
> in 3.17.3.
>
> Atttached you'll find dmesg.log with the error.
> Excerpt:
> [  152.941067] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
> [  152.941072] iwlwifi 0000:03:00.0: Current SW read_ptr 209 write_ptr 234
> [  152.941097] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00  ................
> [  152.941111] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x80003000
> [  152.941125] iwlwifi 0000:03:00.0: FH TRBs(1) = 0xc01100f2
> [  152.941139] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
> When I try reconnecting to WiFi I get dozens more of those errors.
>
> Can someone point me in the right direction for this?
> Is there already a bugreport for this on kernel 3.17.6?
> Should you need more information, I'm happy to supply.
>
> For now I've reverted to 3.16.4, since it seems to work better...

Probably because 3.16 uses an older firmware (-9.ucode).
This is also an interesting input - although I heard complaints about
this very same issue on -9.ucode as well.

>
> Kind regards,
> Gerlof Fokkema
