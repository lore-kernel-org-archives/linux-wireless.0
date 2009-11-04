Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:5665 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958AbZKDRdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 12:33:17 -0500
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:32:58 +0100
Message-Id: <20091104173258.28463.94619.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/41] rt2800usb: use rt2x00usb_register_multiwrite() to set key entries
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: use rt2x00usb_register_multiwrite() to set key entries

Since struct hw_key_entry is 32-bytes large and is smaller than
CSR cache size (which is 64-bytes large) we can use the standard
rt2x00usb_register_multiwrite() helper to set key entries.

This cleanup is a part of preparations for later code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -392,7 +392,6 @@ static int rt2800usb_config_shared_key(s
 {
 	struct hw_key_entry key_entry;
 	struct rt2x00_field32 field;
-	int timeout;
 	u32 offset;
 	u32 reg;
 
@@ -407,12 +406,8 @@ static int rt2800usb_config_shared_key(s
 		       sizeof(key_entry.rx_mic));
 
 		offset = SHARED_KEY_ENTRY(key->hw_key_idx);
-		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
-		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-						    USB_VENDOR_REQUEST_OUT,
-						    offset, &key_entry,
-						    sizeof(key_entry),
-						    timeout);
+		rt2x00usb_register_multiwrite(rt2x00dev, offset,
+					      &key_entry, sizeof(key_entry));
 	}
 
 	/*
@@ -445,7 +440,6 @@ static int rt2800usb_config_pairwise_key
 					 struct ieee80211_key_conf *key)
 {
 	struct hw_key_entry key_entry;
-	int timeout;
 	u32 offset;
 
 	if (crypto->cmd == SET_KEY) {
@@ -467,12 +461,8 @@ static int rt2800usb_config_pairwise_key
 		       sizeof(key_entry.rx_mic));
 
 		offset = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
-		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
-		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
-						    USB_VENDOR_REQUEST_OUT,
-						    offset, &key_entry,
-						    sizeof(key_entry),
-						    timeout);
+		rt2x00usb_register_multiwrite(rt2x00dev, offset,
+					      &key_entry, sizeof(key_entry));
 	}
 
 	/*
