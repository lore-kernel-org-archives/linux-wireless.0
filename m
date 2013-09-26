Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3IZLPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 07:15:16 -0400
Message-ID: <1380194106.14806.2.camel@jlt4.sipsolutions.net> (sfid-20130926_131520_799115_64EF3811)
Subject: Re: [PATCH 1/2] nl80211/cfg80211: Driver with AP SME advertises
 need for PMF SA Query
From: Johannes Berg <johannes@sipsolutions.net>
To: Chet Lanctot <clanctot@codeaurora.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 13:15:06 +0200
In-Reply-To: <1379446296-22236-2-git-send-email-clanctot@codeaurora.org> (sfid-20130917_213226_743831_B2F42172)
References: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
	 <1379446296-22236-2-git-send-email-clanctot@codeaurora.org>
	 (sfid-20130917_213226_743831_B2F42172)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-17 at 12:31 -0700, Chet Lanctot wrote:
> Needed for drivers that have AP SME integrated but do not implement
> The SA Query procedure that is part of Protected Management Frames
> (PMF, 802.11w).  Instead, the need for upper layer software to do
> this procedure is advertised through nl80211/cfg80211.
> 
> Signed-off-by: Chet Lanctot <clanctot@codeaurora.org>
> ---
>  include/uapi/linux/nl80211.h | 11 ++++++++---
>  net/wireless/nl80211.c       |  3 ++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index eb68735..aa1d122 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1891,6 +1891,9 @@ enum nl80211_iftype {
>   * @NL80211_STA_FLAG_ASSOCIATED: station is associated; used with drivers
>   *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
>   *	previously added station into associated state
> + * @NL80211_STA_FLAG_NO_SA_QUERY_REQUIRED: no SA Query procedure is needed
> + *	when an association request is received from a station with which there
> + *	is already a MFP connection

I don't understand this part, and also why is it part of the *station*
info? Shouldn't it be part of the new-station event or something like
that? How can it be valid when reading station info later?

johannes

