Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33727 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab1KTH6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:58:03 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so5187685bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:58:03 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 13/13] ath5k: Optimize ath5k_cw_validate
Date: Sun, 20 Nov 2011 09:56:28 +0200
Message-Id: <1321775788-12520-14-git-send-email-mickflemm@gmail.com> (sfid-20111120_085808_475229_CFEC65FF)
In-Reply-To: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Optimize ath5k_cw_validate by using the classic (X & (X - 1)) == 0
check to see if a number is power of 2.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/qcu.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index e50e64d..cdbaad7 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -111,6 +111,16 @@ ath5k_cw_validate(u16 cw_req)
 	u32 cw = 1;
 	cw_req = min(cw_req, (u16)1023);
 
+	/* Check if cw_req + 1 a power of 2 */
+	if (!((cw_req + 1) & cw_req))
+		return cw_req;
+
+	/* Check if cw_req is a power of 2 */
+	if (!(cw_req & (cw_req - 1)))
+		return cw_req - 1;
+
+	/* If none of the above is correct
+	 * find the closest power of 2 */
 	while (cw < cw_req)
 		cw = (cw << 1) | 1;
 
-- 
1.7.8.rc1

