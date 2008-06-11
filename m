Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:14256 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYFKRgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 13:36:39 -0400
Received: by yx-out-2324.google.com with SMTP id 31so357683yxl.1
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 10:36:39 -0700 (PDT)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] next-20080611 rt2x00: build failure
Date: Wed, 11 Jun 2008 19:48:48 +0200
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20080611100748.d35829f4.randy.dunlap@oracle.com>
In-Reply-To: <20080611100748.d35829f4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806111948.49976.IvDoorn@gmail.com> (sfid-20080611_193702_412304_5C5AEA4D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> when CONFIG_INPUT=n and
> # CONFIG_NEW_LEDS is not set
> CONFIG_LEDS_CLASS=y

Does below patch help?

---
diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index 0ace761..c4d1f67 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -36,6 +36,7 @@ config RT2X00_LIB_FIRMWARE
 config RT2X00_LIB_RFKILL
 	boolean
 	depends on RT2X00_LIB
+	depends on INPUT
 	select RFKILL
 	select INPUT_POLLDEV
 
