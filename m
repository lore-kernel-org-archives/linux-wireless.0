Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59133 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbaFAMnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2014 08:43:20 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so3209109wib.17
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jun 2014 05:43:19 -0700 (PDT)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: rt2x00: rt2x00mac.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 14:44:13 +0200
Message-Id: <1401626653-15842-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20140601_144339_463058_6FB6B8C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index a87ee9b..98f440a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -798,6 +798,8 @@ int rt2x00mac_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
 
 	setup.tx = tx_ant;
 	setup.rx = rx_ant;
+	setup.rx_chain_num = 0;
+	setup.tx_chain_num = 0;
 
 	rt2x00lib_config_antenna(rt2x00dev, setup);
 
-- 
1.7.10.4

