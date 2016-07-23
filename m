Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34933 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbcGWVzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2016 17:55:39 -0400
Message-ID: <5793E7D9.60707@candelatech.com> (sfid-20160723_235546_975472_4EAC19FC)
Date: Sat, 23 Jul 2016 14:55:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath10k: fix system hang at qca99x0 probe on x86 platform
References: <20160614061728.570-1-rmanohar@qti.qualcomm.com> <5792A189.5050807@candelatech.com> <6495e664-5da8-a11b-0bd5-15dc24c51edf@dd-wrt.com>
In-Reply-To: <6495e664-5da8-a11b-0bd5-15dc24c51edf@dd-wrt.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/23/2016 02:11 AM, Sebastian Gottschall wrote:
> from my point of view this patch is just shit. it trunkates the maximum allocated memory to a certain value.
> so firmware requests 800 kb memory but just gets 256kb. so out of bound memory access is guaranteed at all.

At least some of the firmware logic attempts to deal with this segmentation.  9984 firmware had bugs in one area that I fixed,
but probably there are other bugs and that is why it fails for 9980 firmware.

Even if I fix my firmware, that doesn't help everyone else with stock firmware.

At best, maybe enable this type of logic for only exact firmware with proper feature
flag showing that it is known to work with it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
