Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85287511E8C
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 14:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863605; cv=none; b=HvDr4mVUOxqEGw1u+ZzqLGyPhqm20Jg7zan8rcty3N5nT1fpUyh7zvlrVzod6hBmJ5YqdKWxSu8eyZQ9WwjAaPv4aaKDMrBoE7d1PkLZ2q8W6dDloLuIOa6ScOm8lQbgWUfq/3Q5QsGrei9NnFh8s6Wus1wiMcffJuNT+4Zwnyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863605; c=relaxed/simple;
	bh=sGLEpzcPVNllIfLpktgwJKZsixaHiclIoijoTPQYclM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IRGw7tL+74Ep4IbRNc3ms1UxSf8iTOSdPpsxXIZGitbVK0xRRY8K8FEpTgnDYLMbVuOduXtCbFZd+VVeuKer6pSzGTwf+7gJ33zg9Oh5jAsON1okVL/tWicO26UOXqfYUBJ0pN9hGPr+GPsKEsq+jSRMrOMxpG56mV9hKup1HqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ldg6a492; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ldg6a492"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso48726695e9.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 07:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790863602; x=1791468402; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m6l1ddHXrzpQe38WEZnaB9cZIrrtbI67e2zdTJ3dzc8=;
        b=Ldg6a492Zn4A8/PIkMA7QG3RqcyEzrGOf38PfOS1hmebx1PLGfVce2QEug+btwvnvF
         eAutJdMARbGjaSl58kA/k6oOVHIPkRy3hHSFXie14gqO6EGipFOnahmrWcoXwE662dUn
         ou9hQoMEc5KGQQOXiUcYqkDyRQc02Azyu5krgzZfnclWPQyUd5aIGwIYY96eiuSq1R0U
         Wi1Z+LN1/eRpumwRsvB7lZd2Yj8Qghiy6oErAF63wk58q9XO1FdRuMEG9K7IgBlZF4Dm
         +t5otGzrR/RFKnH/WgEQptWTwRLxOEMmIxVscGGGiizI6v6dB+HSOCyoW72PJaowsQTG
         weHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790863602; x=1791468402;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m6l1ddHXrzpQe38WEZnaB9cZIrrtbI67e2zdTJ3dzc8=;
        b=oF6tcjufIn8//OSnJOp94Kwa9rdM+beIMPQ8Ynd1T7ISPbCVvELwiplpYO6FquWoCs
         KawqfyVfzSVCqMfTQkUOh5unfDro2ykgn6hROT6aUYF9Eqb5LgSSYIsQ+Gbl2bTR2R6T
         2svTxgpcAGqJnQxBDCUHYJXC8GRapa6SP4uXv6Q5xWVfhXgyL9LmjYWhmaI9Bgi0laRA
         GCCpUvn6RV+p0gG1dlg2L0CxSWvVKf2LoSBKxEyEoSPjTBNHS7udzRCnJy0f+F2nyXl/
         InE+FdevibCLhVSvitnIrgJwvBf75ZDWw+gEtnK7vhchJZooC+1C9g44gWUPY+XuDY4F
         t9wA==
X-Forwarded-Encrypted: i=1; AKwUvByKYP9ApInVHKKiZu/CnK+HFAOeSTZgr3aPq0rQbDsuXoxEhcAlpVHAvIUxvIEy0qXpoqR9mzEYxzieCd1BPQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lDhtNZ0FXcmOWMuFGRwzpYq7Alya0efbSAeOO0Kc3JdCx0Q0vN
	+MmWTS3cHdH68rypLp/JoBgd4VwjWhS6aBaCwPpnobRiTRBFE5nKmxIlvfcu2Q==
X-Gm-Gg: AYBFou1Ix5grCoWWtXCkVKA35cNdj7vMieNweS4f5i+Iz12GrafISSYjvJ80bWp2o0t
	v44RYhoHvENiD5NgahBJ3MDVYQ7ub5tzla1Zoiq8XL3mcubN5Z5LNuWoHbO4ovqap3D8d4/k2fx
	oe9152jX5sLQuXDI0AbZpJ+VR1s1UgfazitLwyKeU4AAfuMVTGisgzWQ4rMiqU50thVT33tO9b/
	IjArIzHkeMAelmNc2T3iIWgPshmrM583ek/HyoYmBqrHD8OM3Djv6VkEFaabbrgjFDUdDYiI6M+
	wsShIbM3uC70nASOCGSI2T51ENpsn6559MrR5LbvvWdD37Murn5H2gwp6JQb7q5najJCSyV/kYF
	zo+U0t12858/fSTH6eBx0I9HohDAbzSEXf2oNGHhAg9/jAEclpEvGxMImgSamgle00dh8qP5Aon
	k1ajLqWB4vxEljGTZxycMaP7d0kOKBijOCmoY8sL0PaWJZnL6qafzHb6XGSnYMYgMjBP9sJaVU8
	XMSHpmeCANmw10I
X-Received: by 2002:a05:600c:4e41:b0:4a0:1723:2d90 with SMTP id 5b1f17b1804b1-4a01ad7d018mr73552235e9.4.1790863601467;
        Thu, 01 Oct 2026 07:06:41 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f979f4fsm75744305e9.4.2026.10.01.07.06.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 07:06:40 -0700 (PDT)
Message-ID: <fab16229-8e70-41a8-83f3-5d04c6035a43@gmail.com>
Date: Thu, 1 Oct 2026 17:06:39 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problems with rtw89 on 5Ghz wlans.
To: PierluigiFrullani <pierluigi.frullani@frumar.it>,
 linux-wireless@vger.kernel.org
References: <10543730.tdPhlSkOF2@topolinux>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <10543730.tdPhlSkOF2@topolinux>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/09/2026 12:21, PierluigiFrullani wrote:
> Hello all,
>     I'm using Linux Mint 22.1 with kernel 7.0.0-34-generic and a 
> 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8852BE PCIe 802.11ax Wireless Network Controller [1T1R] [10ec:b85b] 
> that has lot of issues with the 5Ghz wlan.
> The problem is that has a very low sensitivity and can detect, in linux, these wlans only when I'm a few feet from access point.
> 
> 
> I've then swapped the driver with https://github.com/morrownr/rtw89 and found the same behaviour.
> I've then opened an issue there :
>  https://github.com/morrownr/rtw89/issues/128 and the peoples there managed to find the culprit and patch his driver that now works perfectly.
> For my understanding the problem was that my card ( may card model ? ) ( rfe_type 41 ) has only one antenna and is not correctly selected b y the driver.
> 
> Looking into the https://github.com/pkshih/rtw/blob/rtw-next/drivers/net/wireless/realtek/rtw89  code I can see that is really similar so then patche applied in the morrownr could possibly apply  also to the vanilla kernel driver.
> 
> 
> Patch is rather easy and with this patch allied and this driver loaded now the 5Ghz is perfectly working.
> 
> 
> Would you be interessed in pushing this patch also here ?
> 
> 
> In case, this is the patch ( also with the comments to verify that the driver loaded is the one that is patched ) :
> diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
> index df396fbfca26..81a4be7a593d 100644
> --- a/drivers/net/wireless/realtek/rtw89/mac.c
> +++ b/drivers/net/wireless/realtek/rtw89/mac.c
> @@ -3244,6 +3244,14 @@ static int rtw89_mac_setup_phycap_part0(struct rtw89_dev *rtwdev)
>      tx_ant = u32_get_bits(phycap->w3, RTW89_C2HREG_PHYCAP_W3_ANT_TX_NUM);
>      rx_ant = u32_get_bits(phycap->w3, RTW89_C2HREG_PHYCAP_W3_ANT_RX_NUM);
>  
> +    if (chip->chip_id == RTL8852B && efuse->rfe_type == 41 &&
> +        tx_nss == 1 && tx_ant == 2 && rx_nss == 1 && rx_ant == 2) {
> +        tx_ant = 1;
> +        rx_ant = 1;
> +
> +        rtw89_warn(rtwdev, "fix more stuff for RFE 41\n");
> +    }
> +
>      hal->tx_nss = tx_nss ? min_t(u8, tx_nss, chip->tx_nss) : chip->tx_nss;
>      hal->rx_nss = rx_nss ? min_t(u8, rx_nss, chip->rx_nss) : chip->rx_nss;
>  
> diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
> index 356623341f65..c9ee3c76cfc9 100644
> --- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
> +++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
> @@ -771,6 +771,15 @@ static void rtw8852b_btc_set_rfe(struct rtw89_dev *rtwdev)
>      } else {
>          md->ant.type = BTC_ANT_SHARED;
>          md->bt0_pos = BTC_BT_BTG;
> +
> +        if (md->rfe_type == 41) {
> +            md->ant.num = 1;
> +            md->ant.single_pos = RF_PATH_B;
> +            md->ant.btg_pos = RF_PATH_B;
> +            md->ant.stream_cnt = 1;
> +
> +            rtw89_warn(rtwdev, "fix stuff for RFE 41\n");
> +        }
>      }
>      rtwdev->btc.btg_pos = md->ant.btg_pos;
>      rtwdev->btc.ant_type = md->ant.type;
> 
> 
> 
> All credits must absolutelly go to  dubhater (   https://github.com/dubhater ) that did all troubleshooting and wrote the patch.
>  
> My interest in this is only to have a (vanilla) kernel version of this driver that works correctly as lot of problems are reported by peoples using the same chip.
> 
> 
> 
> Thanks
> 
> 
> Pierluigi 

Hi,

Two other people reported the same problem recently. I decided to wait
for them to say if the patch helps or not. But I will send the patch
anyway next week.
