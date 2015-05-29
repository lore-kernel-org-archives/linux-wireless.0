Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:38561 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161059AbbE2Qs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 12:48:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Add debugfs support to configure beacon tx mode
In-Reply-To: <1431594885-32346-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 14 May 2015 14:44:45 +0530")
References: <1431594885-32346-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Fri, 29 May 2015 19:48:43 +0300
Message-ID: <878uc7wcr8.fsf@kamboji.qca.qualcomm.com> (sfid-20150529_184907_752407_3504D26C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Introduce debugfs entry to select beacon tx mode to
> staggered or bursted mode. In staggered mode, software beacon
> alert will be evenly distributed for each beaconing interfaces
> by (beacon intval / number of vif). In bursted mode, batch of
> beacons will be sent out as batch at beacon interval.
>
> By default, staggered mode is selected.
>
> To select bursted mode
>
> echo 1 > /sys/kernel/debug/ieee80211/phyX/ath10k/beacon_tx_mode
>
> For staggered mode,
>
> echo 0 > /sys/kernel/debug/ieee80211/phyX/ath10k/beacon_tx_mode
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

In my opinion this should be configured via nl80211, not from debugfs.

-- 
Kalle Valo
