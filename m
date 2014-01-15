Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38278 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaAONZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:25:32 -0500
Message-ID: <1389792328.4338.9.camel@jlt4.sipsolutions.net> (sfid-20140115_142534_646605_898F145F)
Subject: Re: [RFC 4/5] nl80211: add DFS CAC time option
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Wed, 15 Jan 2014 14:25:28 +0100
In-Reply-To: <1389720570-2430-5-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140114_182949_423700_8DB6D80B)
References: <1389720570-2430-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389720570-2430-5-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140114_182949_423700_8DB6D80B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-14 at 18:29 +0100, Janusz Dziedzic wrote:
> Pass DFS CAC time to user mode (mainly
> for iw reg get/iw list/iw info).
> Allow setting DFS CAC time via CRDA.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> ---
>  include/uapi/linux/nl80211.h |    5 +++++
>  net/wireless/nl80211.c       |   13 ++++++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 91054fd..65081e8 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2304,6 +2304,7 @@ enum nl80211_band_attr {
>   * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
>   *	using this channel as the primary or any of the secondary channels
>   *	isn't possible
> + * @NL80211_FREQUENCY_ATTR_DFS_CAC_TIME: DFS CAC time in sec

Why bother with seconds vs. milliseconds? It'd be easier to use the same
units ...

johannes

