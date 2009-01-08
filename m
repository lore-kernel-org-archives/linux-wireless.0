Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f29.google.com ([209.85.218.29]:57472 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZAHJ6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 04:58:13 -0500
Received: by bwz10 with SMTP id 10so6501041bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 01:58:10 -0800 (PST)
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 12/14] mac80211: 802.11w - Optional software CCMP for management frames
Date: Thu, 8 Jan 2009 10:57:45 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>,
	Dan Williams <dcbw@redhat.com>
References: <20090107112346.369581673@atheros.com> <1231340944.3545.38.camel@johannes> <20090107153052.GA24894@jm.kir.nu>
In-Reply-To: <20090107153052.GA24894@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901081057.46495.helmut.schaa@gmail.com> (sfid-20090108_105818_992339_5C0D4244)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 7. Januar 2009 schrieb Jouni Malinen:
> On Wed, Jan 07, 2009 at 04:09:04PM +0100, Johannes Berg wrote:
> 
> > Or just adding it to nl80211, are we ever expecting to have pure wext
> > drivers with MFP capabilities??
> 
> Not that likely, I would assume. However, I would rather not start
> extending driver_wext.c in wpa_supplicant with nl80211 functionality and
> I don't see Network Manager moving away from hardcoding driver_wext
> anytime soon..

I guess NetworkManager won't move away from wext unless all drivers
support nl80211.

Jouni, what do you think about extending wpa_supplicant to allow mutliple
drivers to be set on the commandline (-Dnl80211,wext). The supplicant would
then try to register the first driver and only if that fails it takes the next
one (e.g. try nl80211 first and if that fails use wext). That way NM could
use nl80211 for drivers that support nl80211 (mainly mac80211-drivers) and
wext for the other drivers by passing "-Dnl80211,wext" to the supplicant.

That's just a quick thought but I'd like to hear your opinion.

Helmut
