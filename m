Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55663 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549AbaGWRh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 13:37:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v4 1/5] ath10k:  provide firmware crash info via debugfs.
References: <1406133487-7541-1-git-send-email-greearb@candelatech.com>
Date: Wed, 23 Jul 2014 20:37:23 +0300
In-Reply-To: <1406133487-7541-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 23 Jul 2014 09:38:03
	-0700")
Message-ID: <87a980rn70.fsf@kamboji.qca.qualcomm.com> (sfid-20140723_193732_013007_051037C9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Store the firmware crash registers and last 128 or so
> firmware debug-log ids and present them to user-space
> via debugfs.
>
> Should help with figuring out why the firmware crashed.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> v4:  Use _bh spinlock variants everywhere.
>
> For patch 0005:  Fix kmalloc/vfree problem. 

I see quite a few sparse and checkpatch warnings. But I think we can
ignore about LINUX_VERSION_CODE.

drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_build_dump_file':
drivers/net/wireless/ath/ath10k/debug.c:685:2: warning: right shift count >= width of type [enabled by default]
drivers/net/wireless/ath/ath10k/debug.c:687:2: warning: right shift count >= width of type [enabled by default]
drivers/net/wireless/ath/ath10k/debug.c:685:49: warning: shift too big (32) for type long
drivers/net/wireless/ath/ath10k/debug.c:687:51: warning: shift too big (32) for type long
drivers/net/wireless/ath/ath10k/core.c:491:53: warning: cast to restricted __le32
drivers/net/wireless/ath/ath10k/core.c:492:52: warning: cast to restricted __le32
drivers/net/wireless/ath/ath10k/core.c:493:53: warning: cast to restricted __le32
drivers/net/wireless/ath/ath10k/core.c:494:52: warning: cast to restricted __le32
drivers/net/wireless/ath/ath10k/core.c:491: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/core.c:492: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/core.c:493: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/core.c:494: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/core.c:495: CHECK: multiple assignments should be avoided
drivers/net/wireless/ath/ath10k/debug.c:680: WARNING: LINUX_VERSION_CODE should be avoided, code should be for the version to which it is merged
drivers/net/wireless/ath/ath10k/debug.c:696: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/debug.c:703: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/debug.c:725: WARNING: line over 80 characters
drivers/net/wireless/ath/ath10k/debug.c:733: WARNING: line over 80 characters

-- 
Kalle Valo
