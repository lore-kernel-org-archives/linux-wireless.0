Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34668 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab3BLMXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 07:23:42 -0500
Date: Tue, 12 Feb 2013 15:23:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brett Rudley <brudley@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: [patch] brcmsmac: fix brcms_c_country_valid()
Message-ID: <20130212122314.GB19045@elgon.mountain> (sfid-20130212_132348_010396_AD2CB086)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ccode is not NUL terminated.  Presumably insisting on a terminator makes
brcms_c_country_valid() return false when it's not intended.  ccode[2]
is sprom->leddc_on_time.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is a static checker fix.  I don't know what ->leddc_on_time is in
practice.

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index cdb62b8..10ee314 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -183,8 +183,7 @@ static bool brcms_c_country_valid(const char *ccode)
 	 * chars.
 	 */
 	if (!((0x80 & ccode[0]) == 0 && ccode[0] >= 0x41 && ccode[0] <= 0x5A &&
-	      (0x80 & ccode[1]) == 0 && ccode[1] >= 0x41 && ccode[1] <= 0x5A &&
-	      ccode[2] == '\0'))
+	      (0x80 & ccode[1]) == 0 && ccode[1] >= 0x41 && ccode[1] <= 0x5A))
 		return false;
 
 	/*
