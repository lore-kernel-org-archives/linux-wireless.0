Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38104 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbYA2Rmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 12:42:45 -0500
Subject: [PATCH] mac80211: make alignment warning optional
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 16:57:51 +0100
Message-Id: <1201622272.4394.29.camel@johannes.berg> (sfid-20080129_174251_131567_A0D8C6FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver authors should be aware of the alignment requirements, but
not everybody cares about the warning. This patch makes it depend
on a new Kconfig symbol MAC80211_DEBUG_PACKET_ALIGNMENT which can
be enabled regardless of MAC80211_DEBUG and is recommended for
driver authors (only). This also restricts the warning to data
packets so other packets need not be realigned to not trigger the
warning.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/Kconfig |   12 ++++++++++++
 net/mac80211/rx.c    |    7 +++++++
 2 files changed, 19 insertions(+)

--- everything.orig/net/mac80211/Kconfig	2008-01-29 16:32:55.825603299 +0100
+++ everything/net/mac80211/Kconfig	2008-01-29 16:45:26.295590658 +0100
@@ -98,6 +98,18 @@ config MAC80211_DEBUGFS
 
 	  Say N unless you know you need this.
 
+config MAC80211_DEBUG_PACKET_ALIGNMENT
+	bool "Enable packet alignment debugging"
+	depends on MAC80211
+	help
+	  This option is recommended for driver authors and strongly
+	  discouraged for everybody else, it will trigger a warning
+	  when a driver hands mac80211 a buffer that is aligned in
+	  a way that will cause problems with the IP stack on some
+	  architectures.
+
+	  Say N unless you're writing a mac80211 based driver.
+
 config MAC80211_DEBUG
 	bool "Enable debugging output"
 	depends on MAC80211
--- everything.orig/net/mac80211/rx.c	2008-01-29 16:34:31.155617079 +0100
+++ everything/net/mac80211/rx.c	2008-01-29 16:43:22.635589573 +0100
@@ -325,11 +325,15 @@ static u32 ieee80211_rx_load_stats(struc
 	return load;
 }
 
+#ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
 static ieee80211_txrx_result
 ieee80211_rx_h_verify_ip_alignment(struct ieee80211_txrx_data *rx)
 {
 	int hdrlen;
 
+	if (!WLAN_FC_DATA_PRESENT(rx->fc))
+		return TXRX_CONTINUE;
+
 	/*
 	 * Drivers are required to align the payload data in a way that
 	 * guarantees that the contained IP header is aligned to a four-
@@ -356,11 +360,14 @@ ieee80211_rx_h_verify_ip_alignment(struc
 
 	return TXRX_CONTINUE;
 }
+#endif
 
 ieee80211_rx_handler ieee80211_rx_pre_handlers[] =
 {
 	ieee80211_rx_h_parse_qos,
+#ifdef CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT
 	ieee80211_rx_h_verify_ip_alignment,
+#endif
 	NULL
 };
 


