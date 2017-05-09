Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36025 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750780AbdEIXXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 19:23:36 -0400
Received: by mail-pf0-f176.google.com with SMTP id m17so7007583pfg.3
        for <linux-wireless@vger.kernel.org>; Tue, 09 May 2017 16:23:36 -0700 (PDT)
Date: Tue, 9 May 2017 16:23:34 -0700
From: Kees Cook <keescook@chromium.org>
To: netdev@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>
Subject: [PATCH] libertas: Avoid reading past end of buffer
Message-ID: <20170509232334.GA55070@beast> (sfid-20170510_012412_402148_35A9A28C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using memcpy() from a string that is shorter than the length copied means
the destination buffer is being filled with arbitrary data from the kernel
rodata segment. Instead, use strncpy() which will fill the trailing bytes
with zeros. Additionally adjust indentation to keep checkpatch.pl happy.

This was found with the future CONFIG_FORTIFY_SOURCE feature.

Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index d0c881dd5846..d0b1948ca242 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -1177,9 +1177,9 @@ void lbs_mesh_ethtool_get_strings(struct net_device *dev,
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < MESH_STATS_NUM; i++) {
-			memcpy(s + i * ETH_GSTRING_LEN,
-					mesh_stat_strings[i],
-					ETH_GSTRING_LEN);
+			strncpy(s + i * ETH_GSTRING_LEN,
+				mesh_stat_strings[i],
+				ETH_GSTRING_LEN);
 		}
 		break;
 	}
-- 
2.7.4


-- 
Kees Cook
Pixel Security
