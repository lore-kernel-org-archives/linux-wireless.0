Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:43735 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbYBCRmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 12:42:54 -0500
Date: Sun, 3 Feb 2008 09:42:44 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Patrick McHardy <kaber@trash.net>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Message-ID: <20080203174244.GA1261@jm.kir.nu> (sfid-20080203_174259_205993_F339A7FB)
References: <1201882512.4188.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1201882512.4188.66.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 01, 2008 at 05:15:12PM +0100, Johannes Berg wrote:

> To be honest, I'm totally unclear on how all this queue stuff is
> supposed to work. Ivo pointed me to IEEE80211_TX_QUEUE_AFTER_BEACON
> which is unused and duplicated with IEEE80211_TXCTL_SEND_AFTER_DTIM.

I don't think IEEE80211_TX_QUEUE_AFTER_BEACON was originally used for
anything inside the d80211 code so it was just a queue identifier that
was shared between the hardware driver and more generic 802.11 code. As
such, it should be fine to do this inside the hardware drivers and
remove this from mac80211.

>      2. get rid of IEEE80211_TX_QUEUE_BEACON, it isn't used in mac80211
>         and it's not hardware-independent, not all hardware actually
>         uses a queue for beacons

This was originally used only for setting up queue parameters for Beacon
frames in IBSS and that can be done differently.

>      4. remove IEEE80211_TX_QUEUE_SVP, it's something strange and
>         atheros specific

Sure, that should be removed.

-- 
Jouni Malinen                                            PGP id EFC895FA
