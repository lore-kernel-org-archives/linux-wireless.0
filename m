Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm14.bullet.mail.ukl.yahoo.com ([217.146.183.188]:21942 "HELO
	nm14.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751253Ab2A1HRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 02:17:17 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org
Subject: [RFC] minstrel_ht should not override user supplied rts
Date: Sat, 28 Jan 2012 15:17:06 +0800
Message-Id: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> (sfid-20120128_081736_321940_CED2FE97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently noticed that mac80211 ignores my "iw phy0 set rts" setting. It took
me a while to find the culprit - minstrel_ht enables rts/cts by setting
the IEEE80211_TX_RC_USE_RTS_CTS flag in minstrel_ht_set_rate() regardless of 
the rts threshold configured on the commandline. Since I did not find any
explanation why minstrel_ht does what it does I hereby propose a patch to
make minstrel_ht respect the user supplied setting. You will notice the
minstrel_ht_set_rate() function now never is called with rtscts = true. A
future patch will remove this parameter entirely.

Regards,
Marek

