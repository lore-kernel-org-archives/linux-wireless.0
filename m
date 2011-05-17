Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38640 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab1EQQlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 12:41:49 -0400
Received: by ewy4 with SMTP id 4so193634ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 09:41:48 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: read PHY info only when needed (for PHY-A)
Date: Tue, 17 May 2011 19:19:39 +0200
Message-Id: <1305652779-24293-1-git-send-email-zajec5@gmail.com> (sfid-20110517_184153_331419_33360ABD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We risk reading TMSHIGH register twice, but PHY-A are really rare and we
do not support them at the moment.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9380842..eb41596 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2119,7 +2119,6 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	int err;
 
 	/* Get microcode */
-	tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
 	if ((rev >= 5) && (rev <= 10))
 		filename = "ucode5";
 	else if ((rev >= 11) && (rev <= 12))
@@ -2158,6 +2157,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	switch (dev->phy.type) {
 	case B43_PHYTYPE_A:
 		if ((rev >= 5) && (rev <= 10)) {
+			tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
 			if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
 				filename = "a0g1initvals5";
 			else
@@ -2202,6 +2202,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	switch (dev->phy.type) {
 	case B43_PHYTYPE_A:
 		if ((rev >= 5) && (rev <= 10)) {
+			tmshigh = ssb_read32(dev->sdev, SSB_TMSHIGH);
 			if (tmshigh & B43_TMSHIGH_HAVE_2GHZ_PHY)
 				filename = "a0g1bsinitvals5";
 			else
-- 
1.7.3.4

