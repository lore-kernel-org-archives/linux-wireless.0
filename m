Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30841 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1KGVDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 16:03:16 -0500
Message-ID: <4EB84748.7090302@qca.qualcomm.com> (sfid-20111107_220322_383972_5EADA23A)
Date: Mon, 7 Nov 2011 23:02:00 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/11] ath6kl: Add WOW support
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2011 07:25 AM, Raja Mani wrote:
> Version 2 patch set is tested on Qualcomm MSM board and 
> takes care most of the review comments given by Kalle.
> 
> V2 changes:
>  * WOW mode selection logic is moved to HIF layer, earlier it was implemented in CFG i/f layer.
>  * Individual parameters are used in the functions instead of struct as a parameter.
>  * Unused one extra byte is removed in struct wmi_add_wow_pattern_cmd.
>  * Used ar->state for WOW state handling and separate WOW state handling is removed. 
>  * host sdio irq wake up capability is checked before entering into WOW suspend mode. 
>  * Empty commit logs are avoided.  :-)
>  * No error is reported from Sparse.
>  * Rebased to multi vif implementation.
> 
>  and other minor corrections.
> 
> Using these patch set, WOW patterns can be controlled and configured via iw command. 
> Please refer iw help menu for more details.
> 
> Limitations:
>    * Optional bytes can't be specified while configuring WOW patterns from iw command.
>      This is due to the limitation in the firmware.
> 
>    * Pattern byte matching will always happen from the first byte of received packet. 
>      This is the limitation in the recent "iw" command (It doesn't take the pattern 
>      offset where to start pattern matching in the received packets as of now).

Thanks, patchset looks really good now. There were two things I didn't
like, the check_wow() call in RX path and locking for
ath6kl_wmi_relinquish_implicit_pstream_credits(). But we can fix those
later.

All 11 patches applied. I did a couple of minor changes, I'll send a
separate email describing those.

Kalle
