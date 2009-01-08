Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:51857 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbZAHJLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 04:11:13 -0500
Date: Thu, 8 Jan 2009 11:10:55 +0200
From: Jouni Malinen <j@w1.fi>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
Message-ID: <20090108091055.GA7009@jm.kir.nu> (sfid-20090108_101120_179972_5A36594C)
References: <20090106020130.302750@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090106020130.302750@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 06, 2009 at 03:01:30AM +0100, Alina Friedrichsen wrote:

> It's completely unnecessary to merge with same BSSID. Because here in our city networks we have many of the same BSSID (and SSID) with deferent timestamps, this causes problems.

I agree that merge part (updating Beacon/ProbeRsp data) can be skipped
for same BSSID, but this change seems to break timesync by removing call
to local->ops->reset_tsf(). I don't think that that should be removed
unconditionally. I would like to know whether that operation is causing
any problems in citywide networks and if yes, it might be better to
provide a configuration option to allow the timesync for IBSS to be
disabled since not doing that could cause problems to power saving in
IBSS (not that it is really implemented that widely).

In other words, I would be fine if the calls to
ieee80211_sta_join_ibss() and ieee80211_ibss_add_sta() are replaced with
local->ops->reset_tsf() if BSSIDs are the same when
beacon_timestamp>rx_timestamp.

-- 
Jouni Malinen                                            PGP id EFC895FA
