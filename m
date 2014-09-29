Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38279 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaI2Jr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 05:47:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: add firmware crash counters
References: <20140929094214.12889.97523.stgit@potku.adurom.net>
Date: Mon, 29 Sep 2014 12:47:01 +0300
In-Reply-To: <20140929094214.12889.97523.stgit@potku.adurom.net> (Kalle Valo's
	message of "Mon, 29 Sep 2014 12:42:15 +0300")
Message-ID: <8761g63giy.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_114729_010005_63838C97)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Ben Greear <greearb@candelatech.com>
>
> kvalo: split into it's own patch, add debugfs file and add locking
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Oh, I forgot to add a commit log. I'm planning to add something like
this:

----------------------------------------------------------------------
Add three counters related to firmware crashes or resets.

Usage:

# cat /sys/kernel/debug/ieee80211/phy0/ath10k/fw_reset_stats 
fw_crash_counter                2
fw_warm_reset_counter           43
fw_cold_reset_counter           0
#

----------------------------------------------------------------------

Also I forgot to add the cover letter, here's the changelog for both
patches:

v2:

* remove unneeded ifdef from debug.c

* rebase on top of Michal's "ath10k: fix fw stats processing",
  dropping patch "ath10k: add helper method to grab debug stats"
  because it was not needed anymore

* remove ifdef from ath10k_ops with "#define foo NULL" hack

* hold mutex when reading pdev_stats in ath10k_debug_get_et_stats()

* move fw reset stats to struct ath10k::stats and add locking

* add fw_reset_stats debugfs file


-- 
Kalle Valo
