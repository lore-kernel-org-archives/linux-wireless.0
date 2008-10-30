Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60243 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbYJ3JWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 05:22:47 -0400
Message-ID: <be0976f315094fc29b6d0ee915f8026a.squirrel@secure.sipsolutions.net>
In-Reply-To: <1225329594-21704-2-git-send-email-lrodriguez@atheros.com> 
References: <1225329594-21704-1-git-send-email-lrodriguez@atheros.com>
    <1225329594-21704-2-git-send-email-lrodriguez@atheros.com>
Date: Thu, 30 Oct 2008 10:22:42 +0100 (CET)
Subject: Re: [PATCH 1/6] cfg80211: a reg rule is invalid if freq diff is 0
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> A regulatory rule is invalid when the frequency difference
> between the end of the frequency range and the start is 0.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/wireless/reg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 9dff716..ff706f9 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -321,7 +321,7 @@ static bool is_valid_reg_rule(const struct
> ieee80211_reg_rule *rule)
>
>  	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
>
> -	if (freq_range->max_bandwidth_khz > freq_diff)
> +	if (freq_diff == 0 || freq_range->max_bandwidth_khz > freq_diff)

Might want to make that <= 0 just in case?

johannes
