Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38773 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2GMQJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 12:09:54 -0400
Received: by yhmm54 with SMTP id m54so4031360yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2012 09:09:54 -0700 (PDT)
Message-ID: <5000484E.9070700@lwfinger.net> (sfid-20120713_181037_367753_E25DFB79)
Date: Fri, 13 Jul 2012 11:09:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192de: Fix phy-based version calculation
References: <20120713143551.GF9489@alittletooquiet.net>
In-Reply-To: <20120713143551.GF9489@alittletooquiet.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2012 09:35 AM, Forest Bond wrote:
> From: Forest Bond <forest.bond@rapidrollout.com>
>
> Commit d83579e2a50ac68389e6b4c58b845c702cf37516 incorporated some
> changes from the vendor driver that made it newly important that the
> calculated hardware version correctly include the CHIP_92D bit, as all
> of the IS_92D_* macros were changed to depend on it.  However, this bit
> was being unset for dual-mac, dual-phy devices.  The vendor driver
> behavior was modified to not do this, but unfortunately this change was
> not picked up along with the others.  This caused scanning in the 2.4GHz
> band to be broken, and possibly other bugs as well.
>
> This patch brings the version calculation logic in parity with the
> vendor driver in this regard, and in doing so fixes the regression.
> However, the version calculation code in general continues to be largely
> incoherent and messy, and needs to be cleaned up.
>
> Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)

The code changes are OK; however, please resubmit with a "Cc: Stable 
<stable@vger.kernel.org> [v3.2+]" When you make that change, you can also add a 
Signed-off-by for me.

John,

If possible, please include this in the changes for 3.5.

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> index 18380a7..4420312 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
> @@ -3345,21 +3345,21 @@ void rtl92d_phy_config_macphymode_info(struct ieee80211_hw *hw)
>   	switch (rtlhal->macphymode) {
>   	case DUALMAC_SINGLEPHY:
>   		rtlphy->rf_type = RF_2T2R;
> -		rtlhal->version |= CHIP_92D_SINGLEPHY;
> +		rtlhal->version |= RF_TYPE_2T2R;
>   		rtlhal->bandset = BAND_ON_BOTH;
>   		rtlhal->current_bandtype = BAND_ON_2_4G;
>   		break;
>
>   	case SINGLEMAC_SINGLEPHY:
>   		rtlphy->rf_type = RF_2T2R;
> -		rtlhal->version |= CHIP_92D_SINGLEPHY;
> +		rtlhal->version |= RF_TYPE_2T2R;
>   		rtlhal->bandset = BAND_ON_BOTH;
>   		rtlhal->current_bandtype = BAND_ON_2_4G;
>   		break;
>
>   	case DUALMAC_DUALPHY:
>   		rtlphy->rf_type = RF_1T1R;
> -		rtlhal->version &= (~CHIP_92D_SINGLEPHY);
> +		rtlhal->version &= RF_TYPE_1T1R;
>   		/* Now we let MAC0 run on 5G band. */
>   		if (rtlhal->interfaceindex == 0) {
>   			rtlhal->bandset = BAND_ON_5G;
>


