Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47406 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbXEZVLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 17:11:36 -0400
Message-ID: <4658A286.1050204@lwfinger.net>
Date: Sat, 26 May 2007 16:11:34 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix for tx_bias equal to 0xFF
References: <465869ce.8wcEX9q9ZmHxX2m3%Larry.Finger@lwfinger.net> <200705261919.39143.mb@bu3sch.de> <46587492.6070106@lwfinger.net> <200705262206.53388.mb@bu3sch.de>
In-Reply-To: <200705262206.53388.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 26 May 2007 19:55:30 Larry Finger wrote:
>> Michael Buesch wrote:
>>> Ok, on which specification bits is this actually based? :)
>>> txpower_bg still needs a rewrite, and I have a patch for that in
>>> the pipeline, but it's still buggy due to missing specs stuff.
>>>
>> It is not in the V4 specifications that I have found, but the V3 (softmac) driver does this "fixup". 
> 
> I cannot find this in the sm driver. Can you give me a hint
> where to search?
> 
>> With it, my 4311 connects with bcm43xx-mac80211. Without it, no connection.
> 
> Ok, nice.
> 

My memory was faulty earlier, but it is coming back. V3 differs in that txctl1 (the equivalent of 
tx_bias) is not initialized to 0xFF, but is given a value of 0-3 in bcm43xx_default_txctl1. I added 
trace code that checked the value being written to radio register 0x52 and dumped the stack when the 
value was still 0xFF. On that basis, I made it look like the code in bcm43xx_phy_initg when tx_bias 
is 0xFF.

Would you prefer the equivalent of bcm43xx_default_txctl1? That wouldn't be difficult.

Are the txpower adjustment bugs a problem with the specs? Is there anything I can do?

Larry

Larry
