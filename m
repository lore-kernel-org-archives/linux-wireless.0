Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D804044C510
	for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 23:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784936813; cv=none; b=hz1A9D3//UL+POrMI3v5bwopVQRmMjVlkeD/m+C+4lcXIr+x0DMuuA8Dn9PW23CzZBogGNchNLZONZKU0OXSLMTHPMtXmkTqtRtWtMkYmj//KoDGMXvpftzYx8KIPBTr3p7Sgjgxt72P/0C+szNYXUkSIrzI++aGvPC9mDy7QLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784936813; c=relaxed/simple;
	bh=hQu5fEBr4yw72/6D6mfMdci5WndR6X7MVs615g/yBkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDsvAZqDI8JkVSqlUKbWE7XsPiiM/DsW9QexLPqfsrB16t03G3nh+NrNrwjQ4WLvrf7J2KNCygB8IpRG8FPDjF0uP6K1qLWVdmMvUasH9gB0rDaK8h+YMy64X3TFDaZJVkyRpDCSPEWkT+l80whVZ1HKF/G5vKbZR1RW74ieCuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ab2j+4QE; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ab2j+4QE"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493f6de72faso8039425e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2026 16:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784936810; x=1785541610; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cuF0t9zk47O0WYm4aoKt8keTjuOXwD8BwrbuPEAsyHU=;
        b=ab2j+4QEWwSjqe3TZLDxKzr5ZwNC2gT4yIF4RZa7B7U95eGd8QvJXDT7+HfY5ZWhbT
         rBmP30c21/Acn5NUyLNR+G/WOPJB5jNghE5JlQejyFkJ8KyhUtm8bpp6AuDCR2J2M1dV
         hinOzuQOB6oNxb3WMkJ/VWCQt5U176g0pJMzwnQuu9mLsSaBo2PTVfcE4Do/I3jIoe/F
         zX/8HsNxFgjzac4lmpOmKkdAeyTRIlzpk0jJEWmnLBD1bWbMi4LV2Sn2dFwzi8ab/Ohq
         udYrzwZFvfZRiOXA749jCsyqfEVyESFUtkM0qk8HI1f6WlLlgpp40oMgTeAxH6Um5q22
         fw1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784936810; x=1785541610;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cuF0t9zk47O0WYm4aoKt8keTjuOXwD8BwrbuPEAsyHU=;
        b=Oz6aoq6rUKD/exM7zpYCGBS6+Zi21WIDYTE7Y6QYgHWmgKGoGucMqhnO1uzN6UR4N1
         aKRtBAt9IoDrrZFYJEJdKe5i3v5vYvsHjsEGsYN8Y+XSW9LbIbew+6K2L4dHnEdsQAHB
         msN1YrmNG97/q9lu1YCbzyDLkG6rpk4LAtFvmPkiBscz/9yzn+Qfz1dWnxtECKbngGRk
         HN64uq1ZkvcNenTIaeu34WcEVt19n3yzKzGKaJkDCX4LtMGUlFNKomxP6vyA37QmyI6N
         uoLI81kG1p4oY1gGSwdk6CYQD+JSzoaSnUbVrx2hNUHFD2hjuCCTWjxxV35+VPTSUNlk
         YLgg==
X-Gm-Message-State: AOJu0YwuaouYwGNPgvZ7SSyjscC+LHcLogFSrgvcXrtHAr1cILB8gqJv
	eHhhdTeXM4BIIjn3IOlJJvXlWkRjcx6ZKWlzxQtidGnJWDiUvw7wtXu1
X-Gm-Gg: AR+sD13ALJr5RznSEhwbtAV8uOBd9iVCKGzjCYE49X4X++LfQLJQkDlqNk+UVo0XgvZ
	qqFkvNxYkpaUu1QuOUo7yghldxpn64M+bDDvLmUn8hc5KmD6nqebSsNacv1XcWE7LPdFvdf1Gkb
	J2Dz4VYejIf9ICKmhRCHyjT7rCLG1emM140bzdbLqU7hflhWRmNVv6U/ueEIcnQl5ZPGOCY3q4i
	Ad2lMCtqEiOwB9bxslqK8m1+vSe3jOL2BQGNPQtFH867EfeCK5mH5/UDOOtUcykhD8e6FzNXP9X
	EomzUSTRsCZxyzQnRKy4bgZjQLZNSXjBT1T3j8nq9+f8sT/UzVWzhRHlFhzLqm0rfvy2vLFArBo
	uIugzeaaGRrhckOB/w7b+MZtzI0dO0OKEkC9askN7a7L1JICWlXgzVUDtQur/A4y27e5fmkB4vq
	bDceso8tGq
X-Received: by 2002:a05:600c:1549:b0:493:ecf5:89fd with SMTP id 5b1f17b1804b1-496b5c86291mr2721905e9.17.1784936809938;
        Fri, 24 Jul 2026 16:46:49 -0700 (PDT)
Received: from [192.168.1.50] ([79.118.68.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4ee0e91sm20325105e9.4.2026.07.24.16.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 16:46:48 -0700 (PDT)
Message-ID: <aa006f43-bb28-4067-8538-a63529ab546b@gmail.com>
Date: Sat, 25 Jul 2026 02:46:46 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/19] wifi: rtw88: fw: send rate adaptation and RSSI info
 in the vendor layout
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260724181858.192903-1-luka.gejak@linux.dev>
 <20260724181858.192903-6-luka.gejak@linux.dev>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260724181858.192903-6-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/07/2026 21:18, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> The v41 firmware shipped with the RTL8723BS parses the vendor v5.2.17
> MACID_CFG and RA_INFO byte layouts rather than the bit packed rtw88
> ones, so the existing commands are misinterpreted and rate adaptation
> never settles.
> 
> Emit the byte layout the firmware expects for this chip. The no_update
> bit needs care: setting it tells the firmware to keep the rate mask it
> already has, so a changed mask sent with no_update set is silently
> dropped. Track the last mask sent and clear no_update whenever it
> actually changes, while leaving it set for identical refreshes so the
> firmware keeps the rate it has learned.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/fw.c   | 47 +++++++++++++++++++++--
>  drivers/net/wireless/realtek/rtw88/main.h |  2 +
>  2 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> index a81ff15218e1..495d26eafdd4 100644
> --- a/drivers/net/wireless/realtek/rtw88/fw.c
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -744,9 +744,19 @@ void rtw_fw_send_rssi_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
>  
>  	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RSSI_MONITOR);
>  
> -	SET_RSSI_INFO_MACID(h2c_pkt, si->mac_id);
> -	SET_RSSI_INFO_RSSI(h2c_pkt, rssi);
> -	SET_RSSI_INFO_STBC(h2c_pkt, stbc_en);
> +	if (rtw_is_8723bs(rtwdev)) {
> +		/* Vendor v5.2.17 RA_INFO byte layout (H2C 0x42):
> +		 * [1] mac_id, [2] 0x00, [3] rssi, [4] stbc?0x04:0x00.
> +		 */
> +		h2c_pkt[1] = si->mac_id & 0x7f;
> +		h2c_pkt[2] = 0x00;
> +		h2c_pkt[3] = rssi;
> +		h2c_pkt[4] = stbc_en ? 0x04 : 0x00;

Not sure where you found the value 0x04. I see in hal/phydm/phydm_rssi_monitor.c
that it's setting bit 1, same as rtw88. The other bytes you set here
are equivalent to the macros in the else branch.

> +	} else {
> +		SET_RSSI_INFO_MACID(h2c_pkt, si->mac_id);
> +		SET_RSSI_INFO_RSSI(h2c_pkt, rssi);
> +		SET_RSSI_INFO_STBC(h2c_pkt, stbc_en);
> +	}
>  
>  	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
>  }
> @@ -760,6 +770,37 @@ void rtw_fw_send_ra_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si,
>  
>  	SET_H2C_CMD_ID_CLASS(h2c_pkt, H2C_CMD_RA_INFO);
>  
> +	if (rtw_is_8723bs(rtwdev)) {
> +		/* The v41 firmware parses the vendor v5.2.17 MACID_CFG (0x40)
> +		 * byte layout, not the bit-packed rtw88 RA_INFO below:
> +		 * [1] mac_id, [2] rate_id | sgi_en(bit7),
> +		 * [3] bw(bits 1-0) | no_update(bit3), [4..7] 4-byte mask.
> +		 *
> +		 * no_update(bit3)=1 tells the firmware to keep its existing
> +		 * rate mask, so a mask that changes under no_update is dropped.
> +		 * Force no_update=0 whenever the mask actually changes so the
> +		 * update is applied, and keep no_update=1 for identical
> +		 * refreshes so the firmware retains the rate it has learned.
> +		 */
> +		bool apply = reset_ra_mask || si->ra_mask != si->ra_mask_last;

This doesn't look like the vendor driver's behaviour. To me it
looks like rtw88 is already handling the no_update bit correctly.

> +
> +		h2c_pkt[1] = si->mac_id & 0x7f;
> +		h2c_pkt[2] = (si->rate_id & 0x1f) |
> +			     (si->sgi_enable ? BIT(7) : 0);
> +		h2c_pkt[3] = ((si->bw_mode ? 3 : 1) & 0x3) |
> +			     (apply ? 0 : BIT(3));
> +		h2c_pkt[4] = si->ra_mask & 0xff;
> +		h2c_pkt[5] = (si->ra_mask >> 8) & 0xff;
> +		h2c_pkt[6] = (si->ra_mask >> 16) & 0xff;
> +		h2c_pkt[7] = (si->ra_mask >> 24) & 0xff;
> +
> +		si->ra_mask_last = si->ra_mask;
> +		si->init_ra_lv = 0;
> +
> +		rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
> +		return;
> +	}
> +

I bet you don't need to modify rtw_fw_send_ra_info() at all.

>  	SET_RA_INFO_MACID(h2c_pkt, si->mac_id);
>  	SET_RA_INFO_RATE_ID(h2c_pkt, si->rate_id);
>  	SET_RA_INFO_INIT_RA_LVL(h2c_pkt, si->init_ra_lv);
> diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
> index 8f86f7c12de5..9c435c160b61 100644
> --- a/drivers/net/wireless/realtek/rtw88/main.h
> +++ b/drivers/net/wireless/realtek/rtw88/main.h
> @@ -782,6 +782,8 @@ struct rtw_sta_info {
>  	bool vht_enable;
>  	u8 init_ra_lv;
>  	u64 ra_mask;
> +	/* Last rate mask sent to the firmware, to gate no_update. */
> +	u64 ra_mask_last;
>  
>  	DECLARE_BITMAP(tid_ba, IEEE80211_NUM_TIDS);
>  

