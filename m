Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57580 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab0JJKUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 06:20:34 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Nohee Ko <noheek@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 3/3] staging: brcm80211: fix to use "%pM" flag to print MAC address
Date: Sun, 10 Oct 2010 13:20:13 +0300
Message-Id: <dc990a5f703e69ed428ac2f2479779d36ef1eb3f.1286705921.git.andy.shevchenko@gmail.com>
In-Reply-To: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
References: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
In-Reply-To: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
References: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmutils.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmutils.c b/drivers/staging/brcm80211/brcmfmac/bcmutils.c
index f5c552d..007cb55 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmutils.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmutils.c
@@ -501,10 +501,7 @@ int bcm_ether_atoe(char *p, struct ether_addr *ea)
 
 char *bcm_ether_ntoa(const struct ether_addr *ea, char *buf)
 {
-	static const char template[] = "%02x:%02x:%02x:%02x:%02x:%02x";
-	snprintf(buf, 18, template,
-		 ea->octet[0] & 0xff, ea->octet[1] & 0xff, ea->octet[2] & 0xff,
-		 ea->octet[3] & 0xff, ea->octet[4] & 0xff, ea->octet[5] & 0xff);
+	snprintf(buf, 18, "%pM", ea->octet);
 	return buf;
 }
 
-- 
1.7.2.3

