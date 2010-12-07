Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:44486 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754062Ab0LGCen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:34:43 -0500
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0738769281
	for <linux-wireless@vger.kernel.org>; Tue,  7 Dec 2010 11:34:41 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Jonathan Guerin <jonathan@guerin.id.au>
Subject: Re: ath5k: Weird Retransmission Behaviour
Date: Tue, 7 Dec 2010 11:34:27 +0900
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	"ath5k-devel" <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com> <201012061714.15863.br1@einfach.org> <AANLkTi=Cg2GyRXz6a3Sv8X9ATXJLTSXgfEn+wU4NT0XP@mail.gmail.com>
In-Reply-To: <AANLkTi=Cg2GyRXz6a3Sv8X9ATXJLTSXgfEn+wU4NT0XP@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012071134.27162.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue December 7 2010 10:12:18 Jonathan Guerin wrote:
> > Another thing that strikes me here is: why use multi rate retries if the
> > rate is all the same? (Ignore the actual value of the rate, this is the
> > HW rate code).
> > 
> > Other examples:
> > 
> > *** txdesc tries 2
> > *** mrr 0 tries 9 rate 12
> > *** mrr 1 tries 2 rate 13
> > *** mrr 2 tries 3 rate 11
> > 
> > = 16 transmissions in sum.
> > 
> > *** txdesc tries 9
> > *** mrr 0 tries 3 rate 11
> > *** mrr 1 tries 9 rate 8
> > *** mrr 2 tries 3 rate 11
> > 
> > = 24 transmissions in sum. Again, rate[1] and rate[3] are the same, so
> > why bother setting it up twice?
> 
> I'm not sure if you still had a fixed rate set here - and I don't know
> 100% how minstrel works - but it could be that minstrel is trying to
> do some probing for better rates (if it was set to auto-rate)?

I did not set a fixed rate, so minstrel was probing for better rates / 
providing alternative rates.

In any case there is no reason to use the same rate twice.

bruno
