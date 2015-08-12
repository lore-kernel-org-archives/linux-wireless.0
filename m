Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41862 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbbHLVIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 17:08:52 -0400
Message-ID: <1439413727.15847.0.camel@sipsolutions.net> (sfid-20150812_230855_270589_A0DBC445)
Subject: Re: iw coalesce show - disabled at init?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kobi Cohen-Arazi <kobi.cohenarazi@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 12 Aug 2015 23:08:47 +0200
In-Reply-To: <CAF7g2RHhY_aEHF7nr4VdzVrUf+_cdoKxXbUkajQcx_LxpvvFSA@mail.gmail.com> (sfid-20150812_230539_080974_AF144C33)
References: <CAF7g2RHhY_aEHF7nr4VdzVrUf+_cdoKxXbUkajQcx_LxpvvFSA@mail.gmail.com>
	 (sfid-20150812_230539_080974_AF144C33)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-12 at 11:36 -0700, Kobi Cohen-Arazi wrote:
> Hi,
> 
> When loading a wifi driver that supports set_coalesce and running "iw
> show" command:
> $ iw ... coalesce show
> It would always show coalesce as disabled.
> I think the reason for this is that there are no coalesce rules 
> cached
> in cfg/netlink layers yet. (empty set of rules).
> 
> Is my understanding correct? if yes, Is this by design?
> Ideally, at startup, 80211 should query the driver for the current
> coalesce rules and use it as the initial state.
> 

Typically devices/drivers shouldn't *have* any such rules at startup,
so the point is moot. If the driver/device you're using behaves
differently, arguably that's a bug. Marvell?

johannes
