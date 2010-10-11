Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43193 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab0JKTHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 15:07:12 -0400
Message-ID: <4CB3605D.1040509@candelatech.com>
Date: Mon, 11 Oct 2010 12:07:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless:  Support wiphy_renamed hook for drivers.
References: <1286822537-28756-1-git-send-email-greearb@candelatech.com>	 <1286822639.3634.84.camel@jlt3.sipsolutions.net> <1286822771.3634.85.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286822771.3634.85.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 11:46 AM, Johannes Berg wrote:
> I think you should just do this (untested):

>   void
> @@ -892,8 +889,8 @@ ath5k_debug_init_device(struct ath5k_sof
>   {
>   	sc->debug.level = ath5k_debug;
>
> -	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
> -				ath5k_global_debugfs);
> +	sc->debug.debugfs_phydir = debugfs_create_dir("ath5k",
> +				sc->hw->wiphy->debugfsdir);

This fails to work because sc->hw->wiphy->debugfsdir is null when this
method is called...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

