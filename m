Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098E250E58F;
	Tue, 29 Sep 2026 10:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790678534; cv=none; b=pdrNkNu0CrhbKg/yOYmaJB8RV/MpQDqOC7O+CHhZlkT7Dx0NquBrpHTTFbP4rfA8oMbm11hQrNzUTDnHps0Me7uQHNJ8F8tR1h+BxIIjvS2sdpnDUN6czW2Bx9SvPlpXPtMxb4ggM9WW2kheMiP6nszwoAzeuBiW3NH6yaMQJHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790678534; c=relaxed/simple;
	bh=yTXg3i8Y1WV7SDCAGzf0mEhZSM2ecpcM+IQ9OOQiWAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=urdTmTEGJZYT5xpNyHSDg94KXy1jDs27w/l0Ezm64A1NZO42ZBsIL+npc8rqqjHGHacvbQ+GpHg3od7fsmxN54uA+/Z3PP3m3f3VPq8nMwey3PYGwaZjTEkhexyyZDHTfalxF9xGr7oS5BOWNTv3aMPPB393VOB2y9y/pMZ1QYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lUdy/4mi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lUdy/4mi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129F51F000FF;
	Tue, 29 Sep 2026 10:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790678523;
	bh=+45Tm9BeypxjenadJlBsDLE7aYfc9ERlVgGJD9aall0=;
	h=From:To:Cc:Subject:Date;
	b=lUdy/4miip/vZydEjfnL/1NHG+KU3ETqAnXFu2LF+HMn1N+wMeH835UIUNvm3+gig
	 hoN1KeqDcWBgEwHqH7rYSSyCwJ3Ye5J7n/yCTSrBAMRfyeA1HHjT9W0/C+t2+BZkkX
	 C2mOL9TxbQ9a1ENt92kduLwuk3hR2addgZNQjgMn62NXrFYBj3cwv+SqobyyF2EdjD
	 NTNMGCaTlglreC3QPNhw14bAD/BbqgzpWEz9mpRrtKlTni+nOlmXDL77kWiPL7eBjO
	 DTA1UJQ21a6Zxi85loNKXBIKJt7HJqEKg0i8VZFwXlQ34bBL2bOud1PsGeebVqjcqh
	 dLGv3vA3uJIrw==
From: Arnd Bergmann <arnd@kernel.org>
To: Ping-Ke Shih <pkshih@realtek.com>,
	Johnson Tsai <wenjie.tsai@realtek.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: rtw89: fix LED dependencies
Date: Tue, 29 Sep 2026 12:41:52 +0200
Message-ID: <20260929104159.3236854-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The rtw89 driver fails to build when multicolor LED support is in
a loadable module but the rtw89 driver is built-in:

aarch64-linux-ld: drivers/net/wireless/realtek/rtw89/led_mc.o: in function `rtw89_led_mc_brightness_set':
led_mc.c:(.text+0x50): undefined reference to `led_mc_calc_color_components'
aarch64-linux-ld: drivers/net/wireless/realtek/rtw89/led_mc.o: in function `rtw89_led_mc_init':
led_mc.c:(.text+0x434): undefined reference to `led_classdev_multicolor_register_ext'

The problem is a misunderstanding of how Kconfig dependencies
work, as the 'imply' keyword is not sufficient to enable a
a user-visible dependency, and the boolean 'RTW89_LEDS_MC'
symbol cannot determine whether linking against the MC code is
valid.

Address this by using the correct construct to determing whether
linking agains the MAC80211_LEDS and LEDS_CLASS_MULTICOLOR
code is possible, respectively.

Fixes: d910631ff352 ("wifi: rtw89: add LED support to reflect the wireless association status")
Fixes: 721d90c8509a ("wifi: rtw89: add multicolor LED support for RTL8852CU valve board")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtw89/Kconfig | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig b/drivers/net/wireless/realtek/rtw89/Kconfig
index 7c678dd1f6b3..4000ae344544 100644
--- a/drivers/net/wireless/realtek/rtw89/Kconfig
+++ b/drivers/net/wireless/realtek/rtw89/Kconfig
@@ -208,15 +208,13 @@ config RTW89_DEBUGFS
 config RTW89_LEDS
 	bool
 	depends on RTW89_CORE
-	depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
-	imply MAC80211_LEDS
+	depends on MAC80211_LEDS=y || MAC80211_LEDS=RTW89_CORE
 	default y
 
 config RTW89_LEDS_MC
 	bool
 	depends on RTW89_LEDS
-	depends on LEDS_CLASS_MULTICOLOR
-	imply LEDS_TRIGGER_TIMER
+	depends on LEDS_CLASS_MULTICOLOR=y || LEDS_CLASS_MULTICOLOR=RTW89_CORE
 	default y
 
 endif
-- 
2.53.0

