Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaIEOaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 10:30:24 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] hostap: proc: substitute loops by %*phN
Date: Fri,  5 Sep 2014 17:30:16 +0300
Message-Id: <1409927416-27101-1-git-send-email-andriy.shevchenko@linux.intel.com> (sfid-20140905_163027_366741_F7992940)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For dumping small buffers we may use %*phN specifier instead of custom
approach..

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/hostap/hostap_proc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_proc.c b/drivers/net/wireless/hostap/hostap_proc.c
index 16a06b6..4e2a7dd9 100644
--- a/drivers/net/wireless/hostap/hostap_proc.c
+++ b/drivers/net/wireless/hostap/hostap_proc.c
@@ -184,11 +184,9 @@ static int prism2_bss_list_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, "%*pE", bss->ssid_len, bss->ssid);
 
 	seq_putc(m, '\t');
-	for (i = 0; i < bss->ssid_len; i++)
-		seq_printf(m, "%02x", bss->ssid[i]);
+	seq_printf(m, "%*phN", (int)bss->ssid_len, bss->ssid);
 	seq_putc(m, '\t');
-	for (i = 0; i < bss->wpa_ie_len; i++)
-		seq_printf(m, "%02x", bss->wpa_ie[i]);
+	seq_printf(m, "%*phN", (int)bss->wpa_ie_len, bss->wpa_ie);
 	seq_putc(m, '\n');
 	return 0;
 }
-- 
2.1.0

