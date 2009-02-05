Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42837 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753585AbZBEQ6g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 11:58:36 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Thu, 05 Feb 2009 17:58:34 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090205165834.63840@gmx.net> (sfid-20090205_175846_685735_8BFBCF9C)
MIME-Version: 1.0
Subject: [PATCH] mac80211: Remove TSF atomic requirement from the documentation
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The atomic requirement for the TSF callbacks
is outdated. get_tsf() is only called by
ieee80211_rx_bss_info() which is indirectly
called by the work queue ieee80211_sta_work().
In the same context are called several other
non-atomic functions, too.
And the atomic requirement causes problems
for drivers of USB wifi cards.

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff -urN wireless-testing.orig/include/net/mac80211.h wireless-testing=
/include/net/mac80211.h
--- wireless-testing.orig/include/net/mac80211.h	2009-02-05 06:14:21.00=
0000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-02-05 17:33:09.0000000=
00 +0100
@@ -1354,11 +1354,11 @@
  *
  * @get_tsf: Get the current TSF timer value from firmware/hardware. C=
urrently,
  *	this is only used for IBSS mode BSSID merging and debugging. Is not=
 a
- *	required function. Must be atomic.
+ *	required function.
  *
  * @set_tsf: Set the TSF timer to the specified value in the firmware/=
hardware.
  *      Currently, this is only used for IBSS mode debugging. Is not a
- *	required function. Must be atomic.
+ *	required function.
  *
  * @reset_tsf: Reset the TSF timer and allow firmware/hardware to sync=
hronize
  *	with other STAs in the IBSS. This is only used in IBSS mode. This

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
