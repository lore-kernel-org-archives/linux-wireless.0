Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46915 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZDOXVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 19:21:18 -0400
Received: from [192.168.1.42] (p5487ABF9.dip.t-dialin.net [84.135.171.249])
	by mail.holtmann.org (Postfix) with ESMTP id A34F38B45D
	for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 01:21:21 +0200 (CEST)
Subject: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 16 Apr 2009 01:21:12 +0200
Message-Id: <1239837672.11795.46.camel@violet> (sfid-20090416_012123_293746_81110E23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

so I have an Lenovo X200 with an Intel 5350 cards. This card contains
WiFi and WiMAX radios (not shared). The association with an AP keeps
breaking all the time and it is pretty hard to establish a durable
connection.

After a long debugging session with Reinette we finally tracked down
what is going on here. A full scan with this card takes 7-9 seconds and
that seems to be too long and trigger IEEE80211_MONITORING_INTERVAL
which then deauthenticates us with the AP (reason=6). Problem then is
that the attempt authenticate/associate with the AP fails with all the
time (reason=2). Bringing the interface down/up again doesn't help. It
seems that some internal mac80211 states are messed up. Some times the
whole process stalls completely and nothing happens anymore. Only
unloading and reloading the driver or rebooting helps.

Increasing the IEEE80211_MONITORING_INTERVAL to 10 seconds doesn't
trigger the deauthentication with the AP anymore (or less likely).

During debugging I verified that only the scan actually triggers the
deauthentication. If I don't scan (NM disabled) then everything works
smoothly.

I am running the latest wireless-testing tree (based on 2.6.30-rc2) from
today and the wpa_supplicant from GIT with nl80211 driver.

Regards

Marcel


