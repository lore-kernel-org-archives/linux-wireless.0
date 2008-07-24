Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:37064 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYGXQVY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 12:21:24 -0400
Received: from [205.233.55.237] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1KM3ZB-0006Su-Dd
	for linux-wireless@vger.kernel.org; Thu, 24 Jul 2008 12:21:21 -0400
Date: Thu, 24 Jul 2008 12:20:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] WIRELESS: Make wireless one-click selectable.
Message-ID: <alpine.LFD.1.10.0807241218170.7169@localhost.localdomain> (sfid-20080724_182129_448833_6C68C072)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Use "menuconfig" to make wireless support one-click selectable.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  revised from earlier patch so that wireless defaults to "y".

diff --git a/net/Kconfig b/net/Kconfig
index b986687..d05029b 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -239,14 +239,18 @@ source "net/rxrpc/Kconfig"
 config FIB_RULES
 	bool

-menu "Wireless"
+menuconfig WIRELESS
+	bool "Wireless"
 	depends on !S390
+	default y
+
+if WIRELESS

 source "net/wireless/Kconfig"
 source "net/mac80211/Kconfig"
 source "net/ieee80211/Kconfig"

-endmenu
+endif # WIRELESS

 source "net/rfkill/Kconfig"
 source "net/9p/Kconfig"

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
