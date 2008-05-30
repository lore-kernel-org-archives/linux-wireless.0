Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms5.Sony.CO.JP ([211.125.136.201]:38827 "EHLO ms5.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYE3Hwa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 03:52:30 -0400
Received: from mta6.sony.co.jp (mta6.Sony.CO.JP [137.153.71.9])
 by ms5.sony.co.jp (R8/Sony) with ESMTP id m4U7qSks018331
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:52:28 +0900 (JST)
Received: from mta6.sony.co.jp (localhost [127.0.0.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m4U7qSvk014772
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:52:28 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta6.sony.co.jp (R8/Sony) with ESMTP id m4U7qSa2014722
 for <linux-wireless@vger.kernel.org>; Fri, 30 May 2008 16:52:28 +0900 (JST)
Date: Fri, 30 May 2008 16:52:23 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] WEXT: Add support for passing PMK and capability flags to WEXT
Cc: geoffrey.levand@am.sony.com,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
In-Reply-To: <20080530163019.4741.40F06B3A@sm.sony.co.jp>
References: <20080530163019.4741.40F06B3A@sm.sony.co.jp>
Message-Id: <20080530164258.4744.40F06B3A@sm.sony.co.jp> (sfid-20080530_095234_103838_A0A0F1D7)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This defines the flags for setting the PMK to the driver and the
capability flag for this so that the user space program can figure out
whether the target driver wants to do 4-way hand shake by itself and
pass the PMK which is needed before 4-way handshake to the driver.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 include/linux/wireless.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -611,6 +611,7 @@
 #define IW_ENCODE_ALG_WEP	1
 #define IW_ENCODE_ALG_TKIP	2
 #define IW_ENCODE_ALG_CCMP	3
+#define IW_ENCODE_ALG_PMK	4
 /* struct iw_encode_ext ->ext_flags */
 #define IW_ENCODE_EXT_TX_SEQ_VALID	0x00000001
 #define IW_ENCODE_EXT_RX_SEQ_VALID	0x00000002
@@ -630,6 +631,7 @@
 #define IW_ENC_CAPA_WPA2	0x00000002
 #define IW_ENC_CAPA_CIPHER_TKIP	0x00000004
 #define IW_ENC_CAPA_CIPHER_CCMP	0x00000008
+#define IW_ENC_CAPA_4WAY_HANDSHAKE	0x00000010
 
 /* Event capability macros - in (struct iw_range *)->event_capa
  * Because we have more than 32 possible events, we use an array of

