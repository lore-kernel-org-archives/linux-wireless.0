Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1HIJOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:20 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:20 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 26/40] wl12xx: add wl1271_cmd_role_start_ibss()
Date: Tue,  9 Aug 2011 12:13:39 +0300
Message-Id: <1312881233-9366-27-git-send-email-eliad@wizery.com> (sfid-20110809_111432_208484_8D36E79B)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add wl1271_cmd_role_start_ibss() implementation and defintion.
This function is used in order to start the IBSS role.

Stopping the IBSS is done by using the same api as stop STA,
so there is no need for a separate function.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |   61 +++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/cmd.h |    1 +
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 41dee4f..b8d6848 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -767,12 +767,73 @@ out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
 
+int wl1271_cmd_role_start_ibss(struct wl1271 *wl)
+{
+	struct wl1271_cmd_role_start *cmd;
+	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl1271_debug(DEBUG_CMD, "cmd role start ibss %d", wl->role_id);
+
+	cmd->role_id = wl->role_id;
+	if (wl->band == IEEE80211_BAND_5GHZ)
+		cmd->band |= WL1271_BAND_5GHZ;
+	cmd->channel = wl->channel;
+	cmd->ibss.basic_rate_set = cpu_to_le32(wl->basic_rate_set);
+	cmd->ibss.beacon_interval = cpu_to_le16(wl->beacon_int);
+	cmd->ibss.dtim_interval = bss_conf->dtim_period;
+	cmd->ibss.ssid_type = WL1271_SSID_TYPE_ANY;
+	cmd->ibss.ssid_len = wl->ssid_len;
+	memcpy(cmd->ibss.ssid, wl->ssid, wl->ssid_len);
+	memcpy(cmd->ibss.bssid, wl->bssid, ETH_ALEN);
+	cmd->sta.local_rates = cpu_to_le32(wl->rate_set);
+
+	if (wl->sta_hlid == WL1271_INVALID_LINK_ID) {
+		ret = wl1271_allocate_link(wl, &wl->sta_hlid);
+		if (ret)
+			goto out_free;
+	}
+	cmd->ibss.hlid = wl->sta_hlid;
+	cmd->ibss.remote_rates = cpu_to_le32(wl->rate_set);
+
+	wl1271_debug(DEBUG_CMD, "role start: roleid=%d, hlid=%d, session=%d "
+		     "basic_rate_set: 0x%x, remote_rates: 0x%x",
+		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
+		     wl->basic_rate_set, wl->rate_set);
+
+	wl1271_debug(DEBUG_CMD, "wl->bssid = %pM", wl->bssid);
+
+	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to initiate cmd role enable");
+		goto err_hlid;
+	}
+
+	goto out_free;
+
+err_hlid:
+	/* clear links on error. */
+	wl1271_free_link(wl, &wl->sta_hlid);
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
 
 /**
  * send test command to firmware
  *
  * @wl: wl struct
  * @buf: buffer containing the command, with all headers, must work with dma
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 2ae2d73..e62345b 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -41,12 +41,13 @@ int wl1271_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
 int wl1271_cmd_role_start_dev(struct wl1271 *wl);
 int wl1271_cmd_role_stop_dev(struct wl1271 *wl);
 int wl1271_cmd_role_start_sta(struct wl1271 *wl);
 int wl1271_cmd_role_stop_sta(struct wl1271 *wl);
 int wl1271_cmd_role_start_ap(struct wl1271 *wl);
 int wl1271_cmd_role_stop_ap(struct wl1271 *wl);
+int wl1271_cmd_role_start_ibss(struct wl1271 *wl);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
 int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
-- 
1.7.6.401.g6a319

