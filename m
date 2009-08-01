Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3323 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbZHANXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 09:23:47 -0400
Date: Sat, 1 Aug 2009 09:22:53 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, nbd@openwrt.org
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
Message-ID: <20090801132253.GB15971@hash.localnet>
References: <20090731181020.GE7963@makis> <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com> <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com> <b6c5339f0907311211w4d810b23uc6ec8027924da647@mail.gmail.com> <40f31dec0907311252n76adfde7kb9f34bf8c6baf34c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0907311252n76adfde7kb9f34bf8c6baf34c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 10:52:42PM +0300, Nick Kossifidis wrote:
> > make the above true it needs to stop the queues etc when doing
> > calibration.
> 
> ACK, how do we do that ?
> ieee80211_stop_queues / ieee80211_wake_queues

Yup.  And disabling (at least rx and swba) interrupts on the device
is also probably a good idea.

-- 
Bob Copeland %% www.bobcopeland.com

