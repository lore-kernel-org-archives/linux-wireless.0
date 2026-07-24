Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F9A353A60
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 23:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784937168; cv=none; b=GqlM/6jZk5PgJg8nULoCRBko8FT8nWpuphjirK1pfGinaWbvVQBNjcin0K6v264OkhQmreBI4oSXK1tyS8ztUyN3aaAGZKfCklAP8CFNlArqV6BmOvD7kapiVUOvDAo2H9OziRvRav6CtdiKJqKrGncCD2siSIk9VwQnoafJbVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784937168; c=relaxed/simple;
	bh=6jgi5uf8lN09V6KOs0hDsV2OU3CHDba7Xeqy944ou0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e+JK9/eA9fP2j9RhtSqSZLk7GY7OlEMPCKfCC/Dpg6C06onrZZsHXC3VwOvt1g4//M3gmlQwfT0xIOe2MF7jAivdKlxVguAULYs0ItrbsgkzcJESZMzk3EFdOAzJiVJb9UwXl9Rk2qEpNwXbboNn8cViUaHllowHdPDszeXogps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G5ok+djX; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5ok+djX"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-472326ca506so698484f8f.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 16:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784937165; x=1785541965; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OayzebvdJM9fG6lnwaS3h5fCYnIaMiJiswcoAgkXblM=;
        b=G5ok+djX7UUafmjhSx65cj5pnHgkhYwj8B0Jhkq0WzR2wcxxiBHps543//JR/+hIiN
         2nU7jK6woUTJd6eN/Ld2KB6RaOafCe75z1BtdCihmw77fQ0eH8LCqYmD4RkIrwww6EEe
         QFwqMssYmL5V0wBgATURFB7vZOJbVEV9G7RsYFylKW+p5e+Dd82M9n/v6owfYmWEGmuh
         ELYh2dotGec497AhbLHqBcwVQ0VSy9NGeFY5hbSrdRPAj2QVsHeOhBYE5EEg99YH20jI
         HK7NmfjmCLL7D72S1lr1nPbtU2VRg4bCQbLcVId59BV7xMUZNTD+ZdG/sN+bDyCSKHIQ
         kE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784937165; x=1785541965;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OayzebvdJM9fG6lnwaS3h5fCYnIaMiJiswcoAgkXblM=;
        b=aT8H+dFquJBKXQBqYqzsYkIgEeKOYqzgWBCXpB2o6S+d5QCKDHbE/GZec0/ZHFDsns
         rqraa9rtFIO4+aNLto81UKHWWuV/R44r5Lp4HI560hnfzu9Q2KeMZskY7ETynWltld31
         QwA3vJCvsdKAPke7QkXP9yzFl5g4Oat1BZgu4aXANsTio4r8AHZ8v2bLi4ALvfKXMiMX
         9My3AKrOSOdmVlMfEMa7GCWusNIDYpMzUIZ1M9q3l1WmpF0aC+b6vKem7L89VFi6Qa0D
         dOCUKTQ2OJyFiIPZEXSC4kacpw43asgntrm81IN/Kt+cXwMLGsodS7eotL7k57yR/IKJ
         jENA==
X-Gm-Message-State: AOJu0YwN6aFdLiwDS/PABTPBXH7nDdlYwQ6ICgiMNYxj+fmBpHrL52Pu
	Zks1q+UFmlhn9obLJYRXTZnw2n8l+mp9O2RXUp/9DsSf3Pqli5mYmSkh
X-Gm-Gg: AR+sD10DZhpC2s5mBrmYONh0b68Ia83d7zb2mPc7sX/Cfu/LOcoen9vu8Uhzuar+OCF
	4PD8tolt1m+BWd8yhEQxHqC+zYYJb65ZbzGL8NJLfzFhonf1CbyLp3wouiyt7ij8cvVIgaJVmqQ
	2w5Bcgfpzvj/kaGTHgB7DBhnKHdqG7gfHDlnveFKyrgEJpUCydJ7DDr43W8g9xpKMey1KYHcUwF
	7etO6D3kdJwSXErRvq2Kp8vNI43V4hS+ld8meeCaoP+GjlyGh9uYvwtCRPiMDuK9889mi7Op8zc
	zK4AfLQ6c+mI0We/9XmsmWK2oK9L8+wYSuzAnYq/UxvvYahgkmJVIKu068TPXNwM9tK8RVl51Y2
	LwcPUomE2SBexfNeUesjRWxUzw0mUyGrUB7ZwSN3U4xvmRRss79XcBL/omzxlS0r3JOteStxakD
	rvqFnumSCwmRAPB3otjiw=
X-Received: by 2002:a05:6000:2403:b0:47f:81fe:12fb with SMTP id ffacd0b85a97d-47f9fea0180mr247027f8f.47.1784937165566;
        Fri, 24 Jul 2026 16:52:45 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bd77a9sm26365337f8f.14.2026.07.24.16.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 16:52:44 -0700 (PDT)
Message-ID: <0e1c1d85-6042-4464-9cd0-c93d0a4a2f1c@gmail.com>
Date: Sat, 25 Jul 2026 02:52:42 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/19] wifi: rtw88: fw: send the media status report in
 the vendor layout
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724181858.192903-7-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724181858.192903-7-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:18, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> As with the rate adaptation commands, the RTL8723BS firmware expects the
> vendor v5.2.17 byte layout for the media status report. The bit packed
> rtw88 form leaves the firmware without a valid connect indication, so
> emit the layout it parses for this chip.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index 495d26eafdd4..87da0dd82aaa 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -839,8 +839,19 @@ void rtw_fw_media_status_report(struct rtw_dev *rtwdev, u8 mac_id, bool connect)
>  	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
>  
>  	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_MEDIA_STATUS_RPT);
> -	MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, connect);
> -	MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, mac_id);
> +
> +	if (rtw_is_8723bs(rtwdev)) {
> +		/* Vendor v5.2.17 MEDIA_STATUS_RPT: connect = 21 00 00,
> +		 * disconnect = 00 00 00. Byte1[0]=OPMODE, [5]=ROLE(STA=0),
> +		 * [1]=MACID_IND; byte2=MACID; byte3=MACID_END.
> +		 */
> +		h2c_pkt[1] = connect ? 0x21 : 0x00;
> +		h2c_pkt[2] = mac_id & 0x7f;
> +		h2c_pkt[3] = 0x00;
> +	} else {
> +		MEDIA_STATUS_RPT_SET_OP_MODE(h2c_pkt, connect);
> +		MEDIA_STATUS_RPT_SET_MACID(h2c_pkt, mac_id);
> +	}

rtw88 doesn't fill the role field, but otherwise the layout is the same.

Not sure how important the role is. The other chips work without it.

>  
>  	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
>  }

