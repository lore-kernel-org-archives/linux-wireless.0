Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58621 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759945AbZJGUBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 16:01:46 -0400
Date: Wed, 7 Oct 2009 15:53:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/7] ath5k: few fixes for regressions
Message-ID: <20091007195321.GD22394@tuxdriver.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2009 at 08:44:27PM -0400, Luis R. Rodriguez wrote:
> I wasn't able to connect to some AP and it turned out the issue
> was a few regressions introduced in my series. It was hard to note
> as I was able to connect at work and at home, so I guess this would
> only have been seen with some specific APs. This series fixed my
> connection but since I introduced them I figured I'd throw in
> an extra patch at the end for setting the association ID.
> 
> Luis R. Rodriguez (7):
>   ath5k: fix regression on setting bssid mask on association
>   ath5k: use ath_hw_setbssidmask() for bssid mask setting upon assoc
>   ath5k: fix regression introduced upon the removal of AR5K_HIGH_ID()
>   ath5k: simplify passed params to ath5k_hw_set_associd()
>   ath5k: remove temporary low_id and high_id vars on
>     ath5k_hw_set_associd()
>   ath5k: fix regression which triggers an SME join upon assoc
>   ath5k: enable Power-Save Polls by setting the association ID
> 
>  drivers/net/wireless/ath/ath5k/ath5k.h  |    2 +-
>  drivers/net/wireless/ath/ath5k/attach.c |    2 +-
>  drivers/net/wireless/ath/ath5k/base.c   |   13 ++++++++++---
>  drivers/net/wireless/ath/ath5k/pcu.c    |   30 +++++++++++++-----------------
>  drivers/net/wireless/ath/ath5k/reset.c  |    5 ++---
>  5 files changed, 27 insertions(+), 25 deletions(-)

Actually, none of these seem to apply against 2.6.32...did you mean
for them to go there?

I'll queue them for -next for now...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
