Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935724Ab1JFJPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 05:15:49 -0400
Subject: [PATCH] compat: make driver-select only select complete lines
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 11:15:45 +0200
Message-ID: <1317892545.3945.2.camel@jlt3.sipsolutions.net> (sfid-20111006_111610_086085_32126AFA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Otherwise we end up enabling CONFIG_FOOBAR if
only CONFIG_FOO is requested.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
--- a/scripts/driver-select
+++ b/scripts/driver-select
@@ -88,7 +88,7 @@ function disable_makefile
 function select_driver 
 {
 	backup_file $DRIVERS_MAKEFILE
-	perl -i -ne 'print if /'$1'/ ' $DRIVERS_MAKEFILE
+	perl -i -ne 'print if /'$1'\)/ ' $DRIVERS_MAKEFILE
 }
 
 function select_drivers


