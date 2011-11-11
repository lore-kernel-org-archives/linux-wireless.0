Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3469 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab1KKTt0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 14:49:26 -0500
Message-ID: <4EBD7C3E.9030205@broadcom.com> (sfid-20111111_204948_341305_34265454)
Date: Fri, 11 Nov 2011 11:49:18 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 17/19] brcm80211: fmac: stop using hard coded
 firmware/nvram name
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
 <1320953434-16859-19-git-send-email-arend@broadcom.com>
 <20111111173548.GC2485@tuxdriver.com>
In-Reply-To: <20111111173548.GC2485@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2011 09:35 AM, John W. Linville wrote:
> On Thu, Nov 10, 2011 at 08:30:32PM +0100, Arend van Spriel wrote:
>> From: Franky Lin<frankyl@broadcom.com>
>>
>> The nvram file contains info for firmware which varies with different
>> hardware designs. Current nvram file in Linux firmware repository is
>> for a internal development board. It is not applicable for any exsisting
>> end-user product. Every device with a fullmac support wifi dongle
>> should have its own nvram file in the system. Similar rule can be applied
>> to the dongle firmware. This patch remove the hard coded firmware/nvram
>> name in the driver. The paths of firmware and nvram file must be
>> passed to the driver through module parameter during or configured
>> in kernel option.
>>
>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>> Reviewed-by: Arend van Spriel<arend@broadcom.com
>> Signed-off-by: Franky Lin<frankyl@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>
> I can't say that I'm too fond of this one.  Why do you need to be
> able to change the name of the file?  Other drivers seem to handle
> this without having to set the filename at Kconfig time?
>
> John

That is indeed an approach that would make the code cleaner. Anyway the 
user need to figure out where the firmware/nvram are in the system and 
provide the path to driver in the approach this patch provide. So just 
one more step to create a soft link point to them with the name could be 
recognised by the driver. Could you please drop this patch? I just 
checked the rest of the train can be applied without any problem. I will 
modify and resubmit it in the next train.

Thanks,
Franky

