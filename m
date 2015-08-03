Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35066 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbbHCSsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 14:48:03 -0400
Received: by oihn130 with SMTP id n130so7205920oih.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 11:48:02 -0700 (PDT)
Date: Mon, 3 Aug 2015 13:47:34 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 4/5] wireless-regdb: Update 5GHz rules for US
Message-ID: <20150803184734.GF21180@ubuntu-hedt> (sfid-20150803_204807_240863_0CF637C8)
References: <1437622380-4154-1-git-send-email-wens@csie.org>
 <1437622380-4154-5-git-send-email-wens@csie.org>
 <20150803183422.GD21180@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150803183422.GD21180@ubuntu-hedt>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 03, 2015 at 01:34:22PM -0500, Seth Forshee wrote:
> On Thu, Jul 23, 2015 at 11:32:59AM +0800, Chen-Yu Tsai wrote:
> > The FCC increased the maximum conducted transmission power for the
> > U-NII-1 (5150 ~ 5250 MHz) band to 30 dBm or 1 W for master devices
> > and 24 dBm or 250 mW for mobile/portable devices.
> > 
> > Effective 6/2/2014.
> > 
> > See FCC KDB 905462 D06.
> > 
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > ---
> >  db.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/db.txt b/db.txt
> > index cadd52c..29ba4b6 100644
> > --- a/db.txt
> > +++ b/db.txt
> > @@ -1160,7 +1160,7 @@ country UG: DFS-FCC
> >  
> >  country US: DFS-FCC
> >  	(2402 - 2472 @ 40), (30)
> > -	(5170 - 5250 @ 80), (17), AUTO-BW
> > +	(5170 - 5250 @ 80), (30), AUTO-BW
> 
> The 30 dB limit is for devices in master mode, for clients the limit
> seems to be 250 mW (about 24 dB). Given the TPC requirement for U-NII
> devices the most it could be bumped up to is 21 dB, unless there's some
> other reason I don't know about to keep it at 17 dB.

Oops, looks like I was mistaken, this range does not require TPC. 30 dBm
still seems to be incorrect however.
