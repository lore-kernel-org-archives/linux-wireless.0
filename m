Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:37913 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752629AbZAGOKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 09:10:15 -0500
Date: Wed, 7 Jan 2009 16:09:56 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
Message-ID: <20090107140956.GA22424@jm.kir.nu> (sfid-20090107_151024_212177_F5EA3B37)
References: <20090107112346.369581673@atheros.com> <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes> <20090107122427.GA20019@jm.kir.nu> <1231332428.3545.33.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1231332428.3545.33.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 07, 2009 at 01:47:08PM +0100, Johannes Berg wrote:

> Ok, I guess in that case it doesn't really matter much, though it'd be
> good to not randomly associate to an AP that has MFP enabled when we
> don't know the hardware can handle it.

Yes and that why I was considering of a flag to notify hostapd and
wpa_supplicant about the capability.. But that would mean modifying WEXT
even more ;-).

> I know, for example, that Broadcom hardware can handle it just fine when
> done in software, but I'm pretty sure it cannot handle it in hardware
> crypto...

If that is the case, it would be just a quick test and one-liner to the
driver to fix it. As long as the hardware/firmware does not touch
received management frames that have Protected field set to one it
should be fine (some try to use same rules as for data frames and that
will fail).

> You seem to be concerned only about AP mode, while I'm not much
> concerned about that, there it's always tested explicitly by the person
> setting up the AP, but someone who's just using STA mode would now
> suddenly potentially run into problems when using an AP that is
> MFP-enabled, no?

It is similar for both ends.. For example, wpa_supplicant does not
enable MFP on the client side by default, i.e., both hostapd and
wpa_supplicant behave the same in the sense that MFP needs to be
explicitly enabled.

> Hence, I think adding an explicit flag (whether it needs to be exported
> to userspace I don't know) would probably be good so if the driver/hw
> really cannot handle MFP at all then we don't associate using it, no?

MFP is negotiated in RSN IE and in case of mac80211, it would need to be
going to userspace since wpa_supplicant builds the RSN IE (and well,
hostapd obviously does the same for Authenticator side). We could a new
WEXT capability (e.g., IW_ENC_CAPA_MFP) for this, if desired.. It would
also be possible already with the current patchset to probe for this by
setting IW_AUTH_MFP and see whether the driver returns EOPNOTSUPP, so in
that sense, wpa_supplicant (and hostapd) could already figure this out
before trying to associate.

-- 
Jouni Malinen                                            PGP id EFC895FA
