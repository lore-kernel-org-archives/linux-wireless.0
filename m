Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g19.free.fr ([212.27.42.28]:41299 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbYFVTrs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 15:47:48 -0400
Received: from smtp2-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp2-g19.free.fr (Postfix) with ESMTP id 2AE5912B6F7
	for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 21:47:47 +0200 (CEST)
Received: from [192.168.0.3] (cac94-1-81-57-151-96.fbx.proxad.net [81.57.151.96])
	by smtp2-g19.free.fr (Postfix) with ESMTP id F399112B6CD
	for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2008 21:47:46 +0200 (CEST)
Message-ID: <485EAC63.1070709@free.fr> (sfid-20080622_214750_995849_F9E91273)
Date: Sun, 22 Jun 2008 21:47:47 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: zd1211 stability issue on 2.6.25
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using a zd1211 dongle [1] on 2.6.25 in wpa mode. Sometimes I got
disconnection [2]. But after that scanning seems to doesn't work anymore
[3].
This cause wpa_supplicant to do an endless lop try to find the AP in the
scan result and there no reconnection.
Only a ifconfig wlan0 down, ifconfig wlan0 up make work again scanning.

This make the dongle not usable.

Matthieu



[1]
phy0: Selected rate control algorithm 'pid'
firmware version 4725
zd1211rw 1-5:1.0: zd1211b chip 079b:0062 v4810 high 00-60-b3 AL2230_RF
pa0 g----

[2]
  wlan0: No ProbeResp from current AP 00:07:cb:50:0d:e6 - assume out of
range

[3]
$sudo iwlist wlan0 scan
wlan0     Interface doesn't support scanning : Network is down

