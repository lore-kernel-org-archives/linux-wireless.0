Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0156.hostedemail.com ([216.40.44.156]:46694 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752314AbbEPFgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 01:36:23 -0400
Message-ID: <1431754580.15709.55.camel@perches.com> (sfid-20150516_073627_268611_0ABC4B1C)
Subject: Re: [PATCH] ath9k: add phy.c
From: Joe Perches <joe@perches.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Date: Fri, 15 May 2015 22:36:20 -0700
In-Reply-To: <5556D546.6010703@rempel-privat.de>
References: <1431693340-8861-1-git-send-email-linux@rempel-privat.de>
	 <1431714904.15709.24.camel@perches.com> <5556D546.6010703@rempel-privat.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-05-16 at 07:27 +0200, Oleksij Rempel wrote:

> Am 15.05.2015 um 20:35 schrieb Joe Perches:
> > On Fri, 2015-05-15 at 14:35 +0200, Oleksij Rempel wrote:
> >> ... and move dup code from ar5008_phy.c and ar9002_phy.c to phy.c
> > []
> >> diff --git a/drivers/net/wireless/ath/ath9k/phy.c b/drivers/net/wireless/ath/ath9k/phy.c
> > 
> >> +void phy_hw_spur_mitigate(struct ath_hw *ah,
> >> +			  struct ath9k_channel *chan, int bin)
> >> +{
[]
> >> +	static int inc[4] = { 0, 100, 0, 0 };
> > 
> > static const

> This is cleanup patch, no fixes optimisations
> or regressions should be introduced.

Hello Oleksij.

One of the old compilation units (ar9002_phy.c) had const on
all those arrays, the other did not.

const should be used here.

> If you see some problems in this
> code, you are welcome to provide a patch on top of this one :)

I think you should take comments on the patches you submit.


