Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34040 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbbEFAsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 20:48:54 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v1 01/12] kernel/params.c: export param_ops_bool_enable_only
Date: Tue,  5 May 2015 17:44:19 -0700
Message-Id: <1430873070-7290-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_024930_334084_5E06ED59)
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This will grant access to this helper to code built as modules.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Kyle McMartin <kyle@kernel.org>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/params.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/params.c b/kernel/params.c
index a62dbf8..807f3d4 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -364,6 +364,7 @@ const struct kernel_param_ops param_ops_bool_enable_only = {
 	.set = param_set_bool_enable_only,
 	.get = param_get_bool,
 };
+EXPORT_SYMBOL_GPL(param_ops_bool_enable_only);
 
 /* This one must be bool. */
 int param_set_invbool(const char *val, const struct kernel_param *kp)
-- 
2.3.2.209.gd67f9d5.dirty

