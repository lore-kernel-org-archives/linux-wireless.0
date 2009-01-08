Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48884 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbZAHMTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:19:07 -0500
Date: Thu, 8 Jan 2009 14:18:39 +0200
From: Jouni Malinen <j@w1.fi>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
Message-ID: <20090108121839.GA20687@jm.kir.nu> (sfid-20090108_131918_806704_C6EF3EE9)
References: <20090107112346.369581673@atheros.com> <200901081057.46495.helmut.schaa@gmail.com> <20090108104822.GA12480@jm.kir.nu> <200901081308.23046.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901081308.23046.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 08, 2009 at 01:08:21PM +0100, Helmut Schaa wrote:

> True. However, other consumers of wpa_supplicant (e.g. Yast in SUSE) could
> also benefit from this feature if implemented inside the supplicant. But as
> I wrote, this was just a quick thought on how to make the transition from
> wext to nl80211 smoother.

Agreed and it should be relatively small change in wpa_supplicant, so
I'm not against doing this. However, at this point I would not yet
recommend trying to use driver_nl80211 as the first option. Once we get
nl80211 bit more complete and at least make sure it does not break
something, adding the automatic driver selection would sound more
reasonable. Though, this would also mean that we depend on drivers never
implementing partial nl80211 support that could trigger wpa_supplicant
into believing that they support nl80211 when they would actually work
much better with wext.

-- 
Jouni Malinen                                            PGP id EFC895FA
