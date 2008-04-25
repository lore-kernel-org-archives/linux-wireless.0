Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms6.Sony.CO.JP ([211.125.136.204]:39364 "EHLO ms6.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbYDYFHp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2008 01:07:45 -0400
Received: from mta7.sony.co.jp (mta7.Sony.CO.JP [137.153.71.12])
 by ms6.sony.co.jp (R8/Sony) with ESMTP id m3P57fxV020159
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:41 +0900 (JST)
Received: from mta7.sony.co.jp (localhost [127.0.0.1])
 by mta7.sony.co.jp (R8/Sony) with ESMTP id m3P57fXs010485
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:41 +0900 (JST)
Received: from smail1.sm.sony.co.jp (smail1.sm.sony.co.jp [43.11.253.1])
 by mta7.sony.co.jp (R8/Sony) with ESMTP id m3P57f7u010477
 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:41 +0900 (JST)
Received: from imail.sm.sony.co.jp (imail.sm.sony.co.jp [43.4.141.32]) by smail1.sm.sony.co.jp (8.11.6p2/8.11.6) with ESMTP id m3P57fP18327 for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:41 +0900 (JST)
Received: from [43.4.146.40] (bluenote.sm.sony.co.jp [43.4.146.40])
	by imail.sm.sony.co.jp (8.12.11/3.7W) with ESMTP id m3P57fD6025275
	for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2008 14:07:41 +0900 (JST)
Date: Fri, 25 Apr 2008 14:05:39 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] RFC: WEXT: Add support for passing PMK and capability flags to WEXT
In-Reply-To: <20080424204950.03DD.40F06B3A@sm.sony.co.jp>
References: <20080424204950.03DD.40F06B3A@sm.sony.co.jp>
Message-Id: <20080425135638.03F5.40F06B3A@sm.sony.co.jp> (sfid-20080425_070828_179843_2AF9733F)
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
@@ -616,6 +616,7 @@
 #define IW_ENCODE_ALG_WEP	1
 #define IW_ENCODE_ALG_TKIP	2
 #define IW_ENCODE_ALG_CCMP	3
+#define IW_ENCODE_ALG_PMK	4
 /* struct iw_encode_ext ->ext_flags */
 #define IW_ENCODE_EXT_TX_SEQ_VALID	0x00000001
 #define IW_ENCODE_EXT_RX_SEQ_VALID	0x00000002
@@ -635,6 +636,7 @@
 #define IW_ENC_CAPA_WPA2	0x00000002
 #define IW_ENC_CAPA_CIPHER_TKIP	0x00000004
 #define IW_ENC_CAPA_CIPHER_CCMP	0x00000008
+#define IW_ENC_CAPA_4WAY_HANDSHAKE	0x00000010
 
 /* Event capability macros - in (struct iw_range *)->event_capa
  * Because we have more than 32 possible events, we use an array of

