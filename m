Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:48476 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbaH1EZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 00:25:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3] ath10k:  save firmware debug log messages.
References: <1409172214-24149-1-git-send-email-greearb@candelatech.com>
Date: Thu, 28 Aug 2014 07:25:17 +0300
In-Reply-To: <1409172214-24149-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 27 Aug 2014 13:43:34
	-0700")
Message-ID: <87lhq9utoy.fsf@kamboji.qca.qualcomm.com> (sfid-20140828_062545_167801_D6A58D13)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> They may be dumped through the firmware dump debugfs
> file.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> v3:  Re-worked byte-order related stuff again,
>    thanks to Michael's comments on IRC.
>    Fix problem reported by smatch, possible NPE.
>
>
> v2:  Remove some #ifdefs
>      rebase:  Fix logging, deal with byte-order differences
>        when reading firmware memory.
>
> Tested on x86-64.  smatch is clean, but it seems it cannot detect
> le v/s cpu endian issues on x86-64, so I could have easily missed
> something.

Yeah, sparse warns about endian stuff. But let me do a proper review
before sending a new version.

drivers/net/wireless/ath/ath10k/debug.c:830:34: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/debug.c:830:34:    expected unsigned int [unsigned] [usertype] next_idx
drivers/net/wireless/ath/ath10k/debug.c:830:34:    got restricted __le32 [usertype] <noident>
drivers/net/wireless/ath/ath10k/debug.c:831:35: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/debug.c:831:35:    expected unsigned int [unsigned] [usertype] first_idx
drivers/net/wireless/ath/ath10k/debug.c:831:35:    got restricted __le32 [usertype] <noident>

-- 
Kalle Valo
