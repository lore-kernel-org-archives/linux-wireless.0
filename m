Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:48878 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753077AbaJ1Ncl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:32:41 -0400
Message-ID: <1414503152.27833.17.camel@coelho.fi> (sfid-20141028_143252_454131_78822A14)
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: j@w1.fi, linux-wireless@vger.kernel.org
Date: Tue, 28 Oct 2014 15:32:32 +0200
In-Reply-To: <1414495985-26937-1-git-send-email-luca@coelho.fi>
References: <1414495985-26937-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 0/2] mac80211: fix HT+ to HT- (and vice-versa) CSA
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(fixed Johannes' email address)

Both these bugs go far back, so IMHO they should go to 3.8 and stable.

1/2 goes back to 3.13
2/2 goes back to 2.6.30 (though the affected code changed somewhat
                         since then)

--
Luca.

On Tue, 2014-10-28 at 13:33 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> These two patches fix a bug that Jouni found when running his hostap
> hwsim test scripts (ap_ht40_csa).  The failure was caused by two
> different bugs which are fixed in this patchset.
> 
> The first bug was that we were not using the secondary channel offset
> IE of beacons for the switch, but the offset of the current channel,
> which cause us to use the same offset. 
> 
> The second bug was that we were trying to switch at the exact time of
> the switch on the station side, which, because of the processing time,
> was causing us to be too late.
> 
> Luciano Coelho (2):
>   mac80211: use secondary channel offset IE also beacons during CSA
>   mac80211: schedule the actual switch of the station before CSA count 0
> 
>  net/mac80211/ibss.c        |  2 +-
>  net/mac80211/ieee80211_i.h |  3 +--
>  net/mac80211/mesh.c        |  2 +-
>  net/mac80211/mlme.c        |  5 +++--
>  net/mac80211/spectmgmt.c   | 18 ++++++------------
>  5 files changed, 12 insertions(+), 18 deletions(-)
> 


