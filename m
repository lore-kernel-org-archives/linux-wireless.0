Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:62083 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755048AbYLKPd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 10:33:29 -0500
Message-ID: <494132C3.5070907@lwfinger.net> (sfid-20081211_163333_340835_F4EF6854)
Date: Thu, 11 Dec 2008 09:33:23 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix for change in STA handling in mac80211
References: <127576.99770.qm@web23107.mail.ird.yahoo.com>
In-Reply-To: <127576.99770.qm@web23107.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> I don't know the verdict yet - but I think we need to either revert Johannes's earlier patch, or have this change from Larry incoporated, ASAP.
> 
> Hin-Tak

No, the best solution is to incorporate Johannes patch of today. Now that I
understand what happened, my patch just wallpapers over his mistake.

To explain how that happened, he used NL80211_IFTYPE_STATION (2) when he meant
BIT(NL80211_IFTYPE_STATION)(4). My "fix" works because BIT(NL80211_IFTYPE_ADHOC)
== NL80211_IFTYPE_STATION.

Larry



