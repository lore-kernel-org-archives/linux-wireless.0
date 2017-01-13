Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:35149 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdAMXfw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 18:35:52 -0500
Received: by mail-pf0-f178.google.com with SMTP id f144so37938205pfa.2
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 15:35:51 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 3/3] mwifiex: pcie: read FROMDEVICE DMA-able memory with READ_ONCE()
Date: Fri, 13 Jan 2017 15:35:38 -0800
Message-Id: <20170113233538.36196-3-briannorris@chromium.org> (sfid-20170114_003623_836562_2DA62198)
In-Reply-To: <20170113233538.36196-1-briannorris@chromium.org>
References: <20170113233538.36196-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mwifiex_delay_for_sleep_cookie(), we're looping and waiting for the
PCIe endpoint to write a magic value back to memory, to signal that it
has finished going to sleep. We're not letting the compiler know that
this might change underneath our feet though. Let's do that, for good
hygiene.

I'm not aware of this fixing any concrete problems. I also give no
guarantee that this loop is actually correct in any other way, but at
least this looks like an improvement to me.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: new in v2
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 194e0e04c3b1..c2511f212502 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -440,7 +440,7 @@ static void mwifiex_delay_for_sleep_cookie(struct mwifiex_adapter *adapter,
 
 	for (count = 0; count < max_delay_loop_cnt; count++) {
 		buffer = card->cmdrsp_buf->data - INTF_HEADER_LEN;
-		sleep_cookie = *(u32 *)buffer;
+		sleep_cookie = READ_ONCE(*(u32 *)buffer);
 
 		if (sleep_cookie == MWIFIEX_DEF_SLEEP_COOKIE) {
 			mwifiex_dbg(adapter, INFO,
-- 
2.11.0.483.g087da7b7c-goog
