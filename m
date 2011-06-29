Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:33228 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461Ab1F2N4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 09:56:03 -0400
Date: Wed, 29 Jun 2011 16:55:36 +0300
From: Jouni Malinen <j@w1.fi>
To: Michel Alexandre Salim <salimma@fedoraproject.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH] ath9k: add module option for disabling 11n
 functionality
Message-ID: <20110629135536.GB3259@jm.kir.nu> (sfid-20110629_155607_609380_0CDB2CEE)
References: <4E0A2F8A.8010102@fedoraproject.org>
 <20110628215757.GA14975@jm.kir.nu>
 <4E0AE8C1.9090809@fedoraproject.org>
 <20110629130910.GA2688@jm.kir.nu>
 <4E0B2BF8.6090300@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E0B2BF8.6090300@fedoraproject.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 03:43:20PM +0200, Michel Alexandre Salim wrote:
> The argument would be that driver-specific implementations are
> easier to get committed, and less intrusive than a general
> framework, but yes, I would prefer a more general solution myself.

Changes to the driver go through the same review process and if it makes
this any simpler to understand, I'm NACKing the change to ath9k since
that is not the correct place for this and module parameter is not the
proper mechanism for this type of workaround.

> Would this not require modifications to e.g. NetworkManager, ConnMan
> etc.  as well? While a module parameter is not an ideal workaround,
> it's at least easy to use. If this goes in as a connection
> parameter, it'd be nice to still have a way of manually adjusting it
> through a command-line tool.

Yes, doing this properly would indeed require changes somewhere in user
space (at least in wpa_supplicant; potentially in other components,
too). Were you assuming that users would manually unload and reload the
driver module if they happen to hit some issues? Or write some modprobe
config files to force 802.11n to be disabled for every connection?
Neither sounds like a reasonable "fix" to me.

> My first attempt to solve this was to use 'iwconfig wlan0 set rate
> 54M' -- but this yields "Operation not supported". How about making
> a request for a rate of 54M or below switch the device to 802.11g
> mode (and optionally, a rate of 11M or below => 802.11b mode)? That
> way we don't need to invent a new interface at all. How would I go
> about adding support for rate setting requests to the driver?

I would first move from WEXT to nl80211 in order to get any chance of
getting the change accepted.. We have a somewhat similar mechanism in
NL80211_CMD_SET_TX_BITRATE_MASK, but it does not address HT rates at
all, so some additions would be needed. For example, a new attribute to
the command could be used to set TX mask for MCS indexes and if none are
allowed, HT could be disabled. Though, a cleaner mechanism would likely
be to just provide an explicit attribute to disable 802.11n. If that is
done outside the scope of a single connection, that would be available
as a manual workaround even without modifications to
wpa_supplicant/NM/ConnMan.

-- 
Jouni Malinen                                            PGP id EFC895FA
