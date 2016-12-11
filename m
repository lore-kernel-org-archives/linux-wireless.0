Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0059.hostedemail.com ([216.40.44.59]:51874 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751986AbcLKKuz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Dec 2016 05:50:55 -0500
Message-ID: <1481453445.1764.11.camel@perches.com> (sfid-20161211_115059_165656_E137018C)
Subject: Re: [PATCH 02/14] rtlwifi_new: Remove RT_TRACE messages that use
 DBG_EMERG
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>
Date: Sun, 11 Dec 2016 02:50:45 -0800
In-Reply-To: <20161211054523.7119-3-Larry.Finger@lwfinger.net>
References: <20161211054523.7119-1-Larry.Finger@lwfinger.net>
         <20161211054523.7119-3-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-12-10 at 23:44 -0600, Larry Finger wrote:
> These messages are always logged and reprresent error conditions, thus
> we can use pr_err().
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/base.c  | 15 ++++-----
>  drivers/net/wireless/realtek/rtlwifi/cam.c   | 14 +++------
>  drivers/net/wireless/realtek/rtlwifi/core.c  | 21 +++++--------
>  drivers/net/wireless/realtek/rtlwifi/debug.c |  9 ++----
>  drivers/net/wireless/realtek/rtlwifi/debug.h |  2 +-
>  drivers/net/wireless/realtek/rtlwifi/efuse.c |  3 +-
>  drivers/net/wireless/realtek/rtlwifi/pci.c   | 36 ++++++++--------------
>  drivers/net/wireless/realtek/rtlwifi/ps.c    |  3 +-
>  drivers/net/wireless/realtek/rtlwifi/rc.c    |  3 +-
>  drivers/net/wireless/realtek/rtlwifi/usb.c   | 46 +++++++++-------------------
>  10 files changed, 53 insertions(+), 99 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
[]
> @@ -207,8 +207,7 @@ static void _rtl_init_hw_ht_capab(struct ieee80211_hw *hw,
>  	 *highest supported RX rate
>  	 */
>  	if (rtlpriv->dm.supp_phymode_switch) {
> -		RT_TRACE(rtlpriv, COMP_INIT, DBG_EMERG,
> -			 "Support phy mode switch\n");
> +		pr_err("rtlwifi: Support phy mode switch\n");

I believe most all of these are already prefixed
by the wifi.h that has a #define pr_fmt 
