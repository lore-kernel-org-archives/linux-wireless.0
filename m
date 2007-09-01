Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4413 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbXIAEhZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:37:25 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id BFF17618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:37:23 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 33/35] Remove international roaming support
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:37:23 -0400
Message-ID: <20070901043723.2498.17595.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's broken beyond repair and legally dubious.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |  119 ++++-----------------------------------
 drivers/net/wireless/at76_usb.h |    8 ---
 2 files changed, 13 insertions(+), 114 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index dc56bf4..2c8ad54 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1310,9 +1310,8 @@ exit:
  * at76_start_scan - start a scan
  *
  * @use_essid - use the configured ESSID in non passive mode
- * @ir_step - international roaming step (0, 1)
  */
-static int at76_start_scan(struct at76_priv *priv, int use_essid, int ir_step)
+static int at76_start_scan(struct at76_priv *priv, int use_essid)
 {
 	struct at76_req_scan scan;
 
@@ -1331,10 +1330,7 @@ static int at76_start_scan(struct at76_priv *priv, int use_essid, int ir_step)
 
 	/* atmelwlandriver differs between scan type 0 and 1 (active/passive)
 	   For ad-hoc mode, it uses type 0 only. */
-	if (priv->international_roaming == IR_ON && ir_step == 0)
-		scan.scan_type = SCAN_TYPE_PASSIVE;
-	else
-		scan.scan_type = priv->scan_mode;
+	scan.scan_type = priv->scan_mode;
 
 	/* INFO: For probe_delay, not multiplying by 1024 as this will be
 	   slightly less than min_channel_time
@@ -1342,11 +1338,7 @@ static int at76_start_scan(struct at76_priv *priv, int use_essid, int ir_step)
 	scan.min_channel_time = cpu_to_le16(priv->scan_min_time);
 	scan.max_channel_time = cpu_to_le16(priv->scan_max_time);
 	scan.probe_delay = cpu_to_le16(priv->scan_min_time * 1000);
-
-	if (priv->international_roaming == IR_ON && ir_step == 1)
-		scan.international_scan = 0;
-	else
-		scan.international_scan = priv->international_roaming;
+	scan.international_scan = 0;
 
 	/* other values are set to 0 for type 0 */
 
@@ -1373,7 +1365,7 @@ static int at76_start_monitor(struct at76_priv *priv)
 
 	scan.channel = priv->channel;
 	scan.scan_type = SCAN_TYPE_PASSIVE;
-	scan.international_scan = priv->international_roaming;
+	scan.international_scan = 0;
 
 	ret = at76_set_card_command(priv->udev, CMD_SCAN, &scan, sizeof(scan));
 	if (ret >= 0)
@@ -1976,14 +1968,10 @@ static int at76_iw_handler_set_freq(struct net_device *netdev,
 		 * either that or an invalid frequency was
 		 * provided by the user */
 		ret = -EINVAL;
-	else if (!priv->international_roaming) {
-		if (!(priv->domain->channel_map & (1 << (chan - 1)))) {
-			printk(KERN_INFO
-			       "%s: channel %d not allowed for domain %s "
-			       "(and international_roaming is OFF)\n",
-			       priv->netdev->name, chan, priv->domain->name);
-			ret = -EINVAL;
-		}
+	else if (!(priv->domain->channel_map & (1 << (chan - 1)))) {
+		printk(KERN_INFO "%s: channel %d not allowed for domain %s\n",
+		       priv->netdev->name, chan, priv->domain->name);
+		ret = -EINVAL;
 	}
 
 	if (ret == -EIWCOMMIT) {
@@ -3002,59 +2990,6 @@ static int at76_iw_get_scan_mode(struct net_device *netdev,
 	return 0;
 }
 
-static int at76_set_iroaming(struct at76_priv *priv, int onoff)
-{
-	int ret = 0;
-
-	memset(&priv->mib_buf, 0, sizeof(struct set_mib_buffer));
-	priv->mib_buf.type = MIB_MAC_MGMT;
-	priv->mib_buf.size = 1;
-	priv->mib_buf.index =
-	    offsetof(struct mib_mac_mgmt, multi_domain_capability_enabled);
-	priv->mib_buf.data[0] = onoff;
-	ret = at76_set_mib(priv, &priv->mib_buf);
-	if (ret < 0)
-		err("%s: set_mib (intl_roaming_enable) failed: %d",
-		    priv->netdev->name, ret);
-
-	return ret;
-}
-
-static int at76_iw_set_intl_roaming(struct net_device *netdev,
-				    struct iw_request_info *info, char *name,
-				    char *extra)
-{
-	struct at76_priv *priv = netdev_priv(netdev);
-	int val = *((int *)name);
-	int ret = -EIWCOMMIT;
-
-	at76_dbg(DBG_IOCTL, "%s: AT76_SET_INTL_ROAMING - mode %s",
-		 netdev->name, (val == IR_OFF) ? "off" :
-		 (val == IR_ON) ? "on" : "<invalid>");
-
-	if (val != IR_OFF && val != IR_ON)
-		ret = -EINVAL;
-	else {
-		if (priv->international_roaming != val) {
-			priv->international_roaming = val;
-			at76_set_iroaming(priv, val);
-		}
-	}
-
-	return ret;
-}
-
-static int at76_iw_get_intl_roaming(struct net_device *netdev,
-				    struct iw_request_info *info,
-				    union iwreq_data *wrqu, char *extra)
-{
-	struct at76_priv *priv = netdev_priv(netdev);
-	int *param = (int *)extra;
-
-	param[0] = priv->international_roaming;
-	return 0;
-}
-
 #define AT76_SET_HANDLER(h, f) [h - SIOCIWFIRST] = (iw_handler) f
 
 /* Standard wireless handlers */
@@ -3105,8 +3040,6 @@ static const iw_handler at76_priv_handlers[] = {
 	AT76_SET_PRIV(AT76_GET_SCAN_TIMES, at76_iw_get_scan_times),
 	AT76_SET_PRIV(AT76_SET_SCAN_MODE, at76_iw_set_scan_mode),
 	AT76_SET_PRIV(AT76_GET_SCAN_MODE, at76_iw_get_scan_mode),
-	AT76_SET_PRIV(AT76_SET_INTL_ROAMING, at76_iw_set_intl_roaming),
-	AT76_SET_PRIV(AT76_GET_INTL_ROAMING, at76_iw_get_intl_roaming),
 };
 
 /* Names and arguments of private wireless handlers */
@@ -3146,12 +3079,6 @@ static const struct iw_priv_args at76_priv_args[] = {
 
 	{AT76_GET_SCAN_MODE,
 	 0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "get_scan_mode"},
-
-	{AT76_SET_INTL_ROAMING,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "set_intl_scan"},
-
-	{AT76_GET_INTL_ROAMING,
-	 0, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, "get_intl_scan"}
 };
 
 static const struct iw_handler_def at76_handler_def = {
@@ -3805,21 +3732,8 @@ static void at76_dwork_get_scan(struct work_struct *work)
 		at76_dump_bss_table(priv);
 	switch (priv->scan_runs) {
 
-	case 1:
-		WARN_ON(!priv->international_roaming);
-		ret = at76_start_scan(priv, 0, 0);
-		if (ret < 0)
-			err("%s: %s: start_scan (IR) failed with %d",
-			    priv->netdev->name, __func__, ret);
-		at76_dbg(DBG_MGMT_TIMER,
-			 "%s:%d: starting mgmt_timer for %d ticks",
-			 __func__, __LINE__, SCAN_POLL_INTERVAL);
-		schedule_delayed_work(&priv->dwork_get_scan,
-				      SCAN_POLL_INTERVAL);
-		break;
-
 	case 2:
-		ret = at76_start_scan(priv, 0, 1);
+		ret = at76_start_scan(priv, 0);
 		if (ret < 0)
 			err("%s: %s: start_scan (ANY) failed with %d",
 			    priv->netdev->name, __func__, ret);
@@ -3997,12 +3911,11 @@ static int at76_startup_device(struct at76_priv *priv)
 		 TX_RATE_AUTO ? "auto" : "<invalid>", priv->auth_mode);
 	at76_dbg(DBG_PARAMS,
 		 "%s param: pm_mode %d pm_period %d auth_mode %s "
-		 "scan_times %d %d scan_mode %s international_roaming %d",
+		 "scan_times %d %d scan_mode %s",
 		 priv->netdev->name, priv->pm_mode, priv->pm_period,
 		 priv->auth_mode == WLAN_AUTH_OPEN ? "open" : "shared_secret",
 		 priv->scan_min_time, priv->scan_max_time,
-		 priv->scan_mode == SCAN_TYPE_ACTIVE ? "active" : "passive",
-		 priv->international_roaming);
+		 priv->scan_mode == SCAN_TYPE_ACTIVE ? "active" : "passive");
 
 	memset(ccfg, 0, sizeof(struct at76_card_config));
 	ccfg->promiscuous_mode = 0;
@@ -4075,10 +3988,6 @@ static int at76_startup_device(struct at76_priv *priv)
 	if (ret < 0)
 		return ret;
 
-	ret = at76_set_iroaming(priv, priv->international_roaming);
-	if (ret < 0)
-		return ret;
-
 	at76_set_monitor_mode(priv);
 
 	if (at76_debug & DBG_MIB) {
@@ -4132,11 +4041,11 @@ static void at76_work_start_scan(struct work_struct *work)
 	 * otherwise simply rely on at76_bss_list_timeout */
 	if (priv->scan_state == SCAN_IN_PROGRESS) {
 		at76_free_bss_list(priv);
-		priv->scan_runs = priv->international_roaming ? 1 : 2;
+		priv->scan_runs = 2;
 	} else
 		priv->scan_runs = 3;
 
-	ret = at76_start_scan(priv, 1, 1);
+	ret = at76_start_scan(priv, 1);
 
 	if (ret < 0)
 		err("%s: %s: start_scan failed with %d",
@@ -5364,8 +5273,6 @@ static int at76_init_new_device(struct at76_priv *priv,
 	/* init. netdev->dev_addr */
 	memcpy(netdev->dev_addr, priv->mac_addr, ETH_ALEN);
 
-	/* initializing */
-	priv->international_roaming = IR_OFF;
 	priv->channel = DEF_CHANNEL;
 	priv->iw_mode = IW_MODE_INFRA;
 	memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 65f56c7..c8cff99 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -55,9 +55,6 @@ enum board_type {
 /* scan mode (0 - active, 1 - passive) */
 #define AT76_SET_SCAN_MODE		(SIOCIWFIRSTPRIV + 8)
 #define AT76_GET_SCAN_MODE		(SIOCIWFIRSTPRIV + 9)
-/* international roaming (0 - disabled, 1 - enabled */
-#define AT76_SET_INTL_ROAMING		(SIOCIWFIRSTPRIV + 10)
-#define AT76_GET_INTL_ROAMING		(SIOCIWFIRSTPRIV + 11)
 
 #define CMD_STATUS_IDLE				0x00
 #define CMD_STATUS_COMPLETE			0x01
@@ -114,10 +111,6 @@ enum board_type {
 #define AT76_PM_ON		2
 #define AT76_PM_SMART		3
 
-/* international roaming state */
-#define IR_OFF			0
-#define IR_ON			1
-
 struct hwcfg_r505 {
 	u8 cr39_values[14];
 	u8 reserved1[14];
@@ -535,7 +528,6 @@ struct at76_priv {
 	u32 pm_period;		/* power management period in microseconds */
 
 	struct reg_domain const *domain;	/* reg domain description */
-	int international_roaming;
 
 	/* iwspy support */
 	spinlock_t spy_spinlock;
