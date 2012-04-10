Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6741 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630Ab2DJMte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 08:49:34 -0400
Date: Tue, 10 Apr 2012 18:20:18 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	<ath9k-devel@venema.h4ckr.net>, <kernel-janitors@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k_hw: precedence bug in
 ath9k_hw_set_ofdm_nil()
Message-ID: <20120410125015.GA7543@vmraj-lnx.users.atheros.com> (sfid-20120410_144948_962908_CDD86C5F)
References: <20120410090445.GB26832@elgon.mountain>
 <4F840442.5060706@openwrt.org>
 <20120410105725.GA5589@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120410105725.GA5589@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 10, 2012 at 01:57:25PM +0300, Dan Carpenter wrote:
> On Tue, Apr 10, 2012 at 11:58:26AM +0200, Felix Fietkau wrote:
> > >  	if ((aniState->noiseFloor >= aniState->rssiThrHigh) &&
> > > -	    (!aniState->ofdmWeakSigDetectOff !=
> > > +	    (aniState->ofdmWeakSigDetectOff !=
> > Looking at other Atheros code, I think this patch is wrong, it should
> > be: aniState->ofdmWeakSigDetectOff == entry_ofdm->ofdm_weak_signal_on
> > 
> > While a bit confusing, the behavior of the original code was correct,
> > aniState->ofdmWeakSigDetectOff is used as a boolean.
> > 
> > This code badly needs a cleanup, the whole mess with *on vs *off
> > variables is quite confusing.
> > 
> 
> Yep.  It's bad to name variables xxx_off because it leads triple
> negatives like we see here.
> 
> I guess that "if (!off != on) { ..." might be more readable than
> "if (off == on) { ...".  There are a couple ways to silence this
> warning in Smatch.
> 
> The first way would be to add parenthesis like,
> "((!off) != on) {...".  I think it helps because it makes the negate
> stand out and you don't have to think about how the precedence
> rules works.  Other people think it's a needless parenthesis for
> something that is obvious.
> 
> The other way would be to make either ->ofdmWeakSigDetectOff or
> ->ofdm_weak_signal_on be type bool.  I think this would make the
> code clearer.
>
Declare them as bool type and rename one of them to common (either *_off or *_on).

-Rajkumar
