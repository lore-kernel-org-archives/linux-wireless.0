Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B75E479882
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 18:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790879436; cv=none; b=P7dVFzPvHfN55lFSHpcD0tQgTLTpqcg+eHTM6eia4KfPBw214TjCNyM4kHk5VORZgrdQxHXLKyFjdTuJnvKFO2wvPuAhm/KSqkAKeW+wtxHPNEhdBMTCgjGzxAUYTByCe2Pq7aTbb4iRKYiobnHK46Edv8HXCtblhGf1D1bDVfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790879436; c=relaxed/simple;
	bh=O2wKXAfkN2dFdnmpYinOxhV2lTAlfy6Db2AKWcznGlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q5nArmSm3Ukc3KG1CwGjIwwV/akE5l9vafDvavYVUBvAOnfyv/yPGzuvzol8sThD3AJjgxWF9JYgdDf8kYLu3KVBRVOA4N9Th9zMJUiVXm1VCSIFWgKMOmswJUpBarHpejAIbQ3yCRZ6Tep1GXclNyLw2KxN/TaDYkNE6176i98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kw9b0XKS; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kw9b0XKS"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48b00a0ac65so1343856f8f.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 11:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790879433; x=1791484233; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e5Gu6M674xuod4k8h/Bldv75c8R3MnHXqCgB0KSdcRo=;
        b=kw9b0XKSqUMmqJyAcye0cIqVhrnxjBf4mK62G0l246Itc1xvb1X1T7cytjIQ+EZQrN
         tcBppQUFL12a6zo2KrIKU/bWvd0peOZTkqlTDJnPpWOoK4wW+NDkMHXQKAwyCoHwxN0J
         UP44mFcfMXMAnZUMzMZbbGRpK8cTPiRzd1aZxLK6zVEih5xXSDKIhy5kMYN0T1hRDVTl
         GrTmFYDaISEJV7orbolIN9uyFmw/NxHG/y1EQupWBycw+gWcUXvbhN3EQMCC1ijp/ZQV
         ZoseOW4Q5wZYnKIf+iiIL1B2Ntt8yurzFk0cSlrmHM0M4kfdj3Mt82BYtel4OMZwrbaL
         5/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790879433; x=1791484233;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e5Gu6M674xuod4k8h/Bldv75c8R3MnHXqCgB0KSdcRo=;
        b=zYwXfu3KQTeNZmS2tOsfwvMiG6ItEd+ZDzejZhL1Hf84BjvIDOtWeCXJA6vpt31RK9
         I7Wda0CQGvO7SJVWr2/ncIPdtL240VtHPF368N9WpNgO1PE8vlPLCPfCVj6TrpXCj66F
         wBAEG7kImjSymMEUIUgOWL1xrIUdB8KdLO2sgREQDqOIe4q9Tyw835lioG6m8mfz82UA
         ahMH/iP+FHeBl0Seje8IU9jsnKuuiPLEflKdwt05P3Qi4h2O4QMlfTnJSXsj+fZtkiai
         mPNCz9RrE6iUbUq7olBDqpQrgOdRloWKKbNERwzQCRljsl8ia80Ie/i8kMK2g0RqD+BC
         RK1g==
X-Gm-Message-State: AFq9FYL+bvZwMAi9R3EJ/H7phC8jtxQV1IA/+ZB1GAUIGVZd9CsCRSk+
	LDJbMDIzJ2Ljv+IyZolqrxQmynsCzUgDzfC620S07oA4tNvP77mh+HxC
X-Gm-Gg: AYBFou1319ukda4UWmMP+m9EabZD9H3en0luXXuf1Hmld0+wtrW3alU3HRR4Z7m0Zya
	1RyMXumlv8DUV25Jro1Zg9oc5foIot+u/6bvV7xDFUTjJVW4LFL/6MZaBVTCOCDwlcfGQX2z10I
	3DCHOSjZ7IIroFfNuylu1+PJhw5/GJr084y+E25zjEIBirGtJA1bRR25rJY/HXE1c3hVbfs0Qzi
	zOns7GGDWR+69YrcOa02Y48HbYGN2IfTIFcM4Dw2WLwnIqHUmUzYSkUCAQFSNzOxp/Z3jkAPzri
	VbziXYTSI1ka2EIuBhZ/SYPuTxf0boUvTBr4lkBUWsMoYywuBlATN1UP5LyMQbDlzhKzc+rPPFd
	9B1sWUSmvonZ06D4ZaOu6CeWZoJJlUX3U49624MiKQidBAIVSfQvkzSHteXijrlpNikzzLPvuwu
	o/dl4H1Z4Ds3UxfHT+LaaD8/D5Ebp0ONT5ngv15IuNv5eOLdDT4FZKF6HoZmD6iwzCSalpnjvTj
	HAaXCfDLtqluxzN0Fl5yNoe2l3nmJ+a41DDHkK5OpUYJwapv7VHToZHdAaMsd/6r7RoT+wCc88m
	2w==
X-Received: by 2002:a05:6000:1866:b0:48b:a57:a139 with SMTP id ffacd0b85a97d-48b12750ecbmr819778f8f.36.1790879432612;
        Thu, 01 Oct 2026 11:30:32 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b382fe9cesm50938f8f.42.2026.10.01.11.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 11:30:31 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100.1)
	(envelope-from <chunkeey@gmail.com>)
	id 1xCLWB-00000000KG0-2UMn;
	Thu, 01 Oct 2026 20:30:29 +0200
Message-ID: <1a007951-8e77-4ca5-8dc2-093251357e0a@gmail.com>
Date: Thu, 1 Oct 2026 20:30:29 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] wifi: carl9170: revert broken devres conversions for
 input and hwrng
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260930-carl9170-reverts-v1-0-7033b5716c14@gmail.com>
Content-Language: de-DE, en-US
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20260930-carl9170-reverts-v1-0-7033b5716c14@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/26 6:45 AM, Dmitry Torokhov wrote:
> Commits 23de0fa0d2a0 ("carl9170: devres-ing hwrng_register usage") and
> 87ddb2fc29f1 ("carl9170: devres-ing input_allocate_device") converted
> the HWRNG and WPS button input device registrations in carl9170 to
> devres attached to the parent struct usb_device (&ar->udev->dev) and
> removed the explicit unregistration calls from carl9170_unregister().
> 
> Because carl9170_register() runs asynchronously from the
> request_firmware_nowait() callback after probe has returned, and
> carl9170_usb_disconnect() frees struct ar9170 immediately in the
> interface disconnect callback before devres_release_all() runs, both the
> WPS input device (along with its ar->wps.name and ar->wps.phys strings)
> and the embedded struct hwrng remain registered after struct ar9170 has
> been freed, leading to use-after-free bugs.

? Do I have a different source there ?

carl9170_usb_disconnect() does a wait_for_completion(&ar->fw_load_wait)
before doing anything.

For this completion to be "completed" either the firmware loader callback
went as far as running through all the initialization (includes
carl9170_register(), which registers the WPS button + rng) successfully
and the device is up.

or if there was a grave error (usb protocol error, firmware not responding
the way we want) and the driver basically has to give up... (but then
carl9170_register would have never been able to even get as far as
registering the wps + rng)

Cheers,
Christian

