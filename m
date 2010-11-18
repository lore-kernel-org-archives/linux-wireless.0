Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:32807 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755200Ab0KRTVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 14:21:50 -0500
Date: Thu, 18 Nov 2010 21:21:39 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] mac80211: Use sw crypto for GTKs on AP VLAN interfaces
Message-ID: <20101118192139.GA6421@jm.kir.nu>
References: <1290094587-5387-1-git-send-email-helmut.schaa@googlemail.com>
 <1290099699.3801.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1290099699.3801.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 09:01:39AM -0800, Johannes Berg wrote:
> On Thu, 2010-11-18 at 16:36 +0100, Helmut Schaa wrote:
> > If we want to support hardware crypto for broadcast traffic on AP VLAN
> > interfaces we'd either need to switch to per station GTKs or need to
> > make drivers aware of VLAN interfaces. Not sure if it's worth it.
> > 
> > At least current rt2x00 devices won't be able to support that due to
> > the limited amount of available key space.

> Hmm, good point. Jouni, any comments? Lennert maybe?

I haven't looked at how the per-STA GTKs interface would apply here, but
since the broadcast keys are only used for TX, having multiple keys
should not be much of an issue for drivers that have similar design to
ath9k/ath5k as long as we can convince the driver to assign different
hw_key_idx for each key. So yes, there will need to be some knowledge of
different AP VLAN context to allow this to happen. Anyway, I would not
be too worried about starting with forced sw crypto for
broadcast/multicast frames in any other vif than the first one and
considering optimizations later should someone care enough.

-- 
Jouni Malinen                                            PGP id EFC895FA
