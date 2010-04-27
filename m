Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11197 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656Ab0D0Hf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 03:35:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Apr 2010 00:35:59 -0700
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <stable@kernel.org>,
	Ranga Rao Ravuri <ranga.ravuri@atheros.com>
Subject: [PATCH 2/2] ath9k: Avoid corrupt frames being forwarded to mac80211.
Date: Tue, 27 Apr 2010 13:05:38 +0530
Message-ID: <1272353738-17084-2-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1272353738-17084-1-git-send-email-vnatarajan@atheros.com>
References: <1272353738-17084-1-git-send-email-vnatarajan@atheros.com>
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
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
index cd953f6..025c31a 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
@@ -249,7 +249,7 @@ static const u32 ar5416Common[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8000010 },
+    { 0x00008264, 0x88000010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index f06313d..dae7f33 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -793,7 +793,7 @@ static const u32 ar9280Common_9280_2[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -1963,7 +1963,7 @@ static const u32 ar9285Common_9285[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -3185,7 +3185,7 @@ static const u32 ar9287Common_9287_1_0[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
@@ -4973,7 +4973,7 @@ static const u32 ar9271Common_9271[][2] = {
     { 0x00008258, 0x00000000 },
     { 0x0000825c, 0x400000ff },
     { 0x00008260, 0x00080922 },
-    { 0x00008264, 0xa8a00010 },
+    { 0x00008264, 0x88a00010 },
     { 0x00008270, 0x00000000 },
     { 0x00008274, 0x40000000 },
     { 0x00008278, 0x003e4180 },
-- 
1.7.0.5

