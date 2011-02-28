Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3472 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab1B1Juj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 04:50:39 -0500
Message-ID: <4D6B6FDD.4070202@broadcom.com>
Date: Mon, 28 Feb 2011 10:50:21 +0100
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Javier Martinez Canillas" <martinez.javier@gmail.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 1/2] staging: brcm80211: Add buf_size parameter to
 ampdu_action handler function
References: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1298840055-5044-1-git-send-email-martinez.javier@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Javier,

this change looks good to me.

Thanks, Roland.

On 02/27/2011 09:54 PM, Javier Martinez Canillas wrote:
> struct ieee80211_ops.ampdu_action function pointer definition now includes a
> u8 buf_size parameter.
>
> Update wl_ops_ampdu_action handler function according to this new signature.
>
> Signed-off-by: Javier Martinez Canillas<martinez.javier@gmail.com>
> ---
>   drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
> index 7645c6c..345243b 100644
> --- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
> +++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
> @@ -142,7 +142,8 @@ static int wl_ops_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>   static int wl_ops_ampdu_action(struct ieee80211_hw *hw,
>   			       struct ieee80211_vif *vif,
>   			       enum ieee80211_ampdu_mlme_action action,
> -			       struct ieee80211_sta *sta, u16 tid, u16 *ssn);
> +			       struct ieee80211_sta *sta, u16 tid, u16 *ssn,
> +			       u8 buf_size);
>   static void wl_ops_rfkill_poll(struct ieee80211_hw *hw);
>
>   static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
> @@ -609,7 +610,8 @@ static int
>   wl_ops_ampdu_action(struct ieee80211_hw *hw,
>   		    struct ieee80211_vif *vif,
>   		    enum ieee80211_ampdu_mlme_action action,
> -		    struct ieee80211_sta *sta, u16 tid, u16 *ssn)
> +		    struct ieee80211_sta *sta, u16 tid, u16 *ssn,
> +		    u8 buf_size)
>   {
>   #if defined(BCMDBG)
>   	struct scb *scb = (struct scb *)sta->drv_priv;


