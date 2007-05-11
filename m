Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXEKDBi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 23:01:38 -0400
Subject: [PATCH 13/19] libertas: Purge non-mesh ioctls
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 23:04:39 -0400
Message-Id: <1178852680.8607.41.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/README  |  516 -------------
 drivers/net/wireless/libertas/ioctl.c | 1349 ---------------------------------
 drivers/net/wireless/libertas/join.c  |  135 ----
 drivers/net/wireless/libertas/join.h  |    4 -
 drivers/net/wireless/libertas/wext.c  |  274 -------
 drivers/net/wireless/libertas/wext.h  |   85 --
 6 files changed, 0 insertions(+), 2363 deletions(-)

If it's too big to get through vger, please see:

http://people.redhat.com/dcbw/libertas-patches/0013-libertas-Purge-non-mesh-ioctls.patch

diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
index 688da4c..3785772 100644
--- a/drivers/net/wireless/libertas/README
+++ b/drivers/net/wireless/libertas/README
@@ -40,64 +40,11 @@ NAME
 SYNOPSIS
 	iwpriv <ethX> <command> [sub-command] ...
 
-	iwpriv ethX version
-	iwpriv ethX scantype [sub-command]
-	iwpriv ethX getSNR <n>
-	iwpriv ethX getNF <n>
-	iwpriv ethX getRSSI <n>
-	iwpriv ethX setrxant <n>
-	iwpriv ethX getrxant
-	iwpriv ethX settxant <n>
-	iwpriv ethX gettxant
-	iwpriv ethX authalgs <n>
-	iwpriv ethX pre-TBTT <n>
-	iwpriv ethX 8021xauthalgs <n>
-	iwpriv ethX encryptionmode <n>
 	iwpriv ethX setregioncode <n>
 	iwpriv ethX getregioncode
-	iwpriv ethX setbcnavg <n>
-	iwpriv ethX getbcnavg
-	iwpriv ethX setdataavg <n>
-	iwpriv ethX setlisteninter <n>
-	iwpriv ethX getlisteninter
-	iwpriv ethX setmultipledtim <n>
-	iwpriv ethX getmultipledtim
-	iwpriv ethX atimwindow <n>
-	iwpriv ethX deauth
-	iwpriv ethX adhocstop
-	iwpriv ethX radioon
-	iwpriv ethX radiooff
-	iwpriv ethX reasso-on
-	iwpriv ethX reasso-off
-	iwpriv ethX scanmode  [sub-command]
-	iwpriv ethX setwpaie <n>
-	iwpriv ethX wlanidle-off
-	iwpriv ethX wlanidle-on
-	iwpriv ethX getcis
-	iwpriv ethX getlog
-	iwpriv ethX getadhocstatus
-	iwpriv ethX adhocgrate <n>
-
-Version 4 Command:
-	iwpriv ethX inactvityto <n>
-	iwpriv ethX sleeppd <n>
-	iwpriv ethX enable11d <n>
-	iwpriv ethX tpccfg <n>
-	iwpriv ethX powercfg <n>
-	iwpriv ethX setafc <n>
-	iwpriv ethX getafc
 
 Version 5 Command:
 	iwpriv ethX ledgpio <n>
-	iwpriv ethX scanprobes <n>
-	iwpriv ethX lolisteninter <n>
-	iwpriv ethX rateadapt <n> <m>
-	iwpriv ethX txcontrol <n>
-	iwpriv ethX psnullinterval <n>
-	iwpriv ethX prescan <n>
-	iwpriv ethX getrxinfo
-	iwpriv ethX gettxrate
-	iwpriv ethX beaconinterval
 
 BT Commands:
 	The blinding table (BT) contains a list of mac addresses that should be
@@ -150,114 +97,6 @@ DESCRIPTION
 	The ethX parameter specifies the network device that is to be used to
 		perform this command on. it could be eth0, eth1 etc.
 
-version
-	This is used to get the current version of the driver and the firmware.
-
-scantype
-	This command is used to set the scan type to be used by the driver in
-	the scan command. This setting will not be used while performing a scan
-	for a specific SSID, as it is always done with scan type being active.
-
-	where the sub-commands are: -
-			active 	-- to set the scan type to active
-			passive -- to set the scan type to passive
-			get 	-- to get the scan type set in the driver
-
-getSNR
-	This command gets the average and non average value of Signal to Noise
-	Ratio of Beacon and Data.
-
-	where value is:-
-			0 	-- Beacon non-average.
-			1 	-- Beacon average.
-			2 	-- Data non-average.
-			3 	-- Data average.
-
-	If no value is given, all four values are returned in the order mentioned
-	above.
-
-	Note: This command is available only when STA is connected.
-
-getRSSI
-	This command gets the average and non average value os Receive Signal
-	Strength of Beacon and Data.
-
-	where value is:-
-			0 	-- Beacon non-average.
-			1 	-- Beacon average.
-			2 	-- Data non-average.
-			3 	-- Data average.
-
-	Note: This command is available only when STA is connected.
-
-getNF
-	This command gets the average and non average value of Noise Floor of
-	Beacon and Data.
-
-	where value is:-
-			0 	-- Beacon non-average.
-			1 	-- Beacon average.
-			2 	-- Data non-average.
-			3 	-- Data average.
-
-	Note: This command is available only when STA is connected.
-
-setrxant
-	This command is used to set the mode for Rx antenna.
-
-	The options that can be sent are:-
-			1 	-- Antenna 1.
-			2 	-- Antenna 2.
-			0xFFFF 	-- Diversity.
-
-	Usage:
-		iwpriv ethX setrxant 0x01: select Antenna 1.
-
-getrxant
-	This command is used to get the mode for Rx antenna.
-
-
-settxant
-	This command is used to set the mode for Tx antenna.
-		The options that can be sent are:-
-			1 	-- Antenna 1.
-			2 	-- Antenna 2.
-			0xFFFF 	-- Diversity.
-	Usage:
-		iwpriv ethX settxant 0x01: select Antenna 1.
-
-gettxant
-	This command is used to get the mode for Tx antenna.
-
-authalgs
-	This command is used by the WPA supplicant to set the authentication
-	algorithms in the station.
-
-8021xauthalgs
-	This command is used by the WPA supplicant to set the 8021.x authentication algorithm type
-	station.
-
-	where values can be:-
-			1 	-- None
-			2 	-- LEAP
-			4 	-- TLS
-			8 	-- TTLs
-			16	-- MD5
-
-
-encryptionmode
-	This command is used by the WPA supplicant to set the encryption algorithm.
-
-	where values can be:-
-			0 	-- NONE
-			1 	-- WEP40
-			2 	-- TKIP
-			3 	-- CCMP
-			4 	-- WEP104
-
-pre-TBTT
-	This command is used to set pre-TBTT time period where value is in microseconds.
-
 setregioncode
 	This command is used to set the region code in the station.
 	where value is 'region code' for various regions like
@@ -270,114 +109,6 @@ getregioncode
 	This command is used to get the region code information set in the
 	station.
 
-setbcnavg
-	Set the weighting factor for calculating RSSI.
-
-getbcnavg
-	Get weighting factor for calculating RSSI.
-
-setdataavg
-	Set the weighting factor for calculating SNR.
-
-setlisteninter
-	This command is used to set the listen interval in the
-	station.
-
-	where the value ranges between 1 - 255
-
-getlisteninter
-	This command is used to get the listen interval value set in the
-	station.
-
-setmultipledtim
-	This command is used to set the multiple dtim value in the
-	station.
-		where the value is 1,2,3,4,5,0xfffe
-		0xfffe means the firmware will use listen interval in association
-		command for waking up
-
-getmultipledtim
-	This command is used to get the multiple dtim value set in the station.
-
-atimwindow
-	This command is used to set the atim value in the
-	station.
-
-	where the value ranges between 0 - 50
-
-deauth
-	This command is used to send the de-authentication to the AP with which
-	the station is associated. This command is valid only when
-	station is in Infrastructure mode.
-
-	Note: This command is available only when STA is connected.
-
-adhocstop
-	This command is used to stop beacon transmission from the station and
-	go into idle state in ad-hoc mode.
-
-	Note: This command is available only when STA is connected.
-
-radioon
-	This command is used to turn on the RF antenna.
-
-radiooff
-	This command is sued to turn off the RF antenna.
-
-scanmode
-	This command is used to set the station to scan for either IBSS
-	networks or BSS networks or both BSS and IBSS networks. This
-	command can be used with sub commands,
-
-	where the value for
-			bss 	-- Scan All the BSS networks.
-			ibss 	-- Scan All the IBSS networks.
-			any 	-- Scan both BSS and IBSS networks.
-
-
-
-setwpaie
-	This command is used by WPA supplicant to send the WPA-IE to the driver.
-
-wlanidle-off
-	This command is used to get into idle state.
-
-	Note: This command is available only when STA is connected.
-
-wlanidle-on
-	This command is used to get off the idle state.
-
-	Note: This command is available only when STA is connected.
-
-
-getlog
-	This command is used to get the 802.11 statistics available in the
-		station.
-
-	Note: This command is available only when STA is connected.
-
-getadhocstatus
-	This command is used to get the ad-hoc Network Status.
-
-	The various status codes are:
-		AdhocStarted
-		AdhocJoined
-		AdhocIdle
-		InfraMode
-		AutoUnknownMode
-
-	Note: This command is available only when STA is connected.
-
-adhocgrate
-	This command is used to enable(1) g_rate, Disable(0) g_rate
-	and request(2) the status which g_rate is disabled/enabled,
-	for Ad-hoc creator.
-
-	where value is:-
-		0	-- Disabled
-		1	-- Enabled
-		2	-- Get
-
 ledgpio
 	This command is used to set/get LEDs.
 
@@ -400,253 +131,6 @@ ledgpio
 	Note: LED0 is invalid
 	Note: Maximum Number of LEDs are 16.
 
-inactivityto
-	This command is used by the host to set/get the inactivity timeout value,
-	which specifies when WLAN device is put to sleep.
-
-	Usage:
-		iwpriv ethX inactivityto [<timeout>]
-
-	where the parameter are:
-		timeout: timeout value in milliseconds.
-
-	Example:
-		iwpriv eth1 inactivityto
-			"get the timeout value"
-
-		iwpriv eth1 inactivityto X
-			"set timeout value to X ms"
-
-
-sleeppd
-	This command is used to configure the sleep period of the WLAN device.
-
-	Usage:
-		iwpriv ethX sleeppd [<sleep period>]
-
-	where the parameter are:
-		Period: sleep period in milliseconds. Range 10~60.
-
-	Example:
-		iwpriv eth1 sleeppd 10
-			"set period as 10 ms"
-		iwpriv eth1 sleeppd
-			"get the sleep period configuration"
-
-enable11d
-	This command is used to control 11d
-	where value is:-
-		1	-- Enabled
-		0	-- Disabled
-		2	-- Get
-
-
-
-
-tpccfg
-	Enables or disables automatic transmit power control.
-
-	The first parameter turns this feature on (1) or off (0).  When turning
-	on, the user must also supply four more parameters in the following
-	order:
-		-UseSNR (Use SNR (in addition to PER) for TPC algorithm),
-		-P0 (P0 power level for TPC),
-		-P1 (P1 power level for TPC),
-		-P2 (P2 power level for TPC).
-
-	Usage:
-		iwpriv ethX tpccfg: Get current configuration
-		iwpriv ethX tpccfg 0: disable auto TPC
-		iwpriv ethX tpccfg 0x01 0x00 0x05 0x0a 0x0d: enable auto TPC; do not use SNR;
-							     P0=0x05; P1=0x0a; P2=0x0d;
-		iwpriv ethX tpccfg 0x01 0x01 0x05 0x0a 0x0d: enable auto TPC; use SNR;
-							     P0=0x05; P1=0x0a; P2=0x0d.
-
-powercfg
-	Enables or disables power adaptation.
-
-	The first parameter turns this feature on (1) or off (0).  When turning
-	on, the user must also supply three more parameters in the following
-	order:
-		-P0 (P0 power level for Power Adaptation),
-		-P1 (P1 power level for Power Adaptation),
-		-P2 (P2 power level for Power Adaptation).
-
-	Usage:
-		iwpriv ethX powercfg: Get current configuration
-		iwpriv ethX powercfg 0: disable power adaptation
-		iwpriv ethX powercfg 1 0x0d 0x0f 0x12: enable power adaptation;
-						       P0=0x0d; P1=0x0f; P2=0x12.
-
-getafc
-	This command returns automatic frequency control parameters.  It returns
-	three integers:
-		-P0: automatic is on (1), or off (0),
-		-P1: current timing offset in PPM (part per million), and
-		-P2: current frequency offset in PPM.
-
-setafc
-	Set automatic frequency control options.
-
-	The first parameter turns automatic on (1) or off (0).
-	The user must supply two more parameters in either case, in the following
-  order:
-
-  When auto is on:
-
-		-P0 (automatic adjustment frequency threshold in PPM),
-		-P1 (automatic adjustment period in beacon period),
-
-  When auto is off:
-
-		-P0 (manual adjustment timing offset in PPM), and
-		-P1 (manual adjustment frequency offset in PPM).
-
-	Usage:
-		iwpriv ethX setafc 0 10 10: manual adjustment, both timing and frequcncy
-    offset are 10 PPM.
-
-		iwpriv ethX setafc 1 10 10 enable afc, automatic adjustment,
-    frequency threshold 10 PPM, for every 10 beacon periods.
-
-
-
-scanprobes
-	This command sets number of probe requests per channel.
-
-	Usage:
-		iwpriv ethX scanprobes 3 (set scan probes to 3)
-		iwpriv ethX scanprobes   (get scan probes)
-
-lolisteninter
-	This command sets the value of listen interval.
-
-	Usage:
-	iwpriv ethX lolisteninter 234 (set the lolisteninter to 234)
-	iwpriv ethX lolisteninter     (get the lolisteninter value)
-
-rateadapt
-	This command sets the data rates bitmap.
-	Where <n>
-		0: Disable auto rate adapt
-		1: Enable auto rate adapt
-
-	      <m>
-		 data rate bitmap
-			Bit	Data rate
-			0	1 Mbps
-			1	2 Mbps
-			2	5.5 Mbps
-			3	11 Mbps
-			4	Reserved
-			5	6 Mbps
-			6	9 Mbps
-			7	12 Mbps
-			8	18 Mbps
-			9	24 Mbps
-			10	36 Mbps
-			11	48 Mbps
-			12	54 Mbps
-			12-15	Reserved
-
-	Usage:
-	iwpriv ethX rateadapt
-			read the currect data rate setting
-	iwpriv ethX rateadapt 1 0x07
-			enable auto data rate adapt and
-			data rates are 1Mbps, 2Mbsp and 5.5Mbps
-
-
-txcontrol
-	This command is used to set the Tx rate, ack policy, and retry limit on a per packet basis.
-
-	Where value <n> is:
-	    if bit[4] == 1:
-		bit[3:0]        -- 0   1   2   3   4   5   6   7   8   9   10   11   12   13-16
-		Data Rate(Mbps) -- 1   2   5.5 11  Rsv 6   9   12  18  24  36   48   54   Rsv
-
-	    bit[12:8]
-		if bit[12] == 1, bit[11:8] specifies the Tx retry limit.
-
-	    bit[14:13] specifies per packet ack policy:
-		bit[14:13]
-		     1  0	use immediate ack policy for this packet
-		     1  1       use no ack policy for this packet
-		     0  x	use the per-packet ack policy setting
-
-	Usage:
-	iwpriv ethX txcontrol 0x7513
-			Use no-ack policy, 5 retires for Tx, 11Mbps rate
-
-
-
-psnullinterval
-	This command is used to set/request NULL package interval for Power Save
-	under infrastructure mode.
-
-	where value is:-
-		-1	-- Disabled
-		n>0	-- Set interval as n (seconds)
-
-prescan
-	This command is used to enable (1)/disable(0) auto prescan before assoicate to the ap
-
-	where value is:-
-		0	-- Disabled
-		1	-- Enabled
-		2       -- Get
-
-getrxinfo
-	This command gets non average value of Signal to Noise Ratio of Data and rate index.
-
-	The following table shows RateIndex and Rate
-
-		     RateIndex	Data rate
-			0	1 Mbps
-			1	2 Mbps
-			2	5.5 Mbps
-			3	11 Mbps
-			4	Reserved
-			5	6 Mbps
-			6	9 Mbps
-			7	12 Mbps
-			8	18 Mbps
-			9	24 Mbps
-			10	36 Mbps
-			11	48 Mbps
-			12	54 Mbps
-			13-15	Reserved
-
-gettxrate
-	This command gets current Tx rate index of the first packet associated with Rate Adaptation.
-
-	The following table shows RateIndex and Rate
-
-		     RateIndex	Data rate
-			0	1 Mbps
-			1	2 Mbps
-			2	5.5 Mbps
-			3	11 Mbps
-			4	Reserved
-			5	6 Mbps
-			6	9 Mbps
-			7	12 Mbps
-			8	18 Mbps
-			9	24 Mbps
-			10	36 Mbps
-			11	48 Mbps
-			12	54 Mbps
-			13-15	Reserved
-
-bcninterval
-	This command is used to sets beacon interval in adhoc mode when an argument is given, and gets current adhoc
-	beacon interval when no argument is given. The valid beacon interval is between 20 - 1000,
-	default beacon interval is 100.
-
-	Usage:
-		iwpriv ethX bcninterval 100  (set adhoc beacon interval to 100)
-		iwpriv ethX bcninterval      (get adhoc beacon interval)
-
 fwt_add
 	This command is used to insert an entry into the FWT table. The list of
 	parameters must follow the following structure:
diff --git a/drivers/net/wireless/libertas/ioctl.c b/drivers/net/wireless/libertas/ioctl.c
index 636a089..42dfd45 100644
--- a/drivers/net/wireless/libertas/ioctl.c
+++ b/drivers/net/wireless/libertas/ioctl.c
@@ -27,95 +27,6 @@
 
 #define WAIT_FOR_SCAN_RRESULT_MAX_TIME (10 * HZ)
 
-static int setrxantenna(wlan_private * priv, int mode)
-{
-	int ret = 0;
-	wlan_adapter *adapter = priv->adapter;
-
-	if (mode != RF_ANTENNA_1 && mode != RF_ANTENNA_2
-	    && mode != RF_ANTENNA_AUTO) {
-		return -EINVAL;
-	}
-
-	adapter->rxantennamode = mode;
-
-	lbs_pr_debug(1, "SET RX Antenna mode to 0x%04x\n", adapter->rxantennamode);
-
-	ret = libertas_prepare_and_send_command(priv, cmd_802_11_rf_antenna,
-				    cmd_act_set_rx,
-				    cmd_option_waitforrsp, 0,
-				    &adapter->rxantennamode);
-	return ret;
-}
-
-static int settxantenna(wlan_private * priv, int mode)
-{
-	int ret = 0;
-	wlan_adapter *adapter = priv->adapter;
-
-	if ((mode != RF_ANTENNA_1) && (mode != RF_ANTENNA_2)
-	    && (mode != RF_ANTENNA_AUTO)) {
-		return -EINVAL;
-	}
-
-	adapter->txantennamode = mode;
-
-	lbs_pr_debug(1, "SET TX Antenna mode to 0x%04x\n", adapter->txantennamode);
-
-	ret = libertas_prepare_and_send_command(priv, cmd_802_11_rf_antenna,
-				    cmd_act_set_tx,
-				    cmd_option_waitforrsp, 0,
-				    &adapter->txantennamode);
-
-	return ret;
-}
-
-static int getrxantenna(wlan_private * priv, char *buf)
-{
-	int ret = 0;
-	wlan_adapter *adapter = priv->adapter;
-
-	// clear it, so we will know if the value
-	// returned below is correct or not.
-	adapter->rxantennamode = 0;
-
-	ret = libertas_prepare_and_send_command(priv, cmd_802_11_rf_antenna,
-				    cmd_act_get_rx,
-				    cmd_option_waitforrsp, 0, NULL);
-
-	if (ret) {
-		LEAVE();
-		return ret;
-	}
-
-	lbs_pr_debug(1, "Get Rx Antenna mode:0x%04x\n", adapter->rxantennamode);
-
-	return sprintf(buf, "0x%04x", adapter->rxantennamode) + 1;
-}
-
-static int gettxantenna(wlan_private * priv, char *buf)
-{
-	int ret = 0;
-	wlan_adapter *adapter = priv->adapter;
-
-	// clear it, so we will know if the value
-	// returned below is correct or not.
-	adapter->txantennamode = 0;
-
-	ret = libertas_prepare_and_send_command(priv, cmd_802_11_rf_antenna,
-				    cmd_act_get_tx,
-				    cmd_option_waitforrsp, 0, NULL);
-
-	if (ret) {
-		LEAVE();
-		return ret;
-	}
-
-	lbs_pr_debug(1, "Get Tx Antenna mode:0x%04x\n", adapter->txantennamode);
-
-	return sprintf(buf, "0x%04x", adapter->txantennamode) + 1;
-}
-
 static int wlan_set_region(wlan_private * priv, u16 region_code)
 {
 	int i;
@@ -144,852 +55,6 @@ static int wlan_set_region(wlan_private * priv, u16 region_code)
 	return 0;
 }
 
-/**
- *  @brief Get/Set Firmware wakeup method
- *
- *  @param priv		A pointer to wlan_private structure
- *  @param wrq	   	A pointer to user data
- *  @return 	   	0--success, otherwise fail
- */
-static int wlan_txcontrol(wlan_private * priv, struct iwreq *wrq)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int data;
-	ENTER();
-
-	if ((int)wrq->u.data.length == 0) {
-		if (copy_to_user
-		    (wrq->u.data.pointer, &adapter->pkttxctrl, sizeof(u32))) {
-			lbs_pr_alert("copy_to_user failed!\n");
-			return -EFAULT;
-		}
-	} else {
-		if ((int)wrq->u.data.length > 1) {
-			lbs_pr_alert("ioctl too many args!\n");
-			return -EFAULT;
-		}
-		if (copy_from_user(&data, wrq->u.data.pointer, sizeof(int))) {
-			lbs_pr_alert("Copy from user failed\n");
-			return -EFAULT;
-		}
-
-		adapter->pkttxctrl = (u32) data;
-	}
-
-	wrq->u.data.length = 1;
-
-	LEAVE();
-	return 0;
-}
-
-/**
- *  @brief Get/Set NULL Package generation interval
- *
- *  @param priv		A pointer to wlan_private structure
- *  @param wrq	   	A pointer to user data
- *  @return 	   	0--success, otherwise fail
- */
-static int wlan_null_pkt_interval(wlan_private * priv, struct iwreq *wrq)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int data;
-	ENTER();
-
-	if ((int)wrq->u.data.length == 0) {
-		data = adapter->nullpktinterval;
-
-		if (copy_to_user(wrq->u.data.pointer, &data, sizeof(int))) {
-			lbs_pr_alert( "copy_to_user failed!\n");
-			return -EFAULT;
-		}
-	} else {
-		if ((int)wrq->u.data.length > 1) {
-			lbs_pr_alert( "ioctl too many args!\n");
-			return -EFAULT;
-		}
-		if (copy_from_user(&data, wrq->u.data.pointer, sizeof(int))) {
-			lbs_pr_debug(1, "Copy from user failed\n");
-			return -EFAULT;
-		}
-
-		adapter->nullpktinterval = data;
-	}
-
-	wrq->u.data.length = 1;
-
-	LEAVE();
-	return 0;
-}
-
-static int wlan_get_rxinfo(wlan_private * priv, struct iwreq *wrq)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int data[2];
-	ENTER();
-	data[0] = adapter->SNR[TYPE_RXPD][TYPE_NOAVG];
-	data[1] = adapter->rxpd_rate;
-	if (copy_to_user(wrq->u.data.pointer, data, sizeof(int) * 2)) {
-		lbs_pr_debug(1, "Copy to user failed\n");
-		return -EFAULT;
-	}
-	wrq->u.data.length = 2;
-	LEAVE();
-	return 0;
-}
-
-static int wlan_get_snr(wlan_private * priv, struct iwreq *wrq)
-{
-	int ret = 0;
-	wlan_adapter *adapter = priv->adapter;
-	int data[4];
-
-	ENTER();
-	memset(data, 0, sizeof(data));
-	if (wrq->u.data.length) {
-		if (copy_from_user(data, wrq->u.data.pointer,
-		     min_t(size_t, wrq->u.data.length, 4) * sizeof(int)))
-			return -EFAULT;
-	}
-	if ((wrq->u.data.length == 0) || (data[0] == 0) || (data[0] == 1)) {
-		if (adapter->connect_status == libertas_connected) {
-			ret = libertas_prepare_and_send_command(priv,
-						    cmd_802_11_rssi,
-						    0,
-						    cmd_option_waitforrsp,
-						    0, NULL);
-
-			if (ret) {
-				LEAVE();
-				return ret;
-			}
-		}
-	}
-
-	if (wrq->u.data.length == 0) {
-		data[0] = adapter->SNR[TYPE_BEACON][TYPE_NOAVG];
-		data[1] = adapter->SNR[TYPE_BEACON][TYPE_AVG];
-		data[2] = adapter->SNR[TYPE_RXPD][TYPE_NOAVG];
-		data[3] = adapter->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
-		if (copy_to_user(wrq->u.data.pointer, data, sizeof(int) * 4))
-			return -EFAULT;
-		wrq->u.data.length = 4;
-	} else if (data[0] == 0) {
-		data[0] = adapter->SNR[TYPE_BEACON][TYPE_NOAVG];
-		if (copy_to_user(wrq->u.data.pointer, data, sizeof(int)))
-			return -EFAULT;
-		wrq->u.data.length = 1;
-	} else if (data[0] == 1) {
-		data[0] = adapter->SNR[TYPE_BEACON][TYPE_AVG];
-		if (copy_to_user(wrq->u.data.pointer, data, sizeof(int)))
-			return -EFAULT;
-		wrq->u.data.length = 1;
-	} else if (data[0] == 2) {
-		data[0] = adapter->SNR[TYPE_RXPD][TYPE_NOAVG];
-		if (copy_to_user(wrq->u.data.pointer, data, sizeof(int)))
-			return -EFAULT;
-		wrq->u.data.length = 1;
-	} else if (data[0] == 3) {
-		data[0] = adapter->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
-		if (copy_to_user(wrq->u.data.pointer, data, sizeof(int)))
-			return -EFAULT;
-		wrq->u.data.length = 1;
-	} else
-		return -ENOTSUPP;
-
-	LEAVE();
-	return 0;
-}
-
-static int wlan_beacon_interval(wlan_private * priv, struct iwreq *wrq)
-{
-	int data;
-	wlan_adapter *adapter = priv->adapter;
-
-	if (wrq->u.data.length > 0) {
-		if (copy_from_user(&data, wrq->u.data.pointer, sizeof(int)))
-			return -EFAULT;
-
-		lbs_pr_debug(1, "WLAN SET BEACON INTERVAL: %d\n", data);
-		if ((data > MRVDRV_MAX_BEACON_INTERVAL)
-		    || (data < MRVDRV_MIN_BEACON_INTERVAL))
-			return -ENOTSUPP;
-		adapter->beaconperiod = data;
-	}
-	data = adapter->beaconperiod;
-	if (copy_to_user(wrq->u.data.pointer, &data, sizeof(int)))
-		return -EFAULT;
-
-	wrq->u.data.length = 1;
-
-	return 0;
-}
-
-static int wlan_get_rssi(wlan_private * priv, struct iwreq *wrq)
-{
-	int ret = 0;
-	wlan_adapter *adapter = priv->adapter;
-	int temp;
-	int data = 0;
-	int *val;
-
-	ENTER();
-	data = SUBCMD_DATA(wrq);
-	if ((data == 0) || (data == 1)) {
-		ret = libertas_prepare_and_send_command(priv,
-					    cmd_802_11_rssi,
-					    0, cmd_option_waitforrsp,
-					    0, NULL);
-		if (ret) {
-			LEAVE();
-			return ret;
-		}
-	}
-
-	switch (data) {
-	case 0:
-
-		temp = CAL_RSSI(adapter->SNR[TYPE_BEACON][TYPE_NOAVG],
-				adapter->NF[TYPE_BEACON][TYPE_NOAVG]);
-		break;
-	case 1:
-		temp = CAL_RSSI(adapter->SNR[TYPE_BEACON][TYPE_AVG],
-				adapter->NF[TYPE_BEACON][TYPE_AVG]);
-		break;
-	case 2:
-		temp = CAL_RSSI(adapter->SNR[TYPE_RXPD][TYPE_NOAVG],
-				adapter->NF[TYPE_RXPD][TYPE_NOAVG]);
-		break;
-	case 3:
-		temp = CAL_RSSI(adapter->SNR[TYPE_RXPD][TYPE_AVG] / AVG_SCALE,
-				adapter->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE);
-		break;
-	default:
-		return -ENOTSUPP;
-	}
-	val = (int *)wrq->u.name;
-	*val = temp;
-
-	LEAVE();
-	return 0;
-}
-
-static int wlan_get_nf(wlan_private * priv, struct iwreq *wrq)
-{
-	int ret = 0;
-	wlan_adapter *adapter = priv->adapter;
-	int temp;
-	int data = 0;
-	int *val;
-
-	data = SUBCMD_DATA(wrq);
-	if ((data == 0) || (data == 1)) {
-		ret = libertas_prepare_and_send_command(priv,
-					    cmd_802_11_rssi,
-					    0, cmd_option_waitforrsp,
-					    0, NULL);
-
-		if (ret) {
-			LEAVE();
-			return ret;
-		}
-	}
-
-	switch (data) {
-	case 0:
-		temp = adapter->NF[TYPE_BEACON][TYPE_NOAVG];
-		break;
-	case 1:
-		temp = adapter->NF[TYPE_BEACON][TYPE_AVG];
-		break;
-	case 2:
-		temp = adapter->NF[TYPE_RXPD][TYPE_NOAVG];
-		break;
-	case 3:
-		temp = adapter->NF[TYPE_RXPD][TYPE_AVG] / AVG_SCALE;
-		break;
-	default:
-		return -ENOTSUPP;
-	}
-
-	temp = CAL_NF(temp);
-
-	lbs_pr_debug(1, "%s: temp = %d\n", __FUNCTION__, temp);
-	val = (int *)wrq->u.name;
-	*val = temp;
-	return 0;
-}
-
-static int wlan_get_txrate_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int *pdata;
-	struct iwreq *wrq = (struct iwreq *)req;
-	int ret = 0;
-	adapter->txrate = 0;
-	lbs_pr_debug(1, "wlan_get_txrate_ioctl\n");
-	ret = libertas_prepare_and_send_command(priv, cmd_802_11_tx_rate_query,
-				    cmd_act_get, cmd_option_waitforrsp,
-				    0, NULL);
-	if (ret)
-		return ret;
-
-	pdata = (int *)wrq->u.name;
-	*pdata = (int)adapter->txrate;
-	return 0;
-}
-
-static int wlan_get_adhoc_status_ioctl(wlan_private * priv, struct iwreq *wrq)
-{
-	char status[64];
-	wlan_adapter *adapter = priv->adapter;
-
-	memset(status, 0, sizeof(status));
-
-	switch (adapter->mode) {
-	case IW_MODE_ADHOC:
-		if (adapter->connect_status == libertas_connected) {
-			if (adapter->adhoccreate)
-				memcpy(&status, "AdhocStarted", sizeof(status));
-			else
-				memcpy(&status, "AdhocJoined", sizeof(status));
-		} else {
-			memcpy(&status, "AdhocIdle", sizeof(status));
-		}
-		break;
-	case IW_MODE_INFRA:
-		memcpy(&status, "Inframode", sizeof(status));
-		break;
-	default:
-		memcpy(&status, "AutoUnknownmode", sizeof(status));
-		break;
-	}
-
-	lbs_pr_debug(1, "status = %s\n", status);
-	wrq->u.data.length = strlen(status) + 1;
-
-	if (wrq->u.data.pointer) {
-		if (copy_to_user(wrq->u.data.pointer,
-				 &status, wrq->u.data.length))
-			return -EFAULT;
-	}
-
-	LEAVE();
-	return 0;
-}
-
-/**
- *  @brief Set Auto prescan
- *  @param priv                 A pointer to wlan_private structure
- *  @param wrq			A pointer to iwreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_subcmd_setprescan_ioctl(wlan_private * priv, struct iwreq *wrq)
-{
-	int data;
-	wlan_adapter *adapter = priv->adapter;
-	int *val;
-
-	data = SUBCMD_DATA(wrq);
-	lbs_pr_debug(1, "WLAN_SUBCMD_SET_PRESCAN %d\n", data);
-	adapter->prescan = data;
-
-	val = (int *)wrq->u.name;
-	*val = data;
-	return 0;
-}
-
-static int wlan_set_multiple_dtim_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	struct iwreq *wrq = (struct iwreq *)req;
-	u32 mdtim;
-	int idata;
-	int ret = -EINVAL;
-
-	ENTER();
-
-	idata = SUBCMD_DATA(wrq);
-	mdtim = (u32) idata;
-	if (((mdtim >= MRVDRV_MIN_MULTIPLE_DTIM)
-	     && (mdtim <= MRVDRV_MAX_MULTIPLE_DTIM))
-	    || (mdtim == MRVDRV_IGNORE_MULTIPLE_DTIM)) {
-		priv->adapter->multipledtim = mdtim;
-		ret = 0;
-	}
-	if (ret)
-		lbs_pr_debug(1, "Invalid parameter, multipledtim not changed.\n");
-
-	LEAVE();
-	return ret;
-}
-
-static void adjust_mtu(wlan_private * priv)
-{
-	int mtu_increment = 0;
-
-	if (priv->adapter->linkmode == WLAN_LINKMODE_802_11)
-		mtu_increment += sizeof(struct ieee80211_hdr_4addr);
-
-	if (priv->adapter->radiomode == WLAN_RADIOMODE_RADIOTAP)
-		mtu_increment += max(sizeof(struct tx_radiotap_hdr),
-				     sizeof(struct rx_radiotap_hdr));
-	priv->wlan_dev.netdev->mtu = ETH_FRAME_LEN
-	    - sizeof(struct ethhdr)
-	    + mtu_increment;
-}
-
-/**
- *  @brief Set Link-Layer Layer mode
- *  @param priv                 A pointer to wlan_private structure
- *  @param req			A pointer to ifreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_set_linkmode_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	int mode;
-
-	mode = (int)((struct ifreq *)((u8 *) req + 4))->ifr_data;
-
-	switch (mode) {
-	case WLAN_LINKMODE_802_3:
-		priv->adapter->linkmode = mode;
-		break;
-	case WLAN_LINKMODE_802_11:
-		priv->adapter->linkmode = mode;
-		break;
-	default:
-		lbs_pr_info("usb8388-5: invalid link-layer mode (%#x)\n",
-		       mode);
-		return -EINVAL;
-		break;
-	}
-	lbs_pr_debug(1, "usb8388-5: link-layer mode is %#x\n", mode);
-
-	adjust_mtu(priv);
-
-	return 0;
-}
-
-/**
- *  @brief Set Radio header mode
- *  @param priv                 A pointer to wlan_private structure
- *  @param req			A pointer to ifreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_set_radiomode_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	int mode;
-
-	mode = (int)((struct ifreq *)((u8 *) req + 4))->ifr_data;
-
-	switch (mode) {
-	case WLAN_RADIOMODE_NONE:
-		priv->adapter->radiomode = mode;
-		break;
-	case WLAN_RADIOMODE_RADIOTAP:
-		priv->adapter->radiomode = mode;
-		break;
-	default:
-		lbs_pr_debug(1, "usb8388-5: invalid radio header mode (%#x)\n",
-		       mode);
-		return -EINVAL;
-	}
-	lbs_pr_debug(1, "usb8388-5: radio-header mode is %#x\n", mode);
-
-	adjust_mtu(priv);
-	return 0;
-}
-
-/**
- *  @brief Set Debug header mode
- *  @param priv                 A pointer to wlan_private structure
- *  @param req			A pointer to ifreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_set_debugmode_ioctl(wlan_private * priv, struct ifreq *req)
-{
-	priv->adapter->debugmode = (int)((struct ifreq *)
-					 ((u8 *) req + 4))->ifr_data;
-	return 0;
-}
-
-static int wlan_subcmd_getrxantenna_ioctl(wlan_private * priv,
-					  struct ifreq *req)
-{
-	int len;
-	char buf[8];
-	struct iwreq *wrq = (struct iwreq *)req;
-
-	lbs_pr_debug(1, "WLAN_SUBCMD_GETRXANTENNA\n");
-	len = getrxantenna(priv, buf);
-
-	wrq->u.data.length = len;
-	if (wrq->u.data.pointer) {
-		if (copy_to_user(wrq->u.data.pointer, &buf, len)) {
-			lbs_pr_debug(1, "CopyToUser failed\n");
-			return -EFAULT;
-		}
-	}
-
-	return 0;
-}
-
-static int wlan_subcmd_gettxantenna_ioctl(wlan_private * priv,
-					  struct ifreq *req)
-{
-	int len;
-	char buf[8];
-	struct iwreq *wrq = (struct iwreq *)req;
-
-	lbs_pr_debug(1, "WLAN_SUBCMD_GETTXANTENNA\n");
-	len = gettxantenna(priv, buf);
-
-	wrq->u.data.length = len;
-	if (wrq->u.data.pointer) {
-		if (copy_to_user(wrq->u.data.pointer, &buf, len)) {
-			lbs_pr_debug(1, "CopyToUser failed\n");
-			return -EFAULT;
-		}
-	}
-	return 0;
-}
-
-/**
- *  @brief Get the MAC TSF value from the firmware
- *
- *  @param priv         A pointer to wlan_private structure
- *  @param wrq          A pointer to iwreq structure containing buffer
- *                      space to store a TSF value retrieved from the firmware
- *
- *  @return             0 if successful; IOCTL error code otherwise
- */
-static int wlan_get_tsf_ioctl(wlan_private * priv, struct iwreq *wrq)
-{
-	u64 tsfval;
-	int ret;
-
-	ret = libertas_prepare_and_send_command(priv,
-				    cmd_get_tsf,
-				    0, cmd_option_waitforrsp, 0, &tsfval);
-
-	lbs_pr_debug(1, "IOCTL: Get TSF = 0x%016llx\n", tsfval);
-
-	if (ret != 0) {
-		lbs_pr_debug(1, "IOCTL: Get TSF; command exec failed\n");
-		ret = -EFAULT;
-	} else {
-		if (copy_to_user(wrq->u.data.pointer,
-				 &tsfval,
-				 min_t(size_t, wrq->u.data.length,
-				     sizeof(tsfval))) != 0) {
-
-			lbs_pr_debug(1, "IOCTL: Get TSF; Copy to user failed\n");
-			ret = -EFAULT;
-		} else {
-			ret = 0;
-		}
-	}
-	return ret;
-}
-
-/**
- *  @brief Get/Set adapt rate
- *  @param priv                 A pointer to wlan_private structure
- *  @param wrq			A pointer to iwreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_adapt_rateset(wlan_private * priv, struct iwreq *wrq)
-{
-	int ret;
-	wlan_adapter *adapter = priv->adapter;
-	int data[2];
-
-	memset(data, 0, sizeof(data));
-	if (!wrq->u.data.length) {
-		lbs_pr_debug(1, "Get ADAPT RATE SET\n");
-		ret = libertas_prepare_and_send_command(priv,
-					    cmd_802_11_rate_adapt_rateset,
-					    cmd_act_get,
-					    cmd_option_waitforrsp, 0, NULL);
-		data[0] = adapter->enablehwauto;
-		data[1] = adapter->ratebitmap;
-		if (copy_to_user(wrq->u.data.pointer, data, sizeof(int) * 2)) {
-			lbs_pr_debug(1, "Copy to user failed\n");
-			return -EFAULT;
-		}
-#define GET_TWO_INT	2
-		wrq->u.data.length = GET_TWO_INT;
-	} else {
-		lbs_pr_debug(1, "Set ADAPT RATE SET\n");
-		if (wrq->u.data.length > 2)
-			return -EINVAL;
-		if (copy_from_user
-		    (data, wrq->u.data.pointer,
-		     sizeof(int) * wrq->u.data.length)) {
-			lbs_pr_debug(1, "Copy from user failed\n");
-			return -EFAULT;
-		}
-
-		adapter->enablehwauto = data[0];
-		adapter->ratebitmap = data[1];
-		ret = libertas_prepare_and_send_command(priv,
-					    cmd_802_11_rate_adapt_rateset,
-					    cmd_act_set,
-					    cmd_option_waitforrsp, 0, NULL);
-	}
-	return ret;
-}
-
-/**
- *  @brief Get/Set inactivity timeout
- *  @param priv                 A pointer to wlan_private structure
- *  @param wrq			A pointer to iwreq structure
- *  @return 	   		0 --success, otherwise fail
- */
-static int wlan_inactivity_timeout(wlan_private * priv, struct iwreq *wrq)
-{
-	int ret;
-	int data = 0;
-	u16 timeout = 0;
-
-	ENTER();
-	if (wrq->u.data.length > 1)
-		return -ENOTSUPP;
-
-	if (wrq->u.data.length == 0) {
-		/* Get */
-		ret = libertas_prepare_and_send_command(priv,
-					    cmd_802_11_inactivity_timeout,
-					    cmd_act_get,
-					    cmd_option_waitforrsp, 0,
-					    &timeout);
-		data = timeout;
-		if (copy_to_user(wrq->u.data.pointer, &data, sizeof(int))) {
-			lbs_pr_debug(1, "Copy to user failed\n");
-			return -EFAULT;
-		}
-	} else {
-		/* Set */
-		if (copy_from_user(&data, wrq->u.data.pointer, sizeof(int))) {
-			lbs_pr_debug(1, "Copy from user failed\n");
-			return -EFAULT;
-		}
-
-		timeout = data;
-		ret = libertas_prepare_and_send_command(priv,
-					    cmd_802_11_inactivity_timeout,
-					    cmd_act_set,
-					    cmd_option_waitforrsp, 0,
-					    &timeout);
-	}
-
-	wrq->u.data.length = 1;
-
-	LEAVE();
-	return ret;
-}
-
-static int wlan_do_getlog_ioctl(wlan_private * priv, struct iwreq *wrq)
-{
-	int ret;
-	char buf[GETLOG_BUFSIZE - 1];
-	wlan_adapter *adapter = priv->adapter;
-
-	lbs_pr_debug(1, " GET STATS\n");
-
-	ret = libertas_prepare_and_send_command(priv, cmd_802_11_get_log,
-				    0, cmd_option_waitforrsp, 0, NULL);
-
-	if (ret) {
-		return ret;
-	}
-
-	if (wrq->u.data.pointer) {
-		sprintf(buf, "\n  mcasttxframe %u failed %u retry %u "
-			"multiretry %u framedup %u "
-			"rtssuccess %u rtsfailure %u ackfailure %u\n"
-			"rxfrag %u mcastrxframe %u fcserror %u "
-			"txframe %u wepundecryptable %u ",
-			adapter->logmsg.mcasttxframe,
-			adapter->logmsg.failed,
-			adapter->logmsg.retry,
-			adapter->logmsg.multiretry,
-			adapter->logmsg.framedup,
-			adapter->logmsg.rtssuccess,
-			adapter->logmsg.rtsfailure,
-			adapter->logmsg.ackfailure,
-			adapter->logmsg.rxfrag,
-			adapter->logmsg.mcastrxframe,
-			adapter->logmsg.fcserror,
-			adapter->logmsg.txframe,
-			adapter->logmsg.wepundecryptable);
-		wrq->u.data.length = strlen(buf) + 1;
-		if (copy_to_user(wrq->u.data.pointer, buf, wrq->u.data.length)) {
-			lbs_pr_debug(1, "Copy to user failed\n");
-			return -EFAULT;
-		}
-	}
-
-	return 0;
-}
-
-static int wlan_scan_type_ioctl(wlan_private * priv, struct iwreq *wrq)
-{
-	u8 buf[12];
-	u8 *option[] = { "active", "passive", "get", };
-	int i, max_options = (sizeof(option) / sizeof(option[0]));
-	int ret = 0;
-	wlan_adapter *adapter = priv->adapter;
-
-	if (priv->adapter->enable11d) {
-		lbs_pr_debug(1, "11D: Cannot set scantype when 11D enabled\n");
-		return -EFAULT;
-	}
-
-	memset(buf, 0, sizeof(buf));
-
-	if (copy_from_user(buf, wrq->u.data.pointer, min_t(size_t, sizeof(buf),
-							 wrq->u.data.length)))
-		return -EFAULT;
-
-	lbs_pr_debug(1, "Scan type Option = %s\n", buf);
-
-	buf[sizeof(buf) - 1] = '\0';
-
-	for (i = 0; i < max_options; i++) {
-		if (!strcmp(buf, option[i]))
-			break;
-	}
-
-	switch (i) {
-	case 0:
-		adapter->scantype = cmd_scan_type_active;
-		break;
-	case 1:
-		adapter->scantype = cmd_scan_type_passive;
-		break;
-	case 2:
-		wrq->u.data.length = strlen(option[adapter->scantype]) + 1;
-
-		if (copy_to_user(wrq->u.data.pointer,
-				 option[adapter->scantype],
-				 wrq->u.data.length)) {
-			lbs_pr_debug(1, "Copy to user failed\n");
-			ret = -EFAULT;
-		}
-
-		break;
-	default:
-		lbs_pr_debug(1, "Invalid Scan type Ioctl Option\n");
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-static int wlan_scan_mode_ioctl(wlan_private * priv, struct iwreq *wrq)
-{
-	wlan_adapter *adapter = priv->adapter;
-	u8 buf[12];
-	u8 *option[] = { "bss", "ibss", "any", "get" };
-	int i, max_options = (sizeof(option) / sizeof(option[0]));
-	int ret = 0;
-
-	ENTER();
-
-	memset(buf, 0, sizeof(buf));
-
-	if (copy_from_user(buf, wrq->u.data.pointer, min_t(size_t, sizeof(buf),
-							 wrq->u.data.length))) {
-		lbs_pr_debug(1, "Copy from user failed\n");
-		return -EFAULT;
-	}
-
-	lbs_pr_debug(1, "Scan mode Option = %s\n", buf);
-
-	buf[sizeof(buf) - 1] = '\0';
-
-	for (i = 0; i < max_options; i++) {
-		if (!strcmp(buf, option[i]))
-			break;
-	}
-
-	switch (i) {
-
-	case 0:
-		adapter->scanmode = cmd_bss_type_bss;
-		break;
-	case 1:
-		adapter->scanmode = cmd_bss_type_ibss;
-		break;
-	case 2:
-		adapter->scanmode = cmd_bss_type_any;
-		break;
-	case 3:
-
-		wrq->u.data.length = strlen(option[adapter->scanmode - 1]) + 1;
-
-		lbs_pr_debug(1, "Get Scan mode Option = %s\n",
-		       option[adapter->scanmode - 1]);
-
-		lbs_pr_debug(1, "Scan mode length %d\n", wrq->u.data.length);
-
-		if (copy_to_user(wrq->u.data.pointer,
-				 option[adapter->scanmode - 1],
-				 wrq->u.data.length)) {
-			lbs_pr_debug(1, "Copy to user failed\n");
-			ret = -EFAULT;
-		}
-		lbs_pr_debug(1, "GET Scan type Option after copy = %s\n",
-		       (char *)wrq->u.data.pointer);
-
-		break;
-
-	default:
-		lbs_pr_debug(1, "Invalid Scan mode Ioctl Option\n");
-		ret = -EINVAL;
-		break;
-	}
-
-	LEAVE();
-	return ret;
-}
-
-/**
- *  @brief Get/Set Adhoc G Rate
- *
- *  @param priv		A pointer to wlan_private structure
- *  @param wrq	   	A pointer to user data
- *  @return 	   	0--success, otherwise fail
- */
-static int wlan_do_set_grate_ioctl(wlan_private * priv, struct iwreq *wrq)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int data, data1;
-	int *val;
-
-	ENTER();
-
-	data1 = SUBCMD_DATA(wrq);
-	switch (data1) {
-	case 0:
-		adapter->adhoc_grate_enabled = 0;
-		break;
-	case 1:
-		adapter->adhoc_grate_enabled = 1;
-		break;
-	case 2:
-		break;
-	default:
-		return -EINVAL;
-	}
-	data = adapter->adhoc_grate_enabled;
-	val = (int *)wrq->u.name;
-	*val = data;
-	LEAVE();
-	return 0;
-}
-
 static inline int hex2int(char c)
 {
 	if (c >= '0' && c <= '9')
@@ -1752,36 +817,8 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 
 	lbs_pr_debug(1, "libertas_do_ioctl: ioctl cmd = 0x%x\n", cmd);
 	switch (cmd) {
-	case WLANSCAN_TYPE:
-		lbs_pr_debug(1, "Scan type Ioctl\n");
-		ret = wlan_scan_type_ioctl(priv, wrq);
-		break;
-
 	case WLAN_SETNONE_GETNONE:	/* set WPA mode on/off ioctl #20 */
 		switch (wrq->u.data.flags) {
-		case WLANDEAUTH:
-			lbs_pr_debug(1, "Deauth\n");
-			libertas_send_deauth(priv);
-			break;
-
-		case WLANADHOCSTOP:
-			lbs_pr_debug(1, "Adhoc stop\n");
-			ret = libertas_do_adhocstop_ioctl(priv);
-			break;
-
-		case WLANRADIOON:
-			wlan_radio_ioctl(priv, 1);
-			break;
-
-		case WLANRADIOOFF:
-			wlan_radio_ioctl(priv, 0);
-			break;
-		case WLANWLANIDLEON:
-			libertas_idle_on(priv);
-			break;
-		case WLANWLANIDLEOFF:
-			libertas_idle_off(priv);
-			break;
 		case WLAN_SUBCMD_BT_RESET:	/* bt_reset */
 			wlan_bt_reset_ioctl(priv);
 			break;
@@ -1791,81 +828,6 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 		}		/* End of switch */
 		break;
 
-	case WLAN_SETINT_GETINT:
-		/* The first 4 bytes of req->ifr_data is sub-ioctl number
-		 * after 4 bytes sits the payload.
-		 */
-		subcmd = (int)req->ifr_data;	//from iwpriv subcmd
-		switch (subcmd) {
-		case WLANNF:
-			ret = wlan_get_nf(priv, wrq);
-			break;
-		case WLANRSSI:
-			ret = wlan_get_rssi(priv, wrq);
-			break;
-		case WLANENABLE11D:
-			ret = libertas_cmd_enable_11d(priv, wrq);
-			break;
-		case WLANADHOCGRATE:
-			ret = wlan_do_set_grate_ioctl(priv, wrq);
-			break;
-		case WLAN_SUBCMD_SET_PRESCAN:
-			ret = wlan_subcmd_setprescan_ioctl(priv, wrq);
-			break;
-		}
-		break;
-
-	case WLAN_SETONEINT_GETONEINT:
-		switch (wrq->u.data.flags) {
-		case WLAN_BEACON_INTERVAL:
-			ret = wlan_beacon_interval(priv, wrq);
-			break;
-
-		case WLAN_LISTENINTRVL:
-			if (!wrq->u.data.length) {
-				int data;
-				lbs_pr_debug(1, "Get locallisteninterval value\n");
-#define GET_ONE_INT	1
-				data = adapter->locallisteninterval;
-				if (copy_to_user(wrq->u.data.pointer,
-						 &data, sizeof(int))) {
-					lbs_pr_debug(1, "Copy to user failed\n");
-					return -EFAULT;
-				}
-
-				wrq->u.data.length = GET_ONE_INT;
-			} else {
-				int data;
-				if (copy_from_user
-				    (&data, wrq->u.data.pointer, sizeof(int))) {
-					lbs_pr_debug(1, "Copy from user failed\n");
-					return -EFAULT;
-				}
-
-				lbs_pr_debug(1, "Set locallisteninterval = %d\n",
-				       data);
-#define MAX_U16_VAL	65535
-				if (data > MAX_U16_VAL) {
-					lbs_pr_debug(1, "Exceeds U16 value\n");
-					return -EINVAL;
-				}
-				adapter->locallisteninterval = data;
-			}
-			break;
-		case WLAN_TXCONTROL:
-			ret = wlan_txcontrol(priv, wrq);	//adds for txcontrol ioctl
-			break;
-
-		case WLAN_NULLPKTINTERVAL:
-			ret = wlan_null_pkt_interval(priv, wrq);
-			break;
-
-		default:
-			ret = -EOPNOTSUPP;
-			break;
-		}
-		break;
-
 	case WLAN_SETONEINT_GETNONE:
 		/* The first 4 bytes of req->ifr_data is sub-ioctl number
 		 * after 4 bytes sits the payload.
@@ -1876,62 +838,10 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 			subcmd = (int)req->ifr_data;	//from iwpriv subcmd
 
 		switch (subcmd) {
-		case WLAN_SUBCMD_SETRXANTENNA:	/* SETRXANTENNA */
-			idata = SUBCMD_DATA(wrq);
-			ret = setrxantenna(priv, idata);
-			break;
-		case WLAN_SUBCMD_SETTXANTENNA:	/* SETTXANTENNA */
-			idata = SUBCMD_DATA(wrq);
-			ret = settxantenna(priv, idata);
-			break;
-		case WLAN_SET_ATIM_WINDOW:
-			adapter->atimwindow = SUBCMD_DATA(wrq);
-			adapter->atimwindow = min_t(__u16, adapter->atimwindow, 50);
-			break;
-		case WLANSETBCNAVG:
-			adapter->bcn_avg_factor = SUBCMD_DATA(wrq);
-			if (adapter->bcn_avg_factor == 0)
-				adapter->bcn_avg_factor =
-				    DEFAULT_BCN_AVG_FACTOR;
-			if (adapter->bcn_avg_factor > DEFAULT_BCN_AVG_FACTOR)
-				adapter->bcn_avg_factor =
-				    DEFAULT_BCN_AVG_FACTOR;
-			break;
-		case WLANSETDATAAVG:
-			adapter->data_avg_factor = SUBCMD_DATA(wrq);
-			if (adapter->data_avg_factor == 0)
-				adapter->data_avg_factor =
-				    DEFAULT_DATA_AVG_FACTOR;
-			if (adapter->data_avg_factor > DEFAULT_DATA_AVG_FACTOR)
-				adapter->data_avg_factor =
-				    DEFAULT_DATA_AVG_FACTOR;
-			break;
 		case WLANSETREGION:
 			idata = SUBCMD_DATA(wrq);
 			ret = wlan_set_region(priv, (u16) idata);
 			break;
-
-		case WLAN_SET_LISTEN_INTERVAL:
-			idata = SUBCMD_DATA(wrq);
-			adapter->listeninterval = (u16) idata;
-			break;
-
-		case WLAN_SET_MULTIPLE_DTIM:
-			ret = wlan_set_multiple_dtim_ioctl(priv, req);
-			break;
-
-		case WLAN_SET_LINKMODE:
-			ret = wlan_set_linkmode_ioctl(priv, req);
-			break;
-
-		case WLAN_SET_RADIOMODE:
-			ret = wlan_set_radiomode_ioctl(priv, req);
-			break;
-
-		case WLAN_SET_DEBUGMODE:
-			ret = wlan_set_debugmode_ioctl(priv, req);
-			break;
-
 		case WLAN_SUBCMD_MESH_SET_TTL:
 			idata = SUBCMD_DATA(wrq);
 			ret = wlan_mesh_set_ttl_ioctl(priv, idata);
@@ -1944,38 +854,8 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 
 		break;
 
-	case WLAN_SETNONE_GETTWELVE_CHAR:	/* Get Antenna settings */
-		/*
-		 * We've not used IW_PRIV_TYPE_FIXED so sub-ioctl number is
-		 * in flags of iwreq structure, otherwise it will be in
-		 * mode member of iwreq structure.
-		 */
-		switch ((int)wrq->u.data.flags) {
-		case WLAN_SUBCMD_GETRXANTENNA:	/* Get Rx Antenna */
-			ret = wlan_subcmd_getrxantenna_ioctl(priv, req);
-			break;
-
-		case WLAN_SUBCMD_GETTXANTENNA:	/* Get Tx Antenna */
-			ret = wlan_subcmd_gettxantenna_ioctl(priv, req);
-			break;
-
-		case WLAN_GET_TSF:
-			ret = wlan_get_tsf_ioctl(priv, wrq);
-			break;
-		}
-		break;
-
 	case WLAN_SET128CHAR_GET128CHAR:
 		switch ((int)wrq->u.data.flags) {
-
-		case WLANSCAN_MODE:
-			lbs_pr_debug(1, "Scan mode Ioctl\n");
-			ret = wlan_scan_mode_ioctl(priv, wrq);
-			break;
-
-		case WLAN_GET_ADHOC_STATUS:
-			ret = wlan_get_adhoc_status_ioctl(priv, wrq);
-			break;
 		case WLAN_SUBCMD_BT_ADD:
 			ret = wlan_bt_add_ioctl(priv, req);
 			break;
@@ -2008,40 +888,10 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 
 	case WLAN_SETNONE_GETONEINT:
 		switch ((int)req->ifr_data) {
-		case WLANGETBCNAVG:
-			pdata = (int *)wrq->u.name;
-			*pdata = (int)adapter->bcn_avg_factor;
-			break;
-
 		case WLANGETREGION:
 			pdata = (int *)wrq->u.name;
 			*pdata = (int)adapter->regioncode;
 			break;
-
-		case WLAN_GET_LISTEN_INTERVAL:
-			pdata = (int *)wrq->u.name;
-			*pdata = (int)adapter->listeninterval;
-			break;
-
-		case WLAN_GET_LINKMODE:
-			req->ifr_data = (char *)((u32) adapter->linkmode);
-			break;
-
-		case WLAN_GET_RADIOMODE:
-			req->ifr_data = (char *)((u32) adapter->radiomode);
-			break;
-
-		case WLAN_GET_DEBUGMODE:
-			req->ifr_data = (char *)((u32) adapter->debugmode);
-			break;
-
-		case WLAN_GET_MULTIPLE_DTIM:
-			pdata = (int *)wrq->u.name;
-			*pdata = (int)adapter->multipledtim;
-			break;
-		case WLAN_GET_TX_RATE:
-			ret = wlan_get_txrate_ioctl(priv, req);
-			break;
 		case WLAN_SUBCMD_FWT_CLEANUP:	/* fwt_cleanup */
 			ret = wlan_fwt_cleanup_ioctl(priv, req);
 			break;
@@ -2061,196 +911,8 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 
 		break;
 
-	case WLANGETLOG:
-		ret = wlan_do_getlog_ioctl(priv, wrq);
-		break;
-
 	case WLAN_SET_GET_SIXTEEN_INT:
 		switch ((int)wrq->u.data.flags) {
-		case WLAN_TPCCFG:
-			{
-				int data[5];
-				struct cmd_ds_802_11_tpc_cfg cfg;
-				memset(&cfg, 0, sizeof(cfg));
-				if ((wrq->u.data.length > 1)
-				    && (wrq->u.data.length != 5))
-					return -1;
-
-				if (wrq->u.data.length == 0) {
-					cfg.action =
-					    cpu_to_le16
-					    (cmd_act_get);
-				} else {
-					if (copy_from_user
-					    (data, wrq->u.data.pointer,
-					     sizeof(int) * 5)) {
-						lbs_pr_debug(1,
-						       "Copy from user failed\n");
-						return -EFAULT;
-					}
-
-					cfg.action =
-					    cpu_to_le16
-					    (cmd_act_set);
-					cfg.enable = data[0];
-					cfg.usesnr = data[1];
-					cfg.P0 = data[2];
-					cfg.P1 = data[3];
-					cfg.P2 = data[4];
-				}
-
-				ret =
-				    libertas_prepare_and_send_command(priv,
-							  cmd_802_11_tpc_cfg,
-							  0,
-							  cmd_option_waitforrsp,
-							  0, (void *)&cfg);
-
-				data[0] = cfg.enable;
-				data[1] = cfg.usesnr;
-				data[2] = cfg.P0;
-				data[3] = cfg.P1;
-				data[4] = cfg.P2;
-				if (copy_to_user
-				    (wrq->u.data.pointer, data,
-				     sizeof(int) * 5)) {
-					lbs_pr_debug(1, "Copy to user failed\n");
-					return -EFAULT;
-				}
-
-				wrq->u.data.length = 5;
-			}
-			break;
-
-		case WLAN_POWERCFG:
-			{
-				int data[4];
-				struct cmd_ds_802_11_pwr_cfg cfg;
-				memset(&cfg, 0, sizeof(cfg));
-				if ((wrq->u.data.length > 1)
-				    && (wrq->u.data.length != 4))
-					return -1;
-				if (wrq->u.data.length == 0) {
-					cfg.action =
-					    cpu_to_le16
-					    (cmd_act_get);
-				} else {
-					if (copy_from_user
-					    (data, wrq->u.data.pointer,
-					     sizeof(int) * 4)) {
-						lbs_pr_debug(1,
-						       "Copy from user failed\n");
-						return -EFAULT;
-					}
-
-					cfg.action =
-					    cpu_to_le16
-					    (cmd_act_set);
-					cfg.enable = data[0];
-					cfg.PA_P0 = data[1];
-					cfg.PA_P1 = data[2];
-					cfg.PA_P2 = data[3];
-				}
-				ret =
-				    libertas_prepare_and_send_command(priv,
-							  cmd_802_11_pwr_cfg,
-							  0,
-							  cmd_option_waitforrsp,
-							  0, (void *)&cfg);
-				data[0] = cfg.enable;
-				data[1] = cfg.PA_P0;
-				data[2] = cfg.PA_P1;
-				data[3] = cfg.PA_P2;
-				if (copy_to_user
-				    (wrq->u.data.pointer, data,
-				     sizeof(int) * 4)) {
-					lbs_pr_debug(1, "Copy to user failed\n");
-					return -EFAULT;
-				}
-
-				wrq->u.data.length = 4;
-			}
-			break;
-		case WLAN_AUTO_FREQ_SET:
-			{
-				int data[3];
-				struct cmd_ds_802_11_afc afc;
-				memset(&afc, 0, sizeof(afc));
-				if (wrq->u.data.length != 3)
-					return -1;
-				if (copy_from_user
-				    (data, wrq->u.data.pointer,
-				     sizeof(int) * 3)) {
-					lbs_pr_debug(1, "Copy from user failed\n");
-					return -EFAULT;
-				}
-				afc.afc_auto = data[0];
-
-				if (afc.afc_auto != 0) {
-					afc.threshold = data[1];
-					afc.period = data[2];
-				} else {
-					afc.timing_offset = data[1];
-					afc.carrier_offset = data[2];
-				}
-				ret =
-				    libertas_prepare_and_send_command(priv,
-							  cmd_802_11_set_afc,
-							  0,
-							  cmd_option_waitforrsp,
-							  0, (void *)&afc);
-			}
-			break;
-		case WLAN_AUTO_FREQ_GET:
-			{
-				int data[3];
-				struct cmd_ds_802_11_afc afc;
-				memset(&afc, 0, sizeof(afc));
-				ret =
-				    libertas_prepare_and_send_command(priv,
-							  cmd_802_11_get_afc,
-							  0,
-							  cmd_option_waitforrsp,
-							  0, (void *)&afc);
-				data[0] = afc.afc_auto;
-				data[1] = afc.timing_offset;
-				data[2] = afc.carrier_offset;
-				if (copy_to_user
-				    (wrq->u.data.pointer, data,
-				     sizeof(int) * 3)) {
-					lbs_pr_debug(1, "Copy to user failed\n");
-					return -EFAULT;
-				}
-
-				wrq->u.data.length = 3;
-			}
-			break;
-		case WLAN_SCANPROBES:
-			{
-				int data;
-				if (wrq->u.data.length > 0) {
-					if (copy_from_user
-					    (&data, wrq->u.data.pointer,
-					     sizeof(int))) {
-						lbs_pr_debug(1,
-						       "Copy from user failed\n");
-						return -EFAULT;
-					}
-
-					adapter->scanprobes = data;
-				} else {
-					data = adapter->scanprobes;
-					if (copy_to_user
-					    (wrq->u.data.pointer, &data,
-					     sizeof(int))) {
-						lbs_pr_debug(1,
-						       "Copy to user failed\n");
-						return -EFAULT;
-					}
-				}
-				wrq->u.data.length = 1;
-			}
-			break;
 		case WLAN_LED_GPIO_CTRL:
 			{
 				int i;
@@ -2314,17 +976,6 @@ int libertas_do_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 				wrq->u.data.length = gpio->header.len;
 			}
 			break;
-		case WLAN_ADAPT_RATESET:
-			ret = wlan_adapt_rateset(priv, wrq);
-			break;
-		case WLAN_INACTIVITY_TIMEOUT:
-			ret = wlan_inactivity_timeout(priv, wrq);
-			break;
-		case WLANSNR:
-			ret = wlan_get_snr(priv, wrq);
-			break;
-		case WLAN_GET_RXINFO:
-			ret = wlan_get_rxinfo(priv, wrq);
 		}
 		break;
 
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index ef2440a..b61e8a8 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -96,20 +96,6 @@ int libertas_send_deauth(wlan_private * priv)
 	return ret;
 }
 
-int libertas_do_adhocstop_ioctl(wlan_private * priv)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int ret = 0;
-
-	if (adapter->mode == IW_MODE_ADHOC &&
-	    adapter->connect_status == libertas_connected)
-		ret = libertas_stop_adhoc_network(priv);
-	else
-		ret = -ENOTSUPP;
-
-	return ret;
-}
-
 /**
  *  @brief Associate to a specific BSS discovered in a scan
  *
@@ -262,127 +248,6 @@ int libertas_send_deauthentication(wlan_private * priv)
 }
 
 /**
- *  @brief Set Idle Off
- *
- *  @param priv         A pointer to wlan_private structure
- *  @return             0 --success, otherwise fail
- */
-int libertas_idle_off(wlan_private * priv)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int ret = 0;
-	const u8 zeromac[] = { 0, 0, 0, 0, 0, 0 };
-	int i;
-
-	ENTER();
-
-	if (adapter->connect_status == libertas_disconnected) {
-		if (adapter->mode == IW_MODE_INFRA) {
-			if (memcmp(adapter->previousbssid, zeromac,
-				   sizeof(zeromac)) != 0) {
-
-				lbs_pr_debug(1, "Previous SSID = %s\n",
-				       adapter->previousssid.ssid);
-				lbs_pr_debug(1, "Previous BSSID = "
-				       "%02x:%02x:%02x:%02x:%02x:%02x:\n",
-				       adapter->previousbssid[0],
-				       adapter->previousbssid[1],
-				       adapter->previousbssid[2],
-				       adapter->previousbssid[3],
-				       adapter->previousbssid[4],
-				       adapter->previousbssid[5]);
-
-				i = libertas_find_SSID_in_list(adapter,
-						   &adapter->previousssid,
-						   adapter->previousbssid,
-						   adapter->mode);
-
-				if (i < 0) {
-					libertas_send_specific_BSSID_scan(priv,
-							      adapter->
-							      previousbssid,
-							      1);
-					i = libertas_find_SSID_in_list(adapter,
-							   &adapter->
-							   previousssid,
-							   adapter->
-							   previousbssid,
-							   adapter->mode);
-				}
-
-				if (i < 0) {
-					/* If the BSSID could not be found, try just the SSID */
-					i = libertas_find_SSID_in_list(adapter,
-							   &adapter->
-							   previousssid, NULL,
-							   adapter->mode);
-				}
-
-				if (i < 0) {
-					libertas_send_specific_SSID_scan(priv,
-							     &adapter->
-							     previousssid,
-							     1);
-					i = libertas_find_SSID_in_list(adapter,
-							   &adapter->
-							   previousssid, NULL,
-							   adapter->mode);
-				}
-
-				if (i >= 0) {
-					ret =
-					    wlan_associate(priv,
-							   &adapter->
-							   scantable[i]);
-				}
-			}
-		} else if (adapter->mode == IW_MODE_ADHOC) {
-			ret = libertas_prepare_and_send_command(priv,
-						    cmd_802_11_ad_hoc_start,
-						    0,
-						    cmd_option_waitforrsp,
-						    0, &adapter->previousssid);
-		}
-	}
-	/* else it is connected */
-
-	lbs_pr_debug(1, "\nwlanidle is off");
-	LEAVE();
-	return ret;
-}
-
-/**
- *  @brief Set Idle On
- *
- *  @param priv         A pointer to wlan_private structure
- *  @return             0 --success, otherwise fail
- */
-int libertas_idle_on(wlan_private * priv)
-{
-	wlan_adapter *adapter = priv->adapter;
-	int ret = 0;
-
-	if (adapter->connect_status == libertas_connected) {
-		if (adapter->mode == IW_MODE_INFRA) {
-			lbs_pr_debug(1, "Previous SSID = %s\n",
-			       adapter->previousssid.ssid);
-			memmove(&adapter->previousssid,
-				&adapter->curbssparams.ssid,
-				sizeof(struct WLAN_802_11_SSID));
-			libertas_send_deauth(priv);
-
-		} else if (adapter->mode == IW_MODE_ADHOC) {
-			ret = libertas_stop_adhoc_network(priv);
-		}
-
-	}
-
-	lbs_pr_debug(1, "\nwlanidle is on");
-
-	return ret;
-}
-
-/**
  *  @brief This function prepares command of authenticate.
  *
  *  @param priv      A pointer to wlan_private structure
diff --git a/drivers/net/wireless/libertas/join.h b/drivers/net/wireless/libertas/join.h
index 0e6d928..115f5a8 100644
--- a/drivers/net/wireless/libertas/join.h
+++ b/drivers/net/wireless/libertas/join.h
@@ -37,10 +37,6 @@ extern int libertas_ret_80211_disassociate(wlan_private * priv,
 extern int libertas_ret_80211_associate(wlan_private * priv,
 				     struct cmd_ds_command *resp);
 
-extern int libertas_idle_on(wlan_private * priv);
-extern int libertas_idle_off(wlan_private * priv);
-
-extern int libertas_do_adhocstop_ioctl(wlan_private * priv);
 extern int libertas_reassociation_thread(void *data);
 
 struct WLAN_802_11_SSID;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index c62ffcd..69f52b6 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -986,137 +986,18 @@ static const struct iw_priv_args wlan_private_args[] = {
 	/*
 	 * { cmd, set_args, get_args, name }
 	 */
-	{
-	 WLANSCAN_TYPE,
-	 IW_PRIV_TYPE_CHAR | 8,
-	 IW_PRIV_TYPE_CHAR | 8,
-	 "scantype"},
-
-	{
-	 WLAN_SETINT_GETINT,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 ""},
-	{
-	 WLANNF,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "getNF"},
-	{
-	 WLANRSSI,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "getRSSI"},
-	{
-	 WLANENABLE11D,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "enable11d"},
-	{
-	 WLANADHOCGRATE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "adhocgrate"},
-
-	{
-	 WLAN_SUBCMD_SET_PRESCAN,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "prescan"},
-	{
-	 WLAN_SETONEINT_GETONEINT,
-	 IW_PRIV_TYPE_INT | 1,
-	 IW_PRIV_TYPE_INT | 1,
-	 ""},
-	{
-	 WLAN_BEACON_INTERVAL,
-	 IW_PRIV_TYPE_INT | 1,
-	 IW_PRIV_TYPE_INT | 1,
-	 "bcninterval"},
-	{
-	 WLAN_LISTENINTRVL,
-	 IW_PRIV_TYPE_INT | 1,
-	 IW_PRIV_TYPE_INT | 1,
-	 "lolisteninter"},
-	{
-	 WLAN_TXCONTROL,
-	 IW_PRIV_TYPE_INT | 1,
-	 IW_PRIV_TYPE_INT | 1,
-	 "txcontrol"},
-	{
-	 WLAN_NULLPKTINTERVAL,
-	 IW_PRIV_TYPE_INT | 1,
-	 IW_PRIV_TYPE_INT | 1,
-	 "psnullinterval"},
 	/* Using iwpriv sub-command feature */
 	{
 	 WLAN_SETONEINT_GETNONE,	/* IOCTL: 24 */
 	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
 	 IW_PRIV_TYPE_NONE,
 	 ""},
-
-	{
-	 WLAN_SUBCMD_SETRXANTENNA,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "setrxant"},
-	{
-	 WLAN_SUBCMD_SETTXANTENNA,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "settxant"},
-	{
-	 WLANSETENCRYPTIONMODE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "encryptionmode",
-	 },
 	{
 	 WLANSETREGION,
 	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
 	 IW_PRIV_TYPE_NONE,
 	 "setregioncode"},
 	{
-	 WLAN_SET_LISTEN_INTERVAL,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "setlisteninter"},
-	{
-	 WLAN_SET_MULTIPLE_DTIM,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "setmultipledtim"},
-	{
-	 WLAN_SET_ATIM_WINDOW,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "atimwindow"},
-	{
-	 WLANSETBCNAVG,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "setbcnavg"},
-	{
-	 WLANSETDATAAVG,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "setdataavg"},
-	{
-	 WLAN_SET_LINKMODE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "linkmode"},
-	{
-	 WLAN_SET_RADIOMODE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "radiomode"},
-	{
-	 WLAN_SET_DEBUGMODE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 IW_PRIV_TYPE_NONE,
-	 "debugmode"},
-	{
 	 WLAN_SUBCMD_MESH_SET_TTL,
 	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
 	 IW_PRIV_TYPE_NONE,
@@ -1132,41 +1013,6 @@ static const struct iw_priv_args wlan_private_args[] = {
 	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
 	 "getregioncode"},
 	{
-	 WLAN_GET_LISTEN_INTERVAL,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "getlisteninter"},
-	{
-	 WLAN_GET_MULTIPLE_DTIM,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "getmultipledtim"},
-	{
-	 WLAN_GET_TX_RATE,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "gettxrate"},
-	{
-	 WLANGETBCNAVG,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "getbcnavg"},
-	{
-	 WLAN_GET_LINKMODE,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "get_linkmode"},
-	{
-	 WLAN_GET_RADIOMODE,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "get_radiomode"},
-	{
-	 WLAN_GET_DEBUGMODE,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
-	 "get_debugmode"},
-	{
 	 WLAN_SUBCMD_FWT_CLEANUP,
 	 IW_PRIV_TYPE_NONE,
 	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
@@ -1182,61 +1028,11 @@ static const struct iw_priv_args wlan_private_args[] = {
 	 IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1,
 	 "mesh_get_ttl"},
 	{
-	 WLAN_SETNONE_GETTWELVE_CHAR,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_CHAR | 12,
-	 ""},
-	{
-	 WLAN_SUBCMD_GETRXANTENNA,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_CHAR | 12,
-	 "getrxant"},
-	{
-	 WLAN_SUBCMD_GETTXANTENNA,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_CHAR | 12,
-	 "gettxant"},
-	{
-	 WLAN_GET_TSF,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_CHAR | 12,
-	 "gettsf"},
-	{
 	 WLAN_SETNONE_GETNONE,
 	 IW_PRIV_TYPE_NONE,
 	 IW_PRIV_TYPE_NONE,
 	 ""},
 	{
-	 WLANDEAUTH,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_NONE,
-	 "deauth"},
-	{
-	 WLANADHOCSTOP,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_NONE,
-	 "adhocstop"},
-	{
-	 WLANRADIOON,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_NONE,
-	 "radioon"},
-	{
-	 WLANRADIOOFF,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_NONE,
-	 "radiooff"},
-	{
-	 WLANWLANIDLEON,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_NONE,
-	 "wlanidle-on"},
-	{
-	 WLANWLANIDLEOFF,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_NONE,
-	 "wlanidle-off"},
-	{
 	 WLAN_SUBCMD_FWT_RESET,
 	 IW_PRIV_TYPE_NONE,
 	 IW_PRIV_TYPE_NONE,
@@ -1299,85 +1095,15 @@ static const struct iw_priv_args wlan_private_args[] = {
 	 IW_PRIV_TYPE_CHAR | 128,
 	 "fwt_list_route"},
 	{
-	 WLANSCAN_MODE,
-	 IW_PRIV_TYPE_CHAR | 128,
-	 IW_PRIV_TYPE_CHAR | 128,
-	 "scanmode"},
-	{
-	 WLAN_GET_ADHOC_STATUS,
-	 IW_PRIV_TYPE_CHAR | 128,
-	 IW_PRIV_TYPE_CHAR | 128,
-	 "getadhocstatus"},
-	{
-	 WLAN_SETNONE_GETWORDCHAR,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_CHAR | 128,
-	 ""},
-	{
-	 WLANGETLOG,
-	 IW_PRIV_TYPE_NONE,
-	 IW_PRIV_TYPE_CHAR | GETLOG_BUFSIZE,
-	 "getlog"},
-	{
 	 WLAN_SET_GET_SIXTEEN_INT,
 	 IW_PRIV_TYPE_INT | 16,
 	 IW_PRIV_TYPE_INT | 16,
 	 ""},
 	{
-	 WLAN_TPCCFG,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "tpccfg"},
-	{
-	 WLAN_POWERCFG,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "powercfg"},
-	{
-	 WLAN_AUTO_FREQ_SET,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "setafc"},
-	{
-	 WLAN_AUTO_FREQ_GET,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "getafc"},
-	{
-	 WLAN_SCANPROBES,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "scanprobes"},
-	{
 	 WLAN_LED_GPIO_CTRL,
 	 IW_PRIV_TYPE_INT | 16,
 	 IW_PRIV_TYPE_INT | 16,
 	 "ledgpio"},
-	{
-	 WLAN_ADAPT_RATESET,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "rateadapt"},
-	{
-	 WLAN_INACTIVITY_TIMEOUT,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "inactivityto"},
-	{
-	 WLANSNR,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "getSNR"},
-	{
-	 WLAN_GET_RATE,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "getrate"},
-	{
-	 WLAN_GET_RXINFO,
-	 IW_PRIV_TYPE_INT | 16,
-	 IW_PRIV_TYPE_INT | 16,
-	 "getrxinfo"},
 };
 
 static struct iw_statistics *wlan_get_wireless_stats(struct net_device *dev)
diff --git a/drivers/net/wireless/libertas/wext.h b/drivers/net/wireless/libertas/wext.h
index 39f367c..15cfaaf 100644
--- a/drivers/net/wireless/libertas/wext.h
+++ b/drivers/net/wireless/libertas/wext.h
@@ -10,88 +10,22 @@
 /** PRIVATE CMD ID */
 #define	WLANIOCTL			SIOCIWFIRSTPRIV
 
-#define WLANSETWPAIE			(WLANIOCTL + 0)
-
-#define WLAN_SETINT_GETINT		(WLANIOCTL + 7)
-#define WLANNF					1
-#define WLANRSSI				2
-#define WLANENABLE11D				5
-#define WLANADHOCGRATE				6
-#define WLAN_SUBCMD_SET_PRESCAN			11
-
 #define WLAN_SETNONE_GETNONE	        (WLANIOCTL + 8)
-#define WLANDEAUTH                  		1
-#define WLANRADIOON                 		2
-#define WLANRADIOOFF                		3
-#define WLANREMOVEADHOCAES          		4
-#define WLANADHOCSTOP               		5
-#define WLANCIPHERTEST              		6
-#define WLANCRYPTOTEST				7
-
-#define WLANWLANIDLEON				10
-#define WLANWLANIDLEOFF				11
 #define WLAN_SUBCMD_BT_RESET			13
 #define WLAN_SUBCMD_FWT_RESET			14
 
-#define WLANGETLOG                  	(WLANIOCTL + 9)
-#define GETLOG_BUFSIZE  300
-
-#define WLANSCAN_TYPE			(WLANIOCTL + 11)
-
 #define WLAN_SETNONE_GETONEINT		(WLANIOCTL + 15)
 #define WLANGETREGION				1
-#define WLAN_GET_LISTEN_INTERVAL		2
-#define WLAN_GET_MULTIPLE_DTIM			3
-#define WLAN_GET_TX_RATE			4
-#define	WLANGETBCNAVG				5
 
-#define WLAN_GET_LINKMODE			6
-#define WLAN_GET_RADIOMODE			7
-#define WLAN_GET_DEBUGMODE			8
 #define WLAN_SUBCMD_FWT_CLEANUP			15
 #define WLAN_SUBCMD_FWT_TIME			16
 #define WLAN_SUBCMD_MESH_GET_TTL		17
 
-#define WLANREGCFRDWR			(WLANIOCTL + 18)
-
-#define WLAN_SETNONE_GETTWELVE_CHAR (WLANIOCTL + 19)
-#define WLAN_SUBCMD_GETRXANTENNA    1
-#define WLAN_SUBCMD_GETTXANTENNA    2
-#define WLAN_GET_TSF                3
-
-#define WLAN_SETNONE_GETWORDCHAR	(WLANIOCTL + 21)
-#define WLANGETADHOCAES				1
-
-#define WLAN_SETONEINT_GETONEINT	(WLANIOCTL + 23)
-#define WLAN_BEACON_INTERVAL			1
-#define	WLAN_LISTENINTRVL			4
-
-#define WLAN_TXCONTROL				6
-#define WLAN_NULLPKTINTERVAL			7
-
 #define WLAN_SETONEINT_GETNONE		(WLANIOCTL + 24)
-#define WLAN_SUBCMD_SETRXANTENNA		1
-#define WLAN_SUBCMD_SETTXANTENNA		2
-#define WLANSETAUTHALG				5
-#define WLANSET8021XAUTHALG			6
-#define WLANSETENCRYPTIONMODE			7
 #define WLANSETREGION				8
-#define WLAN_SET_LISTEN_INTERVAL		9
-
-#define WLAN_SET_MULTIPLE_DTIM			10
-#define WLAN_SET_ATIM_WINDOW			11
-#define WLANSETBCNAVG				13
-#define WLANSETDATAAVG				14
-#define WLAN_SET_LINKMODE			15
-#define WLAN_SET_RADIOMODE			16
-#define WLAN_SET_DEBUGMODE			17
 #define WLAN_SUBCMD_MESH_SET_TTL		18
 
 #define WLAN_SET128CHAR_GET128CHAR	(WLANIOCTL + 25)
-#define WLANSCAN_MODE				6
-
-#define WLAN_GET_ADHOC_STATUS			9
-
 #define WLAN_SUBCMD_BT_ADD			18
 #define WLAN_SUBCMD_BT_DEL   			19
 #define WLAN_SUBCMD_BT_LIST			20
@@ -103,27 +37,8 @@
 #define WLAN_SUBCMD_FWT_LIST_ROUTE			26
 
 #define WLAN_SET_GET_SIXTEEN_INT       (WLANIOCTL + 29)
-#define WLAN_TPCCFG                             1
-#define WLAN_POWERCFG                           2
-
-#define WLAN_AUTO_FREQ_SET			3
-#define WLAN_AUTO_FREQ_GET			4
 #define WLAN_LED_GPIO_CTRL			5
-#define WLAN_SCANPROBES 			6
-#define	WLAN_ADAPT_RATESET			8
-#define	WLAN_INACTIVITY_TIMEOUT			9
-#define WLANSNR					10
-#define WLAN_GET_RATE				11
-#define	WLAN_GET_RXINFO				12
-
-#define WLANCMD52RDWR			(WLANIOCTL + 30)
-#define WLANCMD53RDWR			(WLANIOCTL + 31)
-#define CMD53BUFLEN				32
 
-#define	REG_MAC					0x19
-#define	REG_BBP					0x1a
-#define	REG_RF					0x1b
-#define	REG_EEPROM				0x59
 #define WLAN_LINKMODE_802_3			0
 #define WLAN_LINKMODE_802_11			2
 #define WLAN_RADIOMODE_NONE    			0
-- 
1.5.0.6



