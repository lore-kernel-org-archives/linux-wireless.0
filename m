Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:64252 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZINKyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 06:54:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id D10843A008
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 12:54:53 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B9s2r6CmhY+C for <linux-wireless@vger.kernel.org>;
	Mon, 14 Sep 2009 12:54:53 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F88AD.dip0.t-ipconnect.de [217.95.136.173])
	by mx51.mymxserver.com (Postfix) with ESMTP id 5949D3A006
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 12:54:52 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 835721E0036
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2009 12:54:42 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: cfg80211_mgd_wext_connect() and wpa_supplicant don't like each other
Date: Mon, 14 Sep 2009 12:54:14 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909141254.14988.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

When I'm using
* wpa_supplicant
* a static WEP network block
* wext-compat in linux-wl

I always get two errors when roaming (that is, not at the first
connection):


1252921234.926116: CTRL-EVENT-SCAN-RESULTS
1252921234.926185: 0: 00:13:19:80:da:30 ssid=MNFUNK    q70/0/217 e-1
1252921234.926208: 1: 00:1b:d4:44:35:90 ssid=MNWPA     q49/0/195 e-1
1252921234.926227: 2: 00:1b:53:11:dc:40 ssid=MNFUNK    q46/0/192 e-1
1252921234.926255: Trying to associate with 00:13:19:80:da:30 (SSID='MNFUNK' freq=2437 MHz)
1252921234.927327: sock 3, ifname eth1
1252921235.060073: Associated with 00:13:19:80:da:30
1252921235.060090: CTRL-EVENT-CONNECTED - Connection to 00:13:19:80:da:30 completed (auth)
1252921275.106101: ROAM: search for a better AP
1252921276.182124: CTRL-EVENT-SCAN-RESULTS
1252921276.182148: 0: 00:1b:53:11:dc:40 ssid=MNFUNK    q67/0/213 e-1
1252921276.182170: 1: 00:1b:d4:44:35:90 ssid=MNWPA     q60/0/206 e-1
1252921276.182189: 2: 00:13:19:80:da:30 ssid=MNFUNK    q53/0/199 e-1
1252921276.182218: Trying to associate with 00:1b:53:11:dc:40 (SSID='MNFUNK' freq=2412 MHz)
1252921276.184336: sock 3, ifname eth1
ioctl[SIOCSIWFREQ]: No such file or directory
ioctl[SIOCSIWESSID]: No such file or directory
1252921276.268451: Association request to the driver failed
1252921276.268477: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1252921276.355482: Associated with 00:1b:53:11:dc:40

I traced this down a bit into wext-sme.c, cfg80211_mgd_wext_siwfreq().

This function run's cfg80211_mgd_wext_connect() and this function
returns -2.

Isn't this a bit fishy?  Why should a connect function be called
when user-space wants to changes the frequency?   And if for some
reason this is really helpful/necessary, why return the failure
to do so as an error result back to the original "just change the
frequency" call?

In the end, this here:

1252921276.268451: Association request to the driver failed
1252921276.355482: Associated with 00:1b:53:11:dc:40

looks quite contradicting :-/

-- 
http://www.holgerschurig.de
