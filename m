Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kmu-office.ch ([178.209.48.109]:44294 "EHLO
        mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753976AbeFQKeT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 06:34:19 -0400
From: Stefan Agner <stefan@agner.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Stefan Agner <stefan@agner.ch>,
        Tobias Regnery <tobias.regnery@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcm80211: fix wrap around in conversion from constant to s16
Date: Sun, 17 Jun 2018 12:33:50 +0200
Message-Id: <20180617103407.27819-1-stefan@agner.ch> (sfid-20180617_123452_181733_9FC6BCB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The last value in the log_table wraps around to a negative value
since s16 has a value range of -32768 to 32767. This is not what
the table intends to represent. Use the closest positive value
32767.

This fixes a warning seen with clang:
drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c:216:2: warning:
      implicit conversion from 'int' to 's16' (aka 'short') changes
value from 32768
      to -32768 [-Wconstant-conversion]
        32768
        ^~~~~
1 warning generated.

Fixes: 4c0bfeaae9f9 ("brcmsmac: fix array out-of-bounds access in qm_log10")
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c
index b9672da24a9d..b24bc57ca91b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_qmath.c
@@ -213,7 +213,7 @@ static const s16 log_table[] = {
 	30498,
 	31267,
 	32024,
-	32768
+	32767
 };
 
 #define LOG_TABLE_SIZE 32       /* log_table size */
-- 
2.17.1
