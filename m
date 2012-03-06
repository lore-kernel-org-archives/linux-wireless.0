Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20876 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab2CFQMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 11:12:43 -0500
Message-ID: <4F563776.8090000@qca.qualcomm.com> (sfid-20120306_171247_907519_8320F5D1)
Date: Tue, 6 Mar 2012 18:12:38 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: Add provision to define suspend policy in
 disconnected state.
References: <1331026439-7822-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1331026439-7822-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2012 11:33 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> It gives flexibility to the user to define suspend policy
> when the suspend mode is set to WOW and the device is in
> disconnected state at the time of suspend.
> 
> New module parameter wow_mode is added to get the choice
> from the user. This parameter is valid only if the module
> parameter suspend_mode is set to WOW.
> 
> To force WOW in connected state and cut power
> in disconnected state:
>   suspend_mode=0x3 wow_mode=0x1
> 
> To force WOW in connected state and deep sleep
> in disconnected state:
>    suspend_mode=0x3 wow_mode=0x2
> 
> If there is no value specified to wow_mode during insmod,
> deep sleep mode will be tried in the disconnected state.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

[...]

> +		if (ret && (!ar->wow_suspend_mode ||
> +		    ar->wow_suspend_mode == WLAN_POWER_STATE_DEEP_SLEEP))
> +				try_deepsleep = true;

I don't get this part. If the wow_mode parameter is set to 0 or 2 the
functionality is the same, right? So what's the point with 0x2 the
commit log? Deep sleep will be the default in disconnected anyway.
Unless I misunderstood something, of course.

Kalle
