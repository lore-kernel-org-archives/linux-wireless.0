Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35493 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbbDVWIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 18:08:23 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, mingo@kernel.org, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH v2 5/8] kernel/workqueue.c: remove ifdefs over wq_power_efficient
Date: Wed, 22 Apr 2015 14:55:08 -0700
Message-Id: <1429739711-9415-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20150423_000836_570046_D6A38BFE)
In-Reply-To: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
References: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We can avoid an ifdef over wq_power_efficient's declaration
by just using IS_ENABLED().

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cocci@systeme.lip6.fr
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/workqueue.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 586ad91..59bc249 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -280,12 +280,7 @@ static bool wq_disable_numa;
 module_param_named(disable_numa, wq_disable_numa, bool, 0444);
 
 /* see the comment above the definition of WQ_POWER_EFFICIENT */
-#ifdef CONFIG_WQ_POWER_EFFICIENT_DEFAULT
-static bool wq_power_efficient = true;
-#else
-static bool wq_power_efficient;
-#endif
-
+static bool wq_power_efficient = IS_ENABLED(CONFIG_WQ_POWER_EFFICIENT_DEFAULT);
 module_param_named(power_efficient, wq_power_efficient, bool, 0444);
 
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
-- 
2.3.2.209.gd67f9d5.dirty

