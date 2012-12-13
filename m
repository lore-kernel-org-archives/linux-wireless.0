Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:48303 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab2LMNNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 08:13:21 -0500
Message-ID: <50C9D469.8010809@posedge.com> (sfid-20121213_141324_757275_7A9C2FA8)
Date: Thu, 13 Dec 2012 18:43:13 +0530
From: Chaitanya <chaitanyatk@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	viro@parcelfarce.linux.theplanet.co.uk
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: apparmor: Strlen oops in 3.7.0-rc1 (mac80211-next)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes/Al Viro,

Can you submit the below patch?

When moved to mac80211-next kernel was facing the crash related to strlen failure in the audit module.
After some searching found a fix from Al Viro (http://lkml.indiana.edu/hypermail/linux/kernel/1210.2/01060.html) .

This is recurrent.
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

Regards,
Chaitanya T K.
