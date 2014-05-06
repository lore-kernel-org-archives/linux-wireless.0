Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEFNQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 09:16:07 -0400
Message-ID: <1399382148.4218.28.camel@jlt4.sipsolutions.net> (sfid-20140506_151611_447561_5CACA573)
Subject: Re: [PATCH v4 0/4] mac80211/cfg80211: CSA fixes/cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, luca@coelho.fi
Date: Tue, 06 May 2014 15:15:48 +0200
In-Reply-To: <1397049062-24177-1-git-send-email-michal.kazior@tieto.com> (sfid-20140409_151716_663097_86B5A1EC)
References: <1396259841-6359-1-git-send-email-michal.kazior@tieto.com>
	 <1397049062-24177-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140409_151716_663097_86B5A1EC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 15:10 +0200, Michal Kazior wrote:
> Hi,
> 
> The patchset fixes CSA tx queue locking and
> introduces interface teardown upon CSA failure
> during finalization.

Applied (with the rename Luca suggested), thanks.

However, there's one more thing - one caller of ieee80211_csa_finalize()
doesn't check the return value now, I think it probably should. Mind
taking a look at that? It should *probably* be the same as the other
caller (and not propagate the error), I'd say, so maybe that should be
rolled into the function?

Thanks,
johannes

