Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:25021 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbHQIqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 04:46:33 -0400
Message-ID: <55D19F57.4070605@broadcom.com> (sfid-20150817_104655_066996_CC468D4D)
Date: Mon, 17 Aug 2015 10:46:15 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>
CC: David Miller <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] net/wireless: enable wiphy device to suspend/resume asynchronously
References: <55B9B3BA.6080406@linux.intel.com>	 <CANUX_P3PMsvWCWWciwCsRvf5PqLVEK9d9S=2Gbq+EotVGffEow@mail.gmail.com>	 <55D13D66.1050500@linux.intel.com> <1439796553.2451.1.camel@sipsolutions.net>
In-Reply-To: <1439796553.2451.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Rafael

On 08/17/2015 09:29 AM, Johannes Berg wrote:
> On Mon, 2015-08-17 at 09:48 +0800, Fu, Zhonghui wrote:
>>
>> The suspend/resume timing of wiphy device and related devices will be
>> ensured by their parent/child relationship. So, enabling wiphy device
>> to suspend/resume asynchronously does not change any  dependency. It
>> can only take advantage of multicore and improve system
>> suspend/resume speed.
>>
>
> You're going to have to explain that to me, because I don't see that.
> All I see is that when looking at a device, if async is possible, it
> gets added to an async work, and if async is not possible then it gets
> done immediately. Even putting aside the question of whether or not
> async is ordered or not (I don't know), if the wiphy is async and the
> PCI (or other bus) device isn't, then it seems they could get handled
> out of order, no? Or is there some magic code somewhere that I'm
> missing that explicitly waits for the async of the parent/child
> relationship?

This patch got me worried as well. Can't find the magic either. Maybe 
Rafael can give some hints here.

Regards,
Arend

> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

