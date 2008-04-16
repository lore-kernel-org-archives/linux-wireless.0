Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:47390 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbYDPGRc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 02:17:32 -0400
Date: Wed, 16 Apr 2008 09:15:48 +0300
From: Jouni Malinen <j@w1.fi>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 hardware encryption
Message-ID: <20080416061548.GH15053@jm.kir.nu> (sfid-20080416_071739_395400_44E46793)
References: <200804051931.58895.IvDoorn@gmail.com> <1207578963.12481.27.camel@johannes.berg> <200804071645.43604.IvDoorn@gmail.com> <200804141827.50991.IvDoorn@gmail.com> <1ba2fa240804141139ua5f6f26k6920001ceb59443e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240804141139ua5f6f26k6920001ceb59443e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 14, 2008 at 09:39:00PM +0300, Tomas Winkler wrote:

> Not sure what was intention for hw_key_idx but currently there are assignment
> from key->conf.keyidx to hw_key_idx and visa versa.  keyidx is used
> for 802.11 key index [1..4]
> So it's quit risky to use it for something else

hw_key_idx was supposed to be a value that the hardware driver assigns
for each key. This allows the driver to use suitable values that map
easily to whatever key table is used in the hardware/firmware. This is
_not_ same as 802.11 key index (0..3) and no code should made such an
assumption. Based on a quick search, I did not find any net/mac80211
code assigning key->conf.keyidx into hw_key_idx (or struct
ieee80211_tx_control::key_idx).

At least as far as the original design is concerned, hw_key_idx is
controlled by the hardware driver and it is only an internal identifier
for a specific hwaccel key.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
