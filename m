Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35395 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbcEIMiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 08:38:54 -0400
Received: by mail-wm0-f53.google.com with SMTP id e201so135476049wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2016 05:38:53 -0700 (PDT)
From: Eduardo Abinader <eabinader@ocedo.com>
To: linux-wireless@vger.kernel.org
Cc: Eduardo Abinader <eduardo.abinader@riverbed.com>,
	ath9k-devel@lists.ath9k.org, kvalo@qca.qualcomm.com,
	ath9k-devel@qca.qualcomm.com
Subject: [PATCH] ath9k: allow tx99 for ar9002 based cards
Date: Mon,  9 May 2016 14:38:40 +0200
Message-Id: <1462797520-7239-1-git-send-email-eduardo.abinader@riverbed.com> (sfid-20160509_143857_050367_0016ECE8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As there is current support for ar9002 tx99 mode, just allow
to init debugfs and enable tx99.

Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
---
 drivers/net/wireless/ath/ath9k/tx99.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index ac4781f..6161536 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -266,7 +266,7 @@ static const struct file_operations fops_tx99_power = {
 
 void ath9k_tx99_init_debug(struct ath_softc *sc)
 {
-	if (!AR_SREV_9300_20_OR_LATER(sc->sc_ah))
+	if (!AR_SREV_9280_20_OR_LATER(sc->sc_ah))
 		return;
 
 	debugfs_create_file("tx99", S_IRUSR | S_IWUSR,
-- 
2.5.0

