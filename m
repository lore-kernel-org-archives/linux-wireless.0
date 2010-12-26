Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:40851 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0LZLYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 06:24:11 -0500
Subject: [RFC PATCH 0/6] zd1211rw: add support for AP mode
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, zd1211-devs@lists.sourceforge.net,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sun, 26 Dec 2010 13:24:04 +0200
Message-ID: <20101226112404.31775.77854.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

This patchset adds AP mode to zd1211rw. I have done this with vendor driver
as reference and in most parts everything appears ok. Unencrypted AP and 
WEP appears to work without issues, driver can switch back to station mode
without problems.

Now current problems are:

 1. I have not been able to trigger bc/mc buffering. I have tested with
    b43 and rndis_wlan stations.
 2. When connecting with b43 to WPA enabled AP (hostapd 0.7.3), I get lots of:
	wlan2: STA 00:xx:xx:xx:xx:xx IEEE 802.1X: unauthorizing port
	wlan2: STA 00:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated
    and then after ~1-2 minutes of retrying finally it makes connection.
    With rndis_wlan, no problems.
    Either I have hostapd config error (first time using hostapd), or
    something is wrong with driver.
