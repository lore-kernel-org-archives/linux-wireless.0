Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.polimi.it ([131.175.12.3]:56597 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXLZA2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 19:28:07 -0500
From: stefano.brivio@polimi.it
Message-ID: <20071226012624.tjqnh69npcw4o8ko@webmail.polimi.it> (sfid-20071226_002812_148889_A0276BD0)
Date: Wed, 26 Dec 2007 01:26:24 +0100
To: stefano.brivio@polimi.it
Cc: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: [PATCH] mac80211: Fix rate reporting regression
References: <20071226000958.21143.10527.stgit@tetra.sourmilk.net>
	<20071226012007.otwhbzzi80ck8kko@webmail.polimi.it>
In-Reply-To: <20071226012007.otwhbzzi80ck8kko@webmail.polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting stefano.brivio@polimi.it:

>> +	fc = le16_to_cpu(hdr->frame_control);
>> +	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
>> +	    is_multicast_ether_addr(hdr->addr1) || !sta) {

Oops, we check here that sta is not NULL, so we don't dereference it  
in case. I shouldn't even try to comment things by looking at them  
using my crappy webmail.

You need to separate the if (!sta) and the if ((fc &  
IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||  
is_multicast_ether_addr(hdr->addr1)) branches anyway, in order to fix  
refcounting.


--
Ciao
Stefano



