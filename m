Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41028 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757893AbbLBLpS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 06:45:18 -0500
From: Colin King <colin.king@canonical.com>
To: kernel-tram@lists.ubuntu.com, Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: only lock and unlock fws if fws is not null
Date: Wed,  2 Dec 2015 11:45:10 +0000
Message-Id: <1449056710-9776-1-git-send-email-colin.king@canonical.com> (sfid-20151202_124546_206692_A6EA055E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

There is a null ptr check for fws to set bcmc_credit_check, however,
there a lock and unlock on fws should only performed if fwts is
also not null to also avoid a potential null pointer deference.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 086cac3..092f33f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1609,10 +1609,11 @@ static int brcmf_fws_notify_bcmc_credit_support(struct brcmf_if *ifp,
 {
 	struct brcmf_fws_info *fws = ifp->drvr->fws;
 
-	brcmf_fws_lock(fws);
-	if (fws)
+	if (fws) {
+		brcmf_fws_lock(fws);
 		fws->bcmc_credit_check = true;
-	brcmf_fws_unlock(fws);
+		brcmf_fws_unlock(fws);
+	}
 	return 0;
 }
 
-- 
2.6.2

