Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47018 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaIOFLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:11:22 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so3440242wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:11:20 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/12] iwlwifi: dvm: disable power save by default
Date: Mon, 15 Sep 2014 08:10:46 +0300
Message-Id: <1410757848-1827-10-git-send-email-egrumbach@gmail.com> (sfid-20140915_071134_168749_11E1C336)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
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

