Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35528 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934099AbbDVWOy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 18:14:54 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au
Cc: akpm@linux-foundation.org, mingo@kernel.org, tj@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 8/8] kernel/module.c: use module_param_config_on() for sig_enforce
Date: Wed, 22 Apr 2015 14:55:11 -0700
Message-Id: <1429739711-9415-9-git-send-email-mcgrof@do-not-panic.com> (sfid-20150423_001514_508001_A272E3D9)
In-Reply-To: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
References: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cocci@systeme.lip6.fr
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index 9e51b37..3a61e25 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -107,7 +107,7 @@ struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 
 static bool sig_enforce = IS_ENABLED(CONFIG_MODULE_SIG_FORCE);
 #ifndef CONFIG_MODULE_SIG_FORCE
-module_param(sig_enforce, bool_enable_only, 0644);
+module_param_config_on(sig_enforce, sig_enforce, 0644, CONFIG_MODULE_SIG_FORCE);
 #endif /* !CONFIG_MODULE_SIG_FORCE */
 
 /* Block module loading/unloading? */
-- 
2.3.2.209.gd67f9d5.dirty

