Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757114AbbEVPCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 11:02:20 -0400
Message-ID: <1432306931.24980.8.camel@redhat.com> (sfid-20150522_170223_503567_B760DB62)
Subject: Re: [PATCH] cfg80211: properly send NL80211_ATTR_DISCONNECTED_BY_AP
 in disconnect
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Matthieu Mauger <matthieux.mauger@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Date: Fri, 22 May 2015 10:02:11 -0500
In-Reply-To: <1432304759-31767-1-git-send-email-johannes@sipsolutions.net>
References: <1432304759-31767-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-05-22 at 16:25 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When we disconnect from the AP, drivers call cfg80211_disconnect().
> This doesn't know whether the disconnection was initiated locally
> or by the AP though, which can cause problems with the supplicant,
> for example with WPS. This issue obviously doesn't show up with any
> mac80211 based driver since mac80211 doesn't call this function.
> 
> Fix this by requiring drivers to indicate whether the disconnect is
> locally generated or not. I've tried to update the drivers, but may
> not have gotten the values correct, and some drivers may currently
> not be able to report correct values. In case of doubt I left it at
> false, which is the current behaviour.
> 
> Reported-by: Matthieu Mauger <matthieux.mauger@intel.com>
> Tested-by: Matthieu Mauger <matthieux.mauger@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/ath/ath6kl/cfg80211.c         | 4 ++--
>  drivers/net/wireless/ath/wil6210/main.c            | 2 +-
>  drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 4 ++--
>  drivers/net/wireless/libertas/cfg.c                | 4 ++--
>  drivers/net/wireless/mwifiex/join.c                | 2 +-
>  drivers/net/wireless/mwifiex/sta_event.c           | 2 +-
>  drivers/net/wireless/rndis_wlan.c                  | 2 +-
>  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c  | 2 +-
>  drivers/staging/wlan-ng/cfg80211.c                 | 2 +-
>  include/net/cfg80211.h                             | 4 +++-
>  net/wireless/core.h                                | 1 +
>  net/wireless/sme.c                                 | 4 +++-
>  net/wireless/util.c                                | 3 ++-
>  13 files changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 1a4d558022d8..9e3e3176670b 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -841,7 +841,7 @@ void lbs_send_disconnect_notification(struct lbs_private *priv)
>  
>  	cfg80211_disconnected(priv->dev,
>  		0,
> -		NULL, 0,
> +		NULL, 0, false,
>  		GFP_KERNEL);

lbs_send_disconnect_notification() could use a 'bool locally_generated'
parameter that gets passed directly to cfg80211_disconnected(), which in
turn gets passed through from a new 'bool locally_generated' parameter
for lbs_mac_event_disconnected() (which is the only caller of
lbs_send_disconnect_notification).

The calls to lbs_mac_event_disconnected() would pass these values:

lbs_leave_ibss(): true
lbs_process_event(): MACREG_INT_CODE_DEAUTHENTICATED: false
lbs_process_event(): MACREG_INT_CODE_DISASSOCIATED: false
lbs_process_event(): MACREG_INT_CODE_LINK_LOST_NO_SCAN: true
 
>  	lbs_deb_leave(LBS_DEB_CFG80211);
> @@ -1458,7 +1458,7 @@ int lbs_disconnect(struct lbs_private *priv, u16 reason)
>  
>  	cfg80211_disconnected(priv->dev,
>  			reason,
> -			NULL, 0,
> +			NULL, 0, true,
>  			GFP_KERNEL);
>  	priv->connect_status = LBS_DISCONNECTED;

This one is correct.

Dan


