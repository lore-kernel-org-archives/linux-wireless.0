Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37397 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3EQPj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 11:39:27 -0400
Received: by mail-wi0-f174.google.com with SMTP id c10so553349wiw.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 May 2013 08:39:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130517095825.GA1555@pandem0nium>
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<CAJ-VmonrfSx6KLjNdPwtV_8q=Jmjz9KRSYmoLSXt7yocU=y35A@mail.gmail.com>
	<20130516114028.GA27887@pandem0nium>
	<CAJ-Vmo=39cS38UCDeQrdJ7x-t=cyr8cnsf3G2opxyeY3KzWLUg@mail.gmail.com>
	<20130517095825.GA1555@pandem0nium>
Date: Fri, 17 May 2013 08:39:19 -0700
Message-ID: <CAJ-Vmomy+Dy878GcZYtqaFYOnaRaB=zYUXGdbKi44_-KPU-RKw@mail.gmail.com> (sfid-20130517_173933_347200_C073AF83)
Subject: Re: [PATCHv2 00/18] Add support for 5 and 10 MHz channels
From: Adrian Chadd <adrian@freebsd.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 May 2013 02:58, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:

> Maybe I can do the same for the Linux IEs too, just for reference.
> We basically enable it only if 802.11a or g is supported (802.11b is not
> supported), and announce OFDM only rates. The rates are divided by two or
> four (for 10 and 5 MHz), and rounded up. That's pretty much the only
> thing which is changed to 20 MHz.

Cool. I'll do it over the weekend. I'm currently at BSDCan 2013 fixing
and talking about wifi stuff. :-)

> BTW, how is HT handled for narrow channels in FreeBSD? Do you just send
> HT IEs as they are in 20 MHz? Also, do you disable secondary channels?
> (I would probably do that, using two adjacent 5 MHz channels should be
> replaceable by one 10 MHz channel ...)

I haven't enabled 11n half/quarter rate channels yet. Yeah, I intend
to leave the MCS IE's alone, as the MCS rates are a bitmap. I won't
disable HT40 but it wouldn't make sense to configure it.

(But who knows, people do odd crap.)



Adrian
