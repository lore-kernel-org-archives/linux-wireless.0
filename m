Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:60616 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703Ab2LQMMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 07:12:25 -0500
Message-ID: <50CF0C21.60101@posedge.com> (sfid-20121217_131228_995263_39C42C95)
Date: Mon, 17 Dec 2012 17:42:17 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: John Johansen <john.johansen@canonical.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] Apparamor: Fix the OOPS due to wrong header inclusion in
 file in Makefile(3.7.0-rc1 Kernel)
References: <201212171158.qBHBwYni003158@chaitanya-desktop>
In-Reply-To: <201212171158.qBHBwYni003158@chaitanya-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Fix the OOPS in the apparmor security module
during the bootup.(oops points to strlen in audit_log_untrustedstring function)
Note: Actual fix lifted from Al-Viro.
 
Signed-off-by: Chaitanya T K <chaitanyatk@posedge.com>
---
 security/apparmor/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
index 7b3021c..5706b74 100644
--- a/security/apparmor/Makefile
+++ b/security/apparmor/Makefile
@@ -57,7 +57,7 @@ cmd_make-rlim = echo "static const char *const rlim_names[RLIM_NLIMITS] = {" \
 
 $(obj)/capability.o : $(obj)/capability_names.h
 $(obj)/resource.o : $(obj)/rlim_names.h
-$(obj)/capability_names.h : $(srctree)/include/linux/capability.h \
+$(obj)/capability_names.h : $(srctree)/include/uapi/linux/capability.h \
 			    $(src)/Makefile
 	$(call cmd,make-caps)
 $(obj)/rlim_names.h : $(srctree)/include/uapi/asm-generic/resource.h \




