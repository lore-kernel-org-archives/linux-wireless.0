Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27140 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbZBLRkI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 12:40:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Feb 2009 09:40:08 -0800
Date: Thu, 12 Feb 2009 09:39:23 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jan Schneider <jan@horde.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Automatic/manual regulatory settings
Message-ID: <20090212173923.GD4196@tesla> (sfid-20090212_184013_466932_52FEA116)
References: <20090212181959.11876f8viq636hs0@neo.wg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090212181959.11876f8viq636hs0@neo.wg.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2009 at 09:19:59AM -0800, Jan Schneider wrote:
> While looking at logs collected for my microcode crash problem I
> noticed that cfg80211 loads US regulatory settings.

That is because of the CONFIG_WIRELESS_OLD_REGULATORY=y which I keep
insisting should die already. This is still present because CRDA is
starting to be embraced by distributions.

> If I understand the documentation correctly the actual country should
> be set either by the AP or the device using cfg80211.

Correct. With OLD_REG it also means you'll get a static default "US"
regulatory domain. The only other two static options are "JP" and "EU".
This is why this is OLD_REG -- its using static definitions and the
information is present inside the kernel.

Because you _may_ still have CRDA installed we also call CRDA if your
ieee80211_regdomain module parameter is either "US" or "JP" because
there are actual valid ISO / IEC 3166 alpha2 country codes and if
CRDA is present you will get to reap the benefits of an updated
regulatory domain.

> Neither seems to
> happen

On what device? Keep in mind iwlfifi driver ignores the first regulatory
setting by the regulatory code. If users later want to enhance regulatory
further they will have to call it manually using iw:

iw reg set FR

> so is it the "correct" way to do this through the
> ieee80211_regdom module parameter?

No, that should be used only for "US", "JP" and "EU", but technically
you can also try "FR" and CRDA will be called as well if present. But
the correct way to do this from userspace is to do it through iw or
wpa_supplicant, which as the capability of setting it too. If you are
writing your own application you can use the same nl80211 command as
iw and wpa_supplicant, NL80211_CMD_REQ_SET_REG.

> And I wonder how this is supposed
> to happen "idiot-proof" in the future?

Hm?

  LuisT
