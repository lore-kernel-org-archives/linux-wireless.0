Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30249 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1LBKr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 05:47:28 -0500
Date: Fri, 2 Dec 2011 16:17:11 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Inform bss information to cfg80211 before
 connect event
Message-ID: <20111202104709.GB28660@chvasanth-lnx> (sfid-20111202_114732_551113_3DF38EFE)
References: <1322818619-29265-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1322818619-29265-1-git-send-email-vthiagar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 02, 2011 at 03:06:59PM +0530, Vasanthakumar Thiagarajan wrote:
> This is already done but only when bss entry is not availabe
> or aged out. Not updating the bss information when that bss
> is available creates a case where there is a bss entry when
> checked in ath6kl_cfg80211_connect_event() but it got aged out
> by the time cfg80211 checks for the bss entry in __cfg80211_roamed().
> This results in the following warning and the failure to notify
> roaming event to application. To fix this, update the bss information
> for which a romaing event is received. Also renamed ath6kl_add_bss_if_needed()
> to ath6kl_inform_bss().
> 
> [158645.538384] WARNING: at net/wireless/sme.c:586
> __cfg80211_roamed+0xc2/0x1b1()
> [158645.538810] Call Trace:
> [158645.538838]  [<c1033527>] warn_slowpath_common+0x65/0x7a
> [158645.538917]  [<c14cfacf>] ? __cfg80211_roamed+0xc2/0x1b1
> [158645.538946]  [<c103354b>] warn_slowpath_null+0xf/0x13
> [158645.539055]  [<c14cfacf>] __cfg80211_roamed+0xc2/0x1b1
> [158645.539086]  [<c14beb5b>] cfg80211_process_rdev_events+0x153/0x1cc
> [158645.539166]  [<c14bd57b>] cfg80211_event_work+0x26/0x36
> [158645.539195]  [<c10482ae>] process_one_work+0x219/0x38b
> [158645.539273]  [<c14bd555>] ? wiphy_new+0x419/0x419
> [158645.539301]  [<c10486cb>] worker_thread+0xf6/0x1bf
> [158645.539379]  [<c10485d5>] ? rescuer_thread+0x1b5/0x1b5
> [158645.539407]  [<c104b3e2>] kthread+0x62/0x67
> [158645.539484]  [<c104b380>] ? __init_kthread_worker+0x42/0x42
> [158645.539514]  [<c151309a>] kernel_thread_helper+0x6/0xd
> 
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Please drop this patch, this needs more work.

Vasanth
