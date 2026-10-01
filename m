Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A003C1F41
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 22:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790892127; cv=none; b=JGKVz8f7Evr7ev92F5Pc1yW9C2TfD8svUrQZx6i+4t5yW76LipviYMyhcJbHzYhFSpEPeVHt7Sbg8iV6yzU6T3wxAlCXav1fW3KdMXA6UCxxn5D12q/w2nHXNDmTdQhE+OoZVsg4C9IK2fRB4anx+gwkY8AV2TQZ13OKCt5K6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790892127; c=relaxed/simple;
	bh=JjygOzXkqKng+9yvRLyl5HsDYVO+kYdxgW4/DBjOsZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mt842jL46Cn6TkA1IgiQw9w6nnxh03BK4XVGKpGozAZGl6wZVEljAb1c4qJ6BperMnMaT3U9zrCNxGRK3oaSGHhWzVx69jm0vcNnblxA2LCMpzGVPoH0aM3KaPTT2cGMkikV1BObMLaw5YJMhhVMAUSByRrvtixV49BZ44QWpEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rsaLXTi/; arc=none smtp.client-ip=74.125.229.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rsaLXTi/"
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3428f70d7e7so4042699eec.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 15:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790892123; x=1791496923; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bQSqCxLaeYIZqKCGpCRqtTz31RfWsjshUpxQ+xDyGIo=;
        b=rsaLXTi/3GWN5te3LL/Fz+Zr20NMRqISNAHMCk/mVDePAMo2pWyKrJ3AGVMZeSJFRL
         4EXRH8d9oCPvZnwTxrqfH0rafZx2I0+9V7Rlk8wchaISHwlvDBa3ZRGQK4boeAsN21qg
         Qb0dPaXnHprFDLRqjgl4BqlPt53ujc1+a/GnFKcrF7AtSd3DzO1zD9jI7PNU+/yOe5S/
         ica/PC8NQjFsp43mUa+jJyKXmhtl4lQaE20PYxmNosoEUhOW6ESie1a5RUX2DXIwDJVB
         1ypjjHSEv6WHSwP7k0H+BG2fBJPcQebjOBGclFjh2VjJ8p/QhX75GMiwMgPf3dSy/5Im
         z02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790892123; x=1791496923;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bQSqCxLaeYIZqKCGpCRqtTz31RfWsjshUpxQ+xDyGIo=;
        b=0wYmmPf8TPd34JCygCUbfrGsrfTcsUgjLpKOOoQ/QPWxt8obUjFqdPQ5kOs2CxcGxW
         JTOzrbpTBL7EvmtZEl+1Ro1guYgQQPSe14S0eLEoBXgtgdcQsFGt04gaf7cpTMBK4FLX
         9aFOm6nFdj6z7vMru2IJQKpXs44bITQDBe5Iijvxl61Z3PSIpk0YL+Xds70ScM4TBGhX
         SuvUaouRR/TrPnIP1PJcK2g/l3R1JUifrfwVhxWMlff+io/KytlUidgzUe0XS6FRbZOG
         E8Ax7YU4e3Wv4GUkWJcYls5K01Nz8ra8oKhTWdrwMny2OS3XCt5zsc5iAuKNuqdXdVuM
         CMUg==
X-Forwarded-Encrypted: i=1; AKwUvBwDINstrHrUCCEgElP4q/ye04XHok4/QSLG592KrUIXPlZicy/Y4Tn7yOMsPkdrPoxU8QitYfZPOTsta8C7UQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKv6Zn5SQRmtIXScVoNe1RqDt1FvbeETjaTzFJCCY1VlfMWlfd7
	UfNcpF6f2PkjSkKSQvxVE7sAolV6r/0muYtB3hmBznGo0njubmYWrxf7
X-Gm-Gg: AYBFou2E9I9/NmuDP0vE4JeY0aru8SmWoNJfK8c91ipHxxFqD+ImOAVNUupkrjQLTwh
	oqskGf7mFIadlQ9SHwGwMRvwlwzn26p3NYWn1U9VtS0lD+dFV0EcQMTPIIeQVyQnZqnsXRssJQA
	Tr+ZGGt7k10FgXLeM1GtS4iFIds0N1xN2ovGmDHrbVOCZlx5GmqDUjOJfV10sDh7E8B1XxXRq91
	bDqxX8EnX0V73w3gkAH38dcE0NcLpNBso2jDvpamr4tRed/vGLhQNYYZEjDW9wE0y7BvT4FR824
	bnPG3X555Lpr7AZPuPI7suYryP2GoSnyDfyPYlwAsB0IHUL8x7oSMXZI81CeW2KFDc7aGSb9SoB
	L3O6i9i2HlK1LA4PgOywBqr8gsXX7fTKaNM9iUS6q5qpSHy44WJPbId5OuEsdfazNmnWtsKAVM+
	7BMD+JixI7kdDJKfcEGXD1tQYF61ieRBseXYaVE+xLdLUyZ3YULNT9UgMWrvayBqeJevsM9EOhi
	I7w1zyxsSLhMUKwFpXKNjt//QNrdcM/UTpvsxYDeA==
X-Received: by 2002:a05:7300:e9cd:10b0:33c:e82:70c7 with SMTP id 5a478bee46e88-34f21985077mr718743eec.30.1790892120960;
        Thu, 01 Oct 2026 15:02:00 -0700 (PDT)
Received: from google.com ([2a00:79e0:2ebe:8:786c:ba70:85d5:57bf])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34f14f660f1sm1043250eec.13.2026.10.01.15.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 15:01:59 -0700 (PDT)
Date: Thu, 1 Oct 2026 15:01:56 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christian Lamparter <chunkeey@gmail.com>
Cc: Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] wifi: carl9170: revert broken devres conversions for
 input and hwrng
Message-ID: <ar7X4ul_AGHU_mUY@google.com>
References: <20260930-carl9170-reverts-v1-0-7033b5716c14@gmail.com>
 <1a007951-8e77-4ca5-8dc2-093251357e0a@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a007951-8e77-4ca5-8dc2-093251357e0a@gmail.com>

Hi Christian,

On Thu, Oct 01, 2026 at 08:30:29PM +0200, Christian Lamparter wrote:
> On 10/1/26 6:45 AM, Dmitry Torokhov wrote:
> > Commits 23de0fa0d2a0 ("carl9170: devres-ing hwrng_register usage") and
> > 87ddb2fc29f1 ("carl9170: devres-ing input_allocate_device") converted
> > the HWRNG and WPS button input device registrations in carl9170 to
> > devres attached to the parent struct usb_device (&ar->udev->dev) and
> > removed the explicit unregistration calls from carl9170_unregister().
> > 
> > Because carl9170_register() runs asynchronously from the
> > request_firmware_nowait() callback after probe has returned, and
> > carl9170_usb_disconnect() frees struct ar9170 immediately in the
> > interface disconnect callback before devres_release_all() runs, both the
> > WPS input device (along with its ar->wps.name and ar->wps.phys strings)
> > and the embedded struct hwrng remain registered after struct ar9170 has
> > been freed, leading to use-after-free bugs.
>
> ? Do I have a different source there ?
>
> carl9170_usb_disconnect() does a wait_for_completion(&ar->fw_load_wait)
> before doing anything.
>
> For this completion to be "completed" either the firmware loader callback
> went as far as running through all the initialization (includes
> carl9170_register(), which registers the WPS button + rng) successfully
> and the device is up.
>
> or if there was a grave error (usb protocol error, firmware not responding
> the way we want) and the driver basically has to give up... (but then
> carl9170_register would have never been able to even get as far as
> registering the wps + rng)

Sorry for the confusion, mentioning request_firmware_nowait() in the
commit description was a distraction. The issue is not a race with
fw_load_wait, but what happens *after* wait_for_completion() returns in
carl9170_usb_disconnect():

1. Normal disconnect / unbind teardown order:
   In carl9170_usb_disconnect(), right after wait_for_completion(), the
   driver calls carl9170_unregister(ar) and then carl9170_free(ar) ->
   ieee80211_free_hw(ar->hw), which frees struct ar9170 immediately
   inside the .disconnect() callback.

   Because the devres conversions removed input_unregister_device() and
   hwrng_unregister() from carl9170_unregister(), both the WPS input
   device (whose input->name and input->phys point to ar->wps.name and
   ar->wps.phys inside struct ar9170) and ar->rng.rng (which is embedded
   directly inside struct ar9170) are still registered when struct
   ar9170 is freed:

   - The devm_* calls were attached to &ar->udev->dev (the parent
     struct usb_device) rather than &ar->intf->dev (struct
     usb_interface). If the driver is unbound from the interface (via
     sysfs unbind or rmmod) while the USB device stays plugged in,
     devres_release_all(&ar->udev->dev) does not run at all, leaving the
     input device and embedded hwrng registered in global lists after ar
     is freed.
   - Even on a physical USB unplug (and even if &ar->intf->dev had been
     used), the driver core runs .disconnect() before
     devres_release_all(). Thus struct ar9170 is already freed before
     devres runs devm_hwrng_unregister() (which dereferences the freed
     ar->rng.rng to unlink it from rng_list) and
     devm_input_device_unregister() (which reads the freed ar->wps.name
     and ar->wps.phys when generating the KOBJ_REMOVE uevent).

2. Error path in carl9170_register():
   Even during initial bringup, carl9170_register() calls
   carl9170_register_wps_button() and then carl9170_register_hwrng(),
   which calls devm_hwrng_register() *before* carl9170_rng_get(ar)
   issues CARL9170_CMD_RREG over USB.

   If carl9170_rng_get(ar) fails due to a USB or firmware error, both
   the WPS button and the HWRNG have already been registered.
   carl9170_register() then jumps to err_unreg -> carl9170_unregister(),
   and carl9170_usb_firmware_failed() calls
   usb_driver_release_interface(), which runs carl9170_usb_disconnect()
   and frees ar while &ar->udev->dev remains bound.

I can send a v2 with updated commit messages that drop the mention of
request_firmware_nowait() and focus directly on the disconnect teardown
order if you prefer.

Thanks.

-- 
Dmitry
