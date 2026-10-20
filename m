Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792519724;
	b=khScboROOOTEmTQG6k0EQjstr6F+6fCo2dmXilgvbopDOh6DhCcncv/uBH7sF4cQBzlo
	 9JMPw+t6YWnPbxk0lFK8luvA9Ng0/Y8psFK/K0iIkBUBn7AXuHWbcEO5dzY9I9zR8Zqba
	 isaChmNnv8wQn4x5RaaD/kNZVwjg2LTvkEpK434CpXspzp8i+pQpaOCtYqkssnwwO67Fw
	 7N2Pez7wHHX9GomTimG99Uhvu18Bfwoy3tOrTU67qBwSfuSD1dwLN2KBMmn74xgycv6+a
	 SnWDpLuvsQ0+f0bF9ziL24SGafSGBbbqbkk8UEG/RR87LJMeApF3QdimjG5+WGiuVKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792519724;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=B5U4wWA72SN+ZAvJ/BX/X5rev6jTQ5qgJahCbtUh4bk=;
	b=Ir9TPMMPV4XlZQ2IdWOhilqHiWvieyQRtQ644nkITzHUpP/vdWivM244g3bLEoLOjA/E
	 3c6gH1uhl2GlIdEgd9hH4qyH5vWtYI7S6gm4UrpQpK4KcmCOfxTEkEwue0fsQqdNw5SgY
	 RkhpQYBJqIKcilMuiam72AzZMGyJ4gA1P7N6b0WuVdBkfV24HqIwR1kGp4hCi4Tvjv3/8
	 htuPw4+oAR6ZbrsiZxa2Rrrn2+llAexfqmLdmvaW1ww7dzLNS+BAgwos0WRXzYNGDUM9Z
	 9hry87Nq2PVw6v6/+mjL7uiSX99nWDSPFu8stvJ0/A3kcTbnfqM8PDn/GqaNQ0stu7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iGV7omrd;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B557D606A31C
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 18:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B557D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iGV7omrd
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48b042c0759so2393265f8f.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 11:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792519722; x=1793124522; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B5U4wWA72SN+ZAvJ/BX/X5rev6jTQ5qgJahCbtUh4bk=;
        b=iGV7omrdKolkiMTpX8DjlPFEftKUtcJxwckDPp9KjbIUasAv2U3+Mat9uBpRF2jPwN
         U43Q3Cd6uWgY7Gx9Nh/TRGI/ADt4Gh0UPFpuX/GH7R/9c+jeZVdhYl4+sqYY3GG2NmJt
         EilmQK9Fpqc/gS9jwhw3cEF/Oi/xNZWwIqJPuG1xsRjxyFEJxeX8+UGYHC/BqLzSi3F/
         uvw+wm+vajk/TG0Ha8ZxE8lbHjPgcpt8b5PHbNwuN1tK3BtLvEL2G9IHTndym8Grg51Y
         eY1Jh1Gv+wXaypRq8FacWE3UF70vblJSJdxgvE4IsmhrKIe+35u/JpHhDVcAxIh4249z
         RA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792519722; x=1793124522;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B5U4wWA72SN+ZAvJ/BX/X5rev6jTQ5qgJahCbtUh4bk=;
        b=J6XbwkDRw7Bncx6iVwSRnvNXlaJSIGzoDObc3AZQLjZUuAmRwQyKWhnYS/TSHWK4t3
         oMTjDG34rF2IIprXQHMk3qxTuzExnWeOniqHCQVEg47IQ5xvsYXiJSqDk6ospwKN0sXr
         iZa+pQSK4Wz5/JRvOpI+HHbbly7Qwq1rqIi2iYJoaYoBIF0RBSaW+JEqbT75ur6u+6ww
         SCyXTRtVA3Jn6zgcROhIOnbv+aC+kmvz8xgaXf3EbRx0sIJJHMj+0VQXoI5vL9qz2LLs
         LmlLIkJzWmMtYon1HcrWrFt4qWPDNcOkd/yrf8pwR/RFZEpFIeeU6uPcUqGzpoYoN1KV
         TmBQ==
X-Gm-Message-State: AFq9FYIt0SYK60wO3RNWhfZoXYiMCe2qjEd++qcRy+WcYjGRmQ9E9Xh4
	MJGJqSoCQnuYyEdzaUjiF6FCWCRoc5xYGiteG6XaF3aK+29RI5F6HoDK
X-Gm-Gg: AYBFou2dI4DwZKp8/e/KnEvac4s0TQQMkV0bNbytCK1RwT1ntqPMDLakddU4hXVW+JD
	cPbGf6VNKQcobDQRlY27cqsBeJVIXKQsVkeXeCm1qhgSo53KnMLk6E3m6ud+cD49THzNsmU0a4u
	m19bSxS4Yid9w7+jFB/Wt57h/ESXDYuZh4Y0akW1qNf0NQmagnSy0cnxf17HNE84ZcUxL+T9jYr
	AUbZ97toHZu3GPkhXxWj3EeGXiDjzt7MfgM2z4nwDINn6/30eugcZNi16sdoqxGcXv854kYuXSx
	1DWo/pjbPFJbLVvBjv8WC7v6opBRTKBKnMt41q8zJqV0RpAr9jjmOn2/KAhUzBnYa4xpmvY0VqB
	qnZyTLtZGECsWjktHwDEH+fHzlDUl2sX5PKQPRMGSRKp+5PiFmhl7iPFeRpqc46jefJd1aqZbR2
	t0Aw+3tE4igQW87gWBFMJdXRJO53UvrgylQBNbSTVyFzumoiwmIh8Vj1QKNEkS0+7xnos6SY1Ns
	h+byg==
X-Received: by 2002:a5d:53c6:0:b0:48e:412:3827 with SMTP id ffacd0b85a97d-48e07fb2b0dmr18069299f8f.9.1792519721971;
        Tue, 20 Oct 2026 11:08:41 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25835f46sm30848f8f.38.2026.10.20.11.08.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 11:08:41 -0700 (PDT)
Message-ID: <c14d646f-b8b1-47ce-a92e-cbd5f534503f@gmail.com>
Date: Tue, 20 Oct 2026 21:08:39 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B chip
 driver
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20261006130701.120460-6-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/10/2026 16:06, Luka Gejak wrote:
> Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
> power sequences, the efuse layout, the RF and IQ calibration, and the
> chip specific coexistence handling.
> 
> The RTL8723B chip support is based on the initial work by
> Michael Straube <straube.linux@gmail.com>.
> Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
> 
> Co-developed-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Michael Straube <straube.linux@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtw88/rtw8723b.c | 2534 +++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/rtw8723b.h |   14 +
>  2 files changed, 2548 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723b.c b/drivers/net/wireless/realtek/rtw88/rtw8723b.c
> new file mode 100644
> index 000000000000..8bb9c03d769c
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8723b.c

[...]

> +static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
> +{
> +	struct rtw_efuse *efuse = &rtwdev->efuse;
> +	int ret;
> +
> +	ret = rtw8723x_read_efuse(rtwdev, log_map);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Report a power track type this driver does not implement once,
> +	 * here, rather than on every two second pwr_track() tick.
> +	 */
> +	if (efuse->power_track_type != 0)
> +		rtw_warn(rtwdev, "unsupported power track type\n");
> +
> +	/*
> +	 * No firmware hardware feature report exists, so fill the hardware
> +	 * capability here; a zero stream count kills the HT MCS set.
> +	 */
> +	efuse->hw_cap.nss = max_t(u8, rtwdev->hal.rf_path_num, 1);

Another thing I noticed too late: this chip always supports only one
spatial stream. rf_path_num happens to be 1, so no harm done.

> +	efuse->hw_cap.ant_num = efuse->hw_cap.nss;
> +	efuse->hw_cap.bw = BIT(RTW_CHANNEL_WIDTH_20) |
> +			   BIT(RTW_CHANNEL_WIDTH_40);
> +
> +	return 0;
> +}
