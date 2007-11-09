Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:56427 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbXKIQxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 11:53:54 -0500
Message-ID: <473490A0.2050403@lwfinger.net> (sfid-20071109_165359_386695_518B888E)
Date: Fri, 09 Nov 2007 10:53:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Deauthentication cycles
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In my network using WPA-PSK TKIP with mac80211 and b43, I see several of these cycles per day:

eth1: RX deauthentication from 00:1a:70:46:ba:b1 (reason=7)
eth1: deauthenticated
eth1: authenticate with AP 00:1a:70:46:ba:b1
eth1: RX authentication from 00:1a:70:46:ba:b1 (alg=0 transaction=2 status=0)
eth1: authenticated
eth1: associate with AP 00:1a:70:46:ba:b1
eth1: RX ReassocResp from 00:1a:70:46:ba:b1 (capab=0x431 status=0 aid=1)
eth1: associated
eth1: switched to short barker preamble (BSSID=00:1a:70:46:ba:b1)

In searching through the various 802.11-related header files, the only reason code of 7 that I could
find is

WLAN_REASON_CLASS3_FRAME_FROM_NONASSOC_STA

Is this the correct code? If so, any ideas on why this deauthentication is happening? As can be
seen, it isn't fatal and the system always recovers.

Thanks,

Larry
