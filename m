Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:38967 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbYJ3SNj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 14:13:39 -0400
Date: Thu, 30 Oct 2008 20:12:31 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/6] cfg80211: enable 5 GHz band for world regulatory
	domain
Message-ID: <20081030181231.GF3923@jm.kir.nu> (sfid-20081030_191346_310505_FAAEE647)
References: <1225329594-21704-1-git-send-email-lrodriguez@atheros.com> <1225329594-21704-2-git-send-email-lrodriguez@atheros.com> <1225329594-21704-3-git-send-email-lrodriguez@atheros.com> <1225329594-21704-4-git-send-email-lrodriguez@atheros.com> <1225329594-21704-5-git-send-email-lrodriguez@atheros.com> <1225329594-21704-6-git-send-email-lrodriguez@atheros.com> <1225329594-21704-7-git-send-email-lrodriguez@atheros.com> <53ad401862d734b26836f0706a394525.squirrel@secure.sipsolutions.net> <43e72e890810300909if0e2db1qf5ff8512ab760275@mail.gmail.com> <1225387137.3690.70.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225387137.3690.70.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 06:18:57PM +0100, Johannes Berg wrote:

> Yeah but if a user just starts hostapd without crda then we shouldn't
> allow it to operate in 5GHz

Currently, we don't allow that or well, to be more exact, hostapd does
not since it has hardcoded channel list that only allows 2.4 GHz
channels 1-11. Anyway, that is about to change and hostapd will read the
channel lists through nl80211. It looks like 'iw phy info' shows some 5
GHz channels with "radar detection" flag, so it looks like hostapd can,
for now, just drop those channels when CRDA is available. I haven't
actually looked at what happens without CRDA, but anyway, that will
hopefully have similar flag available somehow (or the channels disabled
until such flag becomes available).

-- 
Jouni Malinen                                            PGP id EFC895FA
