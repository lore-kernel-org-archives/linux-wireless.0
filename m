Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52811 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaIHQ4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2014 12:56:39 -0400
Received: by mail-wi0-f180.google.com with SMTP id ex7so3061165wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2014 09:56:38 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/12] iwlwifi: dvm: disable power save by default
Date: Mon,  8 Sep 2014 19:56:15 +0300
Message-Id: <1410195377-10075-10-git-send-email-egrumbach@gmail.com> (sfid-20140908_185645_444770_031F38CF)
In-Reply-To: <540DDF37.5030801@gmail.com>
References: <540DDF37.5030801@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In
https://bugzilla.kernel.org/show_bug.cgi?id=84031,
the submitter said that disabling power saving helped,
do just that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/power.c b/drivers/net/wireless/iwlwifi/dvm/power.c
index 760c45c..1513dbc 100644
--- a/drivers/net/wireless/iwlwifi/dvm/power.c
+++ b/drivers/net/wireless/iwlwifi/dvm/power.c
@@ -40,7 +40,7 @@
 #include "commands.h"
 #include "power.h"
 
-static bool force_cam;
+static bool force_cam = true;
 module_param(force_cam, bool, 0644);
 MODULE_PARM_DESC(force_cam, "force continuously aware mode (no power saving at all)");
 
-- 
1.9.1

