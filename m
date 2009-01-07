Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:33517 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759394AbZAGPbN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 10:31:13 -0500
Date: Wed, 7 Jan 2009 17:30:52 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
Message-ID: <20090107153052.GA24894@jm.kir.nu> (sfid-20090107_163128_641236_7A217A8E)
References: <20090107112346.369581673@atheros.com> <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes> <20090107122427.GA20019@jm.kir.nu> <1231332428.3545.33.camel@johannes> <20090107140956.GA22424@jm.kir.nu> <1231340944.3545.38.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231340944.3545.38.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 07, 2009 at 04:09:04PM +0100, Johannes Berg wrote:

> Or just adding it to nl80211, are we ever expecting to have pure wext
> drivers with MFP capabilities??

Not that likely, I would assume. However, I would rather not start
extending driver_wext.c in wpa_supplicant with nl80211 functionality and
I don't see Network Manager moving away from hardcoding driver_wext
anytime soon..

> Generally, the thing is that we don't really want to require people to
> manually enable MFP, but rather have NM set it to "enable whenever
> possible". That seems not workable unless we know which driver/hw
> supports it.

Sure. Enabling optional MFP automatically whenever driver/hw supports it
would be nice (there is a separate policy selection of requiring MFP and
that's something that users will need to configure if they want it). For
this feature, I would be fine having the optional-MFP configuration in
wpa_supplicant mean that it will be disabled if driver does not support
it, i.e., NM would not actually need to care and it could just always
set ieee80211w=1 in wpa_supplicant configuration (or well, at this
point, it would need to care a bit since wpa_supplicant would reject the
configuration if it was not built with 802.11w support, but that is
probably fine when done over dbus and not config file).

As far as wpa_supplicant is concerned, I can make it determine this by
trying to enable MFP mode at startup to figure out whether the driver is
capable, so there is no need to add an explicit capability flag for this
if we do not want to modify WEXT. For nl80211, we can add capability
flag for MFP and then driver_nl80211.c can skip this validation step.
However, we would still need to add a driver-mac80211 flag for
indicating whether the driver supports MFP.

-- 
Jouni Malinen                                            PGP id EFC895FA
