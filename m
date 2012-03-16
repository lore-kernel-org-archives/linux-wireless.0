Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49787 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2CPShQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 14:37:16 -0400
Message-ID: <4F638859.8060809@candelatech.com> (sfid-20120316_193724_499940_B0F6CDB0)
Date: Fri, 16 Mar 2012 11:37:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k:  Support ethtool getstats api.
References: <1331853606-28434-1-git-send-email-greearb@candelatech.com> <1331853606-28434-4-git-send-email-greearb@candelatech.com> <4F6356E8.3050906@openwrt.org> <4F6368E9.2040007@candelatech.com> <4F636C07.7060202@openwrt.org> <4F636F81.9070804@candelatech.com> <4F637325.2020205@openwrt.org>
In-Reply-To: <4F637325.2020205@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/16/2012 10:06 AM, Felix Fietkau wrote:

>>> Most of the PHY error counters aren't even tracked by the hw, nothing in
>>> the driver enables their use.
>>
>> Well, any reason we cannot enable those?
> The hardware has a limited number of counter registers available for
> tracking PHY errors. Enabling PHY errors to be reported via DMA wastes
> tons of precious CPU cycles.

Am I correct in assuming that these are the only phy-errors that
the driver can currently report?

#define AR_PHY_ERR_DCHIRP      0x00000008
#define AR_PHY_ERR_RADAR       0x00000020
#define AR_PHY_ERR_OFDM_TIMING 0x00020000
#define AR_PHY_ERR_CCK_TIMING  0x02000000

With regard to DMA resources, do you mean that the
waste is in having the NIC receive the packets that
would otherwise be filtered?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

