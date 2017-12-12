Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:46846 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750749AbdLLLPv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 06:15:51 -0500
Received: by mail-qt0-f172.google.com with SMTP id r39so46151782qtr.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 Dec 2017 03:15:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171211153749.51d30b4b@lwn.net>
References: <20171211153749.51d30b4b@lwn.net>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Date: Tue, 12 Dec 2017 12:15:50 +0100
Message-ID: <CAF7Mx6pBReAgVz9FaU6tJ-jWi=HO8BnY_X=XDz50qX7Jx_tTNQ@mail.gmail.com> (sfid-20171212_121555_127951_9005B3E8)
Subject: Re: nl80211: Remove obsolete kerneldoc line
To: Jonathan Corbet <corbet@lwn.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 11, 2017 at 11:37 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> Commit ca986ad9bcd3 (nl80211: allow multiple active scheduled scan
> requests) removed WIPHY_FLAG_SUPPORTS_SCHED_SCAN but left the kerneldoc
> description in place, leading to this docs-build warning:
>
>    ./include/net/cfg80211.h:3278: warning: Excess enum value
>            'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'
>
> Remove the line and gain a bit of peace.

My bad. Thanks for cleaning up.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  include/net/cfg80211.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 8b8118a7fadb..cb4d92b79cd9 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3226,7 +3226,6 @@ struct cfg80211_ops {
>   * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
>   * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
>   *     auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
> - * @WIPHY_FLAG_SUPPORTS_SCHED_SCAN: The device supports scheduled scans.
>   * @WIPHY_FLAG_SUPPORTS_FW_ROAM: The device supports roaming feature in the
>   *     firmware.
>   * @WIPHY_FLAG_AP_UAPSD: The device supports uapsd on AP.
> --
> 2.14.3
>
