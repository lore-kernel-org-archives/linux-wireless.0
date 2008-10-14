Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36515 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbYJNSIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 14:08:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ieee80211: make it depend on drivers that use it
Date: Tue, 14 Oct 2008 13:20:08 -0400
Message-Id: <1224004808-20992-1-git-send-email-linville@tuxdriver.com> (sfid-20081014_200836_442263_957993D0)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make IEEE80211 depend on IPW2100, IPW2200, or HOSTAP, which all select
it.  This removes the need for users to select it manually.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/ieee80211/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
index 94ed7d3..44831db 100644
--- a/net/ieee80211/Kconfig
+++ b/net/ieee80211/Kconfig
@@ -1,5 +1,6 @@
 config IEEE80211
 	tristate "Generic IEEE 802.11 Networking Stack (DEPRECATED)"
+	depends on (IPW2100 || IPW2200 || HOSTAP)
 	---help---
 	This option enables the hardware independent IEEE 802.11
 	networking stack.  This component is deprecated in favor of the
-- 
1.5.4.3

