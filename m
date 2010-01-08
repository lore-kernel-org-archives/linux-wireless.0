Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:51932 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754188Ab0AHXU5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 18:20:57 -0500
Date: Sat, 9 Jan 2010 01:20:09 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] cfg80211: fix 2 GHz subband calculation for
 country IEs
Message-ID: <20100108232009.GA4840@jm.kir.nu>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
 <1262903097-2129-3-git-send-email-lrodriguez@atheros.com>
 <20100108131451.GA18758@jm.kir.nu>
 <43e72e891001081341j1c24b7c4i6f5bb636d8ccc81b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e891001081341j1c24b7c4i6f5bb636d8ccc81b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 08, 2010 at 01:41:58PM -0800, Luis R. Rodriguez wrote:
> On Fri, Jan 8, 2010 at 5:14 AM, Jouni Malinen <j@w1.fi> wrote:
> > By the way, that looks completely bogus.. Channel number cannot be used
> > to figure out whether this is 2.4 GHz or 5 GHz band (e.g., channel 8 is
> > used in both). This really should be based on the band the frame with
> > the Country IE was received.
> 
> This seems to me more like an issue with the spec. Doing it based on
> the received band is obviously possible but what if the AP wants to
> send out Country IE information for both channel 8 on 2 GHz and
> channel 8 on 5 GHz?
> 

I don't think the original Country IE design from IEEE Std 802.11d-2001
really supported such use, i.e., you can only describe the channels from
your own band with that design. Have you really seen APs advertising
channels from the other band in their Country IE?

I would assume you could now use the Regulatory Extension mechanism to
define another regulatory class and subband followed by channel triplets
to do that. However, even in that case, the first triplets in the IE
really needs to be for the band the frame is send on. Once the
Regulatory Extension Identifier is used, further triplets should be
interpreted differently. Anyway, I have no idea whether anyone really
supports this extension (or can parse the standard to figure out how it
would be used ;-)..

-- 
Jouni Malinen                                            PGP id EFC895FA
