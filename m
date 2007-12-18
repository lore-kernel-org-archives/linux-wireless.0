Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbXLROQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 09:16:01 -0500
Subject: [PATCH] mac80211: warn when receiving frames with unaligned data
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Daniel Drake <dsd@gentoo.org>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 15:11:35 +0100
Message-Id: <1197987095.4885.159.camel@johannes.berg> (sfid-20071218_141644_200844_56A6F3DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes mac80211 warn (once) when the driver passes up a
frame in which the payload data is not aligned on a four-byte
boundary, with a long comment for people who run into the condition
and need to know what to do.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- everything.orig/net/mac80211/rx.c	2007-12-18 14:47:18.433014323 +0100
+++ everything/net/mac80211/rx.c	2007-12-18 14:48:47.113014051 +0100
@@ -1619,6 +1619,7 @@ void __ieee80211_rx(struct ieee80211_hw 
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	u8 *bssid;
+	int hdrlen;
 
 	/*
 	 * key references and virtual interfaces are protected using RCU
@@ -1648,6 +1649,18 @@ void __ieee80211_rx(struct ieee80211_hw 
 	rx.fc = le16_to_cpu(hdr->frame_control);
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
+	/*
+	 * Drivers are required to align the payload data to a four-byte
+	 * boundary, so the last two bits of the address where it starts
+	 * may not be set. The header is required to be directly before
+	 * the payload data, padding like atheros hardware adds which is
+	 * inbetween the 802.11 header and the payload is not supported,
+	 * the driver is required to move the 802.11 header further back
+	 * in that case.
+	 */
+	hdrlen = ieee80211_get_hdrlen(rx.fc);
+	WARN_ON_ONCE(((unsigned long)(skb->data + hdrlen)) & 3);
+
 	if (type == IEEE80211_FTYPE_DATA || type == IEEE80211_FTYPE_MGMT)
 		local->dot11ReceivedFragmentCount++;
 


