Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:51405 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYI2Qco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 12:32:44 -0400
Date: Mon, 29 Sep 2008 19:31:47 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
Message-ID: <20080929163147.GC4853@jm.kir.nu> (sfid-20080929_183246_814188_64FBC655)
References: <48E0A65A.2060102@gmail.com> <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu> <1222683923.7064.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1222683923.7064.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 29, 2008 at 12:25:23PM +0200, Johannes Berg wrote:

> > Isn't ath5k reporting quite a large set of channels that would never
> > really be used? 26 channels on 2.4 GHz and 194(huh!) on 5 GHz.. First
> > workaround could be to just limit those to somewhat more common set of
> > channels.
> 
> Well, this is what the hw supports I guess, most channels will actually
> reported to userspace with the DISABLED flag set.

Well.. It reports channels like 2732 MHz or 6100 MHz and 5 GHz center
frequencies for every possible multiple of 5 MHz. If someone is really
using those properly, they are on a licensed band and this types of
lists are not really needed for normal users. Whether the hardware
really supports them or well, more exactly, whether all selected
components can handle these frequencies and whether the radios have been
calibrated for all of these areas is another question.

> > > > There is also a bug in hostapd which waits for ACK forever when this error occur
> > > > in i802_get_hw_feature_data().

For some reason, I do not seem to be able to reproduce this. Both iw and
hostapd were able to fetch the data using the current wireless-testing
tree..

> I recently rewrote the handling in iw completely to make it easier to
> follow, will post an equivalent patch for hostapd in a minute.

Anyway, cleanup for nl send/recv processing is certainly welcome. I've
never fully understood the steps that are used there and what to do if
anything went wrong..

-- 
Jouni Malinen                                            PGP id EFC895FA
