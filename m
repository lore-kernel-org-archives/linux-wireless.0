Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:40066 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeFACOg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 22:14:36 -0400
From: Varsha Rao <rvarsha016@gmail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] net: wireless: brcmsmac: Remove unnecessary parentheses
Date: Fri,  1 Jun 2018 07:44:12 +0530
Message-Id: <20180601021413.4031-1-rvarsha016@gmail.com> (sfid-20180601_041440_706513_83A37D21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the clang warning of extraneous parentheses, with the
following coccinelle script.

@@
identifier i;
expression e;
statement s;
@@
if (
-(i == e)
+i == e
 )
s

Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c
index 3a13d176b221..35e3b101e5cf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -159,7 +159,7 @@ u16 read_radio_reg(struct brcms_phy *pi, u16 addr)
 {
 	u16 data;
 
-	if ((addr == RADIO_IDCODE))
+	if (addr == RADIO_IDCODE)
 		return 0xffff;
 
 	switch (pi->pubpi.phy_type) {
-- 
2.17.0
