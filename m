Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41550 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYH0UZn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2008 16:25:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Date: Wed, 27 Aug 2008 22:25:09 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080827013009.GA15781@tuxdriver.com> <1ba2fa240808271226i95a7789k481a68b09dc60164@mail.gmail.com>
In-Reply-To: <1ba2fa240808271226i95a7789k481a68b09dc60164@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808272225.10557.mb@bu3sch.de> (sfid-20080827_222547_947696_4453D216)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 27 August 2008, Tomas Winkler wrote:
> > John W. Linville (1):
> >      mac80211: quiet chatty IBSS merge message
> 
> This patch is correct yet it suppresses an important warning, meaning
> that you have constant IBSS reconnection, remove all connected station
> and adding them again, This greatly degraded performance. This is
> caused by inability to adjust to TSF of the IBSS leader
> 
> <snipt>
> static int ieee80211_sta_join_ibss(struct net_device *dev,
> 				   struct ieee80211_if_sta *ifsta,
> 				   struct ieee80211_sta_bss *bss)
> .....
> /* Remove possible STA entries from other IBSS networks. */
> 	sta_info_flush_delayed(sdata);
> </snip>

I fail to see how the TSF could be related to an ever reconnecting
station. Can you elaborate on what happens?

I was under the impression that the firmware would handle TSF stuff.
Also the "IBSS leader" is a new thing to me. I remember from the specs
that the device should accept the TSF from _any_ beacon. Not just a
"leader". Am I mislead? :)

I also fail to see how we could _ever_ set the TSF to something remotely
correct from the driver because of the FIFO delay.

> 
> > Assaf Krauss (1):
> >      iwlwifi: W/A for the TSF correction in IBSS

I cannot find this patch in wireless-testing and I don't
have a copy of wireless-2.6 here. Can you send me the patch, or
explain what it does?
