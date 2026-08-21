Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3982649362F
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 20:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787344420; cv=none; b=bfL25eeWUTjN+Bk+X147p+/XWgL0sKA0DFktUxCPL8SAeOisnkJiMDJluirx4QLMGAS0f2BJ8tymwQpXHNmC+N3R50Swsgo++OlCn7zZ0jLv1taffVXrDnOVR0daC6h79DXI3DEDdfXdWBPjxC53SEwuBZjbEFu95qRuyhrMwRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787344420; c=relaxed/simple;
	bh=aIRTkgmWpbV76HbM3Q0AgIJJgZn+CAD2Er7fBmhVzgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AGGZ5B7tDAL/SNooIN2v8baHGBuVw/40g1ADAP3OK/ECyzlM+rxPPgbLTV4G27ujul8vFdZtKVbHEekfeGhPUa3G1xUBAflJKmXQH3mjQNiQCBUkLeC15JAZEow5oypouC7gJ3KryhgZXer20nrNMPVGw9BftgvIofPSpg/Fmhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeLbAvBW; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeLbAvBW"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so169497066b.0
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 13:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787344417; x=1787949217; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VfyhNk7Ob1tC1JJ3rFOEQZPe86dpIKlLM8HAZGK51DY=;
        b=WeLbAvBWhS3krBBFU1Fr/md29l86pxrAtwBq0S4EMfhM2Mjn01q8B3iRNXcFrZo3Sy
         wm8Fa0henVB+zQAAOsw4WmL8IB8ozQFXeAyzskaux3GN35dD2JnVV31EedmU0s+LhiTU
         kQqVjoI4ZJNuvDNa32ZeIcn+qjtEkx7ZuTybCA2KekbDuhv6iV8qcCH05T/jJ4hFX8Sh
         /StSwwSKgIrOlW3q0vJn8NSVqUDLWtFPGvP3gcwACGO0DMgNI4P9UDxLo1NfznSGR3h2
         /TZDTrcr9Kyn0moK6idKKrSiPL1Sgg6wqw+458o3WjZopmBMwS5P/gHBNg7PtDMJvYm9
         uXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787344417; x=1787949217;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VfyhNk7Ob1tC1JJ3rFOEQZPe86dpIKlLM8HAZGK51DY=;
        b=tJDynpYkaOUhzHugJE0ZC+7vuQZSWvzpMcRe7sTBj1reJ411SRITcu5MQpENQgjZXG
         ieuDPpZT7RBOh30dhFXdksf8W/meRX/O5lSHoyYTz/S9+51yitN5tZ+GZC40+7c+pMIV
         QRyl6FaIVgrlNqln71pRuXmNglyaKmffurJTAnpMo3+utc7ftOYIJukg0RF4XpvvzaZs
         v438rFTfWz4yk4jFXT2bngjtxjbT1ifPcU+dP8BPSLzfdFbubdqqxn7YAz9nUnPFi550
         KEONnzgdJ1fyo2UbhlMCpWTGfPS/n51CblwSvJPkWFg0MbJsE3G3saF0PdFWg0Xc1xLR
         FcnQ==
X-Gm-Message-State: AFuF++miFtctDlM/y1f+zqFyhb9zDvvZpGg02R47vuc5DHC/EnLWeh7W
	oy3z6ac+Uih21tEtzqHxTqJP3dPD3/9cwT9V7PbS9hBKKexOCCuDs6NP
X-Gm-Gg: AR+sD11sLt21NFHeSA4OvOZQr8EEH6ycbDyJJwXjCnp46L4IAHYlFVpRchrAwKtiimy
	iDTAU1jPCb/WpPixGYRO8D5IBFa6/v1Efc63qOtMeBRVjhUoJvZPycPBWZc5O6TNRvExNm2ZRbQ
	ih09jqMMav6ErHcnL5TqQ9DQNT6g6l2YANhca/AL/MRu0NZjuhJv6CoUM+B0RgC2E+KAywKHjpw
	li6gj0/o6vcBlhD3s8WsqYjy8xODW9U6CQWIDWg0q3iCi7p5Ts6DymOnTawCrkAxk8+DY9G2JmN
	949c67FEyoV1ea8b4SABgvHXq/KCRS1anCrOUALP4tZ+Dbt+lbFjlpFDemALwmS0gXNb5ciwRkG
	8p8STUqIpW6YKOqpl2bIQSqfShRs9cou6HDezatBZ/TlS7OVige2uf8LZ8/W3bPbdJUuq7dN2BE
	rbe4FI0l3DfqTgstKRD9tz6n8r/3upaQavBKbtP78l6Xv2LE8siyYuF612TNkyIV5EMrZSCA==
X-Received: by 2002:a17:907:c20:b0:c15:f4bb:e663 with SMTP id a640c23a62f3a-c246a3ab3dfmr889302666b.10.1787344417373;
        Fri, 21 Aug 2026 13:33:37 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2458b0933csm663790666b.18.2026.08.21.13.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 13:33:36 -0700 (PDT)
Message-ID: <d51a0fe2-418f-418d-8ca7-9efc4844568c@gmail.com>
Date: Fri, 21 Aug 2026 23:33:35 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: rtw88: disable ASPM for Lenovo IdeaPad S340-14IWL
To: =?UTF-8?B?QXRhIMSwbGhhbiBLw7ZrdMO8cms=?= <atailhan2006@gmail.com>,
 pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260820101642.35003-1-atailhan2006@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260820101642.35003-1-atailhan2006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 20/08/2026 13:16, Ata İlhan Köktürk wrote:
> The Lenovo IdeaPad S340-14IWL (DMI product name "81N4") experiences
> severe connectivity issues with the rtw88 PCIe wireless card when
> ASPM is enabled. Reported symptoms include frequent disconnections,
> kernel panics, and the driver failing to load.
> 
> The issue can be worked around by either adding pci=noaspm to the
> kernel command line or by reloading the driver via modprobe. Add a
> DMI quirk to disable ASPM automatically for this device.
> 
> Signed-off-by: Ata İlhan Köktürk <atailhan2006@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index a30467228..9df8954d8 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -1779,6 +1779,15 @@ static const struct dmi_system_id rtw_pci_quirks[] = {
>  		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
>  					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
>  	},
> +	{
> +		.callback = rtw_pci_disable_caps,
> +		.ident = "Lenovo IdeaPad S340-14IWL",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "81N4"),
> +		},
> +		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM)),
> +	},
>  	{}
>  };
>  

By the way, what wifi chip do you have? It would be good to mention
that in the summary.
