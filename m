Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:8609 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYJ2Q2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 12:28:53 -0400
Received: by ey-out-2122.google.com with SMTP id 6so35864eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 09:28:51 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 4/5] rt2x00: Fix build error when mac80211=M rt2x00=Y
Date: Wed, 29 Oct 2008 17:19:08 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200810291716.47342.IvDoorn@gmail.com> <200810291718.22724.IvDoorn@gmail.com> <200810291718.46231.IvDoorn@gmail.com>
In-Reply-To: <200810291718.46231.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810291719.08229.IvDoorn@gmail.com> (sfid-20081029_172916_215235_9D02CAA7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make menuconfig RT2X00 a tristate instead of boolean,
otherwise we do not correctly inherit the mac80211 value
on which RT2X00 depends, and makes it possible to
compile rt2x00 into the kernel while mac80211 is a
module.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index f839ce0..95511ac 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -1,5 +1,5 @@
 menuconfig RT2X00
-	bool "Ralink driver support"
+	tristate "Ralink driver support"
 	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
 	---help---
 	  This will enable the experimental support for the Ralink drivers,
-- 
1.5.6.1

