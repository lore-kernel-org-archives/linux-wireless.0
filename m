Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2HGLmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 07:42:40 -0400
Message-ID: <1344339753.15172.0.camel@jlt3.sipsolutions.net> (sfid-20120807_134243_933437_685EE03A)
Subject: Re: [PATCH] cfg80211: Fix for crash in cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Srinivasan B <srinivasanb@posedge.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Tue, 07 Aug 2012 13:42:33 +0200
In-Reply-To: <5020BF4F.2090304@posedge.com>
References: <5020BF4F.2090304@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-08-07 at 12:40 +0530, Srinivasan B wrote:
> Patch Description:
>                      cfg80211 module crashes when cfg80211 & mac80211 
> loaded and unloading lmac driver.
> 
> Scenario Explanation:
>                      (Step 1) : cfg80211, mac80211 and lmac driver 
> modules are loaded initially.
>                      (Step 2) : unload the lmac driver.
>                                      then any dev calls to stack causes 
> the crash.
> Code Changes:
>                      dev->ethtools_ops is assigned during 
> NETDEV_REGISTER and the same can be cleared during NETDEV_UNREGISTER.

This doesn't make any sense to me at all.

johannes

