Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54368 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbbEPFpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 01:45:15 -0400
Message-ID: <5556D95E.40706@openwrt.org> (sfid-20150516_074533_942639_9520B8AD)
Date: Sat, 16 May 2015 07:45:02 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: add phy.c
References: <1431693340-8861-1-git-send-email-linux@rempel-privat.de> <55564A50.2050004@openwrt.org> <5556D48B.3090708@rempel-privat.de>
In-Reply-To: <5556D48B.3090708@rempel-privat.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-05-16 07:24, Oleksij Rempel wrote:
> Am 15.05.2015 um 21:34 schrieb Felix Fietkau:
>> On 2015-05-15 14:35, Oleksij Rempel wrote:
>>> ... and move dup code from ar5008_phy.c and ar9002_phy.c to phy.c
>>>
>>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
>> We already have base functionality for AR5008-AR9002 provided in some
>> ar5008_phy.c, and ar5008_hw_attach_phy_ops is called for those chipsets
>> as well. Please keep the de-duplicated code there instead of adding a
>> new phy.c, because AR9003+ uses a completely different codepath.
>> 
>> - Felix
>> 
> 
> ok, thanks.
> Currently i celled this function phy_hw_spur_mitigate(), is it ok or
> there is some better name for this code?
Just use the ar5008 prefix like in the other functions.

- Felix
