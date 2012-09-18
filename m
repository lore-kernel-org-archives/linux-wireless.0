Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab2IRHJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 03:09:23 -0400
Message-ID: <1347952199.6503.3.camel@jlt4.sipsolutions.net> (sfid-20120918_090927_009018_DC8FE745)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: artem.bityutskiy@linux.intel.com
Cc: Eric Dumazet <edumazet@google.com>, linux-wireless@vger.kernel.org
Date: Tue, 18 Sep 2012 09:09:59 +0200
In-Reply-To: <1347892887.7112.9.camel@sauron.fi.intel.com> (sfid-20120917_163617_677167_0B529F43)
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 (sfid-20120917_163617_677167_0B529F43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-09-17 at 17:41 +0300, Artem Bityutskiy wrote:


> OK, finally I got it. After 3 days of hardcore intelligent bisecting
>         I've found out that tethering in 3.5 works for me if I revert
> these 2
>         patches:
>         
>             56138f5 iwlwifi: dont pull too much payload in skb head
>             3edaf3e mac80211: manage AP netdev carrier state

Hm. This is curious. *How* does AP mode fail? You said earlier stations
failed to connect, but can they actually get associated? I'm curious
because while I could see the carrier state thing causing issues (on old
hostapd versions that we didn't test), I'm not sure I see how the skb
payload makes a difference since mac80211 will linearize management
frames (so association should work) and data frames don't matter (so
authorization should work) ... unless there's a bug somewhere in
mac80211 where it forgets to pskb_may_pull(), but I don't see any such
place right now.

johannes

