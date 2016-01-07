Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46357 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbcAGVPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 16:15:16 -0500
Message-ID: <1452201308.3141.25.camel@sipsolutions.net> (sfid-20160107_221520_610580_9AF3BA5D)
Subject: Re: Mac80211 : Wpa rekeying issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 07 Jan 2016 22:15:08 +0100
In-Reply-To: <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com> (sfid-20151231_094154_715579_53F875A2)
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
	 <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
	 <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
	 <0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
	 <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
	 (sfid-20151231_094154_715579_53F875A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-31 at 10:41 +0200, Emmanuel Grumbach wrote:
> 
> So essentially, this is a bug in the TX'ing side. Fixing it requires
> to hit the performance which is not something people are willing to
> do, when the bug is really in the spec.
> 

I wonder if, for most devices, this is really true?

We could, after all, remove the key from hardware acceleration before
we replace it logically in software, avoiding the problem [1], like
this:

https://p.sipsolutions.net/a71aa559c27998c7.txt
(completely untested!)

This would slightly increase the window of time in which devices like
ath10k that require hardware crypto drop the frame entirely, but that
seems quite reasonable?


[1] assuming the driver doesn't return from the set_key() method while
it still has frames that might have been decrypted with that key; which
again is clearly true for iwlwifi due to the combined data/firmware
command design, but maybe not fully guaranteed for ath9k
