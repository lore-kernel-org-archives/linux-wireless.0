Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52312 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1K2Amd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 19:42:33 -0500
Received: by ggnr5 with SMTP id r5so5855554ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 16:42:33 -0800 (PST)
Message-ID: <4ED42A75.4010605@lwfinger.net> (sfid-20111129_014236_652831_B5CE0847)
Date: Mon, 28 Nov 2011 18:42:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Philipp Dreimann <philipp@dreimann.net>
CC: linux-wireless@vger.kernel.org,
	'Chaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtl8192{ce,cu,de,se}: avoid problems because of possible
 ERFOFF -> ERFSLEEP -> .. transition
References: <1322526100-6433-1-git-send-email-philipp@dreimann.net>
In-Reply-To: <1322526100-6433-1-git-send-email-philipp@dreimann.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2011 06:21 PM, Philipp Dreimann wrote:
> Hello!
>
> I noticed that ppsc->rfpwr_state could be set to ERFSLEEP even
> though the device is actually in ERFOFF.
>
> Or am I missing something?
>
> BR,
>   Philipp
>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |    3 ++-
>   drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    3 ++-
>   drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    3 ++-
>   4 files changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> index 592a10a..7f6b933 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
> @@ -569,7 +569,8 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
>   		}
>   	case ERFSLEEP:{
>   			if (ppsc->rfpwr_state == ERFOFF)
> -				break;
> +				return false;
> +				
>   			for (queue_id = 0, i = 0;
>   			     queue_id<  RTL_PCI_MAX_TX_QUEUE_COUNT;) {
>   				ring =&pcipriv->dev.tx_ring[queue_id];
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> index 7285290..33ada66 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
> @@ -548,7 +548,8 @@ static bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
>   		break;
>   	case ERFSLEEP:
>   		if (ppsc->rfpwr_state == ERFOFF)
> -			break;
> +			return false;
> +			
>   		for (queue_id = 0, i = 0;
>   		     queue_id<  RTL_PCI_MAX_TX_QUEUE_COUNT;) {
>   			ring =&pcipriv->dev.tx_ring[queue_id];
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> index 3ac7af1..0883349 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> @@ -3374,7 +3374,7 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_hw *hw,
>   		break;
>   	case ERFSLEEP:
>   		if (ppsc->rfpwr_state == ERFOFF)
> -			break;
> +			return false;
>
>   		for (queue_id = 0, i = 0;
>   		     queue_id<  RTL_PCI_MAX_TX_QUEUE_COUNT;) {
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
> index f27171a..539172e 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
> @@ -602,7 +602,8 @@ bool rtl92s_phy_set_rf_power_state(struct ieee80211_hw *hw,
>   		}
>   	case ERFSLEEP:
>   			if (ppsc->rfpwr_state == ERFOFF)
> -				break;
> +				return false;
> +				
>
>   			for (queue_id = 0, i = 0;
>   			     queue_id<  RTL_PCI_MAX_TX_QUEUE_COUNT;) {

Yes, it would be possible to jump from ERFSLEEP to ERFOFF in the code.

Chaoming: Is this what you want, or is it a bug?

Thanks,

Larry
