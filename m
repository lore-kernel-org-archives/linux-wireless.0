Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56267 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbYIZTAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 15:00:39 -0400
Date: Fri, 26 Sep 2008 15:00:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	YanBo <dreamfly281@gmail.com>
Subject: Re: wireless-testing modpost failure
Message-ID: <20080926190007.GD3483@tuxdriver.com> (sfid-20080926_210043_825340_4B499BE5)
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 08:04:18PM +0200, Davide Pesavento wrote:
> Hi!
> 
> I just pulled from wireless-testing git tree and I'm now hitting this
> build error:
> 
>   Building modules, stage 2.
>   MODPOST 216 modules
> ERROR: "mpp_path_lookup" [net/mac80211/mac80211.ko] undefined!
> ERROR: "mpp_path_add" [net/mac80211/mac80211.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> My kernel config:
> 
> $ grep CONFIG_MAC80211 .config
> CONFIG_MAC80211=m
> CONFIG_MAC80211_RC_PID=y
> CONFIG_MAC80211_RC_DEFAULT_PID=y
> CONFIG_MAC80211_RC_DEFAULT="pid"
> # CONFIG_MAC80211_MESH is not set

Turn this on to make it build again.

I'm not sure what the best long-term solution is.  Should we define
empty versions of those functions when that config option is unset?
Or just make the whole block subject to that config option?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
