Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:60275 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992764AbXBITRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 14:17:12 -0500
Message-ID: <45CCC8B5.3060108@gentoo.org>
Date: Fri, 09 Feb 2007 14:17:09 -0500
From: Joseph Jezak <josejx@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <Larry.Finger@lwfinger.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net> <200702091945.25187.mb@bu3sch.de>
In-Reply-To: <200702091945.25187.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> The specs are unclear at this point:
> "Write the value to the offset"
> Offset in which register type?

PHY Register.  I've clarified it in the specs, I think this was said 
before, I made it worse when I cleaned it up.

>>  	// Initialization
>> -	if (phy->version == 0) {
>> +	if (phy->analog == 0) {
>>  		bcm43xx_write16(bcm, 0x03E6, 0x0122);
>>  	} else {
>> -		if (phy->version >= 2)
>> -			bcm43xx_write16(bcm, 0x03E6, 0x0040);
>> +		if (phy->analog >= 2)
>> +			bcm43xx_write16(bcm, 0x0003, (bcm43xx_read16(bcm, 0x0003)
>> +					& 0xFFBF) | 0x0040);
> 
> I think here is a specs bug.

This is correct.  Why do you think it's a specs bug?

-Joe
