Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:36446 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbaIWIdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 04:33:42 -0400
Received: by mail-we0-f177.google.com with SMTP id t60so4103866wes.8
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 01:33:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/3] ath10k: dump hex bytes with dev string prefix
Date: Tue, 23 Sep 2014 10:22:53 +0200
Message-Id: <1411460574-5424-3-git-send-email-michal.kazior@tieto.com> (sfid-20140923_103354_133910_0A25841A)
In-Reply-To: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com>
References: <1411460574-5424-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it easier to debug hex dumps on systems
with more than a single ath10k device.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * merge 2 scnprintfs into 1 [Kalle]

 drivers/net/wireless/ath/ath10k/debug.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f1e5916..1110f0f 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1264,11 +1264,26 @@ void ath10k_dbg_dump(struct ath10k *ar,
 		     const char *msg, const char *prefix,
 		     const void *buf, size_t len)
 {
+	char linebuf[256];
+	unsigned int linebuflen;
+	const void *ptr;
+
 	if (ath10k_debug_mask & mask) {
 		if (msg)
 			ath10k_dbg(ar, mask, "%s\n", msg);
 
-		print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
+		for (ptr = buf; (ptr - buf) < len; ptr += 16) {
+			linebuflen = 0;
+			linebuflen += scnprintf(linebuf + linebuflen,
+						sizeof(linebuf) - linebuflen,
+						"%s%08x: ",
+						(prefix ? prefix : ""),
+						(unsigned int)(ptr - buf));
+			hex_dump_to_buffer(ptr, len - (ptr - buf), 16, 1,
+					   linebuf + linebuflen,
+					   sizeof(linebuf) - linebuflen, true);
+			dev_printk(KERN_DEBUG, ar->dev, "%s\n", linebuf);
+		}
 	}
 
 	/* tracing code doesn't like null strings :/ */
-- 
1.8.5.3

