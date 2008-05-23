Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28812 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969AbYEWBzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 21:55:01 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 4/5] hostap: don't report useless WDS frames by default
To: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>
Date: Thu, 22 May 2008 21:55:00 -0400
Message-ID: <20080523015500.16636.99401.stgit@dv.roinet.com> (sfid-20080523_035505_127229_6519FAD6)
In-Reply-To: <20080523015442.16636.92254.stgit@dv.roinet.com>
References: <20080523015442.16636.92254.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DEBUG_EXTRA is reported to the kernel log by default, but DEBUG_EXTRA2
is not.  Unrelated WDS frames pollute the log unnecessarily.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_80211_rx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_80211_rx.c b/drivers/net/wireless/hostap/hostap_80211_rx.c
index 4fd7380..47884c3 100644
--- a/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -551,7 +551,7 @@ hostap_rx_frame_wds(local_info_t *local, struct ieee80211_hdr_4addr *hdr,
 	     hdr->addr1[2] != 0xff || hdr->addr1[3] != 0xff ||
 	     hdr->addr1[4] != 0xff || hdr->addr1[5] != 0xff)) {
 		/* RA (or BSSID) is not ours - drop */
-		PDEBUG(DEBUG_EXTRA, "%s: received WDS frame with "
+		PDEBUG(DEBUG_EXTRA2, "%s: received WDS frame with "
 		       "not own or broadcast %s=%s\n",
 		       local->dev->name,
 		       fc & IEEE80211_FCTL_FROMDS ? "RA" : "BSSID",
