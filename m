Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34389 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752497AbcKRIoo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 03:44:44 -0500
Received: by mail-pg0-f67.google.com with SMTP id e9so19715127pgc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 00:44:43 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Fri, 18 Nov 2016 00:44:36 -0800
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/7] mwifiex: Remove unused  'chan_num' variable
Message-ID: <1a455fb2723904d5ce7a0007c1dd847ccbe89eb9.1479458373.git.kirtika@google.com> (sfid-20161118_094448_350068_116F8DB1)
References: <cover.1479458373.git.kirtika@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479458373.git.kirtika@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit b5413e6b2228 removed all uses of chan_num in mwifiex_config_scan().
Compiling mwifiex with W=1 gives the following warning, fix it.

mwifiex/scan.c: In function ‘mwifiex_config_scan’:
mwifiex/scan.c:830:6: warning: variable ‘chan_num’ set but not used [-Wunused-but-set-variable]

Fixes: b5413e6b2228 ("mwifiex: increase the number of nodes in command pool")
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 97c9765..436e628 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -827,7 +827,6 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	u32 num_probes;
 	u32 ssid_len;
 	u32 chan_idx;
-	u32 chan_num;
 	u32 scan_type;
 	u16 scan_dur;
 	u8 channel;
@@ -1105,13 +1104,12 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 			mwifiex_dbg(adapter, INFO,
 				    "info: Scan: Scanning current channel only\n");
 		}
-		chan_num = chan_idx;
 	} else {
 		mwifiex_dbg(adapter, INFO,
 			    "info: Scan: Creating full region channel list\n");
-		chan_num = mwifiex_scan_create_channel_list(priv, user_scan_in,
-							    scan_chan_list,
-							    *filtered_scan);
+		mwifiex_scan_create_channel_list(priv, user_scan_in,
+						 scan_chan_list,
+						 *filtered_scan);
 	}

 }
--
2.8.0.rc3.226.g39d4020
