Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from symlink.to.noone.org ([85.10.207.172]:51995 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZDZNWK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 09:22:10 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	me@bobcopeland.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] ath5k: Storage class should be before const qualifier
Date: Sun, 26 Apr 2009 14:58:40 +0200
Message-Id: <1240750720-9768-1-git-send-email-tklauser@distanz.ch> (sfid-20090426_152215_771800_52D1753E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 8e218fb24faef0bfe95bc91b3c05261e20439527 reverted the previous
patch (commit 925be8a3077351edbf2b59ca689105df214a0792).

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the
beginning of the declaration specifiers in a declaration is an
obsolescent feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/net/wireless/ath5k/eeprom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/eeprom.c b/drivers/net/wireless/ath5k/eeprom.c
index c0fb3b0..c85429d 100644
--- a/drivers/net/wireless/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath5k/eeprom.c
@@ -640,9 +640,9 @@ ath5k_eeprom_init_11bg_2413(struct ath5k_hw *ah, unsigned int mode, int offset)
 static inline void
 ath5k_get_pcdac_intercepts(struct ath5k_hw *ah, u8 min, u8 max, u8 *vp)
 {
-	const static u16 intercepts3[] =
+	static const u16 intercepts3[] =
 		{ 0, 5, 10, 20, 30, 50, 70, 85, 90, 95, 100 };
-	const static u16 intercepts3_2[] =
+	static const u16 intercepts3_2[] =
 		{ 0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 };
 	const u16 *ip;
 	int i;
-- 
1.6.2.4

