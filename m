Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37695 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935000AbcHEMPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 08:15:19 -0400
Message-ID: <1470399313.2977.38.camel@sipsolutions.net> (sfid-20160805_141522_323119_B583A910)
Subject: Re: [PATCH v3] nl80211: Receive correct value for
 NL80211_MESHCONF_HT_OPMODE command
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, me@bobcopeland.com
Date: Fri, 05 Aug 2016 14:15:13 +0200
In-Reply-To: <1470186464-4224-1-git-send-email-masashi.honma@gmail.com> (sfid-20160803_030806_642959_7FAC2A1C)
References: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
	 <1470186464-4224-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20160803_030806_642959_7FAC2A1C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-03 at 10:07 +0900, Masashi Honma wrote:
> Previously, NL80211_MESHCONF_HT_OPMODE rejected correct flag
> combination, ex) IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED |
> IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT.
> 
> This was caused by simple comparison with value 16. This causes
> setting
> non-existent flag (like 0x08) and invalid flag combinations. So this
> commit implements some checks based on IEEE 802.11 2012 8.4.2.59 HT
> Operation element.
> 
Applied, with some minor changes.

johannes
