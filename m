Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44945 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbbHIIlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 04:41:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the  wireless-drivers-next tree
References: <20150807131615.535d4c04@canb.auug.org.au>
Date: Sun, 09 Aug 2015 11:41:45 +0300
In-Reply-To: <20150807131615.535d4c04@canb.auug.org.au> (Stephen Rothwell's
	message of "Fri, 7 Aug 2015 13:16:15 +1000")
Message-ID: <8737zszwdy.fsf@kamboji.qca.qualcomm.com> (sfid-20150809_104219_346007_BAC891C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephen,

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> After merging the wireless-drivers-next tree, today's linux-next build
> (x86_64 allmodconfig) failed like this:
>
> drivers/net/wireless/ath/ath9k/debug_sta.c: In function 'read_file_node_aggr':
> drivers/net/wireless/ath/ath9k/debug_sta.c:54:25: error: 'struct ath_node' has no member named 'ac'
>   for (acno = 0, ac = &an->ac[acno];
>                          ^

[...]

> Caused by commits
>
>   592fa228f213 ("ath9k: remove struct ath_atx_ac")
>   d70d848a75fd ("ath9k: remove the sched field in struct ath_atx_tid")
>
> I have used the wireless-drivers-next tree from next-20150806 for today.

Sorry about that, the commit below should fix the issue. This seems to
be a frequent problem, I think I need to start running more extensive
build tests before applying wireless-drivers patches.

commit 12e035968191c05a574c9c20367cb3090bc7d99d
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Thu Aug 6 12:44:30 2015 +0200

    ath9k: fix build with CONFIG_ATH9K_STATION_STATISTICS=y
    
    kbuild bot reported that commit 592fa228f213 ("ath9k: remove struct
    ath_atx_ac") broke the build when CONFIG_ATH9K_STATION_STATISTICS is y.
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Fixes: 592fa228f213 ("ath9k: remove struct ath_atx_ac")
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>


-- 
Kalle Valo
