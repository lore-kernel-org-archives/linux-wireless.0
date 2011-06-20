Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48954 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab1FTNqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 09:46:31 -0400
Date: Mon, 20 Jun 2011 09:35:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@adurom.com>
Subject: Re: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are
 pending
Message-ID: <20110620133535.GA2251@tuxdriver.com> (sfid-20110620_154635_175397_0BB87F50)
References: <1308425533-20854-1-git-send-email-arik@wizery.com>
 <1308471076.4145.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308471076.4145.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 19, 2011 at 10:11:16AM +0200, Johannes Berg wrote:
> On Sat, 2011-06-18 at 22:32 +0300, Arik Nemtsov wrote:
> > Use the tx_frames_pending() driver callback to determine if Tx frames are
> > pending for its internal queues. If so postpone the dynamic PS timeout
> > to avoid interrupting Tx traffic.
> > 
> > The commit e8306f989483e4b97a8b37dd268de6c8c6f35e75 enabled this
> > behavior for drivers with IEEE80211_HW_PS_NULLFUNC_STACK. We enable this
> > for all drivers supporting dynamic PS.
> > 
> > This patch helps improve performance in noisy environments.
> 
> FWIW, I don't really consider myself maintaining the PS
> implementation ;-) I don't understand it and think the code is way too
> complex.

Perhaps Kalle can comment?  Or...?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
