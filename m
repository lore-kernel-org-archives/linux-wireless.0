Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33944 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaIJNgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:36:04 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 22/22] wil6210: fix PTR_ERR() usage after initialization to constant
Date: Wed, 10 Sep 2014 16:34:51 +0300
Message-ID: <1410356091-19219-23-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153610_513157_F8F89262)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported by coccinelle:

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   6a5d088a923854569e20eac4f3f569926d5911ec
commit: b7cde47009640b88cb3629ee7078a43bc2642459 [18/80] wil6210: convert debugfs to the table mode

coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/wil6210/debugfs.c:327:17-24: ERROR: PTR_ERR applied after initialization to constant on line 304

vim +327 drivers/net/wireless/ath/wil6210/debugfs.c

   298                                          struct dentry *dbg, void *base,
   299                                          const struct dbg_off * const tbl)
   300  {
   301          int i;
   302
   303          for (i = 0; tbl[i].name; i++) {

 > 304                  struct dentry *f = NULL;
   305
   306                  switch (tbl[i].type) {
   307                  case doff_u32:
   308                          f = debugfs_create_u32(tbl[i].name, tbl[i].mode, dbg,
   309                                                 base + tbl[i].off);
   310                          break;
   311                  case doff_x32:
   312                          f = debugfs_create_x32(tbl[i].name, tbl[i].mode, dbg,
   313                                                 base + tbl[i].off);
   314                          break;
   315                  case doff_ulong:
   316                          f = wil_debugfs_create_ulong(tbl[i].name, tbl[i].mode,
   317                                                       dbg, base + tbl[i].off);
   318                          break;
   319                  case doff_io32:
   320                          f = wil_debugfs_create_iomem_x32(tbl[i].name,
   321                                                           tbl[i].mode, dbg,
   322                                                           base + tbl[i].off);
   323                          break;
   324                  }
   325                  if (IS_ERR_OR_NULL(f))
   326                          wil_err(wil, "Create file \"%s\": err %ld\n",

 > 327                                  tbl[i].name, PTR_ERR(f));
   328          }
   329  }
   330

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 21dc437..eb2204e 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -308,7 +308,7 @@ static void wil6210_debugfs_init_offset(struct wil6210_priv *wil,
 	int i;
 
 	for (i = 0; tbl[i].name; i++) {
-		struct dentry *f = NULL;
+		struct dentry *f;
 
 		switch (tbl[i].type) {
 		case doff_u32:
@@ -328,6 +328,8 @@ static void wil6210_debugfs_init_offset(struct wil6210_priv *wil,
 							 tbl[i].mode, dbg,
 							 base + tbl[i].off);
 			break;
+		default:
+			f = ERR_PTR(-EINVAL);
 		}
 		if (IS_ERR_OR_NULL(f))
 			wil_err(wil, "Create file \"%s\": err %ld\n",
-- 
1.9.1

