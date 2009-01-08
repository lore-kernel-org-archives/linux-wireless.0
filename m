Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40502 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485AbZAHKsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 05:48:43 -0500
Date: Thu, 8 Jan 2009 12:48:22 +0200
From: Jouni Malinen <j@w1.fi>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for
	management frames
Message-ID: <20090108104822.GA12480@jm.kir.nu> (sfid-20090108_114850_326614_40AD125F)
References: <20090107112346.369581673@atheros.com> <1231340944.3545.38.camel@johannes> <20090107153052.GA24894@jm.kir.nu> <200901081057.46495.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901081057.46495.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 08, 2009 at 10:57:45AM +0100, Helmut Schaa wrote:

> Jouni, what do you think about extending wpa_supplicant to allow mutliple
> drivers to be set on the commandline (-Dnl80211,wext). The supplicant would
> then try to register the first driver and only if that fails it takes the next
> one (e.g. try nl80211 first and if that fails use wext). That way NM could
> use nl80211 for drivers that support nl80211 (mainly mac80211-drivers) and
> wext for the other drivers by passing "-Dnl80211,wext" to the supplicant.

Well, that could be done inside wpa_supplicant, but more or less the
same effect should already be doable by NM trying to first add the
interface with nl80211 as the driver interface and if that fails, fall
back to wext.

-- 
Jouni Malinen                                            PGP id EFC895FA
