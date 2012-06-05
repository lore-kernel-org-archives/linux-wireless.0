Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37077 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2FETR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 15:17:57 -0400
Date: Tue, 5 Jun 2012 15:00:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix race between tx path and
 ___ieee80211_stop_tx_ba_session
Message-ID: <20120605190008.GB1937@tuxdriver.com> (sfid-20120605_211800_572357_F6662B92)
References: <1336553772-7519-1-git-send-email-helmut.schaa@googlemail.com>
 <1336554064.4323.6.camel@jlt3.sipsolutions.net>
 <CAGXE3d-TRGs=H_8HioSWr=J3zPWsoFRdOm5vc9MgSrbqZJMcUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d-TRGs=H_8HioSWr=J3zPWsoFRdOm5vc9MgSrbqZJMcUQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2012 at 03:55:06PM +0200, Helmut Schaa wrote:
> On Wed, May 9, 2012 at 11:01 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-05-09 at 10:56 +0200, Helmut Schaa wrote:
> >> ___ieee80211_stop_tx_ba_session first deletes the tx aggregation session
> >> timer and afterwards clears HT_AGG_STATE_OPERATIONAL. Hence, there is a
> >> small time window where the tx path can call mod_timer after
> >> del_timer_sync.
> >>
> >> When ieee80211_start_tx_ba_session runs before the timer the call to
> >> init_timer will cause a BUG_ON:
> >
> > This may have been fixed by my other patch where I check the state?
> 
> I'll have to try but I'm not sure if these are two different issues ...

Did we get a final verdict on whether or not this patch is needed?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
