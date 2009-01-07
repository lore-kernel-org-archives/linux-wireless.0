Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46942 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755242AbZAGMZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 07:25:40 -0500
Date: Wed, 7 Jan 2009 14:24:27 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
Message-ID: <20090107122427.GA20019@jm.kir.nu> (sfid-20090107_132544_274942_500B007F)
References: <20090107112346.369581673@atheros.com> <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231330118.3545.28.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 07, 2009 at 01:08:38PM +0100, Johannes Berg wrote:
> On Wed, 2009-01-07 at 13:23 +0200, Jouni Malinen wrote:
> > plain text document attachment (ieee80211w-sw-mgmt-ccmp.patch)
> > If driver/firmware/hardware does not support CCMP for management
> > frames, it can now request mac80211 to take care of encryption and
> > decryption of management frames (when MFP is enabled) in software. The
> > driver will need to add this new IEEE80211_KEY_FLAG_SW_MGMT flag when a
> > CCMP key is being configured for TX side and return the encrypted frames
> > on RX side without RX_FLAG_DECRYPTED flag to use software CCMP for
> > management frames (but hardware for data frames).
> 
> Wouldn't it be better to invert the meaning of the flag so we don't have
> to update all drivers now? It's likely that people won't test CCMP hw
> encryption and also that it won't work, I'd think, no?

I did consider this, but could not convince myself that drivers would be
expected to work without some testing and likely changes.. I do not care
that much which way this is, so if you want this to be inverted, that's
fine, too. I might even go as far as adding an explicit capability flag
that drivers will need to set to claim MFP support and export this to
userspace so that hostapd/wpa_supplicant could refuse the configuration
early. With that kind of flag, inverting this key flag does not get much
since the drivers would need to be changed anyway for MFP to work in
every case.

-- 
Jouni Malinen                                            PGP id EFC895FA
