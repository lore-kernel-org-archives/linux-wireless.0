Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 84-16-245-18.internetserviceteam.com ([84.16.245.18]:41360 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbXDDVLf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2007 17:11:35 -0400
Received: from localhost (localhost [127.0.0.1])
	by hauke-m.de (Postfix) with ESMTP id F199C158F6
	for <linux-wireless@vger.kernel.org>; Wed,  4 Apr 2007 22:38:47 +0200 (CEST)
Received: from hauke-m.de ([84.16.245.18])
	by localhost (vs9007 [84.16.245.18]) (amavisd-new, port 10024)
	with ESMTP id 07359-05 for <linux-wireless@vger.kernel.org>;
	Wed, 4 Apr 2007 22:38:41 +0200 (CEST)
Received: from [192.168.0.2] (p54808aab.dip0.t-ipconnect.de [84.128.138.171])
	by hauke-m.de (Postfix) with ESMTP id 357BC158F4
	for <linux-wireless@vger.kernel.org>; Wed,  4 Apr 2007 22:38:39 +0200 (CEST)
Message-ID: <46140CD0.3010205@hauke-m.de>
Date: Wed, 04 Apr 2007 22:38:40 +0200
From: Hauke Mehrtens <linux-wireless@hauke-m.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: no reassociateing with rtl8187 driver
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi

I am using the rtl8187 driver based on the mac80211 stack and it is
working pretty well except it can't reassociate to the access point with
WEP encryption enabled (I haven't tested without) of which he lost the
connection.

The association process worked very well:

wlan0: starting scan
wlan0: scan completed
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:40:05:cc:38:b4
wlan0: authenticate with AP 00:40:05:cc:38:b4
wlan0: RX authentication from 00:40:05:cc:38:b4 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:40:05:cc:38:b4
wlan0: RX AssocResp from 00:40:05:cc:38:b4 (capab=0x51 status=0 aid=2)
wlan0: associated

But if he loses the connection for example because someone is standing
between the AP and the wireless card, he doesn't try to reassociate to
the wireless LAN and I get this:

wlan0: No ProbeResp from current AP 00:40:05:cc:38:b4 - assume out of range
wlan0: No STA entry for own AP 00:40:05:cc:38:b4
wlan0: No STA entry for own AP 00:40:05:cc:38:b4
wlan0: No STA entry for own AP 00:40:05:cc:38:b4

After stopping the interface and starting it an other time the card is
connecting to the AP

wmaster0: Does not support passive scan, disabled
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:40:05:cc:38:b4
wlan0: authenticate with AP 00:40:05:cc:38:b4
wlan0: RX authentication from 00:40:05:cc:38:b4 (alg=0 transaction=2
status=0)
wlan0: authenticated
wlan0: associate with AP 00:40:05:cc:38:b4
wlan0: RX AssocResp from 00:40:05:cc:38:b4 (capab=0x51 status=0 aid=2)
wlan0: associated

- --
Hauke Mehrtens
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGFAzQrcX0gpXFjnsRAiYgAJ9OYHLHkUvv5tvfZ7+wohvOdmK4tQCcDZ+E
BZabge3jRk4f6eOdV3pTDp8=
=G0GE
-----END PGP SIGNATURE-----
