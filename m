Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127BF2D5432
	for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 17:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789839548; cv=none; b=ltrS1yOdhz5HNv8xNLBc1G9/pocL60Ba8kcEfkWFI04RCJX0zGT65tJh4uPc6iAzg6nQXlYmEGkJ+8j3q5leWzOBYX615xPFZ8bfhwyCSBLVECcHAd5boJJX3bD6OE5HzoysPJ/UT/xgSASMlDM0C2+uB/eB1aPj7+BALJsLp9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789839548; c=relaxed/simple;
	bh=aDvLfzrRHVzY7Tr9+WJLzfUguQi3Vufm2HiQHBwcIPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bq+9yJj+obdpX1/kWJc/iV2anRPc3z/Ssb27Y8OzLisfQyBGneXqn5Yno+ERG7Tz1hNodfeMCjG4Jyl5WNNU6oQ8GxhXVBM2TmQtkfVK7TKDhnKEzs+I9NYTArHi7E+DXM2yasTXFKPZirnIScIobhtnQ7f+kPffoCqhC2Xig8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eer6wxSY; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eer6wxSY"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-484366874b0so970570f8f.2
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2026 10:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789839544; x=1790444344; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kb3NePwhd8h9g2zyqPYSNTvlvzKmxXhHsFrfj1sSN/c=;
        b=eer6wxSYmUpW4J+eYMG9skTYNtAZ3f/lBie8PKtRcjCssfGMUUNYzXrnkdbwQ7QTE9
         RAeb07R6p3tAQisOEHb9CRLu/U4maygk0w5wg2ZmBKnKQ5+sRbby1tn3nLpopbiGr83n
         r2VlxTQ3vkZTV/InTnwK31KrxlpNmsUBDj8VpwHnGtGAJkzpO76IK9HBNtXuj4oqKDRX
         6uIS4X+Lwql/iJjrKA4NLPmkZ7uV37W/AOsm8544qhOHtKZlHjfbeRXP4Ykv7jbBXurI
         X+kpPAHO4j7lXgGnOkMQX6JhwGmXAvN0jf8bOco7Mkp79u9Gkbrg/DfcnPZOgsqaAI40
         YD9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789839544; x=1790444344;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kb3NePwhd8h9g2zyqPYSNTvlvzKmxXhHsFrfj1sSN/c=;
        b=HBQWvvjw7JTw5EsqXwC3jJxgt13iWw6049m8KRR5JiRIPVwKMHR1LYREUf4hNnyrXa
         d+ZkZoIKdENq2H3AUX7Ud3T+14qcH6LTq6M9YlYrYlPgTnSXZYAgQMQn7b4G4k/LwBOR
         QriGOeevpHA+VY4CAMhvMkOVAnGQvnqWU5b9LKi9367vLDJf6vihUP5rU9Hy090D/hBk
         /k5rVR+RTXFx0wcfJUiPURXGF6+QU4kFgx5KBGsxafmIGBqllt7Q6HeiCwQXqCegNEJZ
         OeumJWHi+P+da33laoBjy1hzAYxHWiY62ct6UFxxu0KT1uIOHH78w6ZS2YS9L0amTBBJ
         n8TA==
X-Forwarded-Encrypted: i=1; AKwUvBxxCxjBy3JDOd29GMYgP2NIikEtLzL9QGmCcSViU1Xv84xYPFrtCJlecZhxjm/6+9fLqjPkVJIM/M9EA+HLlQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lj0Cu7dUhIejwjj2bbTzgLeZ9IfGB7tL+NKLmUZTtIpcsu66kE
	BASFrLKHpm6ycucy9whkibkWBxTVPdE+GaMgzAqQo/l5eAwdE331X7Vb
X-Gm-Gg: AYBFou1AknYuGdcIzjmWGC8276N5Sn0kVjAxMrCcEAumlQhwUNKJL0VfC4WISmnjYN7
	/qemreyEaqKAjwffKe8ebQ09dpzuwnPZg29fdSZHbKdmWthMWR8ohrR7SSTMubFm5JCXm27ajSH
	gMUNeILODTfr4ZssQ3vHCyYdiYH8xhIBab8OBNtJHz0lfmWZtRd7RaH4pkY9IksYQAEUgLbsDWP
	bpAIrAwwLExW0/DrQiIvJYOwbbNVMtzydlc9E60JrdIDXy5ng6Vk/x2E1svHnCkKVdHT/ZAgLU8
	OKlfBmEks8tgtT4Y5gkc2KEoYhdleb5hVoAIqZCOp2JZReGW2Z6yLuM6Yu5f8Q/i0OWR2PDs84Y
	4RYpYtcnGbkes50pJr2ipXZjISEWdpAvs9CxhTORGGfSLATpMLOYM49frf/uj7NBN7qcbe1AbjW
	yyZbHSa3DueiU4MTjeEmihe1/uVWQA4sZKPAy6FnGYP0BbhTMz1/HLDLU79W5Hsu4JXEvb+CHo9
	cgEow==
X-Received: by 2002:a5d:5d0e:0:b0:487:27f6:a4da with SMTP id ffacd0b85a97d-48727f6a725mr2724663f8f.42.1789839544149;
        Sat, 19 Sep 2026 10:39:04 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48724460753sm8886436f8f.10.2026.09.19.10.39.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 10:39:03 -0700 (PDT)
Message-ID: <2f2f2366-bf64-45d1-911d-6a769be9d7aa@gmail.com>
Date: Sat, 19 Sep 2026 20:39:01 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8821c: disable deep LPS on PCIe
 devices
To: Paolo Lazzaroni <eexto@aol.com>, Ping-Ke Shih <pkshih@realtek.com>,
 Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Oleksandr Havrylov <goainwo@gmail.com>,
 Gabriel Maia <gabrielvinicius.damaia@gmail.com>,
 Rahul Kumar Rai <learn.rahul.rai@gmail.com>,
 Mihail Dimoski <mihaildimoski@gmail.com>,
 =?UTF-8?B?QXRhIMSwbGhhbiBLw7ZrdMO8cms=?= <atailhan2006@gmail.com>
References: <20260918232801.119348-1-eexto.ref@aol.com>
 <20260918232801.119348-1-eexto@aol.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260918232801.119348-1-eexto@aol.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/09/2026 02:28, Paolo Lazzaroni wrote:
> On RTL8821CE PCIe adapters, entering 32kHz low-power clock deep sleep
> (LPS_DEEP_MODE_LCLK) causes recurrent PCIe completion timeouts,
> "firmware failed to leave lps state", "failed to send h2c command",
> and hard system freezes when transitioning out of low power states with
> PCIe ASPM enabled.
> 
> To work around this, a DMI quirk list (rtw_pci_quirks[]) was introduced
> and has grown across HP, ASUS, Dell, and Lenovo machines. However, DMI
> matching is unsustainable: minor sub-model variances (such as ASUS
> FA506II vs FA506IH) or unlisted models (such as ASUS VivoBook X515JA,
> Bmax Y14, or modern Alder Lake-N mini PCs) leave users experiencing bus
> lockups or firmware drops unless they manually turn off power saving via
> iw.
> 
> Examination of official OEM Windows driver INF files for RTL8821CE
> (HP and ASUS netrtwlane.inf) reveals that vendor drivers explicitly
> disable deep power saving (WoWLANPSMode = 0, bLPS_PG_En = 0) and enable

Disabling LPS_PG doesn't mean disabling LCLK, I think.

> firmware PCIe recovery, while keeping standard PCIe ASPM enabled.
> Furthermore, other chips in rtw88 (RTL8723DE, RTL8812AE, RTL8821AE)
> already set lps_deep_mode_supported = 0 by default.

What those other chips are doing is not relevant. RTL8812AE and
RTL8821AE are not officially supported in rtw88. (Not yet?)
lps_deep_mode_supported is zero in rtw8812a.c and rtw8821a.c because
rtw88_usb doesn't implement deep PS and I didn't research which
modes they could support if deep PS was implemented for USB.

> 
> Conservatively disable LPS_DEEP_MODE_LCLK specifically for RTL8821C on
> PCIe interfaces in rtw_update_lps_deep_mode(). Standard 802.11 LPS
> power saving and PCIe ASPM remain functional, preventing system lockups
> and firmware failures without affecting SDIO or USB variants.
> 
> Signed-off-by: Paolo Lazzaroni <eexto@aol.com>
> ---
>  drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
> index 0f23498b5..5bd854223 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.c
> +++ b/drivers/net/wireless/realtek/rtw88/main.c
> @@ -1360,6 +1360,14 @@ static enum rtw_lps_deep_mode rtw_update_lps_deep_mode(struct rtw_dev *rtwdev,
>  	    !fw->feature)
>  		return LPS_DEEP_MODE_NONE;
>  
> +	/* RTL8821CE PCIe devices fail to wake up from 32kHz LCLK deep sleep
> +	 * in time for PCIe completion deadlines, leading to PCIe bus freeze

Completion timeout is already disabled for this chip.

> +	 * and communication timeouts.
> +	 */
> +	if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE &&
> +	    chip->id == RTW_CHIP_TYPE_8821C)
> +		return LPS_DEEP_MODE_NONE;
> +
>  	if ((chip->lps_deep_mode_supported & BIT(LPS_DEEP_MODE_PG)) &&
>  	    rtw_fw_feature_check(fw, FW_FEATURE_PG))
>  		return LPS_DEEP_MODE_PG;

However, I'm not saying it's necessarily wrong to disable deep PS for
this chip completely. I'm just objecting to your LLM's conclusions.
