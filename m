Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:33373 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbcCUIJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2016 04:09:41 -0400
Received: by mail-ob0-f180.google.com with SMTP id fz5so24227603obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2016 01:09:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458547622-1632-1-git-send-email-wnhuang@google.com>
References: <1458547622-1632-1-git-send-email-wnhuang@google.com>
Date: Mon, 21 Mar 2016 16:09:39 +0800
Message-ID: <CABicQ-UBhk9pdY1EsT1wp6+ZqabbBv47wsciCFbPzzPuOzOFbg@mail.gmail.com> (sfid-20160321_090958_294131_0EB23AE5)
Subject: Re: [PATCH] mwifiex: advertise low priority scan feature
From: Wei-Ning Huang <wnhuang@google.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	kvalo@codeaurora.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Wei-Ning Huang <wnhuang@chromium.org>

On Mon, Mar 21, 2016 at 4:07 PM, Wei-Ning Huang <wnhuang@chromium.org> wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
>
> Low priority scan handling code which delays or aborts scan
> operation based on Tx traffic is removed recently. The reason
> is firmware already takes care of it in our new feature scan
> channel gap. Hence we should advertise low priority scan
> support to cfg80211.
>
> This patch fixes a problem in which OBSS scan request from
> wpa_supplicant was being rejected by cfg80211.
>
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index bb7235e..7dafc5b 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -4086,6 +4086,7 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
>
>         wiphy->features |= NL80211_FEATURE_HT_IBSS |
>                            NL80211_FEATURE_INACTIVITY_TIMER |
> +                          NL80211_FEATURE_LOW_PRIORITY_SCAN |
>                            NL80211_FEATURE_NEED_OBSS_SCAN;
>
>         if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
> --
> 2.8.0.rc3.226.g39d4020
>



-- 
Wei-Ning Huang, 黃偉寧 | Software Engineer, Google Inc., Taiwan |
wnhuang@google.com | Cell: +886 910-380678
