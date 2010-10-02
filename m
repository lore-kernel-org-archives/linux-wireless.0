Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0JBJfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Oct 2010 05:35:33 -0400
Received: by mail-wy0-f174.google.com with SMTP id 28so3658555wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Oct 2010 02:35:32 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 12/20] rt2x00: Don't enable broad- and multicast buffering on USB devices
Date: Sat, 2 Oct 2010 11:31:33 +0200
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201010021126.18748.IvDoorn@gmail.com> <201010021130.43811.IvDoorn@gmail.com> <201010021131.06386.IvDoorn@gmail.com>
In-Reply-To: <201010021131.06386.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010021131.33951.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

Since rt2x00 USB devices have no chance to know when a beacon was sent
out in AP mode currently all broad- and multicast traffic is buffered in
mac80211 but never sent out at all.

Unfortunately we have no chance in sending the traffic out after a
DTIM beacon due to hw limitations. Hence, instead of never sending the
buffered traffic out better send it out immediately.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Reported-by: Lauri Hintsala <lauri.hintsala@bluegiga.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    7 ++++++-
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 ++++++++++-
 drivers/net/wireless/rt2x00/rt73usb.c   |    7 ++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 5843a6d..1033964 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1674,10 +1674,15 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Initialize all hw fields.
+	 *
+	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING unless we are
+	 * capable of sending the buffered frames out after the DTIM
+	 * transmission using rt2x00lib_beacondone. This will send out
+	 * multicast and broadcast traffic immediately instead of buffering it
+	 * infinitly and thus dropping it after some time.
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_RX_INCLUDES_FCS |
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 76b8783..99b505f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3164,11 +3164,20 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK |
 	    IEEE80211_HW_AMPDU_AGGREGATION;
+	/*
+	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
+	 * unless we are capable of sending the buffered frames out after the
+	 * DTIM transmission using rt2x00lib_beacondone. This will send out
+	 * multicast and broadcast traffic immediately instead of buffering it
+	 * infinitly and thus dropping it after some time.
+	 */
+	if (!rt2x00_is_usb(rt2x00dev))
+		rt2x00dev->hw->flags |=
+			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index f78bc2a..66939fd 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2063,9 +2063,14 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Initialize all hw fields.
+	 *
+	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING unless we are
+	 * capable of sending the buffered frames out after the DTIM
+	 * transmission using rt2x00lib_beacondone. This will send out
+	 * multicast and broadcast traffic immediately instead of buffering it
+	 * infinitly and thus dropping it after some time.
 	 */
 	rt2x00dev->hw->flags =
-	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_SIGNAL_DBM |
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK;
-- 
1.7.2.3

