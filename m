Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0H3HsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 03:48:14 -0400
Subject: Re: [PATCH] mac80211: Filter ProbeReq SuppRates based on TX rate
 mask
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100828163610.GA23426@jm.kir.nu>
References: <20100828163610.GA23426@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 09:48:10 +0200
Message-ID: <1283154490.3691.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-08-28 at 19:36 +0300, Jouni Malinen wrote:
> If the TX rate set has been masked, the removed rates can also be
> removed from the Supported Rates and Extended Supported Rates IEs in
> Probe Request frames.

Technically, the probe request frame indicates RX bitrates. I don't
really mind using the TX bitrates as well since typically I do think you
probably want them to be symmetric, but shouldn't that come with nl80211
updates etc. since that's all saying TX_BITRATES?

johannes

