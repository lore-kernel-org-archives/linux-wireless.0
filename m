Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50239 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3FNRpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 13:45:10 -0400
Date: Fri, 14 Jun 2013 13:34:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-fixes 2013-06-14
Message-ID: <20130614173419.GB28497@tuxdriver.com> (sfid-20130614_194535_515460_8B8F3073)
References: <1371206567.8278.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371206567.8278.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 14, 2013 at 12:42:47PM +0200, Johannes Berg wrote:
> John,
> 
> I have two more fixes that I think would be worthwhile for 3.10 but
> admittedly the scenario is somewhat unlikely, so if you want to hold
> them for 3.11 I can live with that. In that case, I can put them into my
> -next tree, or you can pull this into -next (but if you don't pull
> wireless.git first you'd get some more fixes you already have.)
> 
> These two patches fix two issues with using rfkill randomly during
> traffic, which would then cause our driver to stop working and not be
> able to recover at all.
> 
> johannes
> 
> 
> The following changes since commit 622ebe994f6866b8d46ee5d3bcc329ed65d3722d:
> 
>   iwlwifi: fix rate control regression (2013-06-12 14:13:39 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to 8a487b1a7432b20ff3f82387a8ce7555a964b44e:
> 
>   iwlwifi: pcie: wake the queue if stopped when being unmapped (2013-06-13 16:44:04 +0200)
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (2):
>       iwlwifi: pcie: fix race in queue unmapping
>       iwlwifi: pcie: wake the queue if stopped when being unmapped
> 
>  drivers/net/wireless/iwlwifi/pcie/tx.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)

It isn't obvious to me that these need to be included in 3.10.  I can
pull this into wireless-next once the current stuff in wireless makes
it to davem's tree.

If you decide that these really need to go, please provide some more
information on how likely users are to hit the bugs, or how serious
the effects of that would be.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
