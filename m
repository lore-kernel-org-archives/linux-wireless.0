Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60011 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbaEPOh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 10:37:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	<87k39n89jm.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 16 May 2014 17:37:23 +0300
In-Reply-To: <87k39n89jm.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Thu, 15 May 2014 16:18:37 +0300")
Message-ID: <87tx8p3i3g.fsf@kamboji.qca.qualcomm.com> (sfid-20140516_163742_537027_5AB58BFD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This makes sure no further tx requests are
>> submitted to HTT before driver teardown.
>>
>> This should prevent invalid pointer/NULL
>> dereference on htt tx pool in ath10k_htt_tx() in
>> some cases of heavy traffic.
>>
>> Reported-By: Ben Greear <greearb@candelatech.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> For some reason I'm not receiving buildbot emails anymore, but I noticed
> via the kbuild-all archives that this patch has a warning:
>
>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_drain_tx':
>>> drivers/net/wireless/ath/ath10k/mac.c:2442:2: error: implicit
> declaration of function 'lockdep_is_held'
> [-Werror=implicit-function-declaration]
>
> https://lists.01.org/pipermail/kbuild-all/2014-May/004387.html

I fixed it with this:

--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -19,6 +19,7 @@
 
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
+#include <linux/lockdep.h>
 
 #include "hif.h"
 #include "core.h"

Let's see if buildbot is happier now.

-- 
Kalle Valo
