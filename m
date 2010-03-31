Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:49990 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776Ab0CaWez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 18:34:55 -0400
Message-ID: <4BB3CE0D.1030707@gmail.com>
Date: Thu, 01 Apr 2010 00:34:53 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] rt2x00: Enable powersaving by default again on rt2500usb.
References: <1269985826-17438-1-git-send-email-gwingerde@gmail.com> <1269985826-17438-3-git-send-email-gwingerde@gmail.com> <loom.20100401T002825-964@post.gmane.org>
In-Reply-To: <loom.20100401T002825-964@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/10 00:29, Adam Baker wrote:
> Gertjan van Wingerde <gwingerde@...> writes:
> 
>>
>> Now that the powersave issues on rt2500usb have been tackled, powersave
>> can be enabled by default again.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@...>
>> ---
>>  drivers/net/wireless/rt2x00/rt2500usb.c |    5 -----
>>  1 files changed, 0 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c
> b/drivers/net/wireless/rt2x00/rt2500usb.c
>> index 54d2716..c1eec17 100644
>> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
>> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
>> @@ -1647,11 +1647,6 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev
> *rt2x00dev)
>>  	unsigned int i;
>>
>>  	/*
>> -	 * Disable powersaving as default.
>> -	 */
>> -	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>>
> This looks like it deletes one line too few leaving a nested open comment
> block in the code.
> 

Nope, it doesn't. This is just the peculiar way diff creates patches within git.
If you take a look at the full patch, then you'll see that the patch removes all lines
including the '/*' of the next comment.
So the end-result is still good.

---
Gertjan.
