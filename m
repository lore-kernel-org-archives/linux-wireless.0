Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:38607 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752535AbaFWKq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 06:46:58 -0400
Message-ID: <1403520409.2885.9.camel@dubbel> (sfid-20140623_124701_747406_C30FAB9C)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 23 Jun 2014 13:46:49 +0300
In-Reply-To: <1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
References: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
	 <1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v10 0/5] cfg/mac80211: implement multi-vif csa
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, 2014-06-17 at 14:58 +0200, Michal Kazior wrote:
> Hi,
> 
> The patchset implements multi-interface
> reservations and multi-interface channel
> switching.
> 
> There are still some cases that aren't handled
> well (at least degradation of number of channels
> due to interface combinations that I'm aware of).
> 
> 
> v10:
>  * rebase to latest mac80211-next/master
>    (90c18a8b34add196da9b07fd37d0f3b4b451c6b3)
>  * fix compilation [Luca]
> 
> Michal Kazior (5):
>   mac80211: implement multi-vif in-place reservations
>   mac80211: make check_combinations() aware of chanctx reservation
>   mac80211: use chanctx reservation for AP CSA
>   mac80211: use chanctx reservation for STA CSA
>   cfg80211: remove channel_switch combination check

This series looks good to me.  I couldn't spot anything wrong (though I
admit I have not reviewed the latest series as deeply as some of the
previous series), so I think we could apply this now and test, test,
test.  Let's make sure things are working before we officially re-enable
channel switch in general in mac80211.

I have tried to apply these patches in our internal tree and got some
crashed, but there were so many conflicts that I'm almost sure the
troubles were because of a bad merge and not with the original patches
themselves.  I'll do a merge again once this gets applied to mac80211
and, if I still see problems, let's fix them.

In short, I think it's time to merge this to get it tested in real life
instead of just hammering it ad-infinitum with reviews.  The risk is low
anyway, because CSA is still disabled by force in mac80211.

What do others think?

--
Cheers,
Luca.

