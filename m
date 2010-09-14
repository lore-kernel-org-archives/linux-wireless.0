Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32866 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0INTTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 15:19:06 -0400
Message-ID: <4C8FCA98.5080102@candelatech.com>
Date: Tue, 14 Sep 2010 12:18:48 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: fix BSSID mask calculation
References: <1284482240-57922-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1284482240-57922-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 09:37 AM, Felix Fietkau wrote:
> At the time the .add_interface driver op is called, the interface has not
> been marked as running yet, so ieee80211_iterate_active_interfaces will
> not pass it to the iterator function.
> Because of this, the calculated BSSID mask is wrong, which breaks multi-BSS
> operation.
>
> Additionally, the current way of comparing all addresses against each other
> is pointless, as the hardware only uses the hardware MAC address and the BSSID
> mask for matching the destination address, so all the address array
> reallocation is completely unnecessary.
>
> This patch simplifies the logic by setting the initial mask bytes to 0xff
> and removing all bits in the iterator call that don't match the hardware MAC
> address. It also calls the iterator for the vif that was passed to
> add_interface()
>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>

I tried this on top of Johannes' sta_info patch and my
ath9k rfilt patch, and I'm able to create two STAs that talk
to each other (for around 15 seconds after AP reboots, then
no luck).

The mask looks right to me, so I think my particular problem must
be elsewhere.  So, you can add:

Tested-by:  Ben Greear <greearb@candelatech.com>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

