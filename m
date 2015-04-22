Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35417 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbbDVWMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 18:12:43 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, mingo@kernel.org, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 7/8] kernel/module.c: avoid ifdefs for sig_enforce declaration
Date: Wed, 22 Apr 2015 14:55:10 -0700
Message-Id: <1429739711-9415-8-git-send-email-mcgrof@do-not-panic.com> (sfid-20150423_001246_920015_A8FDB04F)
In-Reply-To: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
References: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

There's no need to require an ifdef over the declaration
of sig_enforce as IS_ENABLED() can be used. While at it,
there's no harm in exposing this kernel parameter outside of
CONFIG_MODULE_SIG as it'd be a no-op on non module sig
kernels.

Now, technically we should in theory be able to remove
the #ifdef'ery over the declaration of the module parameter
as we are also trusting the bool_enable_only code for
CONFIG_MODULE_SIG kernels but for now remain paranoid
and keep it.

With time if no one can put a bullet through bool_enable_only
and if there are no technical requirements over not exposing
CONFIG_MODULE_SIG_FORCE with the measures in place by
bool_enable_only we could remove this last ifdef.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cocci@systeme.lip6.fr
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/module.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 43a1ef3..9e51b37 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -105,15 +105,10 @@ static LIST_HEAD(modules);
 struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 #endif /* CONFIG_KGDB_KDB */
 
-#ifdef CONFIG_MODULE_SIG
-#ifdef CONFIG_MODULE_SIG_FORCE
-static bool sig_enforce = true;
-#else
-static bool sig_enforce = false;
-
+static bool sig_enforce = IS_ENABLED(CONFIG_MODULE_SIG_FORCE);
+#ifndef CONFIG_MODULE_SIG_FORCE
 module_param(sig_enforce, bool_enable_only, 0644);
 #endif /* !CONFIG_MODULE_SIG_FORCE */
-#endif /* CONFIG_MODULE_SIG */
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
-- 
2.3.2.209.gd67f9d5.dirty

