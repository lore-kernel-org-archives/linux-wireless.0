Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:41243 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935526AbXGZR4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 13:56:36 -0400
Message-ID: <46A8E044.6080206@lwfinger.net>
Date: Thu, 26 Jul 2007 12:56:20 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <20070726172138.GA6068@tuxdriver.com>
In-Reply-To: <20070726172138.GA6068@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Thu, Jul 26, 2007 at 11:33:01AM -0500, Larry Finger wrote:
>> A typo in the specs interchanges the branches in an if statement, which
>> breaks operations for a BCM4306/rev 2 that has phy->analog == 1.
> 
>> @@ -1895,7 +1895,7 @@ void bcm43xx_phy_set_baseband_attenuatio
>>  		bcm43xx_write16(dev, BCM43xx_MMIO_PHY0,
>>  				(bcm43xx_read16(dev, BCM43xx_MMIO_PHY0)
>>  				 & 0xFFF0) | baseband_attenuation);
>> -	} else if (phy->analog == 1) {
>> +	} else if (phy->analog != 1) {
>>  		bcm43xx_phy_write(dev, BCM43xx_PHY_DACCTL,
>>  				  (bcm43xx_phy_read(dev, BCM43xx_PHY_DACCTL)
>>  				   & 0xFFC3) | (baseband_attenuation << 2));
> 
> Larry,
> 
> How does this relate to the bcm43xx patch you asked me to revert
> (and has been reverted in F-7)?  That one change "==" to ">", while
> this one changes "==" to "!=".  Instead of reverting the other,
> should it do the same thing as this?

It really doesn't matter whether one uses ">" or "!=" here. The number in question is >= 0 and the 
test for for zero occurs earlier in the routine and ends with a return. Now that you mention it, it 
would be best to make bcm43xx nad bcm43xx-mac80211 look the same. I'll modify and resubmit the patch.

Larry


