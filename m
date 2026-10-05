Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3A22F6577
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791230958; cv=none; b=LhFpRsVd/bmOLcvOf65J5ACNJRF8cjZ2VvUOoDO0xn/MozqmZM8cd4cON1vL9bLAvGkBy0vDi4xKGuOorYTbyJevoxs15wPDrF7Bdd1OKCWVJjrXSm9D9E7f3u4KOhSu2W/l8czT01edDJDHLR3VfelgxW7fDFzMH8kpG6Vf79k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791230958; c=relaxed/simple;
	bh=l2VjLBNfP83tFyUiCn0Mqr/m3ilRjj4TMtyy+xpIQhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sEk6ByTfirmh07LJXlGLtUTOep3wdI8PpKo1mZAPGVm5Eh5u+5NI/43s7NpAIJrsZIaZRE8tPG1CUEZd6mDtqztshIBTuiWZ7yhrtSuA4AHwqfmXsGEMHTLZAHzMPYHP2FSbhP3WKOunTDQfbC808xnPVTmK9O4harYQRCdrO7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3286+iC; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3286+iC"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48afd5b1678so1314412f8f.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 13:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791230955; x=1791835755; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IuYdjbd3oCfaoW7xWaancb13dC2bF7M8W7RdQP5xTTE=;
        b=Z3286+iCxVR6dVno4ICmRZClcNKvSM+yZTS1REl8gt2PKwy88kP83EejShTO57UZL8
         DRRV4SZX3uZz1bBuZI9hWTNGOkU09WYe0yzBaTyEZe1pwKc/lGcvmbQbHRq2aPmuprus
         XsS/Wcq3qNgZ4wnjdFqtzMn5Aanmorr6mdIub89foPQg4FuvQ2EAgrAXEgeea1Tz51CC
         uyydu9cY8hZBG4X+WJ9Im7tWBFUGFiGxHXTFePW2OSLFP3fNLpO0MPCK3lUi7OObVD2t
         0YgAq1YQ8Nb/wT9UOaV5uP0XAfJbjGczn3U+74WWMZD4gao6DoSuQrpQxYZobU3pTMxD
         ReGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791230955; x=1791835755;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IuYdjbd3oCfaoW7xWaancb13dC2bF7M8W7RdQP5xTTE=;
        b=zNRR6B14+nOu7rtBR6QdhrorzCBzbO9Vxn0HYBvSVBGY+HZLJYCvWScve7CXXev0k/
         nbWPahuKYsuOVZm8/V/xEoNfpflZ8OwSwpgjWP6q8ztn0qcOp2YyfKDmktMYfeHAXA7E
         eWw5vEp18M34GFPzPfVJdLtdgEqmymaVoB2EtijgZUDUeFaPFF1l6nAWq2gYW18grrLS
         XaKMTXgxVfwEVIZZ8wysxVu1o+qnuBc/IwehoQv3MaApVXDd1a4dM1l31QKzXeEEPTfW
         0HK8PdI+MV0wfLp03rC6TaWVoSiKbKtaTX7wN1VMDHStZ5bPhOXGYTND+V2KuRWOLIfe
         41zQ==
X-Forwarded-Encrypted: i=1; AKwUvBzHDD81AvnsZmD2lyRAlpFkj4n2OsAKuVDeptzO/DBtoywFDpDAhI6/iHkYb1fyT466S+clufQ2aoL+fRG8Qg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ0vZDBouZlD9lbHIdsxIYTJj7566om0/jh5dUBZWiK73lnpTof
	XTryaTn1bBaq+O6uytkPLMpPwre8R9mrI5fCjphy8rMFyTy0If7wUzVqOKdv9g==
X-Gm-Gg: AYBFou3mRt6cDVaulLQh4qH0pEcYcvoA0zMpV/aN88Zqpp08U0Az4yLNhf1w1+GV5Lm
	AJ9K31p0M1+AVOj3pTP2gIKGg/caFe5EJlqMG+dswxjR7WFZwFmj325NR8L/A7Ow/G957z9z8b/
	nZB+sPG1ao60F/HB4mG6w9OozrUJIO3PIA0+PL2cXdIB0DrnNzMkeB7J8zrZ6ZCAtG6BlrdwtQX
	uYUviMekDlVxNIqhZhzM4sVaYcK5qyMazdFaoTNNqLxGzgddQabNCeVU7l594WK0Fv3otcvvTNn
	bf9ws8WRaoCAhbXw4GLnD6Euff2hRTi+BNuKJPCYcTt9zLY73H5UikV28rrkAIwonKpaoFUraPO
	oWOyZWZAUv4rFffSt57dSrj2SV6derR3CNqVEDRDVeYI0DKf6GjgXqqLDLdZJdmO0YZxsHWe0A5
	6ckQvcffes/76CYXSBDsT1LgZrlh1QLHfhbK5TQEFk5pZ9EzZ8m7jUy7AdT6PED8Wt6eMx1ABhd
	qyRFw==
X-Received: by 2002:a05:6000:2289:b0:48c:5cf9:88d6 with SMTP id ffacd0b85a97d-48c5cf98957mr7533027f8f.2.1791230955189;
        Mon, 05 Oct 2026 13:09:15 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c622704a5sm13207057f8f.15.2026.10.05.13.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 13:09:14 -0700 (PDT)
Message-ID: <5c5292e2-b52a-4cb3-9016-45840c490630@gmail.com>
Date: Mon, 5 Oct 2026 23:09:13 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problems with rtw89 on 5Ghz wlans.
To: Ping-Ke Shih <pkshih@realtek.com>,
 PierluigiFrullani <pierluigi.frullani@frumar.it>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <10543730.tdPhlSkOF2@topolinux>
 <fab16229-8e70-41a8-83f3-5d04c6035a43@gmail.com>
 <980970f8b4934572aafbd6f5f6020436@realtek.com>
 <dc900baa-a3c7-4962-a11e-9a949af92340@gmail.com>
 <2f8b1f510df840e1a73a3321e77bbc1b@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <2f8b1f510df840e1a73a3321e77bbc1b@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/10/2026 05:30, Ping-Ke Shih wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>>>>> diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
>>>> b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
>>>>> index 356623341f65..c9ee3c76cfc9 100644
>>>>> --- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
>>>>> +++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
>>>>> @@ -771,6 +771,15 @@ static void rtw8852b_btc_set_rfe(struct rtw89_dev *rtwdev)
>>>>>      } else {
>>>>>          md->ant.type = BTC_ANT_SHARED;
>>>>>          md->bt0_pos = BTC_BT_BTG;
>>>>> +
>>>>> +        if (md->rfe_type == 41) {
>>>
>>> Use the same quirk by the way.
>>>
>>
>> This was the initial version of the patch. Since then I changed
>> it to check hal->tx_nss and hal->rx_nss, to mirror what the
>> vendor driver does. Is that okay?
> 
> I checked vendor driver. It looks like this:
> 
>         if (phy_hw[0].tx_num == 1 && phy_hw[0].tx_path_num == 2 &&
>                 phy_hw[0].rx_num == 1 && phy_hw[0].rx_path_num == 2) {
> 
>                 if (rfe_type == 41) {
>                         RF_DBG(rf, DBG_RF_INIT, "%s: rfe_type: %d set to 1T1R\n", __func__, rfe_type);
>                         phy_hw[0].tx_path_num = 1;
>                         phy_hw[0].rx_path_num = 1;
>                 } else if (rfe_type == 43) {
>                         RF_DBG(rf, DBG_RF_INIT, "%s: rfe_type: %d set to 1T2R\n", __func__, rfe_type);
>                         phy_hw[0].tx_path_num = 2;
>                         phy_hw[0].rx_path_num = 2;
>                 }
>         }
> 
> I'm not sure the "mirror" you menat. 

I meant the check in rtw8852b_btc_set_rfe(). Originally I checked
rfe_type, then later I went back to the vendor driver and traced
where p->phy_cap[0].txss and p->phy_cap[0].rxss came from, and
replaced the rfe_type check with hal->tx_nss and hal->rx_nss.

> I feel it is okay to check tx_num/tx_patch_num before doing override the values
> at first glance. But think a bit more, it looks like no checking will be also
> okay, because I don't think rfe_type 41 can be another configuration.
> 
> By the way, my thinking of this patch is 
> 
> 1. after reading efuse. If rfe_type 41 --> set a quirk
> 2. by quirk, set BTC
> 3. by quirk, set tx_nss/tx_ant
> 
> With the quirk, it will be easier to understand 2 and 3 related things. 

Sounds good.
