Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37710 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab0FGHC5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 03:02:57 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 07 Jun 2010 00:02:57 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>,
	Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Subject: [stable 2.6.32][PATCH] ath9k: Avoid corrupt frames being forwarded to mac80211.
Date: Mon, 7 Jun 2010 12:32:43 +0530
Message-ID: <1275894163-3348-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1275894163-3348-1-git-send-email-vnatarajan@atheros.com>
References: <1275894163-3348-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If bit 29 is set, MAC H/W can attempt to decrypt the received aggregate
with WEP or TKIP, eventhough the received frame may be a CRC failed
corrupted frame. If this bit is set, H/W obeys key type in keycache.
If it is not set and if the key type in keycache is neither open nor
AES, H/W forces key type to be open.  But bit 29 should be set to 1
for AsyncFIFO feature to encrypt/decrypt the aggregate with WEP or TKIP.

Cc: stable@kernel.org
Reported-by: Johan Hovold <johan.hovold@lundinova.se>
Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
---
 drivers/net/wireless/ath/ath9k/initvals.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
index 8622265..a21c214 100644
--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -2762,7 +2762,7 @@ static const u32 ar9280Common_9280_2[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -3935,7 +3935,7 @@ static const u_int32_t ar9285Common_9285[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -5072,7 +5072,7 @@ static const u_int32_t ar9287Common_9287_1_0[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -6864,7 +6864,7 @@ static const u_int32_t ar9271Common_9271_1_0[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
-- 
1.7.1

