Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51860 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0IOTou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 15:44:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: correct sparse warnings
Date: Wed, 15 Sep 2010 15:40:12 -0400
Message-Id: <1284579612-20570-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/libertas/cfg.c
drivers/net/wireless/libertas/cfg.c:493:19: warning: cast to restricted __le16
  CHECK   drivers/net/wireless/libertas/mesh.c
drivers/net/wireless/libertas/mesh.c:577:16: warning: incorrect type in assignment (different base types)
drivers/net/wireless/libertas/mesh.c:577:16:    expected restricted __le32 [addressable] [assigned] [usertype] id
drivers/net/wireless/libertas/mesh.c:577:16:    got bool

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/cfg.c  |    6 ++----
 drivers/net/wireless/libertas/mesh.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 317f086..1bbdb14 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -481,7 +481,6 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 	struct cmd_ds_802_11_scan_rsp *scanresp = (void *)resp;
 	int bsssize;
 	const u8 *pos;
-	u16 nr_sets;
 	const u8 *tsfdesc;
 	int tsfsize;
 	int i;
@@ -490,12 +489,11 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
 	bsssize = get_unaligned_le16(&scanresp->bssdescriptsize);
-	nr_sets = le16_to_cpu(scanresp->nr_sets);
 
 	lbs_deb_scan("scan response: %d BSSs (%d bytes); resp size %d bytes\n",
-			nr_sets, bsssize, le16_to_cpu(resp->size));
+			scanresp->nr_sets, bsssize, le16_to_cpu(resp->size));
 
-	if (nr_sets == 0) {
+	if (scanresp->nr_sets == 0) {
 		ret = 0;
 		goto done;
 	}
diff --git a/drivers/net/wireless/libertas/mesh.c b/drivers/net/wireless/libertas/mesh.c
index 194762a..acf3bf6 100644
--- a/drivers/net/wireless/libertas/mesh.c
+++ b/drivers/net/wireless/libertas/mesh.c
@@ -574,7 +574,7 @@ int lbs_mesh_bt_set_inverted(struct lbs_private *priv, bool inverted)
 	memset(&cmd, 0, sizeof(cmd));
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_BT_ACCESS_SET_INVERT);
-	cmd.id = !!inverted;
+	cmd.id = cpu_to_le32(!!inverted);
 
 	ret = lbs_cmd_with_response(priv, CMD_BT_ACCESS, &cmd);
 
-- 
1.7.2.3

