Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56745 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaFAMi1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2014 08:38:27 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so3205831wib.17
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jun 2014 05:38:26 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "John W. Linville" <linville@tuxdriver.com>,
	Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: libertas: cmd.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 14:39:20 +0200
Message-Id: <1401626360-15505-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140601_143831_357112_3E2AF54C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/libertas/cmd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index aaa2973..0387a5b 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1111,6 +1111,7 @@ int lbs_set_radio(struct lbs_private *priv, u8 preamble, u8 radio_on)
 
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.control = 0;
 
 	/* Only v8 and below support setting the preamble */
 	if (priv->fwrelease < 0x09000000) {
-- 
1.7.10.4

