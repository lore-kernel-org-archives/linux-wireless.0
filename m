Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35737 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab0INSGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 14:06:18 -0400
Message-ID: <4C8FB999.1020200@openwrt.org>
Date: Tue, 14 Sep 2010 20:06:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: fix BSSID mask calculation
References: <1284482240-57922-1-git-send-email-nbd@openwrt.org> <4C8FB1DA.5090209@candelatech.com> <4C8FB621.1060608@openwrt.org> <4C8FB81A.7090007@candelatech.com>
In-Reply-To: <4C8FB81A.7090007@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-14 7:59 PM, Ben Greear wrote:
> It seems I saw this code over-write the mask with a bad value
> when debugging this a few days ago..but perhaps I was mistaken,
> or perhaps your patch fixes this already.
> 
> 	/* configure bssid mask */
> 	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
> 		ath_hw_setbssidmask(common);
> 
> My plan was to have it call ath9k_set_bssid_mask(common->hw) instead.
Not necessary. The bssid mask only needs to be recalculated when
interfaces are brought up (and maybe when they are brought down, but
that's less important).
The code here only needs to apply the precalculated mask to the hardware.

> Were you able to create multiple STA interfaces and have them
> send/receive data with your patch?
I did not test that, but I suspect that my changes help there as well.

- Felix
