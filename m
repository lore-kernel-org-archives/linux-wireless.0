Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:24518 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbZKHTag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 14:30:36 -0500
Received: by fg-out-1718.google.com with SMTP id e12so954033fga.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 11:30:41 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 8 Nov 2009 14:30:41 -0500
Message-ID: <cb0375e10911081130k5d8f8347y999cf66a98e6898a@mail.gmail.com>
Subject: [PATCH] iwlcore: Allow runtime configuration of no_sleep_autoadjust
From: Andrew Lutomirski <andy@luto.us>
To: ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	reinette chatre <reinette.chatre@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Runtime adjustment of no_sleep_autoadjust seems fine, both looking at
the code and in practice.  This makes it easier to test.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
I've been running this patch (and twiddling the setting) for a couple
months now, and it seems to work fine.  I think it's a bit late for
2.6.32, even though it's pretty much impossible for this to cause any
regressions, but it would be nice to see it go in for 2.6.33 until
no_sleep_autoadjust goes away.

diff --git a/drivers/net/wireless/iwlwifi/iwl-power.c
b/drivers/net/wireless/iwlwifi/iwl-power.c
index 60be976..4eba1ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-power.c
+++ b/drivers/net/wireless/iwlwifi/iwl-power.c
@@ -54,7 +54,7 @@
  * adjusting ...
  */
 bool no_sleep_autoadjust = true;
-module_param(no_sleep_autoadjust, bool, S_IRUGO);
+module_param(no_sleep_autoadjust, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_sleep_autoadjust,
 		 "don't automatically adjust sleep level "
 		 "according to maximum network latency");
