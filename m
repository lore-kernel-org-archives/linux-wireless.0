Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:19391 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbZJSPX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 11:23:57 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id DEF23148073
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 17:23:49 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7V77CvWTE+AF for <linux-wireless@vger.kernel.org>;
	Mon, 19 Oct 2009 17:23:49 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F95A1.dip0.t-ipconnect.de [217.95.149.161])
	by mx51.mymxserver.com (Postfix) with ESMTP id D8C541485B5
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 16:06:12 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 7DC551E0010
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2009 16:06:00 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: IBSS mode and scanning
Date: Mon, 19 Oct 2009 16:05:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910191605.48482.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list !

I now try for the first time ever to do some IBSS/ADHOC
networking (so that I can implement this for libertas+cfg80211).

I noticed several things:



Documentation
-------------
http://linuxwireless.org/en/users/Documentation/iw doesn't have
any example. Via google, I found
http://linuxwireless.org/en/users/Documentation/iw/replace-iwconfig,
but this example is wrong, e.g. the frequency isn't specified.

As I'm not yet an authoritative instance for IBSS questions, I
won't fix those wiki pages --- yet.



Scanning while in IBSS mode?
----------------------------
I finally settled to use these commands:

dmesg -c >/dev/null
iw dev wlan0 set type ibss
ifconfig wlan0 192.168.1.2 up
iw --debug dev wlan0 ibss join ADHOC 2412

This seemed to work, but then I tried to look at the beacon. This
was just not possible using "iw":

iw dev wlan0 scan freq
iw dev wlan0 scan freq 2412

didn't work. But, oh wonder, it worked via "iwlist eth1 scan".
For me it looks like a but that I have to use a WEXT tool to
check for ADHOC beacons while in IBSS mode.




DMESG spamming
--------------
At first, my dmesg looked quite reasonable:

[22313.286690] phy0: device now idle
[22313.292241] phy0: device no longer idle - in use
[22313.292647] wlan0: Trigger new scan to find an IBSS to join
[22316.000249] wlan0: Trigger new scan to find an IBSS to join
[22320.000336] wlan0: Trigger new scan to find an IBSS to join
[22322.000444] wlan0: Creating new IBSS network, BSSID 4e:9d:b6:88:b7:9b

but then something started to spam it (Note that I did *NOT* yet operate another IBSS mode):

[22352.000210] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[22352.032050] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[22352.068034] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[22352.108035] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[22352.140057] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
[22352.176038] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merg
...
ad-infinitum

-- 
http://www.holgerschurig.de
