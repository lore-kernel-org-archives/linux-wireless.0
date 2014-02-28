Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22120 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaB1Hir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 02:38:47 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k:  support msdu chaining.
References: <1393550452-1302-1-git-send-email-greearb@candelatech.com>
Date: Fri, 28 Feb 2014 09:38:41 +0200
In-Reply-To: <1393550452-1302-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Thu, 27 Feb 2014 17:20:52
	-0800")
Message-ID: <87fvn3d6v2.fsf@kamboji.qca.qualcomm.com> (sfid-20140228_083851_196844_0E6B4B3C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Consolidate the list of msdu skbs into the msdu-head skb, delete the
> rest of the skbs, pass the msdu-head skb on up the stack as normal.
>
> Tested with high-speed TCP and UDP traffic on modified firmware that
> supports raw-rx.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> v2:  Add note about skb_try_coalesce, though I am not sure it will
>      work or not.
>      Only grow skb once, which should save on some memory (re)allocation
>      and copying when we have more than one chained skb.

I didn't look at the patch itself yet, but I see checkpatch warnings:

drivers/net/wireless/ath/ath10k/htt_rx.c:1022: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/htt_rx.c:1032: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/htt_rx.c:1044: WARNING: labels should not be indented
drivers/net/wireless/ath/ath10k/htt_rx.c:1053: WARNING: labels should not be indented

-- 
Kalle Valo
