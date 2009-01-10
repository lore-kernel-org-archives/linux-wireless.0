Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59913 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752221AbZAJJRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 04:17:07 -0500
Date: Sat, 10 Jan 2009 11:16:59 +0200
From: Jouni Malinen <j@w1.fi>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
Message-ID: <20090110091659.GC1170@jm.kir.nu> (sfid-20090110_101713_441689_05B17BBA)
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu> <20090109205315.277310@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090109205315.277310@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 09, 2009 at 09:53:15PM +0100, Alina Friedrichsen wrote:

> As I see, only the sta_info_flush_delayed() call causes the problems. I can only disable this call in the ieee80211_sta_join_ibss() function, if the BSSID is the same. Do you think this would be better?

Yes, I think it would be better option than removing it and the reset_tsf()
call. Removing STA entries for other IBSS members in any merge case,
even if BSSID changes, does not sound correct in the first place. This
should really only be done if the SSID changes.

> > In other words, I would be fine if the calls to
> > ieee80211_sta_join_ibss() and ieee80211_ibss_add_sta() are replaced with
> > local->ops->reset_tsf() if BSSIDs are the same when
> > beacon_timestamp>rx_timestamp.
> 
> This would be a way, too.

Looking at ieee80211_sta_join_ibss(), most of the stuff there should not
really be needed if BSSID remains the same and we are only syncing our
TSF. reset_tsf() call should be enough for that. Other parts of this
function, apart from sta_info_flush_delayed(), should be run if BSSID
changes. sta_info_flush_delayed() should be included only if SSID
changes (or maybe if we join back to the same IBSS after a long time,
but I'm not too concerned about that corner case).

I think bit more cleanup here by splitting ieee80211_sta_join_ibss()
into pieces and only calling some of them in the merge/timesync case
would be the best solution. For the particular problem that you are
seeing, the minimal change would probably be just to make
sta_info_flush_delayed() call conditional on SSID change (I don't think
this would need to be based on BSSID change).
 
-- 
Jouni Malinen                                            PGP id EFC895FA
