Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:55315 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYKEP7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 10:59:40 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
Date: Wed, 5 Nov 2008 13:59:50 -0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br> <200811051338.33882.herton@mandriva.com.br> <1225899623.3619.119.camel@johannes.berg>
In-Reply-To: <1225899623.3619.119.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811051359.51665.herton@mandriva.com.br> (sfid-20081105_165945_000361_AEA44408)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 November 2008 13:40:22 Johannes Berg wrote:
> On Wed, 2008-11-05 at 13:38 -0200, Herton Ronaldo Krzesinski wrote:
> > > > WARNING: line over 80 characters
> > > > #138: FILE: drivers/net/wireless/rtl8187_dev.c:475:
> > > > +                       if ((le16_to_cpu(ieee80211hdr->seq_ctrl) &
> > > > 0xFFF) == seq_no)
> >
> > Ops, I forgot to run checkpatch.pl here, will run and fix it when I
> > submit next patch.
>
> I wouldn't worry about lines > 80 chars too much, breaking this down
> wouldn't make more readable but less so, in my opinion. I tend to ignore
> that rule where it makes the code unreadable :)
>
> > > Besides, that line looks wrong? the lowest 4 bits are teh fragment
> > > number.
> >
> > It's intended, because the hardware instead of reporting just the
> > sequence number in its 12 bits is reporting fragment number + sequence
> > number, this is a workaround.
>
> Ah. A comment might be appropriate that "seq_no" doesn't actually
> contain the sequence number?

Yes, I'll improve comment there, will change by this:

/*
 * While testing, it was discovered that the seq_no doesn't
 * actually contains the sequence number. Instead
 * of returning just the 12 bits of sequence number,
 * hardware is returning entire sequence control (fragment
 * number plus sequence number) in a 12 bit only field
 * overflowing after some time. As a workaround,
 * just consider the lower bits, and expect it's unlikely
 * we wrongly ack some sent data
 */

>
> johannes

--
[]'s
Herton
