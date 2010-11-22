Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35622 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab0KVXmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 18:42:53 -0500
Message-ID: <4CEAFFF0.3020401@candelatech.com>
Date: Mon, 22 Nov 2010 15:42:40 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 2/3] ath9k: fix timeout on stopping rx dma
References: <1290218928-87475-1-git-send-email-nbd@openwrt.org> <1290218928-87475-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290218928-87475-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2010 06:08 PM, Felix Fietkau wrote:
> It seems that using ath9k_hw_stoppcurecv to stop rx dma is not enough.
> When it's time to stop DMA, the PCU is still busy, so the rx enable
> bit never clears.
> Using ath9k_hw_abortpcurecv helps with getting rx stopped much faster,
> with this change, I cannot reproduce the rx stop related WARN_ON anymore.

I have done some more testing, and several times it rebooted and
properly configured the 30 STAs & passed traffic without error.

So, it appears your change is definitely an improvement.

I did see one time earlier today when it still failed to stop,
however.  Would it be worth attempting the abort and/or stop
hardware calls several times if it fails the first time?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

