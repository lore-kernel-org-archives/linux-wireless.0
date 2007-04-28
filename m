Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:26023 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965975AbXD1QmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 12:42:09 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 6/7] mac80211: suppress warnings
Date: Sat, 28 Apr 2007 12:36:02 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070428163602.27203.25629.stgit@magic.sourmilk.net>
In-Reply-To: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
References: <20070428163601.27203.32016.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This eliminates warnings from gcc and sparse.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 4fd2300..2b6cb06 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -952,8 +952,6 @@ ieee80211_tx_h_check_assoc(struct ieee80211_txrx_data *tx)
 	if (unlikely(!tx->u.tx.mgmt_interface && tx->sdata->ieee802_1x &&
 		     !(sta_flags & WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_DEBUG
-		struct ieee80211_hdr *hdr =
-			(struct ieee80211_hdr *) tx->skb->data;
 		printk(KERN_DEBUG "%s: dropped frame to " MAC_FMT
 		       " (unauthorized port)\n", tx->dev->name,
 		       MAC_ARG(hdr->addr1));
@@ -2049,7 +2047,7 @@ static int __ieee80211_if_config(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_if_conf conf;
-	static const u8 scan_bssid[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	static u8 scan_bssid[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	if (!local->ops->config_interface || !netif_running(dev))
 		return 0;
@@ -2758,7 +2756,7 @@ ieee80211_fill_frame_info(struct ieee80211_local *local,
 				htonl(ieee80211_phytype_dsss_dot11_turbo);
 			break;
 		default:
-			fi->phytype = 0xAAAAAAAA;
+			fi->phytype = htonl(0xAAAAAAAA);
 			break;
 		}
 		fi->channel = htonl(status->channel);
@@ -2779,7 +2777,7 @@ ieee80211_fill_frame_info(struct ieee80211_local *local,
 		}
 
 		fi->antenna = htonl(status->antenna);
-		fi->priority = 0xffffffff; /* no clue */
+		fi->priority = htonl(0xffffffff); /* no clue */
 		fi->ssi_type = htonl(ieee80211_ssi_raw);
 		fi->ssi_signal = htonl(status->ssi);
 		fi->ssi_noise = 0x00000000;

