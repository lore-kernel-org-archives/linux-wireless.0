Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48218 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1A3MY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:24:56 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so2118506ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:24:55 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 19/21] rt2x00: Fix FIXME comments in rt61pci and rt73usb on Michael MIC.
Date: Sun, 30 Jan 2011 13:23:22 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201101301316.04044.IvDoorn@gmail.com> <201101301322.42545.IvDoorn@gmail.com> <201101301323.04342.IvDoorn@gmail.com>
In-Reply-To: <201101301323.04342.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101301323.23477.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Both rt61pci and rt73usb check the Michael MIC in hardware and strip the
Michael MIC from received frames. This is perfectly allowed by mac80211 as
long as this is properly reported to mac80211.
Both these drivers reported the Michael MIC handling properly to mac80211, but
still contained a FIXME comment on this, which is not needed to be handled, since
mac80211 doesn't really need the Michael MIC in this case.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    5 ++---
 drivers/net/wireless/rt2x00/rt73usb.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3afafab..dd2164d 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2118,9 +2118,8 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
 
 		/*
-		 * FIXME: Legacy driver indicates that the frame does
-		 * contain the Michael Mic. Unfortunately, in rt2x00
-		 * the MIC seems to be missing completely...
+		 * The hardware has already checked the Michael Mic and has
+		 * stripped it from the frame. Signal this to mac80211.
 		 */
 		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index aa9c61c..5ff72de 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1709,9 +1709,8 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
 
 		/*
-		 * FIXME: Legacy driver indicates that the frame does
-		 * contain the Michael Mic. Unfortunately, in rt2x00
-		 * the MIC seems to be missing completely...
+		 * The hardware has already checked the Michael Mic and has
+		 * stripped it from the frame. Signal this to mac80211.
 		 */
 		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
 
-- 
1.7.2.3

