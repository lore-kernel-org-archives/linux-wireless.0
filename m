Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:44955 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2DJKzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 06:55:20 -0400
Date: Tue, 10 Apr 2012 13:57:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	ath9k-devel@venema.h4ckr.net, kernel-janitors@vger.kernel.org,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k_hw: precedence bug in
 ath9k_hw_set_ofdm_nil()
Message-ID: <20120410105725.GA5589@mwanda> (sfid-20120410_125524_765056_6C00F7FD)
References: <20120410090445.GB26832@elgon.mountain>
 <4F840442.5060706@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F840442.5060706@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 10, 2012 at 11:58:26AM +0200, Felix Fietkau wrote:
> >  	if ((aniState->noiseFloor >= aniState->rssiThrHigh) &&
> > -	    (!aniState->ofdmWeakSigDetectOff !=
> > +	    (aniState->ofdmWeakSigDetectOff !=
> Looking at other Atheros code, I think this patch is wrong, it should
> be: aniState->ofdmWeakSigDetectOff == entry_ofdm->ofdm_weak_signal_on
> 
> While a bit confusing, the behavior of the original code was correct,
> aniState->ofdmWeakSigDetectOff is used as a boolean.
> 
> This code badly needs a cleanup, the whole mess with *on vs *off
> variables is quite confusing.
> 

Yep.  It's bad to name variables xxx_off because it leads triple
negatives like we see here.

I guess that "if (!off != on) { ..." might be more readable than
"if (off == on) { ...".  There are a couple ways to silence this
warning in Smatch.

The first way would be to add parenthesis like,
"((!off) != on) {...".  I think it helps because it makes the negate
stand out and you don't have to think about how the precedence
rules works.  Other people think it's a needless parenthesis for
something that is obvious.

The other way would be to make either ->ofdmWeakSigDetectOff or
->ofdm_weak_signal_on be type bool.  I think this would make the
code clearer.

regards,
dan carpenter
