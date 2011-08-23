Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57070 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1HWLgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:36:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: pm_qos_request_list was renamed to pm_qos_request
Date: Tue, 23 Aug 2011 13:36:06 +0200
Message-Id: <1314099366-5636-1-git-send-email-hauke@hauke-m.de> (sfid-20110823_133624_917491_FA38E56E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the following commit in linux-next pm_qos_request_list was renamed
to pm_qos_request:
commit b10ac0c24e4c618a99262ad47a1b0176f152883d
Author: Jean Pihet <j-pihet@ti.com>
Date:   Thu Aug 18 10:32:02 2011 +0200

    PM QoS: Minor clean-ups

Backporting it with a #define in compat did not worked as there is also
a function called pm_qos_request() and its name did not changed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/43-rename_pm_qos_request.patch |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 patches/43-rename_pm_qos_request.patch

diff --git a/patches/43-rename_pm_qos_request.patch b/patches/43-rename_pm_qos_request.patch
new file mode 100644
index 0000000..fce4337
--- /dev/null
+++ b/patches/43-rename_pm_qos_request.patch
@@ -0,0 +1,14 @@
+--- a/drivers/net/wireless/ipw2x00/ipw2100.c
++++ b/drivers/net/wireless/ipw2x00/ipw2100.c
+@@ -174,7 +174,11 @@ that only one external action is invoked
+ #define DRV_DESCRIPTION	"Intel(R) PRO/Wireless 2100 Network Driver"
+ #define DRV_COPYRIGHT	"Copyright(c) 2003-2006 Intel Corporation"
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0))
++static struct pm_qos_request_list ipw2100_pm_qos_req;
++#else
+ static struct pm_qos_request ipw2100_pm_qos_req;
++#endif
+ 
+ /* Debugging stuff */
+ #ifdef CONFIG_IPW2100_DEBUG
-- 
1.7.4.1

