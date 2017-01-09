Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34129 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbdAIXeJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 18:34:09 -0500
Received: by mail-pf0-f181.google.com with SMTP id 127so35446473pfg.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2017 15:34:09 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: debugfs: Fix (sometimes) off-by-1 SSID print
Date: Mon,  9 Jan 2017 15:33:50 -0800
Message-Id: <20170109233350.134036-1-briannorris@chromium.org> (sfid-20170110_003414_679299_CCF57E94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar to commit fcd2042e8d36 ("mwifiex: printk() overflow with 32-byte
SSIDs"), we failed to account for the existence of 32-char SSIDs in our
debugfs code. Unlike in that case though, we zeroed out the containing
struct first, and I'm pretty sure we're guaranteed to have some padding
after the 'ssid.ssid' and 'ssid.ssid_len' fields (the struct is 33 bytes
long).

So, this is the difference between:

  # cat /sys/kernel/debug/mwifiex/mlan0/info
  ...
  essid="0123456789abcdef0123456789abcdef "
  ...

and the correct output:

  # cat /sys/kernel/debug/mwifiex/mlan0/info
  ...
  essid="0123456789abcdef0123456789abcdef"
  ...

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
Marking the 'Fixes' tag just for completeness, but AIUI, this isn't a security
vulnerability (besides, it's debugfs), so it might not really warrant -stable.

 drivers/net/wireless/marvell/mwifiex/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index b9284b533294..ae2b69db5994 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -114,7 +114,8 @@ mwifiex_info_read(struct file *file, char __user *ubuf,
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) {
 		p += sprintf(p, "multicast_count=\"%d\"\n",
 			     netdev_mc_count(netdev));
-		p += sprintf(p, "essid=\"%s\"\n", info.ssid.ssid);
+		p += sprintf(p, "essid=\"%.*s\"\n", info.ssid.ssid_len,
+			     info.ssid.ssid);
 		p += sprintf(p, "bssid=\"%pM\"\n", info.bssid);
 		p += sprintf(p, "channel=\"%d\"\n", (int) info.bss_chan);
 		p += sprintf(p, "country_code = \"%s\"\n", info.country_code);
-- 
2.11.0.390
