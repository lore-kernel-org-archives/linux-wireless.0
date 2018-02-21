Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:41012 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbeBULD6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 06:03:58 -0500
Received: by mail-qt0-f196.google.com with SMTP id a9so1348442qtj.8
        for <linux-wireless@vger.kernel.org>; Wed, 21 Feb 2018 03:03:58 -0800 (PST)
Subject: Re: [PATCH] cfg80211/nl80211: add DFS offload flag
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
References: <20180221105635.5824-1-sergey.matyukevich.os@quantenna.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A8D521C.2030502@broadcom.com> (sfid-20180221_120402_602531_69F58AC8)
Date: Wed, 21 Feb 2018 12:03:56 +0100
MIME-Version: 1.0
In-Reply-To: <20180221105635.5824-1-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/21/2018 11:56 AM, Sergey Matyukevich wrote:
> From: Dmitry Lebed <dlebed@quantenna.com>
>
> Add wiphy flag to indicate that HW does all DFS actions by itself.
> User-space functionality already implemented in hostapd using
> vendor-specific (QCA) OUI to advertise HW support.
> Need to introduce generic flag to inform about DFS offload support.
> For deivces with DFS_OFFLOAD flag set user-space will no longer
> need to issue CAC or do any actions in response to
> "radar detected" events. HW will do everything by itself and send
> events to user-space to idicate that CAC was started/finished, etc.
>
> Signed-off-by: Dmitrii Lebed <dlebed@quantenna.com>
> ---
>   include/net/cfg80211.h       | 7 ++++++-
>   include/uapi/linux/nl80211.h | 9 +++++++++
>   net/wireless/nl80211.c       | 7 +++++++
>   3 files changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index ed3a28105d6c..b2d17993ae4d 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3241,6 +3241,11 @@ struct cfg80211_ops {
>    * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
>    * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
>    *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
> + * @WIPHY_FLAG_DFS_OFFLOAD: Device will do all DFS-related actions by itself,
> + *	informing user-space about CAC progress, radar detection event,
> + *	channel change triggered by radar detection event.
> + *	No need to start CAC from user-space, no need to react to
> + *	"radar detected" event.

wiphy flags are kinda deprecated. At least no new flags should be added. 
Instead use EXT_FEATURE flag.

Regards,
Arend

>    * @WIPHY_FLAG_SUPPORTS_FW_ROAM: The device supports roaming feature in the
>    *	firmware.
>    * @WIPHY_FLAG_AP_UAPSD: The device supports uapsd on AP.
