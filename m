Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1FTN7R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 09:59:17 -0400
Subject: Re: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are
 pending
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@adurom.com>
In-Reply-To: <20110620133535.GA2251@tuxdriver.com>
References: <1308425533-20854-1-git-send-email-arik@wizery.com>
	 <1308471076.4145.6.camel@jlt3.sipsolutions.net>
	 <20110620133535.GA2251@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 15:59:13 +0200
Message-ID: <1308578353.4322.8.camel@jlt3.sipsolutions.net> (sfid-20110620_155920_352641_B66BC84D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 09:35 -0400, John W. Linville wrote:
> On Sun, Jun 19, 2011 at 10:11:16AM +0200, Johannes Berg wrote:
> > On Sat, 2011-06-18 at 22:32 +0300, Arik Nemtsov wrote:
> > > Use the tx_frames_pending() driver callback to determine if Tx frames are
> > > pending for its internal queues. If so postpone the dynamic PS timeout
> > > to avoid interrupting Tx traffic.
> > > 
> > > The commit e8306f989483e4b97a8b37dd268de6c8c6f35e75 enabled this
> > > behavior for drivers with IEEE80211_HW_PS_NULLFUNC_STACK. We enable this
> > > for all drivers supporting dynamic PS.
> > > 
> > > This patch helps improve performance in noisy environments.
> > 
> > FWIW, I don't really consider myself maintaining the PS
> > implementation ;-) I don't understand it and think the code is way too
> > complex.
> 
> Perhaps Kalle can comment?  Or...?

Yeah he's a good candidate :)

johannes

