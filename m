Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42718 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKDVdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 16:33:38 -0500
Message-ID: <54594631.9020707@candelatech.com> (sfid-20141104_223341_330635_A3CE0954)
Date: Tue, 04 Nov 2014 13:33:37 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rmanohar@qti.qualcomm.com
Subject: Re: 3.17 regression, ath9k: Summarize hw state per channel context
References: <542F124C.50406@candelatech.com>
In-Reply-To: <542F124C.50406@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2014 02:17 PM, Ben Greear wrote:
> Took a while, but I found the regression that has been bugging me.

[snip]

Ok, so I started looking at this problem.  The bug appears to lie in
the calculating of the BSSID mask.  I think the BSSID calculation must
be broken any time you have vifs in more than one ctx.

The reason is that ath9k_calculate_iter_data is now called per
ctx, but the bssid mask must be per radio, not per ctxt.

Maybe we need two different iter methods now..one similar to the new
one for ctx related summary state, and one like the older code for
the bssid mask?

Thanks,
Ben

> Bisect points at this patch:
> 
> 9a9c4fbc3fcabc0d510600743204f890ebdbb141 is the first bad commit
> commit 9a9c4fbc3fcabc0d510600743204f890ebdbb141
> Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> Date:   Wed Jun 11 16:18:03 2014 +0530
> 
>     ath9k: Summarize hw state per channel context
> 
>     Group and set hw state (opmode, primary_sta, beacon conf) per
>     channel context instead of whole list of vifs. This would allow
>     each channel context to run in different mode (STA/AP).
> 
>     Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>     Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> :040000 040000 aa6eab9d17a0b3468075ff7c1abfee2ccfcb521e e15af8b46ce047c8b46177e2d4cf74a4590a2181 M	drivers
> 
> I will be happy to test patches if anyone has a suggested fix or needs
> debug output...
> 
> Thanks,
> Ben
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

