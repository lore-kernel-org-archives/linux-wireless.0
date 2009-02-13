Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32794 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751298AbZBMUgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 15:36:43 -0500
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Fri, 13 Feb 2009 21:36:41 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1234396421.16004.67.camel@johannes.local>
Message-ID: <20090213203641.199830@gmx.net> (sfid-20090213_213650_661646_97859281)
MIME-Version: 1.0
References: <1234396421.16004.67.camel@johannes.local>
Subject: Re: [PATCH] mac80211: split IBSS/managed code
To: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

this patch is broken.

* In IBSS beaconing doesn't work.

* If you create a new IBSS network it
  scans for other networks to often
  3 times a second.

[  844.752425] wlan0: sta_find_ibss (active_ibss=3D0)
[  844.752435]    did not try to join ibss
[  844.752449] wlan0: No active IBSS STAs - trying to scan for other IB=
SS networks with same SSID (merge)
[  846.032344] wlan0: sta_find_ibss (active_ibss=3D0)
[  846.032356]    did not try to join ibss
[  846.051622] wlan0: No active IBSS STAs - trying to scan for other IB=
SS networks with same SSID (merge)
[  847.214000] wlan0: sta_find_ibss (active_ibss=3D0)
[  847.214009]    did not try to join ibss
[  847.214025] wlan0: No active IBSS STAs - trying to scan for other IB=
SS networks with same SSID (merge)

* If you join an existent IBSS it does
  the following strange things:

[ 5238.150840] wlan5: expiring inactive STA ffff8800bb800340
[ 5238.150847] phy0: Removed STA ffff8800bb800340
[ 5238.161306] phy0: Destroyed STA ffff8800bb800340
[ 5238.161316] wlan5: No active IBSS STAs - trying to scan for other IB=
SS networks with same SSID (merge)
[ 5238.223183] phy0: Adding new IBSS station ffff8800bb81a04a (dev=3Dwl=
an5)
[ 5238.223205] phy0: Allocated STA ffff8800bb800340
[ 5238.223213] phy0: Inserted STA ffff8800bb800340
[ 5238.855114] wlan5: sta_find_ibss (active_ibss=3D0)
[ 5238.855147]    sta_find_ibss: selected ffff88009942f040 current ffff=
8800bc0219f0
[ 5238.855150]    did not try to join ibss
[ 5238.867113] wlan5: expiring inactive STA ffff8800bb800340
[ 5238.867122] phy0: Removed STA ffff8800bb800340
[ 5238.880673] phy0: Destroyed STA ffff8800bb800340
[ 5238.880684] wlan5: No active IBSS STAs - trying to scan for other IB=
SS networks with same SSID (merge)
[ 5238.943194] phy0: Adding new IBSS station ffff8800bb83a04a (dev=3Dwl=
an5)
[ 5238.943218] phy0: Allocated STA ffff8800bb800340
[ 5238.943226] phy0: Inserted STA ffff8800bb800340
[ 5239.572256] wlan5: sta_find_ibss (active_ibss=3D0)
[ 5239.572282]    sta_find_ibss: selected ffff880099539640 current ffff=
8800bc0219f0
[ 5239.572285]    did not try to join ibss

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
