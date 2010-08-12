Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab0HLMuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Aug 2010 08:50:01 -0400
Subject: [PATCH] cfg80211: mark ieee80211_hdrlen const
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Aug 2010 14:49:58 +0200
Message-ID: <1281617398.3803.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function analyses only its single, value-passed
argument, and has no side effects. Thus it can be
const, which makes mac80211 smaller, for example:

   text	   data	    bss	    dec	    hex	filename
 362518	  16720	    884	 380122	  5ccda	mac80211.ko (before)
 362358	  16720	    884	 379962	  5cc3a	mac80211.ko (after)

a 160 byte saving in text size, and an optimisation
because the function won't be called as often.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    2 +-
 net/wireless/util.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-08-12 14:19:40.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-08-12 14:19:41.000000000 +0200
@@ -1715,7 +1715,7 @@ unsigned int ieee80211_get_hdrlen_from_s
  * ieee80211_hdrlen - get header length in bytes from frame control
  * @fc: frame control field in little-endian format
  */
-unsigned int ieee80211_hdrlen(__le16 fc);
+unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc);
 
 /**
  * ieee80211_data_to_8023 - convert an 802.11 data frame to 802.3
--- wireless-testing.orig/net/wireless/util.c	2010-08-12 14:19:40.000000000 +0200
+++ wireless-testing/net/wireless/util.c	2010-08-12 14:19:41.000000000 +0200
@@ -221,7 +221,7 @@ const unsigned char bridge_tunnel_header
 	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 EXPORT_SYMBOL(bridge_tunnel_header);
 
-unsigned int ieee80211_hdrlen(__le16 fc)
+unsigned int __attribute_const__ ieee80211_hdrlen(__le16 fc)
 {
 	unsigned int hdrlen = 24;
 


