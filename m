Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:13361 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752535Ab0FHBKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 21:10:03 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0588869396
	for <linux-wireless@vger.kernel.org>; Tue,  8 Jun 2010 10:10:00 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 1/3] cfg80211: Add nl80211 antenna configuration
Date: Tue, 8 Jun 2010 10:10:13 +0900
References: <20100607065858.16060.38448.stgit@tt-desk> <1275901514.3639.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1275901514.3639.4.camel@jlt3.sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201006081010.13314.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 June 2010 18:05:14 you wrote:
> On Mon, 2010-06-07 at 15:58 +0900, Bruno Randolf wrote:
> > + * @NL80211_CMD_GET_ANTENNA: Get antenna configuration from driver.
> 
> Since we already have runtime configuration and capability information
> as part of the wiphy information printout, remind me again what was
> wrong with adding antenna information there as well rather than having a
> separate command to retrieve it?
>
> As far as differentiating that information is concerned, you can easily
> implement an iw "get antenna" command by just partially printing the
> wiphy information, for example, no?

i don't particularly care about where the antenna information is printed 
exactly, so anything will be fine with me.

but when i look at the wiphy info, it shows mostly capability information, 
like the list of supported frequencies, list of bitrates, supported interface 
modes, supported commands. the only exception is coverage class, which is the 
only runtime configuration as far as i can see. therefore i thought it doesnt 
fit there well.

maybe another command for getting runtime configuration like channel(s), fixed 
bitrates, essid, bssid, RTS/CTS, fraqmentation, txpower, power management, 
antenna settings, etc... would make sense? allthough in this list antenna is 
probably the only one which is per phy and not per interface...

i can leave the 'antenna get' command out until this is clarified.

bruno
