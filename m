Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32837 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab1KMKak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Nov 2011 05:30:40 -0500
Message-ID: <4EBF9B9F.2000307@qca.qualcomm.com> (sfid-20111113_113043_552951_87B6364B)
Date: Sun, 13 Nov 2011 12:27:43 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix call trace while starting IBSS mode
References: <1320838343-5708-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1320838343-5708-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/2011 01:32 PM, Raja Mani wrote:
> When the connect event is received from the target in IBSS mode,
> cfg80211_ibss_joined() is called without informing BSS info to
> cfg80211 layer which internally hits the below WARN_ON message.
> 
> WARNING: at net/wireless/ibss.c:33 __cfg80211_ibss_joined+0x153/0x180 [cfg80211]()
> [..]
> [ 4916.845878] Call Trace:
> [ 4916.845889]  [<c10427d2>] warn_slowpath_common+0x72/0xa0
> [ 4916.845905]  [<f8bccc63>] ? __cfg80211_ibss_joined+0x153/0x180 [cfg80211]
> [ 4916.845918]  [<f8bccc63>] ? __cfg80211_ibss_joined+0x153/0x180 [cfg80211]
> [ 4916.845923]  [<c1042822>] warn_slowpath_null+0x22/0x30
> [ 4916.845934]  [<f8bccc63>] __cfg80211_ibss_joined+0x153/0x180 [cfg80211]
> [ 4916.845941]  [<c1025108>] ? default_spin_lock_flags+0x8/0x10
> [ 4916.845952]  [<f8bb7fcd>] cfg80211_process_rdev_events+0x19d/0x220 [cfg80211]
> [ 4916.845962]  [<f8bb669b>] cfg80211_event_work+0x2b/0x50 [cfg80211]
> [ 4916.845968]  [<c105aae6>] process_one_work+0x116/0x3c0
> [ 4916.845977]  [<f8bb6670>] ? cfg80211_get_dev_from_info+0x40/0x40 [cfg80211]
> [ 4916.845982]  [<c105cdf0>] worker_thread+0x140/0x3b0
> [ 4916.845986]  [<c105ccb0>] ? manage_workers+0x1f0/0x1f0
> [ 4916.845991]  [<c1060c64>] kthread+0x74/0x80
> [ 4916.845995]  [<c1060bf0>] ? kthread_worker_fn+0x160/0x160
> [ 4916.846001]  [<c14e7bbe>] kernel_thread_helper+0x6/0x10
> [ 4916.846005] ---[ end trace 769254924e409367 ]---
> 
> This patch make sures that BSS info is delivered via cfg80211_inform_bss()
> to cfg80211 in advance before intimating IBSS status to cfg80211.
> 
> In addition to this, one debug message is also added to know
> ad-hoc mode status (creator/joiner).
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Thanks, applied.

Kalle
