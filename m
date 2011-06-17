Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab1FQRd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 13:33:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
Reply-To: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
	reservation
References: <20110616102138.GA24447@hertz.marvell.com>
	 <20110616102707.GB24458@hertz.marvell.com>
	 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
	  <20110617132527.GA27436@hertz.marvell.com>
In-Reply-To: <20110617132527.GA27436@hertz.marvell.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 17 Jun 2011 19:24:45 +0200
Message-Id: <1308331485.7329.2.camel@Nokia-N900-51-1> (sfid-20110617_193331_083470_7CF883E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Using spinlocks in TX/RX path is not allowed because spinlocks will make
> TX/RX path to block and its illegal to block while in an RCU read-side
> critical section. I think, I got the joke here :(.

No, that'd be allowed, but you can't spinlock all the TX path because of performance.

I think the way to solve it would be to use synchronize_net() somehow maybe; not really sure.

Johannes

