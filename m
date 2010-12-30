Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:56986 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342Ab0L3VsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 16:48:07 -0500
Received: from outgoing.mit.edu (OUTGOING-AUTH.MIT.EDU [18.7.22.103])
	by mailhub-auth-1.mit.edu (8.13.8/8.9.2) with ESMTP id oBULh15T027460
	for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 16:43:01 -0500
Received: from dpward-laptop.wardengineers.homeip.nethsd1.tn.comcast.net. (c-76-127-58-202.hsd1.ga.comcast.net [76.127.58.202])
	(authenticated bits=0)
        (User authenticated as dpward@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.13.6/8.12.4) with ESMTP id oBULgths008027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 16:43:00 -0500 (EST)
From: David Ward <david.ward@ll.mit.edu>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-wireless: fix driver-select for iwl3945/iwlagn
Date: Thu, 30 Dec 2010 16:42:55 -0500
Message-Id: <1293745375-29775-1-git-send-email-david.ward@ll.mit.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iwl3945/iwlagn drivers were never built when choosing the "intel"
or "iwlwifi" options with the driver-select script. (Note that this
currently affects all stable releases of compat-wireless as well.)

Signed-off-by: David Ward <david.ward@ll.mit.edu>
---
 scripts/driver-select |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/driver-select b/scripts/driver-select
index 3989b9f..0d5a38b 100755
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -318,13 +318,13 @@ case $1 in
 		disable_var_01
 		;;
 	intel)
-		select_drivers		CONFIG_IWLWIFI \
+		select_drivers		CONFIG_COMPAT_IWLWIFI \
 					CONFIG_IPW
 		disable_staging
 		disable_var
 		;;
 	iwlwifi)
-		select_driver		CONFIG_IWLWIFI
+		select_driver		CONFIG_COMPAT_IWLWIFI
 		disable_staging
 		disable_var_01
 		;;
-- 
1.7.1

