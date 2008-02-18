Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:47900 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752883AbYBRCVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 21:21:08 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 1/3] mac80211: better definition of mactime
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Date: Mon, 18 Feb 2008 11:20:51 +0900
Message-ID: <20080218022050.5488.90242.stgit@one> (sfid-20080218_022111_700685_2FBF907D)
In-Reply-To: <20080218021448.5488.10305.stgit@one>
References: <20080218021448.5488.10305.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

define mactime as the time when the first data symbol arrived at the HW. the
old definition was questionable because 802.11 defines timestamp only for
beacon and probe response frames, and there it means the timestamp field.

a stricter definition of mactime is necessary for correct merging of IBSS.

note that it is up to the driver to convert whatever its hardware returns to
this definition. unfortunately we don't know for example when atheros hardware
takes its rx timestamp exactly :(

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---

 include/net/mac80211.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 460da54..1b807f4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -295,7 +295,8 @@ enum mac80211_rx_flags {
  * The low-level driver should provide this information (the subset
  * supported by hardware) to the 802.11 code with each received
  * frame.
- * @mactime: MAC timestamp as defined by 802.11
+ * @mactime: value in microseconds of the 64-bit Time Synchronization Function
+ * 	(TSF) timer when the first data symbol (MPDU) arrived at the hardware.
  * @band: the active band when this frame was received
  * @freq: frequency the radio was tuned to when receiving this frame, in MHz
  * @ssi: signal strength when receiving this frame

