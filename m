Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38919 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbcCXRA0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 13:00:26 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Wei-Ning Huang <wnhuang@chromium.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
	"djkurtz@chromium.org" <djkurtz@chromium.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] mwifiex: advertise low priority scan feature
Date: Thu, 24 Mar 2016 17:00:22 +0000
Message-ID: <d9cefd7c8cfc4f66a767ccd7e9889a9f@SC-EXCH04.marvell.com> (sfid-20160324_180053_899878_044924AA)
References: <1458619796-7694-1-git-send-email-wnhuang@chromium.org>
In-Reply-To: <1458619796-7694-1-git-send-email-wnhuang@chromium.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Wei-Ning Huang [mailto:wnhuang@chromium.org]
> Sent: Tuesday, March 22, 2016 9:40 AM
> To: Linux Wireless
> Cc: LKML; Amitkumar Karwar; djkurtz@chromium.org; Wei-Ning Huang;
> Nishant Sarmukadam; kvalo@codeaurora.org; netdev@vger.kernel.org
> Subject: [PATCH v2] mwifiex: advertise low priority scan feature
> 
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Low priority scan handling code which delays or aborts scan operation
> based on Tx traffic is removed recently. The reason is firmware already
> takes care of it in our new feature scan channel gap. Hence we should
> advertise low priority scan support to cfg80211.
> 
> This patch fixes a problem in which OBSS scan request from
> wpa_supplicant was being rejected by cfg80211.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index bb7235e..7dafc5b 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -4086,6 +4086,7 @@ int mwifiex_register_cfg80211(struct
> mwifiex_adapter *adapter)
> 
>  	wiphy->features |= NL80211_FEATURE_HT_IBSS |
>  			   NL80211_FEATURE_INACTIVITY_TIMER |
> +			   NL80211_FEATURE_LOW_PRIORITY_SCAN |
>  			   NL80211_FEATURE_NEED_OBSS_SCAN;
> 
>  	if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
> --
> 2.8.0.rc3.226.g39d4020

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
