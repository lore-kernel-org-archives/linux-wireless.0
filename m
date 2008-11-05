Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:53882 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYKEPiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 10:38:20 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
Date: Wed, 5 Nov 2008 13:38:31 -0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br> <4910CD42.4010402@lwfinger.net> <1225884552.3619.74.camel@johannes.berg>
In-Reply-To: <1225884552.3619.74.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811051338.33882.herton@mandriva.com.br> (sfid-20081105_163824_058980_18397E8D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 November 2008 09:29:12 Johannes Berg wrote:
> On Tue, 2008-11-04 at 14:31 -0800, Larry Finger wrote:
> > Herton Ronaldo Krzesinski wrote:
> > > Realtek 8187B has a receive command queue to feedback beacon interrupt
> > > and transmitted packet status. Use it to feedback mac80211 about status
> > > of transmitted packets. Unfortunately in the course of testing I found
> > > that the sequence number reported by hardware includes entire sequence
> > > control in a 12 bit only field, so a workaround is done to check only
> > > lowest bits.
> > >
> > > Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> >
> > Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> >
> >
> > Quilt shows the following warning:
> >
> > Warning: trailing whitespace in lines 438,468 of
> > drivers/net/wireless/rtl8187_dev.c
> >
> > scripts/checkpatch shows the following:
> >
> > WARNING: line over 80 characters
> > #138: FILE: drivers/net/wireless/rtl8187_dev.c:475:
> > +                       if ((le16_to_cpu(ieee80211hdr->seq_ctrl) & 0xFFF)
> > == seq_no)

Ops, I forgot to run checkpatch.pl here, will run and fix it when I submit 
next patch.

>
> Besides, that line looks wrong? the lowest 4 bits are teh fragment
> number.

It's intended, because the hardware instead of reporting just the sequence 
number in its 12 bits is reporting fragment number + sequence number, this is 
a workaround.

>
> johannes

-- 
[]'s
Herton
