Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 84-16-245-18.internetserviceteam.com ([84.16.245.18]:58885 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423196AbXD3MV7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2007 08:21:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by hauke-m.de (Postfix) with ESMTP id 67D37164F7
	for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2007 13:58:23 +0200 (CEST)
Received: from hauke-m.de ([84.16.245.18])
	by localhost (vs9007 [84.16.245.18]) (amavisd-new, port 10024)
	with ESMTP id 03221-10 for <linux-wireless@vger.kernel.org>;
	Mon, 30 Apr 2007 13:58:15 +0200 (CEST)
Received: from [192.168.0.2] (p5480a40f.dip0.t-ipconnect.de [84.128.164.15])
	by hauke-m.de (Postfix) with ESMTP id 503F3164F3
	for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2007 13:58:15 +0200 (CEST)
Message-ID: <4635D9D9.1080005@hauke-m.de>
Date: Mon, 30 Apr 2007 13:58:17 +0200
From: Hauke Mehrtens <hauke_nospam@hauke-m.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rtl8187 loosing connection to AP
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have an other problem with the rtl8187 driver for mac80211.
I am using wpa_supplicant with wext with a static IP address and ubuntu=
 7.04

Sometimes (round about every 3 hours) it loses the connection probably
because of some person being between the AP and the card for a small
period of time, but now I saw a second wireless card logging in the tim=
e
range when my card lost the connection, so I can't say exactly what
causes the problem.

iwconfig says the connection is up and associated to the right AP but
the Signal level is something about 12/65 and not 21/65 as normal and
the Link Quality is always about 44/64.
In dmesg no message appears
When pinging the AP only TX bytes are send and the RX bytes don't move
in ifconfig.

After stopping and restarting the connection manually with debian's
ifdown and ifup it doesn't find any AP only "modprobe -r rtl8187" and
"modprobe rtl8187" works for getting the connection up again.

Now I have tested to jam the signal after the connection was lost and I
got these messages from dmesg:

The AP 00:40:05:cc:38:b4 was running all the time.

[10155.912837] wlan0: No ProbeResp from current AP 00:40:05:cc:38:b4 -
assume out of range
[10156.016649] wlan0: starting scan
[10157.289982] wlan0: scan completed
[10157.349069] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10162.339520] wlan0: starting scan
[10163.612845] wlan0: scan completed
[10163.670995] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10168.662296] wlan0: starting scan
[10169.935636] wlan0: scan completed
[10169.993801] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10174.985171] wlan0: starting scan
[10176.258543] wlan0: scan completed
[10176.316600] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10181.324027] wlan0: starting scan
[10182.597374] wlan0: scan completed
[10182.655369] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10187.646843] wlan0: starting scan
[10188.920201] wlan0: scan completed
[10188.978221] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10193.969671] wlan0: starting scan
[10195.243014] wlan0: scan completed
[10195.300967] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10200.292497] wlan0: starting scan
[10201.565811] wlan0: scan completed
[10201.623766] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10206.615296] wlan0: starting scan
[10207.888627] wlan0: scan completed
[10207.947189] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10212.938207] wlan0: starting scan
[10214.211526] wlan0: scan completed
[10214.269498] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10219.261170] wlan0: starting scan
[10220.519913] wlan0: scan completed
[10220.578938] wlan0: No STA entry for own AP 00:40:05:cc:38:b4
[10225.570102] wlan0: starting scan
[10235.056946] wmaster0: Does not support passive scan, disabled
[10235.406471] wlan0: starting scan
[10236.681814] wlan0: scan completed
[10236.739947] wlan0: starting scan
[10238.019091] wlan0: scan completed
[10243.069709] wlan0: starting scan
[10244.315804] wlan0: scan completed
[10245.653922] wlan0: no IPv6 routers present
[10249.366207] wlan0: starting scan
[10250.639630] wlan0: scan completed
=2E........
[10331.349275] wlan0: starting scan
[10332.578674] wlan0: scan completed
- --
Hauke Mehrtens


Hauke Mehrtens
Westpreu=C3=9Fenweg 10
27442 Gnarrenburg
Tel.  : 04763/1745
Mobil : 0151/10778862
ICQ   : 160871207
Web   : www.hauke-m.de
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNdnZrcX0gpXFjnsRAt4BAJ4yQ9irW2Nz+FKLG0JrAHJYgexxPQCeNXzg
CByR8ApiKJBNHP2iaj5ndHY=3D
=3DA57G
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
