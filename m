Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111Ab1EMMoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:44:21 -0400
Subject: concurrency advertising -- driver maintainers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 14:44:17 +0200
Message-ID: <1305290657.3487.32.camel@jlt3.sipsolutions.net> (sfid-20110513_144426_187099_CDAFE5E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please excuse the long CC list. I want to make you aware that I plan to
remove the WIPHY_FLAG_ENFORCE_COMBINATIONS flag again soon, so that all
drivers that don't advertise valid combinations will not be able to have
multiple virtual interfaces.

The affected drivers, as far as I can tell, are:
 * ath5k
 * ath9k
 * carl9170
 * hwsim (I'll look at this)
 * iwlagn (I'm handling that of course)
 * mwl8k
 * rt2x00 (see RFC patch)

I'm happy to help out with the restrictions code, please let me know.

I'd like to remove the flag again before it ever goes upstream, but I
understand the timing is bad, unless we hold my patch out of 2.6.40.

For completeness, I checked all drivers, and the following drivers don't
support more than a single virtual interface anyway:
 * adm8211
 * at76c50x-usb -- but it is broken because it has no checks
 * b43
 * b43legacy
 * iwlegacy
 * libertas_tf
 * p54
 * rtl8180
 * rtl8187
 * rtlwifi
 * wl1251
 * wl12xx
 * zd1211
(Staging drivers:)
 * brcm80211 is broken, allows multiple but can't handle it
 * winbond is also broken the same way

johannes


