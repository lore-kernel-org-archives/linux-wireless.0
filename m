Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47257 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750853Ab1ABIxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jan 2011 03:53:12 -0500
Date: Sun, 2 Jan 2011 10:53:00 +0200
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kvalo@adurom.com>
Cc: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, Jouni Malinen <Jouni.Malinen@atheros.com>
Subject: Re: [PATCH] Revert "ath9k: Parse DTIM period from mac80211"
Message-ID: <20110102085300.GA14217@jm.kir.nu>
References: <1293691681-3574-1-git-send-email-mshajakhan@atheros.com>
 <871v4xgdfp.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <871v4xgdfp.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 01, 2011 at 11:50:50AM +0200, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mshajakhan@atheros.com> writes:
> > * Preventing association with broken AP's
> 
> How can different dtim value cause problems with association? Power
> save should not be even enabled during association. Or do you mean
> there are problems after association, for example during eap
> negotation?

It is not the DTIM value, it is the part of having to receive a Beacon
frame before even trying to associate. This is very much a corner case,
but well, that behavior did change with the commit.

> > * Adds latency in roaming
> 
> We should try to solve this problem differently than hardcoding dtim.
> There are other ways to trigger roaming than just following beacons.
> And if there's no data, there's no need to roam either. 

This is about the part of waiting for Beacon frame before trying to
associate, not about hardcoding DTIM for any other purpose.

> > So its better to always use the safe value of '1' for dtim period
> 
> By hardcoding dtim you increase the power consumption in the case when
> there is no data traffic, so it's not definitely better in all cases.
> 
> I would prefer to fix the real issues instead of hardcoding dtim. And
> if it's really essential to hardcode it now, please add a big fat
> warning indicating that this is a temporary solution and should be
> fixed properly without hardcoding anything.

The real issue (as far as I can tell) was that ath9k was changed to
require mac80211 to get it DTIM period before association. I'm not aware
of any need for that with ath9k. It should have no problems updating PS
parameters after association and as such, should not require mac80211 to
figure DTIM period out before being able to associate. This change is
not about hardcoding DTIM period; it is about removing unneeded change
that added extra latency without any real gain.

-- 
Jouni Malinen                                            PGP id EFC895FA
