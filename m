Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34926 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755123AbcJ3KVZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Oct 2016 06:21:25 -0400
Received: by mail-pf0-f194.google.com with SMTP id s8so5898552pfj.2
        for <linux-wireless@vger.kernel.org>; Sun, 30 Oct 2016 03:21:24 -0700 (PDT)
Date: Sun, 30 Oct 2016 20:21:12 +1000
From: John Heenan <john@zgus.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] rtl8xxxu: Fix for bogus data used to determine macpower
Message-ID: <20161030102112.GA5789@cube> (sfid-20161030_112150_440899_130EF9D4)
References: <cover.1477769750.git.john@zgus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1477769750.git.john@zgus.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code tests show data returned by rtl8xxxu_read8(priv, REG_CR), used to set
macpower, is never 0xea. It is only ever 0x01 (first time after modprobe)
using wpa_supplicant and 0x00 thereafter using wpa_supplicant. These results
occurs with 'Fix for authentication failure' [PATCH 1/2] in place.

Whatever was returned, code tests always showed that at least
rtl8xxxu_init_queue_reserved_page(priv);
is always required. Not called if macpower set to true.

Please see cover letter, [PATCH 0/2], for more information from tests.

For rtl8xxxu-devel branch of git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git

Signed-off-by: John Heenan <john@zgus.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index f25b4df..aae05f3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3904,6 +3904,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		macpower = false;
 	else
 		macpower = true;
+	macpower = false; // Code testing shows macpower must always be set to false to avoid failure
 
 	ret = fops->power_on(priv);
 	if (ret < 0) {
-- 
2.10.1
