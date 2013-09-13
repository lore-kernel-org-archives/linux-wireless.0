Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:41119 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3IMSAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 14:00:43 -0400
Received: by mail-oa0-f44.google.com with SMTP id l17so1496907oag.3
        for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 11:00:41 -0700 (PDT)
Message-ID: <523352C8.8000902@lwfinger.net> (sfid-20130913_200046_573847_BD55F77E)
Date: Fri, 13 Sep 2013 13:00:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192cu: testing with EdiMax USB
References: <5232DAF0.6040907@ilande.co.uk> <52330CB4.7020902@ilande.co.uk> <523312D0.3020001@ilande.co.uk>
In-Reply-To: <523312D0.3020001@ilande.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/13/2013 08:27 AM, Mark Cave-Ayland wrote:
> On 13/09/13 14:01, Mark Cave-Ayland wrote:
>
>>> I spent a bit more time tinkering further with debug=0x5, forgetting
>>> that I had left your last diagnostic patch applied. Based upon when the
>>> beacon output disappears in the logs (after updating the power
>>> registers), it does seem likely that is a power-related problem.
>>
>> FWIW I just tried a quick test where I commented out the entire
>> rtl92c_dm_txpower_tracking_callback_thermalmeter() function to make it a
>> nop, and that didn't seem to make any difference...
>
> Aha! The following diff to remove the call to rtl92c_dm_diginit() keeps me
> associated to the AP:
>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> index d2d57a2..c18362d 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
> @@ -1275,7 +1275,7 @@ void rtl92c_dm_init(struct ieee80211_hw *hw)
>          struct rtl_priv *rtlpriv = rtl_priv(hw);
>
>          rtlpriv->dm.dm_type = DM_TYPE_BYDRIVER;
> -       rtl92c_dm_diginit(hw);
> +       //rtl92c_dm_diginit(hw);
>          rtl92c_dm_init_dynamic_txpower(hw);
>          rtl92c_dm_init_edca_turbo(hw);
>          rtl92c_dm_init_rate_adaptive_mask(hw);
>
> However, dhclient still takes a very long time get an IP address and the
> connection seems extremely lossy, much like it was when I could get a connection
> before. Perhaps there are two different bugs here, one for the association and
> one for the data loss?

Thanks for the info. Eliminating the call to rtl92c_dm_diginit() is a very large 
hammer to attack a small flea, but that points to a potential problem.

Larry


