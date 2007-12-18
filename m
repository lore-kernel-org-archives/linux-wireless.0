Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57686 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758257AbXLRAY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 19:24:29 -0500
Message-Id: <200712180022.lBI0MrTO010075@imap1.linux-foundation.org> (sfid-20071218_002431_892553_20F114E1)
Subject: [patch (for 2.6.24?) 3/4] libertas: select WIRELESS_EXT
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, akpm@linux-foundation.org,
	dcbw@redhat.com
From: akpm@linux-foundation.org
Date: Mon, 17 Dec 2007 16:22:53 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>

Ensure that libertas selects WIRELESS_EXT, since selecting other stuff that
should depend on WEXT, like IEEE80211, doesn't seem to drag that in for us.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/wireless/Kconfig~libertas-select-wireless_ext drivers/net/wireless/Kconfig
--- a/drivers/net/wireless/Kconfig~libertas-select-wireless_ext
+++ a/drivers/net/wireless/Kconfig
@@ -264,6 +264,7 @@ config IPW2200_DEBUG
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on WLAN_80211
+	select WIRELESS_EXT
 	select IEEE80211
 	select FW_LOADER
 	---help---
_
