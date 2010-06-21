Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:36972 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab0FUMrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 08:47:11 -0400
Subject: Re: [PATCH 2/2] wl1251: fix ELP_CTRL register reads
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Kalle Valo <kvalo@adurom.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	"John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
	 <1275693948-3189-2-git-send-email-notasas@gmail.com>
	 <AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 14:46:50 +0200
Message-ID: <1277124410.28895.23.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-06-05 at 10:04 +0300, Kalle Valo wrote:
> On 5 June 2010 02:25, Grazvydas Ignotas <notasas@gmail.com> wrote:
> > Reading the ELP_CTRL register with sdio_readb causes problems because
> > hardware seems to be performing a write using stuff bits in the request
> > (those bits contain write data in write request). This indicates that it
> > actually expects RAW (read after write) type of request, so perform that
> > when reading ELP_CTRL instead. Also cache last written value so we know
> > what to write when doing RAW request.
> >
> > Because of the above it was not possible to wake the chip from ELP power
> > saving mode, PM had to be disabled to have the driver usable in SDIO
> > mode. After this patch PM is functional.
> 
> Excellent that Power Save is now working SDIO. Thank you very much!
Hi, me and some other people are trying to run standard GNU/Linux (not
android ) on the htcdream.
The htcdream has a wl1251_sdio with a msm sdio controller.
we currently work on a 2.6.32 kenrel.
As it's a phone, power management is important and so I tried with PS
enabled by default in the kernel:
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEFAULT_PS_VALUE=1

I've tried lastest compat-wireless (2010-06-20) with the following
patches:

Index:
compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251_sdio.c
===================================================================
---
compat-wireless-2010-06-19.orig/drivers/net/wireless/wl12xx/wl1251_sdio.c	2010-06-20 23:00:09.755843242 +0200
+++ compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251_sdio.c
2010-06-20 23:01:34.733958063 +0200
@@ -106,7 +106,7 @@
 	 * request).
 	 */
 	sdio_claim_host(func);
-	*val = sdio_writeb_readb(func, wl_sdio->elp_val, addr, &ret);
+	*val = sdio_readb_ext(func, addr, &ret, 1);
 	sdio_release_host(func);
 
 	if (ret)

Index:
compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251_sdio.c
===================================================================
---
compat-wireless-2010-06-19.orig/drivers/net/wireless/wl12xx/wl1251_sdio.c	2010-06-20 22:04:12.776553632 +0200
+++ compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251_sdio.c
2010-06-20 22:06:30.375232047 +0200
@@ -131,6 +131,20 @@
 
 static void wl1251_sdio_reset(struct wl1251 *wl)
 {
+	extern int sdio_reset_comm(struct mmc_card *card);
+	struct sdio_func *func = wl_to_func(wl);
+	int ret;
+
+	sdio_claim_host(func);
+	sdio_reset_comm(func->card);
+	ret = sdio_enable_func(func);
+	if (ret)
+		goto release;
+
+	sdio_set_block_size(func, 512);
+
+release:
+	sdio_release_host(func);
 }
 
 static void wl1251_sdio_enable_irq(struct wl1251 *wl)
@@ -271,6 +285,9 @@
 	ret = wl1251_init_ieee80211(wl);
 	if (ret)
 		goto out_free_irq;
+	
+	/* we can power it down now until it's started */
+	wl->set_power(0);
 
 	sdio_set_drvdata(func, wl);
 	return ret;

Index: compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251.h
===================================================================
--- compat-wireless-2010-06-19.orig/drivers/net/wireless/wl12xx/wl1251.h
2010-06-20 22:07:29.346389894 +0200
+++ compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251.h
2010-06-20 22:08:41.974607260 +0200
@@ -381,6 +381,8 @@
 
 	u32 chip_id;
 	char fw_ver[21];
+
+	bool associated;
 };
 
 int wl1251_plt_start(struct wl1251 *wl);
Index:
compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251_main.c
===================================================================
---
compat-wireless-2010-06-19.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2010-06-20 22:07:36.606391128 +0200
+++ compat-wireless-2010-06-19/drivers/net/wireless/wl12xx/wl1251_main.c
2010-06-20 22:10:11.594572491 +0200
@@ -869,6 +869,13 @@
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 hw scan");
 
+	/*
+	 * FIXME: scanning while associated causes lockups,
+	 * so we don't allow that
+	 */
+	if (wl->associated)
+		return -EBUSY;
+
 	if (req->n_ssids) {
 		ssid = req->ssids[0].ssid;
 		ssid_len = req->ssids[0].ssid_len;
and a minor build patch:
Index: compat-wireless-2010-06-19/scripts/gen-compat-autoconf.sh
===================================================================
--- compat-wireless-2010-06-19.orig/scripts/gen-compat-autoconf.sh
2010-06-20 17:40:48.586388753 +0200
+++ compat-wireless-2010-06-19/scripts/gen-compat-autoconf.sh	2010-06-20
17:41:07.833335272 +0200
@@ -192,7 +192,7 @@
 		define_config_multiple_deps CONFIG_MAC80211_QOS y $ALL_DEPS
 		rm -f $MULT_DEP_FILE
 		# Kernels >= 2.6.32 can disable WEXT :D
-		if [ $SUBLEVEL -lt 32 ]; then
+		if [ $SUBLEVEL -le 32 ]; then
 			define_config_dep CONFIG_CFG80211_WEXT 1 CONFIG_WIRELESS_EXT
 		fi
 	fi


And I've the following messages in dmesg:
[ 1412.632263] cfg80211: Calling CRDA to update world regulatory domain
[ 1413.038391] wifi probe start
[ 1413.038452] trout_wifi_power: 1
[ 1413.240142] trout_wifi_reset: 0
[ 1413.291748] trout_wifi_set_carddetect: 1
[ 1413.291778] mmc0: card_present 1
[ 1413.291809] mmc0: Slot status change detected (0 -> 1)
[ 1413.291839] wifi probe done
[ 1415.828735] mmc0: Command timeout
[ 1415.834259] mmc0: card claims to support voltages below the defined
range. These will be ignored.
[ 1415.838806] mmc0: new SDIO card at address 0001
[ 1415.855041] wl1251: using SDIO interrupt
[ 1415.985321] phy0: Selected rate control algorithm 'minstrel'
[ 1415.990325] wl1251: loaded
[ 1415.991363] wl1251: initialized
[ 1433.640594] request_suspend_state: sleep (0->3) at 1427975218412
(2010-06-21 12:31:23.116053303 UTC)
[ 1433.641845] msm_i2c msm_i2c.0: Warning bus was busy (8)
[ 1464.390441] sdio_reset_comm():
[ 1465.120025] wl1251: 151 tx blocks at 0x3b788, 35 rx blocks at 0x3a780
[ 1465.140136] wl1251: firmware booted (Rev 4.0.4.3.5)
[ 1465.280761] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 1556.024566] wlan0: authenticate with 00:24:01:63:89:bd (try 1)
[ 1556.036285] wlan0: authenticated
[ 1556.114501] wlan0: associate with 00:24:01:63:89:bd (try 1)
[ 1556.126525] wlan0: RX AssocResp from 00:24:01:63:89:bd (capab=0x401
status=0 aid=3)
[ 1556.126556] wlan0: associated
[ 1556.425354] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 1556.734130] mmc0: Command timeout
[ 1556.739166] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1557.454101] mmc0: Command CRC error
[ 1557.454162] wl1251: ERROR sdio_writeb failed (-84)
[ 1557.763610] mmc0: Command timeout
[ 1557.768829] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1558.773071] mmc0: Command CRC error
[ 1558.773132] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1559.782562] mmc0: Command timeout
[ 1559.787628] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1560.792022] mmc0: Command CRC error
[ 1560.792083] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1561.821563] mmc0: Command timeout
[ 1561.826629] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1562.831085] mmc0: Command CRC error
[ 1562.831146] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1563.860534] mmc0: Command timeout
[ 1563.865570] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1564.869995] mmc0: Command CRC error
[ 1564.870056] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1565.899475] mmc0: Command timeout
[ 1565.904541] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1566.449127] wlan0: no IPv6 routers present
[ 1566.908996] mmc0: Command CRC error
[ 1566.909057] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1567.918518] mmc0: Command timeout
[ 1567.923553] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1568.928009] mmc0: Command CRC error
[ 1568.928100] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1569.937500] mmc0: Command timeout
[ 1569.942565] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1570.946990] mmc0: Command CRC error
[ 1570.947052] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1571.956481] mmc0: Command timeout
[ 1571.961547] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1572.966003] mmc0: Command CRC error
[ 1572.966064] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1573.975463] mmc0: Command timeout
[ 1573.980529] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1574.984985] mmc0: Command CRC error
[ 1574.985046] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1576.244323] mmc0: Command timeout
[ 1576.249359] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1577.253845] mmc0: Command CRC error
[ 1577.253906] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1578.563140] mmc0: Command timeout
[ 1578.568237] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1578.667968] mmc0: Command CRC error
[ 1578.668029] wl1251: ERROR sdio_writeb failed (-84)
[ 1579.572692] mmc0: Command timeout
[ 1579.577758] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1580.582153] mmc0: Command CRC error
[ 1580.582214] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1581.591705] mmc0: Command timeout
[ 1581.596771] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1582.601165] mmc0: Command CRC error
[ 1582.601226] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1583.610626] mmc0: Command timeout
[ 1583.615692] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1584.620117] mmc0: Command CRC error
[ 1584.620178] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1585.629638] mmc0: Command timeout
[ 1585.634704] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1586.639129] mmc0: Command CRC error
[ 1586.639190] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1587.648681] mmc0: Command timeout
[ 1587.653717] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1588.658142] mmc0: Command CRC error
[ 1588.658203] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1589.667663] mmc0: Command timeout
[ 1589.672729] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1590.677093] mmc0: Command CRC error
[ 1590.677185] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1591.686614] mmc0: Command timeout
[ 1591.691680] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1592.696075] mmc0: Command CRC error
[ 1592.696136] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1593.705657] mmc0: Command timeout
[ 1593.710693] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1594.715087] mmc0: Command CRC error
[ 1594.715148] mmc0:0001: error -84 reading SDIO_CCCR_INTx
[ 1595.724639] mmc0: Command timeout
[ 1595.729705] mmc0:0001: error -110 reading SDIO_CCCR_INTx
[ 1596.734100] mmc0: Command CRC error
[ 1596.734161] mmc0:0001: error -84 reading SDIO_CCCR_INTx
etc....
So I use the wifi,listen to a webradio,browse the web etc...
but after a while it stop working,and after a while it stops working.
and when it occurs,iwconfig say that it's still associated...
Denis.


