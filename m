Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:38250 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbYKDVaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 16:30:24 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets using tx close descriptor for 8187B
Date: Tue, 4 Nov 2008 19:30:27 -0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
References: <244535.27936.qm@web23107.mail.ird.yahoo.com>
In-Reply-To: <244535.27936.qm@web23107.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811041930.29564.herton@mandriva.com.br> (sfid-20081104_223038_082022_4DE71D05)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 04 November 2008 18:27:12 Hin-Tak Leung wrote:
> --- On Tue, 4/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> 
wrote:
> > Realtek 8187B has a receive command queue to feedback beacon
> > interrupt
> > and transmitted packet status. Use it to feedback mac80211
> > about status
> > of transmitted packets. Unfortunately in the course of
> > testing I found
> > that the sequence number reported by hardware includes
> > entire sequence
> > control in a 12 bit only field, so a workaround is done to
> > check only
> > lowest bits.
> >
> > ---
> >  v2: fix rate stuck at 1M reported by Larry Finger, Hin-Tak
> > and also seen by me.
> >      btw, I noted now with a ralink device that rt2500usb
> > (rt2x00) has same
> >      issue currently.
> >
> >
> > -		hdr->retry =
> > cpu_to_le32((info->control.rates[0].count - 1) <<
> > 8);
> > +		hdr->retry =
> > cpu_to_le32(info->control.rates[0].count << 8);
> >
> > -		hdr->retry =
> > cpu_to_le32((info->control.rates[0].count - 1) <<
> > 8);
> > +		hdr->retry =
> > cpu_to_le32(info->control.rates[0].count << 8);
>
> These are the only lines which changed between the two versions of the
> patch - if removing the two -1's fixes the rate stuck (and these two lines
> are newly introduced), shouldn't this be a separate commit if it fixes a
> problem introduced by an earlier commit?

No, there was other change as well:
info->status.rates[0].count = pkt_rc - 1;
to
info->status.rates[0].count = pkt_rc;

that's in fact what fixes the rate control problem with pid (from what I 
understand from the code, if rates[0].count is not zero (that will be always 
the case here) pid would register the tx with errors, and would explain the 
rate stuck at 1M).

The other changes is because now with new rate control api, it changed 
semantics but is passing a different retry_count than before now, while 
testing I found for example, connecting to an ap using wep, it is passing in 
tx packet in same conditions retry_count=6 now instead of 7 as before rate 
control api, so I considered a bug, unless this is desired (also depending on 
code path the retry count in tx packet could be set to zero now, is this 
right?); if new behaviour of retry_count in this case is right (and my change 
is wrong) please someone explain to me what is the semantic now behind the 
new rate control api (looking at the rate control api change why there is 
some differences between drivers?, as some drivers simply just replaced 
retry_count with rates[0].count usage while others changed 
to "rates[0].count - 1".)

>
> I did *not* (and do not) have a rate-stuck problem, but I am running a
> slightly mod version of the patch against 2.6.27, which doesn't have
> "rates[x].count" yet, with the retry_count struct member which seems to
> have since been removed.

Please try and check the patches with latest wireless-testing.

--
[]'s
Herton
