Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41695 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaCGO2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 09:28:48 -0500
Message-ID: <1394202525.4653.6.camel@jlt4.sipsolutions.net> (sfid-20140307_152850_973041_E2C9F4ED)
Subject: Re: [RFC PATCH 4/8] cfg80211: Modify chandef related functions to
 work with 5/10MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michal Sojka <sojkam1@fel.cvut.cz>,
	s.sander@nordsys.de, jan-niklas.meier@volkswagen.de
Date: Fri, 07 Mar 2014 15:28:45 +0100
In-Reply-To: <1394199475-5208-5-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143809_157703_44CC8321)
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1394199475-5208-5-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140307_143809_157703_44CC8321)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 14:37 +0100, Rostislav Lisovy wrote:
> Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
> ---
>  include/net/cfg80211.h |  4 ++++
>  net/wireless/chan.c    | 10 ++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f5ecd6c..16f19e0 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -367,6 +367,10 @@ static inline enum nl80211_channel_type
>  cfg80211_get_chandef_type(const struct cfg80211_chan_def *chandef)
>  {
>  	switch (chandef->width) {
> +	case NL80211_CHAN_WIDTH_5:
> +		return NL80211_CHAN_5MHZ;

NACK, this isn't needed, just fix the code to not use channel_type.

johannes

