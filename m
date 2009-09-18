Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17107 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZIRMQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 08:16:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 9AD6C4B00E
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 14:16:10 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id umb27iTLGAde for <linux-wireless@vger.kernel.org>;
	Fri, 18 Sep 2009 14:16:10 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F87DB.dip0.t-ipconnect.de [217.95.135.219])
	by mx51.mymxserver.com (Postfix) with ESMTP id 349894B008
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 14:16:09 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 8C0D51E0036
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 14:15:58 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: scren result doesn't match probe-response
Date: Fri, 18 Sep 2009 14:15:23 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909181415.23124.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have three APs and let wpa_supplicant connect to one:

1253271753.960692: Received scan results (3 BSSes)
1253271753.960710: ##HS 0: 00:1b:d4:44:35:90 ssid='MNWPA' freq=2412
1253271753.960728: ##HS 1: 00:1b:53:11:dc:40 ssid='MNFUNK' freq=2412
1253271753.960745: ##HS 2: 00:13:19:80:da:30 ssid='MNHS' freq=2412
...
1253271754.402004: CTRL-EVENT-CONNECTED - Connection to 00:13:19:80:da:30 completed (auth) [id=0 id_str=]


When I change the the access-point with MNHS/WPA to XXXXX/WPA2.
The APs sends a de-auth message, and wpa_supplicant does a scan:

 56.445693 00:13:19:80:da:30 -> 00:20:a6:61:15:c0 IEEE 802.11 Deauthentication,SN=555,FN=0
 57.117063 00:20:a6:61:15:c0 -> ff:ff:ff:ff:ff:ff IEEE 802.11 Probe Request,SN=8,FN=0, SSID: "MNHS"
 57.307272 00:20:a6:61:15:c0 -> ff:ff:ff:ff:ff:ff IEEE 802.11 Probe Request,SN=9,FN=0, SSID: "MNHS"
 57.518420 00:20:a6:61:15:c0 -> ff:ff:ff:ff:ff:ff IEEE 802.11 Probe Request,SN=10,FN=0, SSID: "MNHS"
 58.104889 00:20:a6:61:15:c0 -> ff:ff:ff:ff:ff:ff IEEE 802.11 Probe Request,SN=11,FN=0, SSID: "MNHS"
 58.105612 00:20:a6:61:15:c0 -> ff:ff:ff:ff:ff:ff IEEE 802.11 Probe Request,SN=12,FN=0, SSID: "MNFUNK"
 58.105967 00:1b:53:11:dc:40 -> 00:20:a6:61:15:c0 IEEE 802.11 Probe Response,SN=1496,FN=0,BI=100, SSID: "MNFUNK"
 58.555765 00:1b:53:11:dc:40 -> 00:20:a6:61:15:c0 IEEE 802.11 Probe Response,SN=1503,FN=0,BI=100, SSID: "MNFUNK"
 58.556370 00:1b:53:11:dc:40 -> 00:20:a6:61:15:c0 IEEE 802.11 Probe Response,SN=1504,FN=0,BI=100, SSID: "MNFUNK"
 58.607339 00:1b:53:11:dc:40 -> 00:20:a6:61:15:c0 IEEE 802.11 Authentication,SN=1505,FN=0
 58.636330 00:1b:53:11:dc:40 -> 00:20:a6:61:15:c0 IEEE 802.11 Authentication,SN=1506,FN=0

So far, so fine. Now let's look what wpa_supplicant get's back
as a scan-result:

1253271769.784819: Received scan results (3 BSSes)
1253271769.784836: ##HS 0: 00:1b:d4:44:35:90 ssid='MNWPA' freq=2412
1253271769.784855: ##HS 1: 00:1b:53:11:dc:40 ssid='MNFUNK' freq=2412
1253271769.784871: ##HS 2: 00:13:19:80:da:30 ssid='' freq=2412

Hey, there was no probe-response from da:30 at all ...

-- 
http://www.holgerschurig.de
