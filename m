Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3LPOGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:06:45 -0500
Message-ID: <1387202794.2057.2.camel@jlt4.sipsolutions.net> (sfid-20131216_150647_875586_90C0B880)
Subject: Re: [PATCH 06/11] ath9k_hw: remove ah->config.pcie_clock_req
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Mon, 16 Dec 2013 15:06:34 +0100
In-Reply-To: <52AF0547.1060505@openwrt.org> (sfid-20131216_145129_387099_D3F855B4)
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
		<1387040625-38114-6-git-send-email-nbd@openwrt.org>
		<21166.30518.304613.545323@gargle.gargle.HOWL>
		<52AEE12F.5020008@openwrt.org>
	 <21166.64423.30022.947286@gargle.gargle.HOWL>
	 <52AF0547.1060505@openwrt.org> (sfid-20131216_145129_387099_D3F855B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 14:51 +0100, Felix Fietkau wrote:
> On 2013-12-16 14:09, Sujith Manoharan wrote:
> > Felix Fietkau wrote:
> >> Fine with me, let's leave this one out and merge the others (if there
> >> aren't any other issues).
> > 
> > Station mode seems fine with the series, I didn't get a chance to test
> > IBSS or P2P.
> > 
> > In AP mode, the timestamp in the first beacon is higher than earlier, since
> > we no longer reset the HW TSF when enabling beaconing and there is a
> > window between start() and enable_beacon(). I am not sure if this is a
> > problem, but I think the spec has something to say about BSS creation in
> > infrastructure mode.
> I looked through the spec and could not find any indication that
> starting at zero is mandatory.

I don't believe you have to start at 0 - but it requires that TSF=0 is a
DTIM TBTT.

johannes

