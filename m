Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:51574 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356Ab2AQEC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 23:02:28 -0500
Received: by mail-lpp01m010-f41.google.com with SMTP id w12so100361lag.0
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 20:02:27 -0800 (PST)
Subject: Re: [PATCH 2/2] wl12xx: add operation to retrieve the MAC address
 from Fuse ROM
From: Luciano Coelho <coelho@ti.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAGRGNgWjCYsyzWCn0-j-A7Cqv2Prdftzxvu6WkjMzOdvOxcunA@mail.gmail.com>
References: <1326723806-15960-1-git-send-email-coelho@ti.com>
	 <1326723806-15960-3-git-send-email-coelho@ti.com>
	 <CAGRGNgVfJeEji1EtU5u_GfHN9sgKGEkDRg9ko7JdkMqUUFvFyw@mail.gmail.com>
	 <1326772102.4598.63.camel@cumari>
	 <CAGRGNgWjCYsyzWCn0-j-A7Cqv2Prdftzxvu6WkjMzOdvOxcunA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 06:02:24 +0200
Message-ID: <1326772944.4598.67.camel@cumari> (sfid-20120117_050232_628806_9197F293)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-17 at 14:51 +1100, Julian Calaby wrote: 
> On Tue, Jan 17, 2012 at 14:48, Luciano Coelho <coelho@ti.com> wrote:
> > On Tue, 2012-01-17 at 11:46 +1100, Julian Calaby wrote:
> >> > +               /* in wl127x we have the MAC address if the PG is >= (3, 1) */
> >> > +               if (major == 3 && minor >= 1)
> >>
> >> Is this test correct? Do only major == 3 PGs support this command?
> >
> > Yes, major == 3 and minor greater than or equal to 1.  Actually, there
> > can't be a major greater than 3, because it's only 2 bits, so 3 is the
> > maximum value.
> 
> Just wanted to check as it seemed odd compared to the block for the
> WL128X parts. I'm guessing TI never expected these parts to last long
> enough to have more than 3 major revisions =)

Yeah, and 16 HW revisions in total is usually more than enough.  And, if
really needed, there may be some bits elsewhere to be used.

I understand your point and I actually had a similar check as for
wl128x, but then I realized the "major >= 3" was useless and removed it.

Thanks for looking into this! :)

-- 
Cheers,
Luca.

