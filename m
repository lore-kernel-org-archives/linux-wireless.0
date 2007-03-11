Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:56494 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbXCKEkS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2007 23:40:18 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HQFpF-0002Ce-B8
	for linux-wireless@vger.kernel.org; Sat, 10 Mar 2007 23:38:29 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] zd1211rw: sparse-annotate radiotap header
To: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sat, 10 Mar 2007 23:40:16 -0500
Message-ID: <20070311044016.1351.41028.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All fields in radiotap header must be little endian.  The driver does it
correctly, but the structure definition must be annotated.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index 5b9e04a..231ec2d 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -367,8 +367,8 @@ struct zd_rt_hdr {
 	struct ieee80211_radiotap_header rt_hdr;
 	u8  rt_flags;
 	u8  rt_rate;
-	u16 rt_channel;
-	u16 rt_chbitmask;
+	__le16 rt_channel;
+	__le16 rt_chbitmask;
 } __attribute__((packed));
 
 static void fill_rt_header(void *buffer, struct zd_mac *mac,


