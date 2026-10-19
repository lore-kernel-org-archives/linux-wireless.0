Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792442242;
	b=UsKBE/dPwQ8pZ7Vwsbh+G7NruyyFWC2BZZvkc7uoZ0FYD+aV/YFfuWBhm3ud84i4K4x/
	 b/u3nKZBnQ4db6uDuPMNk5mpa+jJM/yYfxTT03hHvUMlHfWEGAFDKIrWT0dMVU6V3GZl7
	 ViDJpa96LPrgf8IJEN70vkjqPprkAl0ch0HmjRIxUSoV8KgEtEw3LAHuqHy0DoU6TpqM2
	 CTPbzugKi3yDZuPfQ6IC0zqy0uGtebmwS/pP4q/9+KugtoilcIRDbr382glbEVL4MZa46
	 SbRmhjmQz/kDHsOkAxm7+9as3D4LZarDoXiUc+g8noF5faqIGR+psrkU5in+XQrL0LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792442242;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=B++vJOb6X11H2mvy1jKn0S5ZiLB/eF7VD5NKB8JrwlA=;
	b=ExooRou3vbsfw/6YfFmmnt2/8YO1oeFMrTv7Ogwp7VBc+ngUnwn7UlJu+BT2uMZtZccc
	 a+BQ7sbEaRRyvNWxYtGCUtVoqFoc6frlI/ESpA8W2XvX6v/Dmb1A18vxuZVF+x2CLuuqa
	 Nu3mVvYC7qIYxxfMmE8Fwxtxpkbo7oOPyI7GE4jkKjRQLoqW0L9rZFsRa9i+tsEXJNwiI
	 lZcVwofW0DI0aapCZZUXkzmSfdwhuEIp0jBbrHz2BCfnyLMEiNLpuGmMzIHBkejz7V/n2
	 N2cZEYgoYj3TeqRG5eEB6z2YKC6aFe9biSNC0GL8RifAAZOsg6WWkDVTg5UDsvbrrsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=e+oyuIcr;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A75A606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 20:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A75A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=e+oyuIcr
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a1e3098ee2so19407785e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 13:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792442240; x=1793047040; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B++vJOb6X11H2mvy1jKn0S5ZiLB/eF7VD5NKB8JrwlA=;
        b=e+oyuIcrr8WY24DZQSlBHufn0ge3X73FBOxu0RbSCdDbuVDHc2kCpEnISxOhdOTpS2
         2gPdrX6rwP7T+xdiYt8nLuAINg4s0oKSvAjh+PoD6h2NoC+fIRr+votO0dY6Wmb13Tve
         hrSPbkIf9/hfqXCHgPIpDLvs/IthwRl6ivoykaEzyMS190mZBYzBDHGp7mjD5kpfBGSO
         opBmJzA7AcslSH4cHSU8eGmZhkVAvKUl7JiifMn7r6Wc6/PSbCXZOKnGrXZq70zMFxzC
         8FU3mvUDYm5i/hQ/tsZm3C7mrG/JP159iFPh+gBs4/rqD5a0L64q8xc09mVy1E/AFrEQ
         ZK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792442240; x=1793047040;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B++vJOb6X11H2mvy1jKn0S5ZiLB/eF7VD5NKB8JrwlA=;
        b=W0u96PaYeD5ST/NoiZIBQovEe+XKEiYda8VXZ2lQjtyQAeS3xHwtdnfm426nHfTq98
         3w0GI3sqEj2pZuQxWHlKvSeRjKrMH81vxnP1OCUqdP3vpfRijnaY/3aSocZNPiOXl8Fp
         aQfWLRKqa6X0prQDhIXBuZTOcmYy3XprLPVHtQo/K/gS3dqSin6H6zd/oQesd3wrcJzc
         Tve6RIDyM7KVym2C1DCLLfY5f+WzizNpnC0kE+a/72FdCDnE0xvXaLTJTgY5pd3O1mMP
         8hRXirQh10h6BtOlNF5SpZPEYNXQT1HbLWM720ae0dXZmLPjK/vbirwOb7iMcszGjZEZ
         qrhQ==
X-Forwarded-Encrypted: i=1; AKwUvBzty0VSOWVXTfFvHQJOEFxk8M8BFom8THTq5/NLqcQgFb8fFVxr1O3uwk5NacsKSx/9ADUKgvQd1E9AE/jG8w==@vger.kernel.org
X-Gm-Message-State: AFq9FYJyE0h5z5iVWQIwFzbmZa+DOV68835WtDsOStkgSt4M0qjKTh03
	7UH8MvlIGo4rTyMyL1NKA/cWkJetnoJdwAY9Gt2tAP7uAOIbuGWY5UHc
X-Gm-Gg: AYBFou1NospqKkb9qM/j03FZukVliBmjM4WTD/b/FmLBdamm9JmYdIi/Sp5Qq+G2UfS
	niWkeoqBnvS3Wvo1XdQUk1BMEkfm1QQ5094x5Jdju3kOOZ4X8ZgdkojMBs5J3aSKCwwCnOoaQHR
	piCw2iG+cP38ZiyHjDn9hfJ9dWZFh9HQkcERWsmiLpyIdSgKWXULOI6FHTeUjGc2tpYYWgVJOLh
	Whf9cObAZ3WT0Ad2Fs8/SOG+yRI96xm4VKzBP70GAmW/tiyZjwdqTrvCzlSWspWQL+hqM2tbv9f
	a+K5/Wp1qBO6h6N8dyRJ3EgTrF7TFrlJVqng35uH4RDRiKnSSAR2zIgmHRAX4DYqLuAkI0JPnsK
	T/SKgYHYz4ruvO5gZpbVGELR7TrEo1fu+/hKdtKp4oGJ4aHM0Zzij6IqOXq+KUPueKEu+9Tcqaz
	M+DVaHGUWNG5/YwbxziCz0MqF1JLEMUppV7PwHZ3rglfypjF8zriy/hBz5okIoI+WNC6cJ3V/fI
	a6+VGMjgYnejMSq
X-Received: by 2002:a05:600c:190e:b0:4a1:90d7:88a8 with SMTP id 5b1f17b1804b1-4a1d76106c0mr194438665e9.25.1792442240382;
        Mon, 19 Oct 2026 13:37:20 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e1d82dfd5sm1095113f8f.47.2026.10.19.13.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 13:37:19 -0700 (PDT)
Message-ID: <f82ea5e6-d9ef-4978-9658-7e8ce760c7ae@gmail.com>
Date: Mon, 19 Oct 2026 23:37:18 +0300
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
Subject: Re: [PATCH rtw-next] wifi: rtw88: 8723b: Read the package type from
 efuse
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Luka Gejak <luka.gejak@linux.dev>
References: <d22c9202-d019-4ca1-8534-c23244d612d4@gmail.com>
 <425c1552139b4f09a5db42459fa74a08@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <425c1552139b4f09a5db42459fa74a08@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/10/2026 05:39, Ping-Ke Shih wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
> 
> [...]
> 
>> +static void rtw8723b_read_package_type(struct rtw_dev *rtwdev)
>> +{
>> +       struct rtw_hal *hal = &rtwdev->hal;
>> +       u8 val_1fb;
>> +
>> +       rtw8723b_efuse_grant(rtwdev, true);
>> +       rtw_read8_physical_efuse(rtwdev, 0x1fb, &val_1fb);
>> +       rtw8723b_efuse_grant(rtwdev, false);
> 
> In rtw_parse_efuse_map(), we can pass 'phy_map' to read_efuse()?
> -chip->ops->read_efuse(rtwdev, log_map);
> +chip->ops->read_efuse(rtwdev, log_map, phy_map);
> 
> As .phy_efuse_size = 512 for RTL7823B, I think it will work. 
> 

Yes, that should work.

>> +
>> +       switch (u8_get_bits(val_1fb, GENMASK(2, 0))) {
> 
> Bit 2~0 seems like PKG_TYPE. Define an enum?
> 
>> +       case 0x4:
>> +               hal->pkg_type = RTW8723B_PACKAGE_TFBGA79;
>> +               break;
>> +       case 0x5:
>> +               hal->pkg_type = RTW8723B_PACKAGE_TFBGA90;
>> +               break;
>> +       case 0x6:
>> +               hal->pkg_type = RTW8723B_PACKAGE_QFN68;
>> +               break;
>> +       case 0x7:
>> +               hal->pkg_type = RTW8723B_PACKAGE_TFBGA80;
>> +               break;
>> +       default:
>> +               hal->pkg_type = RTW8723B_PACKAGE_DEFAULT;
>> +               break;
>> +       }
>> +
>> +       if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_SDIO &&
>> +           u8_get_bits(val_1fb, GENMASK(5, 4)) == 0x2)
> 
> Can you define enums for bit 5-4 and value 0x2?
> I'm not sure if vendor driver has some comments pointing out this or not.
> 

I guess bits 5-4 identify the chip variant:

	/* RTL8703AS: 0x1FB[5:4] 2b'10 */
	/* RTL8723BS: 0x1FB[5:4] 2b'11 */
	if ((efuseContent & 0x30) == 0x20) {
		pAdapter->registrypriv.bw_mode &= 0xF0;
		RTW_INFO("This is the case of 8703AS\n");
	}

RTL8703AS appears to be a (cheaper?) version of RTL8723BS. Ten years ago
Hans de Goede was saying:

	The rtl8703as in reality is a rtl8723bs in a different package.
	(it has the same sdio-id).

	In android the rtl8703as uses the rtl8723bs-vq0 driver instead of the
	regular rtl8732bs driver. Looking at a diff between the 2 the only
	difference is that the vq0 driver forces the antenna-path to
	ODM_RF_PATH_B.

	It seems that we can identify the rtl8703as by its package, as it comes
	in a QNF68 package, where as the rtl8723bs comes in a TFBGA79 package,
	so we can simply support both in the same driver.

https://github.com/hadess/rtl8723bs/pull/93/changes/ebec0ae8ccedc05a945478926d52c99277f500ee

>> +               rtwdev->efuse.hw_cap.bw &= ~BIT(RTW_CHANNEL_WIDTH_40);
>> +}
>> +
>>  static int rtw8723b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
>>  {
>>         struct rtw_efuse *efuse = &rtwdev->efuse;
> 

