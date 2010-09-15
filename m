Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55203 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab0IOUoK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 16:44:10 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: make patch apply again.
Date: Wed, 15 Sep 2010 22:43:34 +0200
Message-Id: <1284583415-11506-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284583415-11506-1-git-send-email-hauke@hauke-m.de>
References: <1284583415-11506-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 ...k-Add-debugfs-interface-to-dump-registers.patch |   25 ++++++++++---------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch b/crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch
index d236c46..a6c6d3e 100644
--- a/crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch
+++ b/crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch
@@ -42,13 +42,10 @@ Signed-off-by: Felix Fietkau <nbd@openwrt.org>
  #ifdef CONFIG_ATH_DEBUG
  
  static ssize_t read_file_debug(struct file *file, char __user *user_buf,
-@@ -893,7 +907,38 @@ static ssize_t write_file_regval(struct 
- static const struct file_operations fops_regval = {
- 	.read = read_file_regval,
- 	.write = write_file_regval,
--	.open = ath9k_debugfs_open,
-+};
-+
+@@ -908,6 +922,40 @@ static const struct file_operations fops
+ 	.llseek = default_llseek,/* read accesses f_pos */
+ };
+ 
 +#define REGDUMP_LINE_SIZE	20
 +#define REGDUMP_NUM_REGS	(0x16bd4 / 4 + 1)
 +#define REGDUMP_DATA_LEN	(REGDUMP_NUM_REGS * REGDUMP_LINE_SIZE + 1)
@@ -79,10 +76,14 @@ Signed-off-by: Felix Fietkau <nbd@openwrt.org>
 +	.open = open_file_regdump,
 +	.read = ath9k_debugfs_read_buf,
 +	.release = ath9k_debugfs_release_buf,
- 	.owner = THIS_MODULE
- };
- 
-@@ -961,6 +1006,11 @@ int ath9k_init_debug(struct ath_hw *ah)
++	.owner = THIS_MODULE,
++	.llseek = default_llseek,/* read accesses f_pos */
++};
++
+ int ath9k_init_debug(struct ath_hw *ah)
+ {
+ 	struct ath_common *common = ath9k_hw_common(ah);
+@@ -972,6 +1020,11 @@ int ath9k_init_debug(struct ath_hw *ah)
  		goto err;
  
  	sc->debug.regidx = 0;
@@ -94,7 +95,7 @@ Signed-off-by: Felix Fietkau <nbd@openwrt.org>
  	return 0;
  err:
  	ath9k_exit_debug(ah);
-@@ -972,6 +1022,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
+@@ -983,6 +1036,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
  	struct ath_common *common = ath9k_hw_common(ah);
  	struct ath_softc *sc = (struct ath_softc *) common->priv;
  
-- 
1.7.0.4

