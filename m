Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:8265 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0BHMm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 07:42:26 -0500
Received: by fg-out-1718.google.com with SMTP id 22so21545fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 04:42:24 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Vivek Natarajan <vnatarajan@atheros.com>
Subject: Re: [PATCH v3] mac80211: Retry null data frame for power save.
Date: Mon, 8 Feb 2010 13:42:19 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201002081342.20062.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 February 2010 13:17:00 Vivek Natarajan wrote:
> Even if the null data frame is not acked by the AP, mac80211
> goes into power save. This might lead to loss of frames
> from the AP.
> Prevent this by restarting dynamic_ps_timer when ack is not
> received for null data frames.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
>  include/net/mac80211.h     |    1 +
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/mlme.c        |   20 +++++++++++++++-----
>  net/mac80211/status.c      |   16 ++++++++++++++--
>  4 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 74ccf30..92a3caf 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -978,6 +978,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
>  	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
>  	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
> +	IEEE80211_HW_TX_STATUS				= 1<<18,
>  };

It might be a good idea to add some documentation for new flags.

Otherwise this can easily lead to confusing (e.g.: Does
HW_TX_STATUS mean that the HW reports not just ACKs, but also
when if the frame was filtered by the HW, or if the HW reports
the rate control information (retries & retry index) as well?)

On a related issue: What about _inverting_ the flag, so it will
be set for devices which can't give any accurate tx_status
information. This has the advantage that we don't have to touch
other drivers?

Regards,
	Chr

