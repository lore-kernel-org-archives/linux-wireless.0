Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:62636 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3INT7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 15:59:49 -0400
Received: by mail-la0-f42.google.com with SMTP id ep20so2075695lab.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Sep 2013 12:59:47 -0700 (PDT)
Message-ID: <5234C03A.2070701@cogentembedded.com> (sfid-20130914_220009_108841_3E664B8E)
Date: Sat, 14 Sep 2013 23:59:54 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 2/7] rtlwifi: rtl8192de: Fix smatch warnings in rtl8192de/hw.c
References: <1379094304-22041-1-git-send-email-Larry.Finger@lwfinger.net> <1379094304-22041-3-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1379094304-22041-3-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 09/13/2013 09:44 PM, Larry Finger wrote:

> Smatch lists the following:
>    CHECK   drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> drivers/net/wireless/rtlwifi/rtl8192de/hw.c:1200 rtl92de_set_qos() info: ignoring unreachable code.
> drivers/net/wireless/rtlwifi/rtl8192de/hw.c:1200 rtl92de_set_qos() info: ignoring unreachable code.

> Dead code is removed.

    It is instead commented out, including non-dead code it seems...

> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192de/hw.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> index 7dd8f6d..c9b0894 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
> @@ -1194,6 +1194,7 @@ void rtl92d_linked_set_reg(struct ieee80211_hw *hw)
>    * mac80211 will send pkt when scan */
>   void rtl92de_set_qos(struct ieee80211_hw *hw, int aci)
>   {
> +/*
>   	struct rtl_priv *rtlpriv = rtl_priv(hw);
>   	rtl92d_dm_init_edca_turbo(hw);
>   	return;

    Shouldn't the comment start here (and *return* removed)? It's also
better to remove the dead code than just to comment it out.

> @@ -1213,6 +1214,7 @@ void rtl92de_set_qos(struct ieee80211_hw *hw, int aci)
>   		RT_ASSERT(false, "invalid aci: %d !\n", aci);
>   		break;
>   	}
> + */
>   }

WBR, Sergei


