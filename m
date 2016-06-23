Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35359 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbcFWVce (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 17:32:34 -0400
Message-ID: <576C556B.1040509@osg.samsung.com> (sfid-20160623_233250_879312_C7497A71)
Date: Thu, 23 Jun 2016 22:32:27 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
CC: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: wilc1000: arrays can't be NULL
References: <1466704629-26084-1-git-send-email-luisbg@osg.samsung.com> <1466709897.1847.24.camel@perches.com>
In-Reply-To: <1466709897.1847.24.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23/06/16 20:24, Joe Perches wrote:
> On Thu, 2016-06-23 at 18:57 +0100, Luis de Bethencourt wrote:
>> hif_drv->usr_scan_req.net.net_info[i] contains found_net_info structs
>> which have the following element:
>> u8 bssid[6];
> []
>> I am aware this patch gives a few checkpatch.pl warnings about lines being
>> over 80 characters. Fixing that would be a completely different issue, and
>> a lengthy one since the file has loads of them.
>>
>> Hopefully somebody else picks that up. Maybe I should send a hit to the
>> kernelnewbies mailing list :)
> 
> Or not.
> 
> really_long_identifiers™ makes using 80 columns silly.

I agree. Not a priority, at all.

> 
> The hungarian could probably be converted though.
> 

I could look into this tomorrow.

I noticed, for example these 3 in the same function:
struct wid strWIDList[8];
u32 u32WidsCount = 0, dummyval = 0;
u8 *pu8CurrByte = NULL;

Not pretty and cleaning those should take little time.

> A log of the memcpy and memcpy uses could probably be
> converted to ether_addr_<foo> too.
> 

Switching memcpy for ether_addr_copy and memcmp for ether_addr_equal.

I could send a patch for this as well, but I would need to have somebody
test it for me. Or maybe get this hardware for myself and do it properly.

Do you approve of my original patch?

Thanks for the review :)
Luis


