Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1878 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667Ab1GLPUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 11:20:40 -0400
Message-ID: <4E1C6645.8060302@gnu.org> (sfid-20110712_172043_016939_EDD794A5)
Date: Tue, 12 Jul 2011 11:20:37 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Sven Neumann <s.neumann@raumfeld.com>
CC: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: kernel NULL pointer dereference in lbs_set_11d_domain_info (3.0-rc6)
References: <1310399981.11331.4.camel@sven>  <4E1B655E.6010209@gnu.org> <1310455326.2218.1.camel@sven>
In-Reply-To: <1310455326.2218.1.camel@sven>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2011 03:22 AM, Sven Neumann wrote:
> On Mon, 2011-07-11 at 17:04 -0400, Pavel Roskin wrote:
>> On 07/11/2011 11:59 AM, Sven Neumann wrote:
>>> Hi,
>>>
>>> we are using a PXA device and I am observing sporadic crashes after
>>> resume from suspend with 3.0-rc6:
>>>
>>>
>>> [ 1296.027645] PM: resume of devices complete after 296.440 msecs
>>> [ 1296.284633] Restarting tasks ...
>>> [ 1296.320276] done.
>>> [ 1296.421618] mmc0: new SDIO card at address 0001
>>> [ 1297.312570] libertas_sdio mmc0:0001:1: (unregistered net_device): 00:19:88:11:db:67, fw 9.70.7p0, cap 0x00000303
>>
>> I think the trouble starts with "unregistered net_device".  It looks
>> like some structures in memory are corrupted.
>
> I don't think that is the problem. The output from booting the kernel
> says "unregistered net_device" as well:
>
> [    9.236512] libertas_sdio: Libertas SDIO driver
> [    9.245261] libertas_sdio: Copyright Pierre Ossman
> [    9.762777] libertas_sdio mmc0:0001:1: (unregistered net_device):
> 00:19:88:11:db:67, fw 9.70.7p0, cap 0x00000303
> [    9.792377] libertas_sdio mmc0:0001:1: wlan0: Marvell WLAN 802.11
> adapter

Oh well.  Then you need to add some tracing to 
lbs_set_11d_domain_info().  I do it the old way.  I put this macro to 
the beginning of the file:

#define MARK printk("%s:%d %s()\n", __FILE__, __LINE__, __func__);

And then I add "MARK" to every second line, as long as it's permitted 
syntactically.  I may skip adding MARK where failures are unlikely, such 
as initialization of local variables.  Once you find the line where 
printing stops, print all variables used on that line.

I would also print the arguments as pointers in the beginning.  Maybe 
they are corrupt.

-- 
Regards,
Pavel Roskin
