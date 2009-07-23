Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:50096 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493AbZGWJlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 05:41:07 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: RE: Slow roaming in mac80211 (2.6.30).
Date: Thu, 23 Jul 2009 11:40:23 +0200
Message-ID: <2E12E93FA1AB41BDA5C8A7292FCAC884@gotws1589>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0041_01CA0B8A.5DCDA0F0"
In-Reply-To: <1248215454.11735.24.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0041_01CA0B8A.5DCDA0F0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Johannes,

> The real question is: why the hell is it probing the AP?
> I agree -- the spurious probing is strange. But I also have to admit
> that basically I don't care as long as it works -- most of this is just
> a side effect of how wireless extensions work.

I have further investigated the roaming issues and found two problems.

First ieee80211_rx_mgmt_deauth() and ieee80211_rx_mgmt_disassoc()
sets a retry state at the same time as they tells the wpa_supplicant
that the AP is gone.

Patch lae-mac80211-rm-direct-probe.patch addresses this problem.


Second problem address the auto scan function in
ieee80211_sta_config_auth().  When an incomplete AP information is
found, it start a new scan. This scan will delay the actions taken by
the wpa_supplicant for the scan period.

Patch lae-mac80211-rm-extra-scan-request.patch addresses this problem.

I do not have the knowledge to judge if the patch is correctly
applied/located, but they sure give the desired effect. Old roaming
time was 4,5 seconds for 13 channels and with the above patches it is
down to 400ms for 3 channels. See trace below.


> I would suggest you just use wpa_supplicant -Dnl80211, which 
> should help
> a lot with this kind of things.

I need to patch the kernel for this, rigth ?
Where can I get appropriate patches?

/Lars

-----

[  124.597307] wlan0: deauthenticated (Reason: 1)
[  124.597341] LaE: [ieee80211_rx_mgmt_deauth] do not set
IEEE80211_STA_MLME_DIRECT_PROBE
[  124.699253] [B] LaE: SCANRQUEST: SSID=AGV
[  124.699298] LaE: [ieee80211_request_scan(568)] set IEEE80211_STA_REQ_SCAN
[  124.699456] ieee80211_start_scan: enter
[  124.919184] ieee80211_scan_completed: enter
[  124.919577] [B] LaE: SCANRESULT: BSSID=00:08:21:31:53:87, SSID=AGV
, ch=11, , q=  0, l=  0(-56dBm), n=  0
[  124.919655] [B] LaE: SCANRESULT: BSSID=00:08:21:31:53:87, SSID=
, ch=11, , q=  0, l=  0(-56dBm), n=  0
[  124.919726] [B] LaE: SCANRESULT: BSSID=00:40:96:a0:e7:e7, SSID=AGV
, ch= 1, , q=  0, l=  0(-36dBm), n=  0
[  124.919978] ieee80211_ioctl_siwauth: enter
[  124.920053] ieee80211_ioctl_siwencodeext: enter
[  124.920084] ieee80211_set_encryption: enter
[  124.920177] ieee80211_ioctl_siwencodeext: enter
[  124.920210] ieee80211_set_encryption: enter
[  124.920262] ieee80211_ioctl_siwencodeext: enter
[  124.920291] ieee80211_set_encryption: enter
[  124.920341] ieee80211_ioctl_siwencodeext: enter
[  124.920370] ieee80211_set_encryption: enter
[  124.920421] ieee80211_ioctl_siwencodeext: enter
[  124.920449] ieee80211_set_encryption: enter
[  124.920667] ieee80211_ioctl_siwencodeext: enter
[  124.920704] ieee80211_set_encryption: enter
[  124.920774] ieee80211_ioctl_siwauth: enter
[  124.921454] ieee80211_ioctl_siwgenie: enter
[  124.921518] ieee80211_ioctl_siwauth: enter
[  124.921560] ieee80211_ioctl_siwauth: enter
[  124.921598] ieee80211_ioctl_siwauth: enter
[  124.921637] ieee80211_ioctl_siwauth: enter
[  124.921674] ieee80211_ioctl_siwauth: enter
[  124.921712] ieee80211_ioctl_siwauth: enter
[  124.921755] ieee80211_ioctl_siwfreq: enter freq=241200000
[  124.951244] LaE: [ieee80211_sta_config_auth(1847)] disable
ieee80211_start_scan
[  124.951456] ieee80211_ioctl_siwessid: enter ssid=AGV
[  124.951553] LaE: [ieee80211_sta_config_auth(1847)] disable
ieee80211_start_scan
[  124.951641] ieee80211_ioctl_siwap: enter AP=00:40:96:a0:e7:e7
[  124.959261] wlan0: authenticate with AP 00:40:96:a0:e7:e7
[  124.960678] wlan0: authenticated
[  124.960717] wlan0: associate with AP 00:40:96:a0:e7:e7
[  124.962865] wlan0: RX ReassocResp from 00:40:96:a0:e7:e7 (capab=0x431
status=0 aid=6)
[  124.962907] wlan0: associated



------=_NextPart_000_0041_01CA0B8A.5DCDA0F0
Content-Type: application/octet-stream;
	name="lae-mac80211-rm-extra-scan-request.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lae-mac80211-rm-extra-scan-request.patch"

diff -Nurp -x '*.o' -x '*.mod.*' -x '*.ko' a/net/mac80211/mlme.c =
linux-2.6.30.1/net/mac80211/mlme.c=0A=
--- a/net/mac80211/mlme.c	2009-07-21 15:48:29.000000000 +0200=0A=
+++ linux-2.6.30.1/net/mac80211/mlme.c	2009-07-23 10:14:29.000000000 =
+0200=0A=
@@ -1834,6 +1843,8 @@ static int ieee80211_sta_config_auth(str=0A=
 		ieee80211_rx_bss_put(local, bss);=0A=
 		ieee80211_sta_reset_auth(sdata);=0A=
 		return 0;=0A=
+	} else if (1) {=0A=
+		printk(KERN_DEBUG "LaE: [%s(%d)] disable ieee80211_start_scan \n", =
__func__, __LINE__ );=0A=
 	} else {=0A=
 		if (ifmgd->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {=0A=
 			ifmgd->assoc_scan_tries++;=0A=

------=_NextPart_000_0041_01CA0B8A.5DCDA0F0
Content-Type: application/octet-stream;
	name="lae-mac80211-rm-direct-probe.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="lae-mac80211-rm-direct-probe.patch"

diff -Nurp -x '*.o' -x '*.mod.*' -x '*.ko' a/net/mac80211/mlme.c =
linux-2.6.30.1/net/mac80211/mlme.c=0A=
--- a/net/mac80211/mlme.c	2009-07-21 15:48:29.000000000 +0200=0A=
+++ linux-2.6.30.1/net/mac80211/mlme.c	2009-07-23 10:14:29.000000000 =
+0200=0A=
@@ -1191,6 +1194,9 @@ static void ieee80211_rx_mgmt_deauth(str=0A=
 		printk(KERN_DEBUG "%s: deauthenticated (Reason: %u)\n",=0A=
 				sdata->dev->name, reason_code);=0A=
 =0A=
+	if ( ifmgd->state =3D=3D IEEE80211_STA_MLME_ASSOCIATED ) {=0A=
+		printk(KERN_DEBUG "LaE: [%s] do not set =
IEEE80211_STA_MLME_DIRECT_PROBE \n", __func__);=0A=
+	} else=0A=
 	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) &&=0A=
 	    (ifmgd->state =3D=3D IEEE80211_STA_MLME_AUTHENTICATE ||=0A=
 	     ifmgd->state =3D=3D IEEE80211_STA_MLME_ASSOCIATE ||=0A=
@@ -1225,6 +1231,9 @@ static void ieee80211_rx_mgmt_disassoc(s=0A=
 		printk(KERN_DEBUG "%s: disassociated (Reason: %u)\n",=0A=
 				sdata->dev->name, reason_code);=0A=
 =0A=
+	if ( ifmgd->state =3D=3D IEEE80211_STA_MLME_ASSOCIATED ) {=0A=
+		printk(KERN_DEBUG "LaE: [%s] do not set IEEE80211_STA_MLME_ASSOCIATE =
\n", __func__);=0A=
+	} else=0A=
 	if (!(ifmgd->flags & IEEE80211_STA_EXT_SME) &&=0A=
 	    ifmgd->state =3D=3D IEEE80211_STA_MLME_ASSOCIATED) {=0A=
 		ifmgd->state =3D IEEE80211_STA_MLME_ASSOCIATE;=0A=

------=_NextPart_000_0041_01CA0B8A.5DCDA0F0--

