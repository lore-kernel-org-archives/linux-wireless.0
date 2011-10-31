Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:50174 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932689Ab1JaKZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 06:25:21 -0400
Received: by mail-bw0-f45.google.com with SMTP id zu5so604157bkb.4
        for <linux-wireless@vger.kernel.org>; Mon, 31 Oct 2011 03:25:20 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] nl80211: Add probe response offload attribute
From: Luciano Coelho <coelho@ti.com>
To: Guy Eilam <guy@wizery.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <1319313081-28722-1-git-send-email-guy@wizery.com>
References: <1319313081-28722-1-git-send-email-guy@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 12:04:58 +0200
Message-ID: <1320055498.2672.10.camel@cumari> (sfid-20111031_112525_240345_6736E8C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-22 at 21:51 +0200, Guy Eilam wrote: 
> Notify the userspace of the probe response offloading
> support by the driver.
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---
> v2:
> use struct wiphy instead of a function pointer
> this change made the previous second PATCH:
> "Get the probe response offloading support from the driver" irrelevant
> changed WPS to WSC
> 
>  include/linux/nl80211.h |   24 ++++++++++++++++++++++++
>  include/net/cfg80211.h  |    5 +++++
>  net/wireless/nl80211.c  |    5 +++++
>  3 files changed, 34 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 9d797f2..c1f0a3d 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1109,6 +1109,11 @@ enum nl80211_commands {
>   *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
>   *	used for asking the driver to perform a TDLS operation.
>   *
> + * @NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT: Indicates the support
> + *	of probe response offloading by the driver/firmware.
> + *	In addition this attribute holds a bitmap of the supported protocols
> + *	for offloading using &enum nl80211_probe_resp_offload_support_attr.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -1337,6 +1342,8 @@ enum nl80211_attrs {
>  	NL80211_ATTR_TDLS_SUPPORT,
>  	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
>  
> +	NL80211_ATTR_PROBE_RESP_OFFLOAD_SUPPORT,
> +

I'm not sure I understand why we need this.  Why aren't the flags
themselves enough?

Johannes wrote, on a separate thread:
> Oh, and probably a regular WIPHY flag that indicates whether the
> attribute should be added at all so that it can also be 0 but present
> (presence with 0 value indicates something other than not present).

What would be the meaning when the WIPHY flag is set but the attributes
are all 0? Wouldn't it mean that we don't support probe_resp offload at
all? Or would it mean that we support probe_resp offloading in normal
cases (ie. not WCS nor P2P)? If the latter is the case, why not add a
bit in the attributes to indicate that "normal" probe_resp offloading is
supported? I think this would be cleaner because there wouldn't be any
implicit semantics.


-- 
Cheers,
Luca.

