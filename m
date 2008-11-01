Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYKALfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 07:35:01 -0400
Subject: Re: [PATCH] mac80211: Allow AP mode to be enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <878ws3ptrh.fsf@nokia.com>
References: <20081030175030.GD3923@jm.kir.nu>  <878ws3ptrh.fsf@nokia.com>
Content-Type: text/plain
Date: Sat, 01 Nov 2008 12:34:49 +0100
Message-Id: <1225539289.3569.2.camel@johannes.berg> (sfid-20081101_123508_993616_1DEED8B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I tried to test this with latest hostapd (commit b6a55236) and
> wireless-testing (commit d80fe0040), but unfortunately I wasn't
> succesful. Here's the output from hostapd with b43:
> 
> $ sudo ./hostapd -dd wlan1.conf
> Configuration file: wlan1.conf
> ctrl_interface_group=0
> Opening raw packet socket for ifindex 0
> BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
> SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
> Failed to update rate sets in kernel module
> RATE[0] rate=10 flags=0x2
> RATE[1] rate=20 flags=0x6
> RATE[2] rate=55 flags=0x6
> RATE[3] rate=110 flags=0x6
> RATE[4] rate=60 flags=0x0
> RATE[5] rate=90 flags=0x0
> RATE[6] rate=120 flags=0x0
> RATE[7] rate=180 flags=0x0
> RATE[8] rate=240 flags=0x0
> RATE[9] rate=360 flags=0x0
> RATE[10] rate=480 flags=0x0
> RATE[11] rate=540 flags=0x0
> Could not set passive scanning: Unknown error 4294967295
> Flushing old station entries
> Deauthenticate all stations
> Mode: IEEE 802.11g  Channel: 5  Frequency: 2432 MHz
> Failed to set CTS protect in kernel driver
> Failed to set Short Slot Time option in kernel driver
> Could not set preamble for kernel driver
> Using interface wlan1 with hwaddr 00:11:50:f4:c2:42 and ssid 'test'
> ioctl[SIOCSIWESSID]: Operation not supported
> len=4
> Could not set SSID for kernel driver

John merged all my stuff, and that included removing the SSID, you need
this hostapd patch:

--- a/hostapd/driver_nl80211.c
+++ b/hostapd/driver_nl80211.c
@@ -386,28 +386,6 @@ static int i802_set_rate_sets(void *priv, int *supp_rates, int *basic_rates,
 }
 
 
-static int i802_set_ssid(const char *ifname, void *priv, const u8 *buf,
-			 int len)
-{
-	struct i802_driver_data *drv = priv;
-	struct iwreq iwr;
-
-	memset(&iwr, 0, sizeof(iwr));
-	os_strlcpy(iwr.ifr_name, ifname, IFNAMSIZ);
-	iwr.u.essid.flags = 1; /* SSID active */
-	iwr.u.essid.pointer = (caddr_t) buf;
-	iwr.u.essid.length = len;
-
-	if (ioctl(drv->ioctl_sock, SIOCSIWESSID, &iwr) < 0) {
-		perror("ioctl[SIOCSIWESSID]");
-		printf("len=%d\n", len);
-		return -1;
-	}
-
-	return 0;
-}
-
-
 static int i802_send_frame(void *priv, const void *data, size_t len,
 			   int encrypt, int flags)
 {
@@ -2315,7 +2293,6 @@ const struct wpa_driver_ops wpa_driver_nl80211_ops = {
 	.sta_deauth = i802_sta_deauth,
 	.sta_disassoc = i802_sta_disassoc,
 	.sta_remove = i802_sta_remove,
-	.set_ssid = i802_set_ssid,
 	.send_mgmt_frame = i802_send_mgmt_frame,
 	.sta_add2 = i802_sta_add2,
 	.get_inact_sec = i802_get_inact_sec,



