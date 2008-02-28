Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:45364 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbYB1LX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 06:23:59 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: RE: Roaming issues: Monitoring of a usable link to the AP.
Date: Thu, 28 Feb 2008 12:22:59 +0100
Message-ID: <001e01c879fc$46372e00$0b3ca8c0@gotws1589> (sfid-20080228_112403_853853_4B1209DA)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_001F_01C87A04.A7FB9600"
In-Reply-To: <008501c8797f$38e7c520$0b3ca8c0@gotws1589>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_001F_01C87A04.A7FB9600
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

 
Hi Johannes,

Back with the traces.

First, I was wrong about receiving frames from other STA using same AP. It
was my fault.

Below (see attachment) is a trace from ieee80211_rx_h_sta_process() 
You can see the frames that will update the last_rx field.

Current version will update on all frames due to the OR condition.

Changing it to and AND condition will strip almost all frames away in the
sample.
The result would be that the STA will PROBE the AP each 2 seconds in the
ieee80211_rx_h_sta_process().

In my code I have added a feature that monitors BEACONS from 'my' AP.
When number of received beacons drops below 5 / 2 seconds, I assume out of
range.
I do not know if this is necessary but it gives faster roaming in the
out-of-range scenario.

/Lars

------=_NextPart_000_001F_01C87A04.A7FB9600
Content-Type: text/plain;
	name="dmsg.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmsg.txt"

Hi,=0A=
=0A=
Back with the traces.=0A=
=0A=
First, I was wrong about receiving frames from other STA using same AP. =0A=
It was my fault.=0A=
=0A=
Below is a trace from ieee80211_rx_h_sta_process() =0A=
You can see the frames that will update the last_rx field.=0A=
=0A=
Current version will update on all frames due to the OR condition.=0A=
=0A=
Changing it to and AND condition will strip almost all frames away in =
the sample below.=0A=
The result would be that the STA will PROBE the AP each 2 seconds in the =
ieee80211_rx_h_sta_process().=0A=
=0A=
In my code I have added a feature that monitors BEACONS from 'my' AP.=0A=
When number of received beacons drops below 5 / 2 seconds, I assume out =
of range.=0A=
I do not know if this is necessary but it gives faster roaming in the =
out-of-range scenario.=0A=
=0A=
/Lars=0A=
=0A=
=0A=
=0A=
=0A=
MAC addresses in trace below=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
[00:1e:be:8d:6e:c2] =3D> BSS=0A=
[00:0e:8e:02:f5:7b] =3D> STA with RT61=0A=
[2e:30:d8:00:00:bf] =3D> LAN PC=0A=
[00:e0:4c:ad:00:10] =3D> LAN PC=0A=
[ff:ff:ff:ff:ff:ff] =3D> BROADCAST=0A=
[01:80:c2:00:00:00] =3D> Bridge Group Address=0A=
[00:a0:f8:67:c9:1d] =3D> STA Symbol 3000=0A=
[00:19:cb:12:1c:1c] =3D> LAN FireWall=0A=
=0A=
=0A=
Diff to give the trace below:=0A=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=0A=
--- mac80211/rx.c	2008-02-19 07:02:29.000000000 +0100=0A=
+++ mac80211/rx.c	2008-02-28 10:28:30.000000000 +0100=0A=
@@ -647,6 +647,21 @@ ieee80211_rx_h_sta_process(struct ieee80=0A=
 		 * the Probe Request frames (the only broadcast frames from a=0A=
 		 * STA in infrastructure mode) from keeping a connection alive.=0A=
 		 */=0A=
+		DECLARE_MAC_BUF(addr1);=0A=
+		DECLARE_MAC_BUF(addr2);=0A=
+		DECLARE_MAC_BUF(addr3);=0A=
+=0A=
+#if 1 // defined(LAE_DEBUG)=0A=
+		printk("LaE: %s: last_rx=3D%lu, addr1=3D%s, addr2=3D%s, addr3=3D%s, =
type=3D%u (%s)\n",=0A=
+		       __func__,=0A=
+		       sta->last_rx,=0A=
+		       print_mac(addr1, hdr->addr1),=0A=
+		       print_mac(addr2, hdr->addr2),=0A=
+		       print_mac(addr3, hdr->addr3),=0A=
+		       rx->sdata->vif.type,=0A=
+		       (rx->sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA ? "T":"F")=0A=
+		      );=0A=
+#endif=0A=
 		sta->last_rx =3D jiffies;=0A=
 	}=0A=
 =0A=
=0A=
<4>[  597.937786] LaE: ieee80211_rx_h_sta_process: last_rx=3D69998, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:e0:4c:ad:00:10, type=3D2 (T)=0A=
<4>[  598.039528] LaE: ieee80211_rx_h_sta_process: last_rx=3D69998, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.141908] LaE: ieee80211_rx_h_sta_process: last_rx=3D70023, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.244278] LaE: ieee80211_rx_h_sta_process: last_rx=3D70049, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.346658] LaE: ieee80211_rx_h_sta_process: last_rx=3D70075, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.347328] LaE: ieee80211_rx_h_sta_process: last_rx=3D70100, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D2e:30:d8:00:00:bf, type=3D2 (T)=0A=
<4>[  598.449029] LaE: ieee80211_rx_h_sta_process: last_rx=3D70100, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.551414] LaE: ieee80211_rx_h_sta_process: last_rx=3D70126, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.639937] LaE: ieee80211_rx_h_sta_process: last_rx=3D70151, =
addr1=3D00:0e:8e:02:f5:7b, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:e0:4c:ad:00:10, type=3D2 (T)=0A=
<4>[  598.653792] LaE: ieee80211_rx_h_sta_process: last_rx=3D70173, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.756157] LaE: ieee80211_rx_h_sta_process: last_rx=3D70177, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.858530] LaE: ieee80211_rx_h_sta_process: last_rx=3D70203, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  598.960913] LaE: ieee80211_rx_h_sta_process: last_rx=3D70228, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.063278] LaE: ieee80211_rx_h_sta_process: last_rx=3D70254, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.165659] LaE: ieee80211_rx_h_sta_process: last_rx=3D70279, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.268045] LaE: ieee80211_rx_h_sta_process: last_rx=3D70305, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.370407] LaE: ieee80211_rx_h_sta_process: last_rx=3D70331, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.472778] LaE: ieee80211_rx_h_sta_process: last_rx=3D70356, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.575160] LaE: ieee80211_rx_h_sta_process: last_rx=3D70382, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.575500] LaE: ieee80211_rx_h_sta_process: last_rx=3D70407, =
addr1=3D01:80:c2:00:00:00, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:a0:f8:67:c9:1d, type=3D2 (T)=0A=
<4>[  599.677530] LaE: ieee80211_rx_h_sta_process: last_rx=3D70407, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.779971] LaE: ieee80211_rx_h_sta_process: last_rx=3D70433, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.780332] LaE: ieee80211_rx_h_sta_process: last_rx=3D70459, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:19:cb:12:1c:1c, type=3D2 (T)=0A=
<4>[  599.780918] LaE: ieee80211_rx_h_sta_process: last_rx=3D70459, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D2e:30:d8:00:00:bf, type=3D2 (T)=0A=
<4>[  599.882283] LaE: ieee80211_rx_h_sta_process: last_rx=3D70459, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.984658] LaE: ieee80211_rx_h_sta_process: last_rx=3D70484, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  599.985278] LaE: ieee80211_rx_h_sta_process: last_rx=3D70510, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:e0:4c:ad:00:10, type=3D2 (T)=0A=
<4>[  600.087028] LaE: ieee80211_rx_h_sta_process: last_rx=3D70510, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  600.189407] LaE: ieee80211_rx_h_sta_process: last_rx=3D70535, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  600.291779] LaE: ieee80211_rx_h_sta_process: last_rx=3D70561, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  600.394158] LaE: ieee80211_rx_h_sta_process: last_rx=3D70587, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  600.496530] LaE: ieee80211_rx_h_sta_process: last_rx=3D70612, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  600.598908] LaE: ieee80211_rx_h_sta_process: last_rx=3D70638, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  600.701279] LaE: ieee80211_rx_h_sta_process: last_rx=3D70663, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  600.803658] LaE: ieee80211_rx_h_sta_process: last_rx=3D70689, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  600.906029] LaE: ieee80211_rx_h_sta_process: last_rx=3D70715, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.008407] LaE: ieee80211_rx_h_sta_process: last_rx=3D70740, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.110778] LaE: ieee80211_rx_h_sta_process: last_rx=3D70766, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.213244] LaE: ieee80211_rx_h_sta_process: last_rx=3D70791, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.315528] LaE: ieee80211_rx_h_sta_process: last_rx=3D70817, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.417909] LaE: ieee80211_rx_h_sta_process: last_rx=3D70842, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.418561] LaE: ieee80211_rx_h_sta_process: last_rx=3D70868, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D2e:30:d8:00:00:bf, type=3D2 (T)=0A=
<4>[  601.520285] LaE: ieee80211_rx_h_sta_process: last_rx=3D70868, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.622659] LaE: ieee80211_rx_h_sta_process: last_rx=3D70894, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.622998] LaE: ieee80211_rx_h_sta_process: last_rx=3D70919, =
addr1=3D01:80:c2:00:00:00, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:a0:f8:67:c9:1d, type=3D2 (T)=0A=
<4>[  601.725029] LaE: ieee80211_rx_h_sta_process: last_rx=3D70919, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.827410] LaE: ieee80211_rx_h_sta_process: last_rx=3D70945, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  601.929780] LaE: ieee80211_rx_h_sta_process: last_rx=3D70970, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.032163] LaE: ieee80211_rx_h_sta_process: last_rx=3D70996, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.032804] LaE: ieee80211_rx_h_sta_process: last_rx=3D71022, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:e0:4c:ad:00:10, type=3D2 (T)=0A=
<4>[  602.134543] LaE: ieee80211_rx_h_sta_process: last_rx=3D71022, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.236908] LaE: ieee80211_rx_h_sta_process: last_rx=3D71047, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.339286] LaE: ieee80211_rx_h_sta_process: last_rx=3D71073, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.441659] LaE: ieee80211_rx_h_sta_process: last_rx=3D71098, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.544029] LaE: ieee80211_rx_h_sta_process: last_rx=3D71124, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.646410] LaE: ieee80211_rx_h_sta_process: last_rx=3D71150, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.748780] LaE: ieee80211_rx_h_sta_process: last_rx=3D71175, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.851162] LaE: ieee80211_rx_h_sta_process: last_rx=3D71201, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  602.851826] LaE: ieee80211_rx_h_sta_process: last_rx=3D71226, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D2e:30:d8:00:00:bf, type=3D2 (T)=0A=
<4>[  602.953536] LaE: ieee80211_rx_h_sta_process: last_rx=3D71227, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.055915] LaE: ieee80211_rx_h_sta_process: last_rx=3D71252, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.158281] LaE: ieee80211_rx_h_sta_process: last_rx=3D71278, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.260660] LaE: ieee80211_rx_h_sta_process: last_rx=3D71303, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.363030] LaE: ieee80211_rx_h_sta_process: last_rx=3D71329, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.465411] LaE: ieee80211_rx_h_sta_process: last_rx=3D71354, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.567780] LaE: ieee80211_rx_h_sta_process: last_rx=3D71380, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.670160] LaE: ieee80211_rx_h_sta_process: last_rx=3D71406, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.670540] LaE: ieee80211_rx_h_sta_process: last_rx=3D71431, =
addr1=3D01:80:c2:00:00:00, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:a0:f8:67:c9:1d, type=3D2 (T)=0A=
<4>[  603.772536] LaE: ieee80211_rx_h_sta_process: last_rx=3D71431, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.874910] LaE: ieee80211_rx_h_sta_process: last_rx=3D71457, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  603.977281] LaE: ieee80211_rx_h_sta_process: last_rx=3D71482, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.079660] LaE: ieee80211_rx_h_sta_process: last_rx=3D71508, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.080295] LaE: ieee80211_rx_h_sta_process: last_rx=3D71534, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:e0:4c:ad:00:10, type=3D2 (T)=0A=
<4>[  604.182038] LaE: ieee80211_rx_h_sta_process: last_rx=3D71534, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.284427] LaE: ieee80211_rx_h_sta_process: last_rx=3D71559, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.386781] LaE: ieee80211_rx_h_sta_process: last_rx=3D71585, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.489164] LaE: ieee80211_rx_h_sta_process: last_rx=3D71610, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.489834] LaE: ieee80211_rx_h_sta_process: last_rx=3D71636, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D2e:30:d8:00:00:bf, type=3D2 (T)=0A=
<4>[  604.591532] LaE: ieee80211_rx_h_sta_process: last_rx=3D71636, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.693910] LaE: ieee80211_rx_h_sta_process: last_rx=3D71662, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.796281] LaE: ieee80211_rx_h_sta_process: last_rx=3D71687, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  604.898661] LaE: ieee80211_rx_h_sta_process: last_rx=3D71713, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.001031] LaE: ieee80211_rx_h_sta_process: last_rx=3D71738, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.103411] LaE: ieee80211_rx_h_sta_process: last_rx=3D71764, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.205783] LaE: ieee80211_rx_h_sta_process: last_rx=3D71790, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.308160] LaE: ieee80211_rx_h_sta_process: last_rx=3D71815, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.410531] LaE: ieee80211_rx_h_sta_process: last_rx=3D71841, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.512911] LaE: ieee80211_rx_h_sta_process: last_rx=3D71866, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.615283] LaE: ieee80211_rx_h_sta_process: last_rx=3D71892, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.717669] LaE: ieee80211_rx_h_sta_process: last_rx=3D71918, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.717993] LaE: ieee80211_rx_h_sta_process: last_rx=3D71943, =
addr1=3D01:80:c2:00:00:00, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:a0:f8:67:c9:1d, type=3D2 (T)=0A=
<4>[  605.820031] LaE: ieee80211_rx_h_sta_process: last_rx=3D71943, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.922412] LaE: ieee80211_rx_h_sta_process: last_rx=3D71969, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  605.923117] LaE: ieee80211_rx_h_sta_process: last_rx=3D71994, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D2e:30:d8:00:00:bf, type=3D2 (T)=0A=
<4>[  606.024781] LaE: ieee80211_rx_h_sta_process: last_rx=3D71995, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.127163] LaE: ieee80211_rx_h_sta_process: last_rx=3D72020, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.127876] LaE: ieee80211_rx_h_sta_process: last_rx=3D72046, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:e0:4c:ad:00:10, type=3D2 (T)=0A=
<4>[  606.229533] LaE: ieee80211_rx_h_sta_process: last_rx=3D72046, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.331915] LaE: ieee80211_rx_h_sta_process: last_rx=3D72071, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.434282] LaE: ieee80211_rx_h_sta_process: last_rx=3D72097, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.536666] LaE: ieee80211_rx_h_sta_process: last_rx=3D72122, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.639031] LaE: ieee80211_rx_h_sta_process: last_rx=3D72148, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.741411] LaE: ieee80211_rx_h_sta_process: last_rx=3D72174, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.843926] LaE: ieee80211_rx_h_sta_process: last_rx=3D72199, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  606.946169] LaE: ieee80211_rx_h_sta_process: last_rx=3D72225, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  607.048531] LaE: ieee80211_rx_h_sta_process: last_rx=3D72250, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=
<4>[  607.150936] LaE: ieee80211_rx_h_sta_process: last_rx=3D72276, =
addr1=3Dff:ff:ff:ff:ff:ff, addr2=3D00:1e:be:8d:6e:c2, =
addr3=3D00:1e:be:8d:6e:c2, type=3D2 (T)=0A=

------=_NextPart_000_001F_01C87A04.A7FB9600--

