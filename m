Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38718 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab2CZNJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 09:09:43 -0400
Message-ID: <4F706A91.8010901@qca.qualcomm.com> (sfid-20120326_150946_730083_2B5A9C7A)
Date: Mon, 26 Mar 2012 16:09:37 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 1/2] ath6kl: Isolate host sleep mode config part from
 ath6kl_wow_suspend
References: <1332322418-16572-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1332322418-16572-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2012 11:33 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> The piece of code used in ath6kk_wow_suspend function
> to configure the host sleep mode is needed in deep sleep
> case also.
> 
> Moving that portion to a separate function called
> ath6kl_update_host_mode() would be helpful to avoid
> the duplication of the same code in deep sleep path.
> 
> There is no functional change.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, both patches applied.

But I did small changes to the first patch. I noticed that the inline
functions were only used in cfg80211.c so there was no need to have in
core.h. Also I fixed one long line.

Kalle
