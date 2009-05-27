Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:53988 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755968AbZE0IKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 04:10:40 -0400
Date: Wed, 27 May 2009 10:12:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wireless/p54: prepare for FIRMWARE_NAME_MAX removal
Message-ID: <20090527081249.GA3777@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

We're going to remove the FIRMWARE_NAME_MAX definition in order to avoid any
firmware name length restriction.
This patch gets rid of the statically allocated p54usb firmware string, and
replaces them with const char pointers.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/p54/p54usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: iwm-2.6/drivers/net/wireless/p54/p54usb.c
===================================================================
--- iwm-2.6.orig/drivers/net/wireless/p54/p54usb.c	2009-05-27 09:52:58.000000000 +0200
+++ iwm-2.6/drivers/net/wireless/p54/p54usb.c	2009-05-27 09:53:29.000000000 +0200
@@ -84,8 +84,8 @@ MODULE_DEVICE_TABLE(usb, p54u_table);
 static const struct {
 	u32 intf;
 	enum p54u_hw_type type;
-	char fw[FIRMWARE_NAME_MAX];
-	char fw_legacy[FIRMWARE_NAME_MAX];
+	const char *fw;
+	const char *fw_legacy;
 	char hw[20];
 } p54u_fwlist[__NUM_P54U_HWTYPES] = {
 	{
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
