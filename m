Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34531 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbcFCQH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 12:07:28 -0400
Subject: Re: [PATCH 2/2] ath10k: remove 10.1 firmware support
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
References: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
 <20160603153328.11947-2-rmanohar@qti.qualcomm.com>
 <5751A6D5.7080901@candelatech.com>
 <743182bcbd1efbdb576bcc51b0215300@codeaurora.org>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5751AB3F.2070604@candelatech.com> (sfid-20160603_180732_334616_5295B273)
Date: Fri, 3 Jun 2016 09:07:27 -0700
MIME-Version: 1.0
In-Reply-To: <743182bcbd1efbdb576bcc51b0215300@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2016 08:55 AM, Rajkumar Manoharan wrote:
> On 2016-06-03 21:18, Ben Greear wrote:
>> On 06/03/2016 08:33 AM, Rajkumar Manoharan wrote:
>>> Earlier qca9888 device was brought up using 10.1 firmware and then
>>> later all firmware fixes and new features are migrated to 10.2/10.2.x
>>> firmware branch. As all of 10.1 funtionalities are supported in 10.2
>>> based firmware, removing 10.1 firmware support for qca9888 device.
>>
>> Oh please do not do this.  My 10.1 firmware works very nicely,
>> and out-performs 10.2 in my testing.  Lots of people use my firmware
>> when they need IBSS support or other features not found in
>> official firmware, so it is not just me that will have
>> problems if you remove this support.
>>
> Aah.. I thought CT firmware is 10.2 based. Since most of firmware bug fixes and enhancements are integrated into 10.2 based firmware, we thought of get rid of
> 10.1 firmware to reduce code size. Moreover existing 10.1 official firmware has known issues. Is it possible to upgrade CT firmware to 10.2 WMI/HTT interfaces?

I have a 10.2 firmware too, but it is less stable, performs worse,
uses more RAM on the NIC (so I can do fewer virtual stations),
and I am not sure I can squeeze enough RAM out of it to port some
of the more interesting rate-ctrl fixes from 10.1 to 10.2.
I have recently started backporting a lot of 10.2.4 changes
into 10.1, which will aid any users on pre 4.0 kernels since they cannot
run 10.2.4 firmware w/out backporting.

I might could make my 10.1 work with a 10.2 driver API, but it would take quite a bit of
effort, way more than what removing 10.1 from the driver saves in my opinion.
The driver already separates firmware specific logic pretty well, so I don't think
it should be a huge maintenance effort to keep 10.1 support in the driver.

Maybe you could delete the 10.2 (not 10.2.4) firmware support and gain some space that way?  I
doubt anyone is using that productively....

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

