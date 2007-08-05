Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46190 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516AbXHEH0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 03:26:34 -0400
Message-ID: <46B57BA8.5010102@lwfinger.net>
Date: Sun, 05 Aug 2007 02:26:32 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Andy Green <andy@warmcat.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bcm43xx-mac80211: Rescale link quality output
References: <46b56ce8.MTc7K0Zquczk+/6h%Larry.Finger@lwfinger.net> <46B5717A.6090302@warmcat.com>
In-Reply-To: <46B5717A.6090302@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> Somebody in the thread at some point said:
>> BCM43xx_RX_MAX_SSI (60)
> 
>> +	status.signal = jssi * 100 / BCM43xx_RX_MAX_SSI;
> 
> That can't be doing what you intended... (int)100/60 == 1, it just
> multiplies jssi by 1.  Maybe some brackets around the multiply?

I think gcc does equal rank operations from left to right, and the change does have the desired 
result, but the parentheses should be there for clarity.

Thanks,

Larry
