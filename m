Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54756 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab1KGSQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 13:16:34 -0500
Date: Mon, 7 Nov 2011 13:11:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: init rate-control for TDLS sta when supp-rates
 are known
Message-ID: <20111107181135.GD2798@tuxdriver.com> (sfid-20111107_191638_165011_C7839BB6)
References: <1319636866-12171-1-git-send-email-arik@wizery.com>
 <20111027142248.GA3972@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111027142248.GA3972@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 27, 2011 at 05:22:48PM +0300, Jouni Malinen wrote:
> On Wed, Oct 26, 2011 at 03:47:46PM +0200, Arik Nemtsov wrote:
> > Initialize rate control algorithms only when supported rates are known
> > for a TDLS peer sta. Direct Tx between peers is not allowed before the
> > link is enabled. In turn, this only occurs after a change_station()
> > call that sets supported rates.
> 
> Thanks - this seems to fix the issues I saw previously. I tested ath9k
> with this instead of my earlier patch and was able to run successfully
> through my TDLS test scripts against another implementation.

I merged this patch from Jouni:

	commit e3a4cc2f073739c9c9c2e97efc774703061f034a
	Author: Jouni Malinen <j@w1.fi>
	Date:   Sun Oct 23 22:36:04 2011 +0300

	    mac80211: Fix TDLS support validation in add_station handler
    
	    We need to verify whether the command is successful before allocating
	    the station entry to avoid extra processing. This also fixes a memory
	    leak on the error path.
    
	    Signed-off-by: Jouni Malinen <j@w1.fi>
	    Signed-off-by: John W. Linville <linville@tuxdriver.com>

I'm not sure what to do with this patch now.  I think I will just drop
it, and you can send me a new patch that applies on top of Jouni's
(perhaps even reverting it) as appropriate?

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
