Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54716 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYIXXdE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 19:33:04 -0400
Date: Wed, 24 Sep 2008 19:32:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
Message-ID: <20080924233234.GE3639@tuxdriver.com> (sfid-20080925_013308_780810_8A99BF6D)
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com> <20080924232453.GG9187@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080924232453.GG9187@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 24, 2008 at 04:24:53PM -0700, Luis R. Rodriguez wrote:
> On Wed, Sep 24, 2008 at 03:15:36PM -0700, John W. Linville wrote:
> > This is also an excuse to create the long rumored lib80211 module...
> 
> How about stuffing it in something like:
> 
> include/linux/wlandevice.h
> 
> Is there a benefit to having a module for it as this time?

The escape_essid function is currently not inlined.  Are you
arguing that it should be?  Otherwise it needs to live _somewhere_.
The cfg80211 module might make sense, except that the libertas,
ipw2100, and ipw2200 drivers don't use cfg80211 (at least for now).

Besides, you have to start _somewhere_.  I have a feeling that this
happened in the first place because there was nowhere for drivers to
share bits of code like this (other than mac80211 or iee80211).

> Which reminds me, net/ieee80211/ should be ipw'ized now that the
> old softmac drivers are gone.
> 
> mcgrof@tesla ~/wireless-testing/drivers/net/wireless (git::v2.6.27-rc6)$ grep -nHr "#include <net/ieee80211.h>" *
> airo.c:50:#include <net/ieee80211.h>
> atmel.c:70:#include <net/ieee80211.h>
> hostap/hostap_main.c:29:#include <net/ieee80211.h>
> hostap/hostap_hw.c:49:#include <net/ieee80211.h>
> ipw2100.h:42:#include <net/ieee80211.h>
> ipw2200.h:51:#include <net/ieee80211.h>
> libertas/types.h:10:#include <net/ieee80211.h>
> libertas/main.c:17:#include <net/ieee80211.h>
> libertas/dev.h:13:#include <net/ieee80211.h>
> libertas/wext.c:11:#include <net/ieee80211.h>
> libertas/cmd.c:7:#include <net/ieee80211.h>
> orinoco.c:88:#include <net/ieee80211.h>
> rndis_wlan.c:44:#include <net/ieee80211.h>
> wl3501.h:5:#include <net/ieee80211.h>
> zd1201.c:24:#include <net/ieee80211.h>
> 
> Whatever these suckers are using can probably be slapped in there as
> well. But yea -- we just need to get it done huh.
> 
> Thoughts?

I figure there are probably other bits that can be shared, but most of
them probably require at least _some_ recoding.  This is a no-brainer
and it "breaks the ice" for more follow-on work.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
