Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46721 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0F3GtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 02:49:18 -0400
Received: by fxm14 with SMTP id 14so164401fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jun 2010 23:49:16 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCHv2] mac82011: Allow selection of minstrel_ht as default rc algorithm
Date: Wed, 30 Jun 2010 08:48:42 +0200
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201006300848.42201.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow selection of minstrel_ht as default rate control algorithm. At
the moment minstrel_ht can only be requested by the driver code but
not selected as default in make menuconfig. Fix this by using
minstrel_ht when minstrel was selected as default and minstrel_ht
is available.

This change won't affect legacy devices as minstrel_ht falls back to
minstrel in that case.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 83eec7a..4d6f865 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -69,6 +69,7 @@ endchoice
 
 config MAC80211_RC_DEFAULT
 	string
+	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL && MAC80211_RC_MINSTREL_HT
 	default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
 	default "pid" if MAC80211_RC_DEFAULT_PID
 	default ""
-- 
1.6.4.2

