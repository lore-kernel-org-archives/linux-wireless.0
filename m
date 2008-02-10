Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:38996 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYBJVxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:36 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4239380fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:34 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 05/14] rt2x00: Select CONFIG_NEW_LEDS
Date: Sun, 10 Feb 2008 22:48:47 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102248.47156.IvDoorn@gmail.com> (sfid-20080210_215338_472701_6A4983A8)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Select CONFIG_NEW_LEDS before selecting the other LED config
options. This fixes a link error when NEW_LEDS was disabled.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 51adb2f..4bb46e9 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -41,6 +41,7 @@ config RT2X00_LIB_RFKILL
 config RT2X00_LIB_LEDS
 	boolean
 	depends on RT2X00_LIB
+	select NEW_LEDS
 	select LEDS_CLASS
 	select LEDS_TRIGGERS
 	select MAC80211_LEDS
-- 
1.5.4

