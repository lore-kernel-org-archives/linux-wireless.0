Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:55895 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab2AZMmo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:42:44 -0500
Received: by mail-gy0-f177.google.com with SMTP id z22so185868ghb.36
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:42:43 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <hostap@lists.shmoo.com>
Cc: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <johannes@sipsolutions.net>,
	<coelho@ti.com>, <assaf@ti.com>, <yoni.divinsky@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>
Subject: [RFC 5/7] nl80211: add support to enable TX on oper-channel
Date: Thu, 26 Jan 2012 14:41:27 +0200
Message-Id: <1327581689-22090-6-git-send-email-victorg@ti.com> (sfid-20120126_134246_471951_FCD17A24)
In-Reply-To: <1327581689-22090-1-git-send-email-victorg@ti.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once a channel has been passes the channel availability
check (CAC) the ap may start the tx with
wpa_driver_nl80211_enable_dfs_tx().

Add wpa_driver_nl80211_enable_dfs_tx() + init drv_ops.

Signed-off-by: Boris Presman <boris.presman@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 src/drivers/driver_nl80211.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/src/drivers/driver_nl80211.c b/src/drivers/driver_nl80211.c
index f1e6ca2..e3d6a3c 100644
--- a/src/drivers/driver_nl80211.c
+++ b/src/drivers/driver_nl80211.c
@@ -8627,6 +8627,32 @@ static int nl80211_set_p2p_powersave(void *priv, int legacy_ps, int opp_ps,
 }
 
 
+static int wpa_driver_nl80211_enable_dfs_tx(void *priv)
+{
+	struct i802_bss *bss = priv;
+	struct wpa_driver_nl80211_data *drv = bss->drv;
+	struct nl_msg *msg;
+	int ret;
+
+	wpa_printf(MSG_DEBUG, "nl80211: Enable DFS tx");
+
+	msg = nlmsg_alloc();
+	if (!msg)
+		return -1;
+
+	nl80211_cmd(bss->drv, msg, 0, NL80211_CMD_DFS_ENABLE_TX);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
+
+	ret = send_and_recv_msgs(drv, msg, NULL, NULL);
+	if (ret == 0)
+		return 0;
+	wpa_printf(MSG_DEBUG, "nl80211: Failed to enable DFS tx: "
+		   "%d (%s)", ret, strerror(-ret));
+nla_put_failure:
+	return -1;
+}
+
+
 #ifdef CONFIG_TDLS
 
 static int nl80211_send_tdls_mgmt(void *priv, const u8 *dst, u8 action_code,
@@ -8920,6 +8946,7 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.set_rekey_info = nl80211_set_rekey_info,
 	.poll_client = nl80211_poll_client,
 	.set_p2p_powersave = nl80211_set_p2p_powersave,
+	.enable_tx = wpa_driver_nl80211_enable_dfs_tx,
 #ifdef CONFIG_TDLS
 	.send_tdls_mgmt = nl80211_send_tdls_mgmt,
 	.tdls_oper = nl80211_tdls_oper,
-- 
1.7.5.4

