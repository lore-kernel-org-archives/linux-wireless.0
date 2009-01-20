Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:52096 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757712AbZATPKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 10:10:17 -0500
Date: Tue, 20 Jan 2009 17:10:03 +0200
From: Jouni Malinen <j@w1.fi>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fixed BSSID step 3: Don't merge with the same BSSID
Message-ID: <20090120151003.GA8710@jm.kir.nu> (sfid-20090120_161023_264608_9862F976)
References: <20090106020130.302750@gmx.net> <20090108091055.GA7009@jm.kir.nu> <20090117221225.301920@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090117221225.301920@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 17, 2009 at 11:12:25PM +0100, Alina Friedrichsen wrote:
> > I agree that merge part (updating Beacon/ProbeRsp data) can be skipped
> > for same BSSID, but this change seems to break timesync by removing call
> > to local->ops->reset_tsf(). I don't think that that should be removed
> > unconditionally.

> I have looked in the Source of ath5k and ath9k. It seens to me that the TSF sync is done in the low-level driver and/or the hardware directly. So I see no reason to set it back to zero, if you have a dummy merge to the same BSSID and channel. (E.g. caused by TSF overflows.) I think it should only done if you change the network, so BSSID and/or channel is deferent.

Some hardware designs require the reset_tsf call to allow the hardware
to get back in sync with the TSF based on received timestamp values in
some cases. I would expect this to be used in ath9k and ath5k. This does
not mean that the timestamp would be reset to zero in actual Beacon
frames, i.e., this is just something done internally in the
driver/firmware/hardware and the need for reset_tsf() is to just provide
the notification to the driver when this special case is needed.

-- 
Jouni Malinen                                            PGP id EFC895FA
