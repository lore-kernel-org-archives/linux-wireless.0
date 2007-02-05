Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-98.dex002.intermedia.net ([64.78.19.95]:14518 "EHLO
	dhost002-99.dex002.intermedia.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932675AbXBERBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 12:01:55 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 5 Feb 2007 08:47:38 -0800
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Add API to generate RTS and CTS-to-self frames
Message-ID: <20070205164738.GA31058@instant802.com>
References: <200702051412.50703.mb@bu3sch.de> <20070205145824.GA6637@jm.kir.nu> <200702051628.46518.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200702051628.46518.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 05, 2007 at 04:28:46PM +0100, Michael Buesch wrote:

> As I said in response to Johannes' comment, if a driver needs just
> the duration, we should export the functions to calculate it
> and remove the calculation from the tx_control and the tx_control
> setup path.

In that case, I would like to see this change being included in the same
patch/patchset.. Without this, I can only NAK this kind of change since
it removes functionality needed for some designs and that is not
something I would like to see happening with net/d80211 since the goal
is to allow all reasonable hardware designs to work with it.

> Currently there is no driver using it, so I simply removed it.

There are, but maybe not in wireless-dev.git.

> BTW: Which cards need the duration, but not the whole frame?

Any card that supports different transmit rates for hw retries involving
RTS/CTS/fragmentation (e.g., Atheros).

-- 
Jouni Malinen                                            PGP id EFC895FA
