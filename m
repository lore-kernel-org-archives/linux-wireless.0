Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC8A54A7E7
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792170611; cv=none; b=RcXI9nOtoMcpQFS/0ed9YF+Nk28bGUr66MgB788ay+qSa3yrq14mBnSy1fgEVPO3fBUuVDpNVqnlwBFMhvolQLCQCkZ4eNzfFWC+Ai4dVtDKFVOlTnT7T/GvOaTO1gcpGT2VBhf64jqLZJhKS3iH7xNM5hFTGyoLy/o7qFE8kiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792170611; c=relaxed/simple;
	bh=4VUCa9kmi2R+Fcy1SzE699NuziKVzAT3EwTLjXQ+c3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UPhvu2QR0FwBWjrpOrP2F6CwNSnxUioDQJR+zlQCihyZy6OP7u/pr/8p1VcVRB28UjeFmC8c5jmoKINvGFKz7K9CfRYwzB/nskhVnlcSiNSY6MTX+Ry+NyCrOFUUAL/R1/gDusPJlB8tJmwSaEvJ8Kcd5T9U4Yfb+RcIXpcPKP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIivBGY0; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIivBGY0"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49fbb2acc90so1823875e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 10:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792170608; x=1792775408; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S974kxO+/JENpjy1sKN+r1kDpociiyhv3BX11j5VJ3k=;
        b=YIivBGY0sCMmdBsT2WZVJcwMUB/i3vgb0jK1wWmMacSWegFE9Lx5g6N9FJP+38rXPl
         s1OpRf+eIihYEboerSZYH3X+ErN80zNPboyf61KWCwqNSyDQ+uMl4Ib58POXKY68al59
         H91yFdj6MSHX22DMK81KuXaDD8Zy81LXsvMqMdTYSNUtU3m0fa35uEX6s9y4f8URFquu
         AVLbSoVtwBUUN6RrIaQW1VI6UVWWEbaJIU9NtwrdLnzQvuGXMuEjeKkrkTi8TBZWTpi8
         apYTJqkqaCruUUZWkkSz01TRyRwo/FcYu+ORIjP4C6htoZFtfzv5eCw+GJQufj7xEsJT
         pRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792170608; x=1792775408;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S974kxO+/JENpjy1sKN+r1kDpociiyhv3BX11j5VJ3k=;
        b=0RlxCgrGr+Ijmojat+HZQY3LRcXKDm+U2rjzi2h6KFKIenlHqE9IQ4j70eYFJ07qGT
         2kt7KOzmL4/tDzZQW7K6pNuN4zEZ6Rb1Wy1MKR/4544S52ITM1o+we72vyGPrkjo2I3e
         67cpQ4Sz0wxkm1szFVYzP3lzaK/bbGZm7CDd5LALvp9Y0xYnReBzxjLd/os2Zvkh2RbM
         SZTGDk5aTt0vOM+/Hwt8V922W1hHWfBwTLnt1bsw0/qUFeTP1zjiKj6hP0/Ji46yzx44
         bikftaYFPq8QN4lye20WRvaNXT87IUiEiMRcd0dOPQKWWnsyodE4kUxmHelJdlAlMJCq
         Cq7g==
X-Forwarded-Encrypted: i=1; AKwUvByHaTE/U3DEA/RXameYAH8XAf8S8IXDEh08ATGjjXT2WX6jCLLEMDtzvwcwfp49FUYdNj3SZeMpO3+qNfIfUA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJScpzXebjxf7dvtrRqhM2Mf96pakPZ/mSxQu50MEGfAO8lH91i
	lDRR1GvOrBSmd1n7APNcYimo+CKi9u88TMfgFLbPE5Da1f0wvY5sJ1iCoXrc3A==
X-Gm-Gg: AYBFou0mr0oKvhr9pdb8aVeitKlMEtX8QX5I3wpanfLeZRwmSbQGzr6sSfTo3o0qTeR
	FSpQJ0mb5mbxAVQNNhhI8neh5Wgrfo2eOD6EnTIPS2f325qRJLbvHfp7JAzE8LTasmeHPOMPa0T
	IjEUPZr4mNZvWbm182qR4+USpEAzUI7zshn8arP6DmH5a7qjSGVYCzr8fZ+tqreo8+bRLY6uuQ5
	EuA44qKOCvlk2cmlbVPBIDjle5hIwcPRhdkh7Mx25WOX+pICh5EDR05qvUDRhihLz0u6B2+2L2M
	Tg5W0pv7CLwVNXD39Hd/M+jWR6MLnB/EFSYv9Zj3zKovJiWyr2Gfm9fCUZIFUbzVRyMoz/qnt5Y
	/oJxyjXJKWetxr/5YgdveMBOX4MkMwS73CgGDtOWZncQHzPty4Qq7/MeFosQyYKOWQBq8ksR2IQ
	uTJpD+VJL2CENip7ng5yzNqKul6GZltifIPiuQOs9NSlVkkfs2pSaoUtzIYDMOZMcPw1JdwRt98
	mKcDQ==
X-Received: by 2002:a05:600c:19cd:b0:4a1:96cd:2f67 with SMTP id 5b1f17b1804b1-4a1d75ce2damr10283045e9.4.1792170607605;
        Fri, 16 Oct 2026 10:10:07 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1d0e2bb8dsm46811515e9.2.2026.10.16.10.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 10:10:07 -0700 (PDT)
Message-ID: <fd91ff33-d8a1-4ab0-83da-c15816c148cd@gmail.com>
Date: Fri, 16 Oct 2026 20:10:05 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtl8xxxu: isolate the USB register buffer
 from CPU state
To: 5mghybrid@khu.ac.kr, linux-wireless@vger.kernel.org
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>,
 Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261010-rtl8xxxu-usb-dma-v1-0-e670d9c08fdf@khu.ac.kr>
 <20261010-rtl8xxxu-usb-dma-v1-1-e670d9c08fdf@khu.ac.kr>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20261010-rtl8xxxu-usb-dma-v1-1-e670d9c08fdf@khu.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/2026 01:39, Kim Wooseok via B4 Relay wrote:
> From: Kim Wooseok <5mghybrid@khu.ac.kr>
> 
> An RTL8192EU failed to reconnect on a Raspberry Pi after an AP power
> cycle. RF_MODE contained a corrupted value, and restoring its initialized
> value restored reception.
> 
> The register access helpers pass usb_buf directly to usb_control_msg(),
> but the buffer is embedded next to usb_buf_mutex. On the affected Pi,
> it shares a cache line with the mutex's waiter state. A contending task
> updates that state while the USB transfer uses the buffer. This violates
> the cache-line isolation required for non-coherent DMA.
> 

Perhaps it's a silly question, but doesn't this just move the problem
elsewhere? Or does kmalloc_obj() guarantee that nothing else will access
the memory near usb_buf?

> Allocate the buffer once in probe and reuse it, avoiding an allocation
> for every register access.

An allocation for every register access was not happening even before
this patch. I guess your LLM wrote this...

> Keep the existing register access helpers and
> mutex protection. Free the buffer on probe failure and after power_off()
> in disconnect, since shutdown still uses the register access helpers.
> 
> Fixes: 26f1fad29ad9 ("New driver: rtl8xxxu (mac80211)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Wooseok <5mghybrid@khu.ac.kr>
> ---
> I tested the separate-buffer approach on an RTL8192EU connected to a
> Raspberry Pi 5, using the existing Linux 6.18.34 kernel. While repeatedly
> requesting scans, wireless ping traffic kept receiving replies and the
> RF_MODE and HSSI register values remained stable.
> 
> The submission is based on rtw-next. An ARM64 build of the rtl8xxxu
> driver with W=1 completed without warnings, and sparse reported no
> diagnostics in core.c.
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/core.c     | 35 ++++++++++++++++--------
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  2 +-
>  2 files changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/core.c b/drivers/net/wireless/realtek/rtl8xxxu/core.c
> index 3d0c22db3..604bb1e5b 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/core.c
> @@ -622,9 +622,9 @@ u8 rtl8xxxu_read8(struct rtl8xxxu_priv *priv, u16 addr)
>  	mutex_lock(&priv->usb_buf_mutex);
>  	len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			      REALTEK_USB_CMD_REQ, REALTEK_USB_READ,
> -			      addr, 0, &priv->usb_buf.val8, sizeof(u8),
> +			      addr, 0, &priv->usb_buf->val8, sizeof(u8),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);
> -	data = priv->usb_buf.val8;
> +	data = priv->usb_buf->val8;
>  	mutex_unlock(&priv->usb_buf_mutex);
>  
>  	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_REG_READ)
> @@ -645,9 +645,9 @@ u16 rtl8xxxu_read16(struct rtl8xxxu_priv *priv, u16 addr)
>  	mutex_lock(&priv->usb_buf_mutex);
>  	len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			      REALTEK_USB_CMD_REQ, REALTEK_USB_READ,
> -			      addr, 0, &priv->usb_buf.val16, sizeof(u16),
> +			      addr, 0, &priv->usb_buf->val16, sizeof(u16),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);
> -	data = le16_to_cpu(priv->usb_buf.val16);
> +	data = le16_to_cpu(priv->usb_buf->val16);
>  	mutex_unlock(&priv->usb_buf_mutex);
>  
>  	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_REG_READ)
> @@ -668,9 +668,9 @@ u32 rtl8xxxu_read32(struct rtl8xxxu_priv *priv, u16 addr)
>  	mutex_lock(&priv->usb_buf_mutex);
>  	len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>  			      REALTEK_USB_CMD_REQ, REALTEK_USB_READ,
> -			      addr, 0, &priv->usb_buf.val32, sizeof(u32),
> +			      addr, 0, &priv->usb_buf->val32, sizeof(u32),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);
> -	data = le32_to_cpu(priv->usb_buf.val32);
> +	data = le32_to_cpu(priv->usb_buf->val32);
>  	mutex_unlock(&priv->usb_buf_mutex);
>  
>  	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_REG_READ)
> @@ -688,10 +688,10 @@ int rtl8xxxu_write8(struct rtl8xxxu_priv *priv, u16 addr, u8 val)
>  		addr |= 0x8000;
>  
>  	mutex_lock(&priv->usb_buf_mutex);
> -	priv->usb_buf.val8 = val;
> +	priv->usb_buf->val8 = val;
>  	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
>  			      REALTEK_USB_CMD_REQ, REALTEK_USB_WRITE,
> -			      addr, 0, &priv->usb_buf.val8, sizeof(u8),
> +			      addr, 0, &priv->usb_buf->val8, sizeof(u8),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);
>  
>  	mutex_unlock(&priv->usb_buf_mutex);
> @@ -711,10 +711,10 @@ int rtl8xxxu_write16(struct rtl8xxxu_priv *priv, u16 addr, u16 val)
>  		addr |= 0x8000;
>  
>  	mutex_lock(&priv->usb_buf_mutex);
> -	priv->usb_buf.val16 = cpu_to_le16(val);
> +	priv->usb_buf->val16 = cpu_to_le16(val);
>  	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
>  			      REALTEK_USB_CMD_REQ, REALTEK_USB_WRITE,
> -			      addr, 0, &priv->usb_buf.val16, sizeof(u16),
> +			      addr, 0, &priv->usb_buf->val16, sizeof(u16),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);
>  	mutex_unlock(&priv->usb_buf_mutex);
>  
> @@ -733,10 +733,10 @@ int rtl8xxxu_write32(struct rtl8xxxu_priv *priv, u16 addr, u32 val)
>  		addr |= 0x8000;
>  
>  	mutex_lock(&priv->usb_buf_mutex);
> -	priv->usb_buf.val32 = cpu_to_le32(val);
> +	priv->usb_buf->val32 = cpu_to_le32(val);
>  	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
>  			      REALTEK_USB_CMD_REQ, REALTEK_USB_WRITE,
> -			      addr, 0, &priv->usb_buf.val32, sizeof(u32),
> +			      addr, 0, &priv->usb_buf->val32, sizeof(u32),
>  			      RTW_USB_CONTROL_MSG_TIMEOUT);
>  	mutex_unlock(&priv->usb_buf_mutex);
>  
> @@ -7851,6 +7851,13 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>  
>  	usb_set_intfdata(interface, hw);
>  
> +	/* Keep the USB register buffer separate from driver state. */
> +	priv->usb_buf = kzalloc_obj(*priv->usb_buf);
> +	if (!priv->usb_buf) {
> +		ret = -ENOMEM;
> +		goto err_set_intfdata;
> +	}
> +
>  	ret = rtl8xxxu_parse_usb(priv, interface);
>  	if (ret)
>  		goto err_set_intfdata;
> @@ -7971,7 +7978,9 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>  err_set_intfdata:
>  	usb_set_intfdata(interface, NULL);
>  
> +	kfree(priv->usb_buf);
>  	kfree(priv->fw_data);
> +
>  	mutex_destroy(&priv->usb_buf_mutex);
>  	mutex_destroy(&priv->syson_indirect_access_mutex);
>  	mutex_destroy(&priv->h2c_mutex);
> @@ -7999,7 +8008,9 @@ static void rtl8xxxu_disconnect(struct usb_interface *interface)
>  
>  	dev_info(&priv->udev->dev, "disconnecting\n");
>  
> +	kfree(priv->usb_buf);
>  	kfree(priv->fw_data);
> +
>  	mutex_destroy(&priv->usb_buf_mutex);
>  	mutex_destroy(&priv->syson_indirect_access_mutex);
>  	mutex_destroy(&priv->h2c_mutex);
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index c6953051d..8cbadcf71 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1891,7 +1891,7 @@ struct rtl8xxxu_priv {
>  		__le32 val32;
>  		__le16 val16;
>  		u8 val8;
> -	} usb_buf;
> +	} *usb_buf;
>  	union {
>  		u8 raw[EFUSE_MAP_LEN];
>  		struct rtl8723au_efuse efuse8723;
> 

