Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588CC3B0AF0
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 05:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785303093; cv=none; b=ODQeInpY5BjhfGkos9vDC1GOl4QzZjXrwefykOOoFEPF4wwEWfUv2pK5aXBUiVMSo+ES67g9ynwGL2YssVGK5dfuoPGOgx8fJM6RRvo5iNOd3uFMrwA5ZHUi3Tf5eySoCbJ8CDGSYo5S5qmz826GrdZECeUWivI6jaho3HstApA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785303093; c=relaxed/simple;
	bh=TK73DyNBFNgavPIJ8NX7LzeWA/wjG1g5dTxoKb05AaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RuxITD5f1k8nxDj/jsTmcNsVdSlg8pFtrRGQOO6twgJU5Hi3leS1EGLcmD+cdm2xyQwS21jJrRnqVmIV0yuq0HWWqk17jQM7xbIgffF8UI6fEECd+4bAlvYcbLnscpQFgBpTM+5QrcRqhvbELtCbNgFac5TkxYYjDH2Vrs6E9yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mHrEPotl; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mHrEPotl"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493f75f7172so4154365e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 22:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785303090; x=1785907890; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZZkhjXFCyNRKV6oXHNjuiRGL2GiMm192P3++mpEhAgw=;
        b=mHrEPotlLNvS8C6SrW/UtuFx2D9wHvXhYxFJAT1Dm+SbmiaU8mVO6HacECQqYyC0se
         afdZ98wxFEaMGdncnmNx2p02fya0WlDB9ynH+xTWVpsc899Se/P0tYTHe/NzZ+Wbg8rC
         kOveryLb4IbVHx6Mb9iSyVkA0x+vya71+cZsB2UpSC/AuiMu1PE2QsXHB5JH2m9bab0S
         hhfY4yKQR0J8D9JyExFHMTqQRaKqnMvmYq5CQedc9Ph7VrRreK5QzDrgsXBQ5T5+oESo
         jY3evf0LjK7eQy24xXWW6QxkyyGMU+u20av5v/fdAyAlLng4oEaLrgFPVoSK5QjEdq+N
         Nw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785303090; x=1785907890;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZkhjXFCyNRKV6oXHNjuiRGL2GiMm192P3++mpEhAgw=;
        b=Vb88akD/fvgPT6Q4/Dy+5AN1e2mr6RiawazvesMo7YcpISxl2FXnP8N8LUOtbfnJck
         +MNnXu86s72Tkn9zKzwbUj5YTSmqefem6Stq5M5KXkbbYLL0NDFWfaY+9UVj4Uwl2Aag
         UkHpwnLoaN9299plI05cdeBWxB+7L+5hoNY84I3Gr+BpoKzZ30kDUeMlLr6MzWm8Gz2h
         32lGwy5hbj9gE5OzGZHsSEQ0eZx6Zb1nhSNWgbnLGJ1jb8Lu157crDHQE5qewWCKCgJz
         3p4ZMpWbkP57eh56yo/mxK+0OrB9TtmEZtUjZODZTwu6xK9tJhSthjla00zAuGN1AWs1
         FXMw==
X-Forwarded-Encrypted: i=1; AHgh+RrOhOu64x5bF/OGzkT4bR46GOXc1sTt/nptM6Yl33UxAIOjNui7LZ/eSM7uvTA37TVuhFNWHQMp3Gu9Tp2CPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqNsGgfueitqURmDQ2hiKNsb7QON4MIYa9K/XkKY3NaMnvdEdl
	hLBikS0rnxn/Zsn1WVMvFKixnwy4LB4hAcMW9JAEXSLXDheIqoeDCa2vP9hQIs5aMLI=
X-Gm-Gg: AR+sD12I+zn5xHemZu5WNvy+bi9JY7CtB+yQNRgluVVjsDjvjU71krC2MudoPHC4u8p
	F1oVGi1Ykgy8diiYY/oFHtkGpjGEtw7YFMKjH+xyQlhHWJVgx5hqe5C/JsJ2WgEpB+7gi8kf4e5
	qF6LUXSfcHjL9Bvo5HNHlHhCX6bHzpmHSSGOLcdF2W/xdEWXc6NlwSCUIxp4ZPrNkc5Fh95NiWi
	b5RK0l2PnzynUhKRCLWgfLkhxwzrhjn9ouG0r5zV7qTNpR9+rmr72ciE+k8OPSbquez7jL7GQZt
	TNpjDR7KBIWlOEilMOY1f85+XlUlEZ5cYJ9NEBEHxbKWfgLNp9b6amrc51HmN72PEvOhggC342W
	urc5Q47YrEUhiH0FpKPyxgU5BBDuoAPhXDcILy+bgGBL2RQaeNT1BUrOjDCuD7dK6MKoKevL1Cm
	cjlAQSXm2PhedjCy/IOve3zDutMfxkYLswr2Nof1WwEnf7vct0CGK3LJ9a
X-Received: by 2002:a05:600c:6986:b0:495:3aac:1098 with SMTP id 5b1f17b1804b1-496c6591311mr60736795e9.32.1785303090216;
        Tue, 28 Jul 2026 22:31:30 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957bff4784sm337623375e9.4.2026.07.28.22.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 22:31:29 -0700 (PDT)
Date: Wed, 29 Jul 2026 08:31:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Yi Cong <cong.yi@linux.dev>
Cc: gregkh@linuxfoundation.org, linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: Re: [PATCH 2/4] staging: rtl8723bs: fix double free when
 register_netdev() fails
Message-ID: <ammQLsniXJ4LwNRF@stanley.mountain>
References: <20260729022509.2863634-1-cong.yi@linux.dev>
 <20260729022509.2863634-3-cong.yi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729022509.2863634-3-cong.yi@linux.dev>

On Wed, Jul 29, 2026 at 10:25:07AM +0800, Yi Cong wrote:
> From: Yi Cong <yicong@kylinos.cn>
> 
> When register_netdev() fails, the error_register_netdev label in
> _rtw_drv_register_netdev() frees the adapter and netdev via
> rtw_free_drv_sw()/rtw_free_netdev() and then returns _FAIL.
> 
> The caller rtw_drv_init(), however, still holds a non-NULL if1 on this
> failure path and jumps to free_if1, where rtw_sdio_if1_deinit() invokes
> rtw_free_drv_sw() and rtw_free_netdev() again on the same already-freed
> objects, resulting in a double free / use-after-free.
> 
> Drop the freeing from error_register_netdev and let rtw_sdio_if1_deinit()
> perform the tear-down, which is the single owner for this path.
> 
> Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
> Signed-off-by: Yi Cong <yicong@kylinos.cn>
> ---
>  drivers/staging/rtl8723bs/os_dep/os_intfs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rtl8723bs/os_dep/os_intfs.c b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
> index f31196f54b3e..ac401042faf4 100644
> --- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
> +++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
> @@ -773,10 +773,12 @@ static int _rtw_drv_register_netdev(struct adapter *padapter, char *name)
>  
>  error_register_netdev:
>  
> -	rtw_free_drv_sw(padapter);
> -
> -	rtw_free_netdev(pnetdev);
> -
> +	/* Let the caller (rtw_drv_init -> rtw_sdio_if1_deinit) release the
> +	 * adapter and netdev. Freeing them here would lead to a double free:
> +	 * rtw_drv_init() still holds a non-NULL if1 and calls
> +	 * rtw_sdio_if1_deinit(), which invokes rtw_free_drv_sw() and
> +	 * rtw_free_netdev() again on the already-freed objects.
> +	 */

No need for this comment.  These weren't allocated in
_rtw_drv_register_netdev() and no one really expects them to be
freed here either.  AI always adds obvious comments but eventually
the kernel will turn into the Terms of Service text which no one can
possibly read in a life time.

regards,
dan carpenter

