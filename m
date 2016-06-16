Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4136 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbcFPN5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 09:57:50 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k:  Fix mgmt tx status for 10.4.3 firmware.
Date: Thu, 16 Jun 2016 13:57:43 +0000
Message-ID: <87shwdw815.fsf@kamboji.qca.qualcomm.com> (sfid-20160616_155754_444705_ED39F77C)
References: <1456782654-24723-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1456782654-24723-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 29 Feb 2016 13:50:54	-0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> When testing a 10.4.3 firmware in station mode, I notice that
> when the AP is powered down, the ath10k does not notice AP is gone
> because mgt frames get tx status of 3, which is not handled.
>
> It appears that status 3 means something similar to failed-retry.
>
> Treating it thus lets the station disconnect properly.
>
> Tested against a non-stock 10.4.3 firmware, but likely upstream
> firmware acts similarly in this case.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> This patch is against a heavily patched tree based on 4.4, hopefully
> it can be applied to upstream code w/out too much trouble.
>
> Someone should verify this on stock 10.4-ish firmware before applying.

Has anyone tested this with stock driver and stock firmware?

Full patch here:

https://patchwork.kernel.org/patch/8460831/

-- 
Kalle Valo