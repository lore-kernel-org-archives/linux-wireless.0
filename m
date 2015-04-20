Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34914 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbDTXbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 19:31:22 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v1 2/6] kernel/module.c: use generic module param operaters for sig_enforce
Date: Mon, 20 Apr 2015 16:30:33 -0700
Message-Id: <1429572637-30234-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20150421_013233_832745_F6F31600)
In-Reply-To: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com>
References: <1429572637-30234-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

We're directly checking and modifying sig_enforce when needed instead
of using the generic helpers. This prevents us from generalizing this
helper so that others can use it. Use indirect helpers to allow us
to generalize this code a bit and to make it a bit more clear what
this is doing.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: cocci@systeme.lip6.fr
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/module.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 42a1d2a..de12c4a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -114,23 +114,25 @@ static bool sig_enforce = false;
 static int param_set_bool_enable_only(const char *val,
 				      const struct kernel_param *kp)
 {
-	int err;
-	bool test;
+	int err = 0;
+	bool new_value;
+	bool orig_value = *(bool *)kp->arg;
 	struct kernel_param dummy_kp = *kp;
 
-	dummy_kp.arg = &test;
+	dummy_kp.arg = &new_value;
 
 	err = param_set_bool(val, &dummy_kp);
 	if (err)
 		return err;
 
 	/* Don't let them unset it once it's set! */
-	if (!test && sig_enforce)
+	if (!new_value && orig_value)
 		return -EROFS;
 
-	if (test)
-		sig_enforce = true;
-	return 0;
+	if (new_value)
+		err = param_set_bool(val, kp);
+
+	return err;
 }
 
 static const struct kernel_param_ops param_ops_bool_enable_only = {
-- 
2.3.2.209.gd67f9d5.dirty

