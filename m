Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:51028 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761479AbXHFUgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 16:36:50 -0400
Message-ID: <46B78661.4050807@lwfinger.net>
Date: Mon, 06 Aug 2007 15:36:49 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] bcm43xx-mac80211: Add TX power set file to debugfs
References: <46b782f6.XGqOxV2KvXubz5jy%Larry.Finger@lwfinger.net> <200708062225.58737.mb@bu3sch.de>
In-Reply-To: <200708062225.58737.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 06 August 2007 22:22:14 Larry Finger wrote:
>> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
>> ===================================================================
>> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
>> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
>> @@ -2762,12 +2762,11 @@ static int bcm43xx_dev_config(struct iee
>>  	}
>>  
>>  	/* Adjust the desired TX power level. */
>> -	if (conf->power_level != 0) {
>> -		if (conf->power_level != phy->power_level) {
>> -			phy->power_level = conf->power_level;
>> -			bcm43xx_phy_xmitpower(dev);
>> -		}
>> -	}
>> +	if (conf->power_level != 0 && phy->power_level == 0) {
>> +		phy->power_level = conf->power_level;
>> +	} else
>> +		phy->power_level = 10;
>> +	bcm43xx_phy_xmitpower(dev);
> 
> No, what's that? I disagree with that.
> This breaks power adjustment.
> 

I just discovered that it fails. When I find the problem, I'll resubmit. Is the debugfs part right?

Larry
