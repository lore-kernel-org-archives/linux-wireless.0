Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34489 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753007AbaBLWi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 17:38:28 -0500
Date: Wed, 12 Feb 2014 22:38:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Howells <dhowells@redhat.com>, Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] hostap: fix "hostap: proc: Use remove_proc_subtree()"
Message-ID: <20140212223817.GS26684@n2100.arm.linux.org.uk> (sfid-20140212_233831_459918_AC5E01F5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove_proc_subtree() doesn't work here as local->ddev has already
been removed, and NULLed out.  Use proc_remove() instead.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
I would include an oops, however the machine I discovered this on has
a page 0 populated - so the symptoms are multiple 'wlan0' entries in
/proc/net/hostap.  This is probably a candidate for stable too.

 drivers/net/wireless/hostap/hostap_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/hostap/hostap_proc.c b/drivers/net/wireless/hostap/hostap_proc.c
index aa7ad3a7a69b..4e5c0f8c9496 100644
--- a/drivers/net/wireless/hostap/hostap_proc.c
+++ b/drivers/net/wireless/hostap/hostap_proc.c
@@ -496,7 +496,7 @@ void hostap_init_proc(local_info_t *local)
 
 void hostap_remove_proc(local_info_t *local)
 {
-	remove_proc_subtree(local->ddev->name, hostap_proc);
+	proc_remove(local->proc);
 }
 
 

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
