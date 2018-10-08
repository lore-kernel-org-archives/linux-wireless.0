Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5766EC677D4
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 15:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1317A20890
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 15:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QuYCuyg1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1317A20890
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbeJHXGI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 19:06:08 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34176 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbeJHXGH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 19:06:07 -0400
Received: by mail-ot1-f67.google.com with SMTP id i12-v6so20417432otl.1;
        Mon, 08 Oct 2018 08:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xgcFrayUMiyqhcI9wRtyyi9GoM8fznnVQDQtwVhO39A=;
        b=QuYCuyg1eVdezNXe+bLfpigm54SEwuJyaPMbSScnHlz2Tg5sa+sOFz39RfErbDNqoU
         HRnYgSAe59os02JQNa7FtFQMA6X3GhWUAJ2dCYTU8AZM2nyX8rilcWfNZs8iToYJst4G
         P9tievS4HIWgxqd2ves+lGiYOgvdTA5qLTKRbZdV/h7DFMNTvKbB5cCTId8RS1yydadr
         oEsjNWj3WoK1NLXuw5uIcTqEanulGBX8NR2IGHu9akQIn0dEFe8xLP8le4y5zzWc9d4r
         a4G2tjtCEUovgr3UEmdPfXJczMZ53R5S9H9rVzkrNKnujd9MTPPF3YvyIiSP+SEqlcJo
         JmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xgcFrayUMiyqhcI9wRtyyi9GoM8fznnVQDQtwVhO39A=;
        b=bfDGef89cA+h2MqcIv7Emv+Lg9F0NAlIPkcYn3lvd7n3JbZShHa9vuSsToFD4agRFA
         lRkmW1VWKREnuzJjAgFCUFYZYmuqS6bE35VLJfzX3G3CDYnYztntTaseNhhfs49snpUN
         Yq6EqZ8pP9UjmOlro4pzZUxZR77uh71CDglO7bDhc2Rjv9u30RGGHg2s07fmwTZA6lDs
         h68MtkhjqJrbU+aQ1XqZkZxoBei+GqglBy9CrRZzwkaVVB51aO7hOqvCW4fx5tqKhaQX
         ks51nyhOh7FZheIJ9zGSREr9JuNF/LPOkVZ61odNH0y20xlQcGosFESQfAN2NRIxTOMm
         lsQg==
X-Gm-Message-State: ABuFfogBq0m7gANgKIX8wmV5HBc0IbidcFDTKeUbbZiFBF+rs0OcZ8OH
        15rVGio/oqT/oRLUgRa68x8YY6gT
X-Google-Smtp-Source: ACcGV63L5kKq2txJnFPculwW65X5iQ12ETLvKPxtvJ6dZrIVgQ1MvIzPYBX9OhCWeuiIbqO4j24lHw==
X-Received: by 2002:a9d:beb:: with SMTP id 98-v6mr3607033oth.364.1539014024225;
        Mon, 08 Oct 2018 08:53:44 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id b49sm8308186otb.33.2018.10.08.08.53.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 08:53:42 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: rtl8821ae: replace
 _rtl8821ae_mrate_idx_to_arfr_id with generic version
To:     Colin King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20181008085028.23874-1-colin.king@canonical.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <aac8eec4-d4e7-93c3-d42c-8960d16629d6@lwfinger.net>
Date:   Mon, 8 Oct 2018 10:53:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20181008085028.23874-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/8/18 3:50 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Function _rtl8821ae_mrate_idx_to_arfr_id is functionally identical to
> the generic version rtl_mrate_idx_to_arfr_id, so remove
> _rtl8821ae_mrate_idx_to_arfr_id and use the generic one instead.
> 
> This also fixes a missing break statement found by CoverityScan in
> _rtl8821ae_mrate_idx_to_arfr_id, namely: CID#1167237 ("Missing break
> in switch")
> 
> Thanks to Joe Perches for spotting this when I submitted an earlier patch.
> 
> Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 71 +------------------
>   1 file changed, 1 insertion(+), 70 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> index 317c1b3101da..ba258318ee9f 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
> @@ -3404,75 +3404,6 @@ static void rtl8821ae_update_hal_rate_table(struct ieee80211_hw *hw,
>   		 "%x\n", rtl_read_dword(rtlpriv, REG_ARFR0));
>   }
>   
> -static u8 _rtl8821ae_mrate_idx_to_arfr_id(
> -	struct ieee80211_hw *hw, u8 rate_index,
> -	enum wireless_mode wirelessmode)
> -{
> -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	struct rtl_phy *rtlphy = &rtlpriv->phy;
> -	u8 ret = 0;
> -	switch (rate_index) {
> -	case RATR_INX_WIRELESS_NGB:
> -		if (rtlphy->rf_type == RF_1T1R)
> -			ret = 1;
> -		else
> -			ret = 0;
> -		; break;
> -	case RATR_INX_WIRELESS_N:
> -	case RATR_INX_WIRELESS_NG:
> -		if (rtlphy->rf_type == RF_1T1R)
> -			ret = 5;
> -		else
> -			ret = 4;
> -		; break;
> -	case RATR_INX_WIRELESS_NB:
> -		if (rtlphy->rf_type == RF_1T1R)
> -			ret = 3;
> -		else
> -			ret = 2;
> -		; break;
> -	case RATR_INX_WIRELESS_GB:
> -		ret = 6;
> -		break;
> -	case RATR_INX_WIRELESS_G:
> -		ret = 7;
> -		break;
> -	case RATR_INX_WIRELESS_B:
> -		ret = 8;
> -		break;
> -	case RATR_INX_WIRELESS_MC:
> -		if ((wirelessmode == WIRELESS_MODE_B)
> -			|| (wirelessmode == WIRELESS_MODE_G)
> -			|| (wirelessmode == WIRELESS_MODE_N_24G)
> -			|| (wirelessmode == WIRELESS_MODE_AC_24G))
> -			ret = 6;
> -		else
> -			ret = 7;
> -	case RATR_INX_WIRELESS_AC_5N:
> -		if (rtlphy->rf_type == RF_1T1R)
> -			ret = 10;
> -		else
> -			ret = 9;
> -		break;
> -	case RATR_INX_WIRELESS_AC_24N:
> -		if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_80) {
> -			if (rtlphy->rf_type == RF_1T1R)
> -				ret = 10;
> -			else
> -				ret = 9;
> -		} else {
> -			if (rtlphy->rf_type == RF_1T1R)
> -				ret = 11;
> -			else
> -				ret = 12;
> -		}
> -		break;
> -	default:
> -		ret = 0; break;
> -	}
> -	return ret;
> -}
> -
>   static u32 _rtl8821ae_rate_to_bitmap_2ssvht(__le16 vht_rate)
>   {
>   	u8 i, j, tmp_rate;
> @@ -3761,7 +3692,7 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
>   		break;
>   	}
>   
> -	ratr_index = _rtl8821ae_mrate_idx_to_arfr_id(hw, ratr_index, wirelessmode);
> +	ratr_index = rtl_mrate_idx_to_arfr_id(hw, ratr_index, wirelessmode);
>   	sta_entry->ratr_index = ratr_index;
>   	ratr_bitmap = _rtl8821ae_set_ra_vht_ratr_bitmap(hw, wirelessmode,
>   							ratr_bitmap);
> 

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

