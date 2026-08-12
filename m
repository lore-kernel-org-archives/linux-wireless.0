Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F53A479870
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 17:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786554097; cv=none; b=JfE8jHMJb0GynM2uN+BpKljvStEKjeOihOR9P2HCzOBJJ4LS9uqklZzGyFSdsAIQ7GZFBLS7BlmHs0DhAGcjNgyKzrBr1aCa/cI5Qaoe2DYpzBuYk/+a+sk+WXY3wYa+zIqNxXEdPSjp+O+BoN9AM3yNCKVXYEy1+8Igc9Vr25c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786554097; c=relaxed/simple;
	bh=aJ/jvxc2ctK1lt0tQ2TChzeQzsHVHHrp1bEqTXhSOng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X4m6uSXNTVEozCUtdcnvgFva83PIKs+c0bZlcBn36RB6hSBLa7Rq3oJME+qF5hxQXU6+6fnNFY5/n8q/5++rxv1gmytC5o/fmn6EL2ZShpG0nSpmPZmnLQgqvC0+FYQGAw2mCFgwxyPmHpoxIwrduVoey6EquMsRQkTI46PiU1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nfPhX/7x; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nfPhX/7x"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4954dff6536so9240865e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 10:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786554093; x=1787158893; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uI6vrcYKkcjWBM0Dd7YQxXSItax+cXf1Uwe865HlonI=;
        b=nfPhX/7x3D5nZtZFTwC+6pY9HdjDjPk8AoiqDcq4HxIMAYjhQNG9eORmhntEzlzNhW
         c9KM2szWp0LuFZiMwMweGTzTaecDWLNyXHzRzVJpFuyqnwpT2sBF1mSQ2zkFw4ttk1Io
         nkp/LW+/YeM/47anM33K4AUuKT0mj8cdUqmOpBbG9NOjdeQUTte0PVBs6jRcGckonK68
         gdMUEtXWOoZbwWI6wawVMKuklh3ARnIGPCpXR6Xrs8aPO82X3uxN4waFKDdfmGYwaYM7
         f16GMIYEF8Qgg8iF5cw5WenpM05es9oku7W0R90DEapAqMMyR1WBrtiUf/LlIwEcPcUK
         HXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786554093; x=1787158893;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uI6vrcYKkcjWBM0Dd7YQxXSItax+cXf1Uwe865HlonI=;
        b=f17cd6Np01qAvgCycClVVFza72fLZheG5nyIAkSgUHeJimpRIqR+xnRaeIrsViGkK+
         IF4gv3gvg+BMT0SmQ9h706THQamyLZ/vlu7Igys2HWYW+zgRKHIRGy0KFXlTH6xSTRLb
         UeTrJ0VSz9qmeyBk0nCl6q8hnhtX1tcmmehIYnVRtgIzI4Z0YQREztTniLY0EhaXl2TL
         otNjrUh69XMGT/b0HzxTmG+DkhOOFPCAcZAoX3ikmJoMtMLgtmtyjBtBvXoanfoFhKK7
         az8deDGJ3eT3GnsuH40rXEsKZvAEw6U5n0hKplx2zLUVQRGHeVC+YfJnaizoziARYwSr
         LcJA==
X-Forwarded-Encrypted: i=1; AHgh+Rpje7SWkOcdRn1r1pE9DEQcegvPY2p4JfWjsFhEW1a3CSfVxi01ReSYHz0WQBg6dfrN+UFEWkDjJ59mEaoy/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuwedjeiOpizhnbMeZUuyXxxl1sRF7xDtpjNnl+vxEBQyuv+Wj
	4B6dGqCB2+8a3/GBblkeisU4qkHIhkoP4pCrNuJGsrDXVPagUY7iUXX4
X-Gm-Gg: AR+sD13b0SKajKsABGwRKDQVYt8qOF5VcqVTT2KVJZYreKbOeMzB6M6VF/ywviv/cP0
	1w4YgO3rAcC2+xu9abHZjVhcMq+illXDZh/l52ARJnsc8ptYFpQDIkGzLG3BFa6C7sZgRU99R1X
	alr0BTdoeB/T3wGd0ytVv02pRVFHr+QQMWvPScFQ4L3WA+/tvDq1gcp8LRl2LBzl5ZCFAS+svmo
	tRPncRMYznc6PF/Nb8U9GfbDnkbQ5KI/pbPm3IdEPbchMiNmDyq3P2BioQColaJbioq8gXN0j6W
	gOinvL6ovPxBc9sAYJtVdihnDfR9ScGtxPXw0aucy1JusFy+8cL45zh3nHV6TMUaWjtkunctgPA
	djz5Dq2T46RbvTN1wnDBr1pc+1Yr1/LEp15SCTTD7GKWTZuMg0QhXao+5JbvXKyGjBcBD8or+DN
	VU5VTnYkgAsHUDSExsxQco7HULQG+8YQpPUq+ElKhj4aNxrlIDzi7Zog+ieov72Oi0/uEImg==
X-Received: by 2002:a05:600c:b85:b0:495:48d7:f178 with SMTP id 5b1f17b1804b1-4997c13a13emr77455255e9.11.1786554092258;
        Wed, 12 Aug 2026 10:01:32 -0700 (PDT)
Received: from [192.168.1.50] ([79.119.240.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981b2b69bsm2322415e9.5.2026.08.12.10.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 10:01:31 -0700 (PDT)
Message-ID: <cf94fcd9-b119-4116-a7c5-4866fd2e63e5@gmail.com>
Date: Wed, 12 Aug 2026 20:01:28 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next] wifi: rtw88: usb: do not log transfers lost
 to a mode switch
To: Mehmet Fide <mehmet.fide@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>,
 linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20260812122858.3317577-1-mehmet.fide@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20260812122858.3317577-1-mehmet.fide@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/08/2026 15:28, Mehmet Fide wrote:
> An RTL8822BU or RTL8822CU is asked to come back as a USB 3 device by
> rtw_usb_switch_mode_new(), added in commit 315c23a64e99 ("wifi: rtw88:
> usb: Support USB 3 with RTL8822CU/RTL8822BU"). The chip powers off its
> MAC and leaves the bus while the last control transfers of that sequence
> are still in flight, so they complete with -EPROTO and the driver reports
> them as errors:
> 
>   rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
>   rtw_8822bu 1-1:1.0: write register 0xc4 failed with -71
>   usb 1-1: USB disconnect, device number 2
>   usbcore: registered new interface driver rtw_8822bu
>   rtw_8822bu 1-1:1.0: Firmware version 27.2.0, H2C version 13
> 
> Register 0xc4 is REG_PAD_CTRL2 and the access losing the race is the
> rtw_write32_set() that ends the switch sequence, a few milliseconds before
> the disconnect. Which transfer gets caught varies from boot to boot: 0xc4
> is in the "always on" section, so every write to it is followed by a second
> one from rtw_usb_reg_sec(), and sometimes that is the one that fails:
> 
>   rtw_8822bu 1-1:1.0: rtw_usb_reg_sec: reg 0x4e0, usb write 1 fail, status: -71
> 
> Nothing is wrong here. The device re-enumerates, probes again and registers
> normally, which is why rtw_usb_probe() already treats a non-zero return
> from rtw_usb_switch_mode() as "Not a fail". On a USB 2 only port the
> switch can never succeed, so the message returns on every boot and
> everyone using such a port has to work out that it is harmless.
> 
> Mark the window in which the chip is expected to leave the bus and skip the
> error reports for transfers that fall into it. The flag is never cleared
> because the switch always ends in a re-probe with a fresh struct rtw_usb.
> 
> Tested with an RTL8822BU (0x7392:0xb822) on a USB 2 root port of a TI AM62,
> where the message appears exactly once per boot. With the patch both lines
> are gone while the disconnect, the re-enumeration and the second firmware
> load are unchanged. The tested build was 6.12.103 carrying the same change;
> the hunks differ only in context.
> 
> Signed-off-by: Mehmet Fide <mehmet.fide@gmail.com>

I guess this is one way to do it.

I was going to do this the same way I did for rtw89, along with some
other changes, like retry control messages up to 10 times and do both
reads and writes from a single function. But I got busy with life stuff
and haven't started.

By the way, RTL8812AU and RTL8814AU (handled by rtw_usb_switch_mode_old())
have the same problem.

Your patch looks funny. Please generate patches using "git format-patch",
and use the rtw-next branch from https://github.com/pkshih/rtw.

> ---
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -64,7 +64,7 @@
>  				 RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
>  				 t_reg, 0, data, t_len, 500);
>  
> -	if (status != t_len && status != -ENODEV)
> +	if (status != t_len && status != -ENODEV && !rtwusb->switching_mode)
>  		rtw_err(rtwdev, "%s: reg 0x%x, usb write %u fail, status: %d\n",
>  			__func__, t_reg, t_len, status);
>  }
> @@ -90,7 +90,7 @@
>  	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			      RTW_USB_CMD_REQ, RTW_USB_CMD_READ, addr,
>  			      RTW_USB_VENQT_CMD_IDX, data, len, 1000);
> -	if (ret < 0 && ret != -ENODEV && count++ < 4)
> +	if (ret < 0 && ret != -ENODEV && !rtwusb->switching_mode && count++ < 4)
>  		rtw_err(rtwdev, "read register 0x%x failed with %d\n",
>  			addr, ret);
>  
> @@ -140,7 +140,7 @@
>  	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
>  			      RTW_USB_CMD_REQ, RTW_USB_CMD_WRITE,
>  			      addr, 0, data, len, 500);
> -	if (ret < 0 && ret != -ENODEV && count++ < 4)
> +	if (ret < 0 && ret != -ENODEV && !rtwusb->switching_mode && count++ < 4)
>  		rtw_err(rtwdev, "write register 0x%x failed with %d\n",
>  			addr, ret);
>  
> @@ -1111,6 +1111,7 @@
>  
>  static int rtw_usb_switch_mode_new(struct rtw_dev *rtwdev)
>  {
> +	struct rtw_usb *rtwusb = rtw_get_usb_priv(rtwdev);
>  	enum usb_device_speed cur_speed;
>  	u8 id = rtwdev->chip->id;
>  	bool can_switch;
> @@ -1151,6 +1152,11 @@
>  	rtw_write32(rtwdev, REG_PAD_CTRL2, pad_ctrl2);
>  	rtw_write8(rtwdev, REG_PAD_CTRL2 + 1, 4);
>  
> +	/* From here the chip powers off its MAC and re-enumerates, so it can
> +	 * leave the bus while a control transfer is still in flight.
> +	 */
> +	rtwusb->switching_mode = true;
> +
>  	rtw_write16_set(rtwdev, REG_SYS_PW_CTRL, BIT_APFM_OFFMAC);
>  	usleep_range(1000, 1001);
>  	rtw_write32_set(rtwdev, REG_PAD_CTRL2, BIT_NO_PDN_CHIPOFF_V1);
> --- a/drivers/net/wireless/realtek/rtw88/usb.h
> +++ b/drivers/net/wireless/realtek/rtw88/usb.h
> @@ -85,6 +85,9 @@
>  	struct sk_buff_head rx_free_queue;
>  	struct work_struct rx_work;
>  	struct work_struct rx_urb_work;
> +
> +	/* the chip is re-enumerating, control transfers are expected to fail */
> +	bool switching_mode;
>  };
>  
>  static inline struct rtw_usb_tx_data *rtw_usb_get_tx_data(struct sk_buff *skb)

