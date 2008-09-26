Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:63386 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542AbYIZDGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 23:06:20 -0400
Message-ID: <48DC51AF.6000900@lwfinger.net> (sfid-20080926_050629_896731_195630F8)
Date: Thu, 25 Sep 2008 22:06:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net> <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
In-Reply-To: <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> wild guess try to revert:
> 'mac80211: make master iface not wireless'

You win the prize. Bisection shows that
84b0ba8ed0423a3c56a28e701b735daae3e15766 is first bad commit

commit 84b0ba8ed0423a3c56a28e701b735daae3e15766
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Sep 16 14:18:59 2008 +0200

    mac80211: make master iface not wireless


The actual crash is in the following routine from include/net/wireless.h:

/**
 * wiphy_priv - return priv from wiphy
 */
static inline void *wiphy_priv(struct wiphy *wiphy)
{
        BUG_ON(!wiphy);
        return &wiphy->priv;
}

I'm still looking to see where it goes wrong.

Larry

