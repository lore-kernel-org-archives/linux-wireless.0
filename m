Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:34956 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbYGXQFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 12:05:44 -0400
Received: from [205.233.55.237] (helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1KM3K2-0005Mg-8h
	for linux-wireless@vger.kernel.org; Thu, 24 Jul 2008 12:05:42 -0400
Date: Thu, 24 Jul 2008 12:03:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] WIRELESS:  Make wireless immediately deselectable.
Message-ID: <alpine.LFD.1.10.0807241201230.3685@localhost.localdomain> (sfid-20080724_180549_465562_591D7A10)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Use a "menuconfig" Kconfig directive to allow wireless support to be
one-click deselectable.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  this *looks* like it's a safe enhancement.

diff --git a/net/Kconfig b/net/Kconfig
index b986687..4e01cec 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -239,14 +239,17 @@ source "net/rxrpc/Kconfig"
 config FIB_RULES
 	bool

-menu "Wireless"
+menuconfig WIRELESS
+	bool "Wireless"
 	depends on !S390

+if WIRELESS
+
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
