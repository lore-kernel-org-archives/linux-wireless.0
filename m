Received: from mail-out.aladdin-rd.ru (mail-out.aladdin-rd.ru [91.199.251.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7635327BF3;
	Wed, 11 Feb 2026 08:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.199.251.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770798984; cv=none; b=VgsEEr11JqcF0bNAsg3S5bGxBSrmxBWDg+jJuI94EDVK5W2TFeMkrQRg1H/x+Fm/SBpTL1hlkW4XlmVFc1pjG6/e5paN5Aq6jp24bVFgwuKa9XwiJR974Fqp1XezVE4qTz89oipSeU46/UWGDrsk8PDIIdhrPaHIkiCWdMqdjik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770798984; c=relaxed/simple;
	bh=BVz1bM74OvQl89TLWkaJ4OQ0Wr8i89XZCPW6Ug3O/nE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XPx1iJa+3ELwAUVftUvC4bY3porn/+1rKmWf6Pw3TVQOtlkJ4Xn9gieEbwdT/81XXuwEM+DDkJJHXYRHOOWymVPz+NiIH2+p1pLpAGjoFRBG9rS1vz9apVRfpJGo3cTGyTa0Klr4AfJp36UXpGB4P6CJ8tftf47H1wLsj4k3gCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aladdin.ru; spf=pass smtp.mailfrom=aladdin.ru; dkim=pass (2048-bit key) header.d=aladdin.ru header.i=@aladdin.ru header.b=w7P8aM9+; arc=none smtp.client-ip=91.199.251.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aladdin.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aladdin.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aladdin.ru header.i=@aladdin.ru header.b="w7P8aM9+"
DKIM-Signature: v=1; a=rsa-sha256; d=aladdin.ru; s=mail; c=simple/simple;
	t=1770798043; h=from:subject:to:date:message-id;
	bh=BVz1bM74OvQl89TLWkaJ4OQ0Wr8i89XZCPW6Ug3O/nE=;
	b=w7P8aM9+0IiwZZzVZ6jYrzR3vLpRtjxbizRF/7L2rUfq7+mZ4/uc7PWLzWxIACEUjDBTJ/MUIFR
	+6n4lM97qbvTsrssbCTcEZvu/zQ1t235XBtsc9QGVcAFe3qtVaQuPd9z0wi/XvK+otxo24quqbqY5
	2Rkc9IkzRAy/UKyfiwvOnvRE2hDZvIvtJgjViBdo1JanYMBYzjMdBnTkDd7L5MIdCK+tjSlvPgsjE
	ZJ03iFLazlwoz5J5vyV795+Vj1md1xLeSQG5Wnm+QEyl5tHDH4Qzj0pbl/GXR6pOs/qiaSpvfEgh7
	5JYNTGpKxXs7Qp9fwa/FjZKH1jDtJmAtKiYA==
From: Daniil Dulov <d.dulov@aladdin.ru>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Daniil Dulov <d.dulov@aladdin.ru>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>,
	<stable@vger.kernel.org>
Subject: [PATCH v2] wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()
Date: Wed, 11 Feb 2026 11:20:24 +0300
Message-ID: <20260211082024.1967588-1-d.dulov@aladdin.ru>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EXCH-2016-04.aladdin.ru (192.168.1.104) To
 EXCH-2016-01.aladdin.ru (192.168.1.101)

There is a use-after-free error in cfg80211_shutdown_all_interfaces found
by syzkaller:

BUG: KASAN: use-after-free in cfg80211_shutdown_all_interfaces+0x213/0x220
Read of size 8 at addr ffff888112a78d98 by task kworker/0:5/5326
CPU: 0 UID: 0 PID: 5326 Comm: kworker/0:5 Not tainted 6.19.0-rc2 #2 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Workqueue: events cfg80211_rfkill_block_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x116/0x1f0
 print_report+0xcd/0x630
 kasan_report+0xe0/0x110
 cfg80211_shutdown_all_interfaces+0x213/0x220
 cfg80211_rfkill_block_work+0x1e/0x30
 process_one_work+0x9cf/0x1b70
 worker_thread+0x6c8/0xf10
 kthread+0x3c5/0x780
 ret_from_fork+0x56d/0x700
 ret_from_fork_asm+0x1a/0x30
 </TASK>

The problem arises due to the rfkill_block work is not cancelled when wiphy
is being unregistered. In order to fix the issue cancel the corresponding
work in wiphy_unregister().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 1f87f7d3a3b4 ("cfg80211: add rfkill support")
Cc: stable@vger.kernel.org
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
---
v2: move cancel_work_sync() from cfg80211_dev_free() to wiphy_unregister()
as suggested by Johannes Berg <johannes@sipsolutions.net>
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9a420d627d3c..8628e0eefadc 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1214,6 +1214,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* this has nothing to do now but make sure it's gone */
 	cancel_work_sync(&rdev->wiphy_work);
 
+	cancel_work_sync(&rdev->rfkill_block);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
-- 
2.34.1

