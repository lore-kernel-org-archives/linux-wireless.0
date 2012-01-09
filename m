Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53003 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab2AITVy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 14:21:54 -0500
Message-ID: <4F0B3DF6.7000103@qca.qualcomm.com> (sfid-20120109_202158_643614_889BBF93)
Date: Mon, 9 Jan 2012 21:20:22 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/8] ath6kl: Rename modparam variable suspend_cutpower
 to suspend_mode
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com> <1326098182-9103-2-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1326098182-9103-2-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 10:36 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> suspend_cutpower was introduced to force cut power mode when
> system goes to suspend state. Now, generic module parameter
> is required to specify suspend mode including DEEP SLEEP and WOW
> while doing insmod. Renaming existing module parameter variable
> suspend_cutpower would be sufficient to meet this requirement.
> 
> suspend_mode can take any one of three suspend state,
>    1) cut power
>    2) deep sleep
>    3) wow
> 
> For invalid value other than above mode, cut power mode will be
> selected.
> 
> To avoid externing mod parameter suspend_mode, new variable
> ar->suspend_mode is added to have copy of mod param variable
> and will be in sdio.c in the following patches.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

I think this patch needs to be folded with something else, maybe with
patch 2?

Kalle
