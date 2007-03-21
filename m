Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61950 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932247AbXCUPaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 11:30:09 -0400
Message-ID: <46014F75.7080609@lwfinger.net>
Date: Wed, 21 Mar 2007 10:29:57 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Change radio_init2050 to match specs
References: <460048f1.Sz+VinhM/N8KG294%Larry.Finger@lwfinger.net> <200703211501.48178.mb@bu3sch.de>
In-Reply-To: <200703211501.48178.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 20 March 2007 21:49, Larry Finger wrote:
>> The code in the mac80211 version of radio_init2050 differs from the specs
>> in two places.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> Index: wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
>> ===================================================================
>> --- wireless-mb.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
>> +++ wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
>> @@ -3444,9 +3444,9 @@ static u16 radio2050_rfover_val(struct b
>>  			if (phy_register == BCM43xx_PHY_RFOVER) {
>>  				return 0x9B3;
>>  			} else if (phy_register == BCM43xx_PHY_RFOVERVAL) {
>> -				extlna |= (i << 8);
>>  				if (extlna)
>>  					extlna |= 0x8000;
>> +				extlna |= (i << 8);
> 
> What's the difference?

The nonzero test for extlna should be made on the table value, not the table value or'd with i << 8.

Larry
