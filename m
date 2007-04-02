Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:62511 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbXDBDuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2007 23:50:19 -0400
Message-ID: <46107D79.3060706@lwfinger.net>
Date: Sun, 01 Apr 2007 22:50:17 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: WPA does not connect to bcm43xx-mac80211 when using NetworkManager
References: <460E2B8C.4030002@gmail.com>	 <200703311503.53445.flamingice@sourmilk.net>	 <f6ca9fed0703311256m1b14ec35p836a62de532dd804@mail.gmail.com>	 <200703311700.52792.flamingice@sourmilk.net> <1175388624.10282.0.camel@localhost.localdomain>
In-Reply-To: <1175388624.10282.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Dan,

My bcm43xx-mac80211 system generates the following log entries when trying to connect using WPA-PSK
TKIP controlled by NetworkManager. The same configuration works with bcm43xx-softmac.

eth1: Initial auth_alg=0
eth1: authenticate with AP 00:14:bf:85:49:fa
eth1: RX authentication from 00:14:bf:85:49:fa (alg=0 transaction=2 status=0)
eth1: authenticated
eth1: associate with AP 00:14:bf:85:49:fa
eth1: RX AssocResp from 00:14:bf:85:49:fa (capab=0x31 status=0 aid=2)
eth1: associated
wmaster0: Added STA 00:14:bf:85:49:fa
eth1: RX deauthentication from 00:14:bf:85:49:fa (reason=15)
eth1: deauthenticated
eth1: set_encrypt - unknown addr 00:00:00:00:00:00
eth1: authenticate with AP 00:14:bf:85:49:fa
eth1: RX authentication from 00:14:bf:85:49:fa (alg=0 transaction=2 status=0)
eth1: authenticated
eth1: associate with AP 00:14:bf:85:49:fa
eth1: RX ReassocResp from 00:14:bf:85:49:fa (capab=0x31 status=0 aid=2)
eth1: associated
eth1: starting scan

It does the original open authentication and associates, but the final WPA authentication times out.

I'm using Michael Buesch's "mb" tree with the "mac80211: use IWEVGENIE" and "mac80211: set enc_capa"
patches by Michael Wu. My distro is openSUSE 10.2 on an x86_64 system.

Please advise on any further information I should provide.

Thanks,

Larry
