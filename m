Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:51206 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751475AbXBNAmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 19:42:52 -0500
Message-ID: <45D25AFC.2060508@lwfinger.net>
Date: Tue, 13 Feb 2007 18:42:36 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: Fix for 4311 and 02/07/07 specification changes
References: <45d241c0.gWJcHxUYgWmBTwx8%Larry.Finger@lwfinger.net> <200702140002.05727.mb@bu3sch.de>
In-Reply-To: <200702140002.05727.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 13 February 2007 23:54, Larry Finger wrote:
>> The specifications for the bcm43xx driver have been modified. This patch
>> incorporates these changes in the code, which results in the BCM4311 and
>> BCM4312 working. The name of one of the PHY parameters, previously known
>> as "version", has been changed to "analog", short for  "analog core version" .
>>
>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> 
>> @@ -750,7 +757,7 @@ static void bcm43xx_phy_initb5(struct bc
>>  	if (radio->version == 0x2050)
>>  		bcm43xx_phy_write(bcm, 0x0038, 0x0667);
>>  
>> -	if (phy->connected) {
>> +	if (phy->type == BCM43xx_PHYTYPE_G) {
> 
> I don't think this is correct.
> I think (didn't verify) the specs talk about the "gmode" here.
> I think you have been misleaded by that. The "gmode" bit is
> the "connected" bit in the old softmac driver.
> 

The specs definitely say "If this is a GPHY" is step 5 of http://bcm-specs.sipsolutions.net/B5PHY.

Larry

