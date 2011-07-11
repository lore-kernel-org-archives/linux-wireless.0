Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:57877 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab1GKVEb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 17:04:31 -0400
Message-ID: <4E1B655E.6010209@gnu.org> (sfid-20110711_230435_306844_151F40E2)
Date: Mon, 11 Jul 2011 17:04:30 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Sven Neumann <s.neumann@raumfeld.com>
CC: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: kernel NULL pointer dereference in lbs_set_11d_domain_info (3.0-rc6)
References: <1310399981.11331.4.camel@sven>
In-Reply-To: <1310399981.11331.4.camel@sven>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2011 11:59 AM, Sven Neumann wrote:
> Hi,
>
> we are using a PXA device and I am observing sporadic crashes after
> resume from suspend with 3.0-rc6:
>
>
> [ 1296.027645] PM: resume of devices complete after 296.440 msecs
> [ 1296.284633] Restarting tasks ...
> [ 1296.320276] done.
> [ 1296.421618] mmc0: new SDIO card at address 0001
> [ 1297.312570] libertas_sdio mmc0:0001:1: (unregistered net_device): 00:19:88:11:db:67, fw 9.70.7p0, cap 0x00000303

I think the trouble starts with "unregistered net_device".  It looks 
like some structures in memory are corrupted.  Debugging that may be 
tricky.  I think the first step would be to print stack where that 
message is printed in lbs_update_hw_spec().  Also, add statements to 
print priv and priv->dev at that point.  You should be able to compare 
the pointers before and after the suspend.

Once you find what is corrupted, go up the stack and see where the 
corruption happens.

-- 
Regards,
Pavel Roskin
