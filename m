Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab0I2ISa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 04:18:30 -0400
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, stable@kernel.org,
	linux-wireless@vger.kernel.org, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <20100928222945.GB10932@tux>
References: <20100928222945.GB10932@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 10:18:23 +0200
Message-ID: <1285748303.3756.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 15:29 -0700, Luis R. Rodriguez wrote:

> Since we end up associated to two different APs at the same
> time to transmit to either AP consists of an offchannel
> operation but today we just lack the state machine to be able
> to do this properly so for now just drop those frames.

I really think that can be done more easily though. For one, clearly we
already have the warning, so we don't need more infrastructure to catch
such errors?! Also, this may end up hiding issues that we don't yet
understand, like the nullfunc one you were talking about. The delBA one
we now understand fully, so it makes more sense to simply suppress
sending delBA when we are going to disassociate by way of associating
with a new AP, no?

johannes

