Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:22230 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966525AbZLHWGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:06:13 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1501013eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 14:06:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200912011052.13643.holgerschurig@gmail.com>
References: <1256687501-8636-1-git-send-email-andrey@cozybit.com>
	 <436f52800911301653q224bacceq4a14cbbfaa5cc0e2@mail.gmail.com>
	 <200912011052.13643.holgerschurig@gmail.com>
Date: Tue, 8 Dec 2009 14:06:17 -0800
Message-ID: <436f52800912081406k5d94596dga8eb5a7de04d8e76@mail.gmail.com>
Subject: Re: [PATCH] libertas: remove internal buffers from GSPI driver
From: Colin McCabe <cmccabe@alumni.cmu.edu>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>, dcbw@redhat.com,
	sebatian@breakpoint.cc, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, getting rid of the spinlock around hw_host_to_card would mean
that concurrent calls to hw_host_to_card could happen.

I don't _think_ this would be a problem in if_spi, at least. Now that
we've moved to using complete spi_message structures, each message
should be sent atomically by the SPI layer.

The only question is whether certain messages have to happen in
sequence. For example, in if_spi_c2h_cmd, we do spu_read_u16 from
scratch reg 2 to find out how many bytes to read. Then we read the
bytes from the RDWRPORT register. If someone else did some other SPU
operations between those two, would the module get confused? I don't
_think_ so, but I haven't tested it.

Colin


On Tue, Dec 1, 2009 at 1:52 AM, Holger Schurig <holgerschurig@gmail.com> wrote:
>> Perhaps the easiest thing would be to get rid of this usage of
>> hw_host_to_card?
>
> That would mean to rewrite this not only for SPI, but also for
> USB and CS. If you come up with patches, I'm willing to test this
> against USB and/or CS, in case you don't have this hardware.
>
> --
> http://www.holgerschurig.de
>
