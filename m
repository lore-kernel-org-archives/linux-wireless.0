Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33762 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbaESO7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 10:59:44 -0400
Message-ID: <1400511574.4273.17.camel@jlt4.sipsolutions.net> (sfid-20140519_165947_664372_2A6EE09B)
Subject: Re: [PATCHv3 2/4] cfg80211: export expected throughput via nl80211
 (GET_STATION)
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Mon, 19 May 2014 16:59:34 +0200
In-Reply-To: <1400344906-27984-3-git-send-email-antonio@meshcoding.com>
References: <1400344906-27984-1-git-send-email-antonio@meshcoding.com>
	 <1400344906-27984-3-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-05-17 at 18:41 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Send the expected throughput when replying to a GET_STATION
> command via nl80211.
> 
> Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
> ---
>  include/uapi/linux/nl80211.h | 3 +++
>  net/wireless/nl80211.c       | 4 ++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 0cfa827..2964948 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2199,6 +2199,8 @@ enum nl80211_sta_bss_param {
>   *	Contains a nested array of signal strength attributes (u8, dBm)
>   * @NL80211_STA_INFO_CHAIN_SIGNAL_AVG: per-chain signal strength average
>   *	Same format as NL80211_STA_INFO_CHAIN_SIGNAL.
> + * @NL80211_STA_EXPECTED_THROUGHPUT: expected throughput (considering also the
> + *	802.11 header) expressed in kbps

This should say it's a u32.

johannes

