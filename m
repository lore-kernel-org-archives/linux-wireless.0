Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from symlink.to.noone.org ([85.10.207.172]:47491 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522AbZBIWeB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 17:34:01 -0500
Date: Mon, 9 Feb 2009 23:06:53 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: proski@gnu.org, hermes@gibson.dropbear.id.au,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	kernel-janitors@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] orinoco: Storage class should be before const qualifier
Message-ID: <20090209220653.GA8023@xenon.distanz.ch> (sfid-20090209_233409_757115_6C91AF47)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/net/wireless/orinoco/orinoco.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 45a04fa..32482c3 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -431,7 +431,7 @@ struct fw_info {
 	u16 pda_size;
 };
 
-const static struct fw_info orinoco_fw[] = {
+static const struct fw_info orinoco_fw[] = {
 	{ NULL, "agere_sta_fw.bin", "agere_ap_fw.bin", 0x00390000, 1000 },
 	{ NULL, "prism_sta_fw.bin", "prism_ap_fw.bin", 0, 1024 },
 	{ "symbol_sp24t_prim_fw", "symbol_sp24t_sec_fw", NULL, 0x00003100, 512 }
-- 
1.5.6.5

