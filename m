Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1LHJZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 04:25:06 -0500
Subject: Re: [PATCH 1/2] ieee80211: Introduce ieee80211_has_frags
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111208_102237_335526_751A1794)
References: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111208_102237_335526_751A1794)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 10:25:02 +0100
Message-ID: <1323336302.3332.7.camel@jlt3.sipsolutions.net> (sfid-20111208_102511_631307_5A8EDF60)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 10:21 +0100, Helmut Schaa wrote:
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  include/linux/ieee80211.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 17f2a76..18326eb 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -544,6 +544,15 @@ static inline int ieee80211_is_qos_nullfunc(__le16 fc)
>  	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
>  }
>  
> +/**
> + * ieee80211_has_frag - check if IEEE80211_SCTL_FRAG is set
> + * @seq_ctrl: frame sequence control bytes in little-endian byteorder
> + */
> +static inline int ieee80211_has_frag(__le16 seq_ctrl)

bool? not like I care much though

Would _is_frag() read nicer? The piece you're checking is a fragment I
think?

> +{
> +	return (seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)) != 0;
> +}
> +

Maybe you should move that close to ieee80211_has_morefrags() so it's
easy to tell the difference? :-) (that doesn't use bool either, heh)

johannes

