Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from intranet.asianux.com ([58.214.24.6]:18632 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3ATJxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 04:53:07 -0500
Message-ID: <50FBBEB2.2000306@asianux.com> (sfid-20130120_105317_825798_E27D56A1)
Date: Sun, 20 Jan 2013 17:53:54 +0800
From: Chen Gang <gang.chen@asianux.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: [PATCH] drivers/net/wireless/iwlegacy: adding check length for parameter
 buf
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


  the parameter 'const char *buf' may be not '\0' based string.
  so need check the length before use it.

additinal info:
  originally, it had the relative checking.
  but it was deleted when fix another issues (using strlcpy instead of
strncpy)
  and now, we need restore the checking (but still keep strlcpy)

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c
b/drivers/net/wireless/iwlegacy/3945-mac.c
index 050ce7c..71cdbac 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3273,7 +3273,7 @@ il3945_store_measurement(struct device *d, struct
device_attribute *attr,

 	if (count) {
 		char *p = buffer;
-		strlcpy(buffer, buf, sizeof(buffer));
+		strlcpy(buffer, buf, min(sizeof(buffer), count));
 		channel = simple_strtoul(p, NULL, 0);
 		if (channel)
 			params.channel = channel;
-- 
1.7.10.4
