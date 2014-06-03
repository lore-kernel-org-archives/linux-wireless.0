Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:48208 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaFCNO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 09:14:56 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp01.msg.oleane.net (MTA) with ESMTP id s53DErb5009994
	for <linux-wireless@vger.kernel.org>; Tue, 3 Jun 2014 15:14:53 +0200
Subject: cfg80211: enable chanel with CRDA issue
Date: Tue, 3 Jun 2014 15:14:51 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319017BCEBA@sbs2003.acksys.local> (sfid-20140603_151528_422534_79EFEC6A)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi, 

I'm using a compat-wireless 2014-05-22 from openwrt.
I changed the package/kernel/mac80211 Makefile to use the CRDA (I
removed the CFG80211_INTERNAL_REGDB flags)

My product boot on US regulatory domain. I set the FR regulatory domain
with iw command.

After FR domain are set, I don't have all channel available in france.
Only the channel available in US and in FR are available.

The origin of this issue is that the flags IEEE80211_CHAN_DISABLED is
never cleared.

I looking for on compat-wireless source files, but I don't understand
how all flags are cleared on channel structure. 

Could you give me some  pointer to fix this issue ?

Regards.

Cedric Voncken 

