Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55993 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0KDNgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 09:36:15 -0400
Received: by fxm16 with SMTP id 16so1422572fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 06:36:13 -0700 (PDT)
Message-ID: <4CD2B6E9.9080303@lwfinger.net>
Date: Thu, 04 Nov 2010 08:36:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Question about wireless configuration
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to test the latest Realtek driver for the RTL8187L. In order for the
driver to be able to scan, CONFIG_WIRELESS_EXT must be set to "y". I could find
no way to do that with the kernel configuration utilities until I made the
following patch. I know it is wrong, but I would like to know the correct way.

Thanks,

Larry



diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index d0ee290..c50af61 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,5 +1,5 @@
 config WIRELESS_EXT
-       bool
+       def_bool y

 config WEXT_CORE
        def_bool y
