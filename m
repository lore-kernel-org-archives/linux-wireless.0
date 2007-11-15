Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:52403 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbXKOCkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 21:40:52 -0500
Received: by py-out-1112.google.com with SMTP id u77so3189301pyb
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2007 18:40:51 -0800 (PST)
Message-ID: <8e6f94720711141840g7346f4eak577477d735b72f39@mail.gmail.com> (sfid-20071115_024103_923499_422B1E07)
Date: Wed, 14 Nov 2007 21:40:51 -0500
From: "Will Dyson" <will.dyson@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Cc: "Florian Lohoff" <flo@rfc822.org>,
	"Marcus Better" <marcus@better.se>, linux-wireless@vger.kernel.org,
	"Mattias Nissler" <mattias.nissler@gmx.de>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <20071114211354.GD6226@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20071111102315.GC10486@paradigm.rfc822.org>
	 <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com>
	 <20071113192330.GA19601@paradigm.rfc822.org>
	 <fhedc4$5l9$1@ger.gmane.org>
	 <20071114153347.GA3512@paradigm.rfc822.org>
	 <8e6f94720711141057w463d55c4r2be74d0aa8d78918@mail.gmail.com>
	 <20071114211354.GD6226@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 14, 2007 4:13 PM, John W. Linville <linville@tuxdriver.com> wrote:

> > http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=d37cabfb5f60a3bb56585a74fd3f140ba2960fe0
> >
> > The patch is in the wireless-2.6/everything tree, but not Linus's tree.
>
> Most of the patch seems like a no-op, except this bit:
>
>         if (is_rts_frame(frame_control) || is_cts_frame(frame_control)) {
>                 __set_bit(ENTRY_TXD_BURST, &desc.flags);
> -               if (is_rts_frame(frame_control))
> +               if (is_rts_frame(frame_control)) {
>                         __set_bit(ENTRY_TXD_RTS_FRAME, &desc.flags);
> +                       __set_bit(ENTRY_TXD_ACK, &desc.flags);
> +               } else
> +                       __clear_bit(ENTRY_TXD_ACK, &desc.flags);
>                 if (control->rts_cts_rate)
>                         tx_rate = control->rts_cts_rate;
>         }
>
> Is this correct?  I'm not sure about the actual meaning of TXD_W0_ACK
> (which keys off ENTRY_TXD_ACK)...

Adding Mattias (the patch's author), Ivo and the rt2x00 list to the CC.

TXD_W0_ACK seems to mean that the firmware should expect an ack for
the packet represented by that tx descriptor. That is how it is being
used (and looking at the vendor driver confirms it).

The rest of the patch moves the logic for setting this bit (or not) to
a central location, so that the interesting bit is not repeated in
each chip-specific driver file.

Although now that I really look at the patch, I wonder why the
IEEE80211_TXCTL_NO_ACK bit is not already set correctly for RTS and
CTS-to-self frames. It doesn't look like any other driver does this
kind of calculation, so perhaps the problem solved by this patch is
also present elsewhere?

-- 
Will Dyson
