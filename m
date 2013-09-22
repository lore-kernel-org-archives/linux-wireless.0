Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:47803 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3IVTJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 15:09:36 -0400
Received: by mail-lb0-f181.google.com with SMTP id u14so2019571lbd.40
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 12:09:34 -0700 (PDT)
Message-ID: <523F406B.2010708@cogentembedded.com> (sfid-20130922_210955_627780_7A3FFD0E)
Date: Sun, 22 Sep 2013 23:09:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 2/8 V3] rtlwifi: rtl8192de: Fix smatch warnings in rtl8192de/hw.c
References: <1379534260-14841-1-git-send-email-Larry.Finger@lwfinger.net> <1379534260-14841-3-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1379534260-14841-3-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 09/18/2013 11:57 PM, Larry Finger wrote:

> Smatch lists the following:
>    CHECK   drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> drivers/net/wireless/rtlwifi/rtl8192de/hw.c:1200 rtl92de_set_qos() info: ignoring unreachable code.
> drivers/net/wireless/rtlwifi/rtl8192de/hw.c:1200 rtl92de_set_qos() info: ignoring unreachable code.

> The dead code is deleted.

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/hw.c |   19 -------------------
>   1 file changed, 19 deletions(-)

> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> ===================================================================
> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> @@ -1194,25 +1194,6 @@ void rtl92d_linked_set_reg(struct ieee80
>    * mac80211 will send pkt when scan */
>   void rtl92de_set_qos(struct ieee80211_hw *hw, int aci)
>   {
> -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	rtl92d_dm_init_edca_turbo(hw);

    This call seems reachable...

> -	return;
> -	switch (aci) {
> -	case AC1_BK:
> -		rtl_write_dword(rtlpriv, REG_EDCA_BK_PARAM, 0xa44f);
> -		break;
> -	case AC0_BE:
> -		break;
> -	case AC2_VI:
> -		rtl_write_dword(rtlpriv, REG_EDCA_VI_PARAM, 0x5e4322);
> -		break;
> -	case AC3_VO:
> -		rtl_write_dword(rtlpriv, REG_EDCA_VO_PARAM, 0x2f3222);
> -		break;
> -	default:
> -		RT_ASSERT(false, "invalid aci: %d !\n", aci);
> -		break;
> -	}
>   }

WBR, Sergei

