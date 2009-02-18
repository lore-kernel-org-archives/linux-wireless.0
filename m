Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48479 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbZBRIZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 03:25:46 -0500
Date: Wed, 18 Feb 2009 10:25:20 +0200
From: Jouni Malinen <j@w1.fi>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Missing link quality with wireless-testing
Message-ID: <20090218082520.GA26280@jm.kir.nu> (sfid-20090218_092600_369268_B19E9165)
References: <1234896777.4678.7.camel@californication> <1234899806.29785.35.camel@johannes.local> <1234902294.4678.12.camel@californication> <1234904111.29785.44.camel@johannes.local> <1234904978.4678.31.camel@californication> <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net> <1234933059.21412.28.camel@californication> <20090218073104.GA23366@jm.kir.nu> <1234944391.21412.47.camel@californication>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234944391.21412.47.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 09:06:31AM +0100, Marcel Holtmann wrote:

> so it seems the missing value is affecting the details wpa_supplicant is
> handing out via its D-Bus interface. I didn't check the code yet to see
> what is actually happening or if I just happen to run an outdated
> version.

Yes, it looks like the dbus interface will get all three wext values
(quality, noise, level) regardless of whether they were available from
kernel or not. This does not cause any issues for wpa_supplicant, but if
other programs (e.g., NM) are using the "quality" value in preference to
"level", they would be processing zeros for all BSSes. If I understood
correctly, NM does indeed prefer to use "quality", so this will likely
explain why you are seeing different behavior with the qual->qual value
removed (= 0 for wpa_supplicant).

I don't know how NM would react to the "quality" value being removed,
but it would sound reasonable to do that in wpa_supplicant (and same for
"noise") if the value was not available from the driver (based on the
WEXT flags or in case of nl80211, just based on the fact that these
values are never reported). I would expect this change to go in shortly
(assuming it does not trigger any critical issue with NM), but anyway,
this does not help with old versions.

-- 
Jouni Malinen                                            PGP id EFC895FA
