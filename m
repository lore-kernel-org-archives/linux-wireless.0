Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:17950 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425Ab2CAJdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 04:33:06 -0500
Date: Thu, 1 Mar 2012 10:22:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: endian bug in mwifiex_drv_change_adhoc_chan()
Message-ID: <20120301072230.GC7152@elgon.mountain> (sfid-20120301_103314_337400_EBD39687)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In mwifiex_drv_change_adhoc_chan() we pass channel to
mwifiex_bss_ioctl_ibss_channel() which sets the high 16 bits.  This
works on little endian systems but not on big endian ones.  I've changed
mwifiex_drv_change_adhoc_chan() to use a 16 bit variable.  This matches
the other functions in the file.

I considered changing mwifiex_change_adhoc_chan() as well but it turns
out that the function isn't implemented so I just removed the
definition.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 52810b1..60a6919 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -909,10 +909,9 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 			 struct mwifiex_802_11_ssid *req_ssid);
 int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 				struct mwifiex_user_scan_cfg *scan_req);
-int mwifiex_change_adhoc_chan(struct mwifiex_private *priv, int channel);
 int mwifiex_set_radio(struct mwifiex_private *priv, u8 option);
 
-int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel);
+int mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel);
 
 int mwifiex_set_encode(struct mwifiex_private *priv, const u8 *key,
 		       int key_len, u8 key_index, int disable);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index b0fbf5d..652d299 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -599,7 +599,7 @@ static int mwifiex_bss_ioctl_ibss_channel(struct mwifiex_private *priv,
  *          - Start/Join the IBSS
  */
 int
-mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
+mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, u16 channel)
 {
 	int ret;
 	struct mwifiex_bss_info bss_info;
@@ -636,7 +636,7 @@ mwifiex_drv_change_adhoc_chan(struct mwifiex_private *priv, int channel)
 	ret = mwifiex_deauthenticate(priv, ssid_bssid.bssid);
 
 	ret = mwifiex_bss_ioctl_ibss_channel(priv, HostCmd_ACT_GEN_SET,
-					     (u16 *) &channel);
+					     &channel);
 
 	/* Do specific SSID scanning */
 	if (mwifiex_request_scan(priv, &bss_info.ssid)) {
