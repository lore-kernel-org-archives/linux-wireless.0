Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta1.parkeon.com ([91.121.43.66]:41301 "EHLO mta1.parkeon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab3DOMzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 08:55:47 -0400
Message-ID: <516BF8D0.5070401@parkeon.com> (sfid-20130415_145553_301607_D9E88FB7)
Date: Mon, 15 Apr 2013 14:55:44 +0200
From: Martin Fuzzey <mfuzzey@parkeon.com>
Reply-To: mfuzzey@parkeon.com
MIME-Version: 1.0
To: Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware problems with Lesswire Wibear  11n module using mwifiex
References: <5155BF92.2020704@parkeon.com> <477F20668A386D41ADCC57781B1F70430D9DCBF173@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DCBF173@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

Thanks for your reply.
On 29/03/13 22:32, Bing Zhao wrote:
> Hi Martin,
>
>> [ 2210.066680] mwifiex_sdio mmc1:0001:1: WLAN FW is active
>> [ 2220.083880] mwifiex_sdio mmc1:0001:1: mwifiex_cmd_timeout_func:
>> Timeout cmd id (1584563353.27844) = 0xa9, act = 0x0
>>
>> This shows that there is no reply to the first command sent in
>> mwifiex_sta_init_cmd()
> There is a possibility that the firmware has responded to this command but the SDIO interrupt gets stuck somewhere.
>
> Are you able to hook up an oscilloscope to check whether SDIO DAT1 pin stays low or not?
Indeed,

DAT1 goes low after the command is sent and stays low until the card is 
reset.

No SDIO interrupts are received by the host controller (i.MX53)

So it looks like a host controller issue - right?

Regards,

Martin

