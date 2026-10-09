Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D094F5DF2
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 19:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791574669; cv=none; b=tc/AIhwNd8rrOFp53Svi12wggx56v4s9CzjTO9w26+qs6p3qWO5xJGcLaHCxFnBaFpTNTpFskJytFZ4Q+AgTNb/OUtTD/3pguCpbMrNxum9mHPE89t1q/xJQcGMCI5a8gteqR61fQcKDEYGE6Pg/EdaNcIeGriBA2fZrZ+9c7+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791574669; c=relaxed/simple;
	bh=2vzC5G85WBo1venNMaQZoCZ2FhcSm38JjrxzMjDDMWQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAOvTl1WWf9PdnS3GnJ6fWJttalsKjNwGYNrpYZSGrkkIuL/Wu4tMMbzUgxr4Yc6HoZ6J5Ih+8r//I+1fR7fpDNsCwxegRHdqZmkVblsVyXJJnpOyrI7UnvKt6zbBE7gJUGOjv69FecFcDQ/+JghOWnxy3W80c3s9yh8BfXg0pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bf9kUCL4; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bf9kUCL4"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49d0da752ffso1938415e9.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 12:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791574659; x=1792179459; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aFY2YO2cb3qpWj8CQZTY+PYX53TlszA01EImDQNtvOc=;
        b=Bf9kUCL4IHWHdjs/Nv3jSybcEFpqUR7IaJhxTKEPHbDKKMFwSjs0AppPNLoG7uU5d9
         ARnJuECAPp9Ob96HqZXWgQSIzpelMK+crsscu+T87kJQv15bWc/j8tPvuY6WH2MJBS2T
         ChVNrLVrsyyw9DJYvv1ZXA8ioDU3fJy5TRxOMPvkiwdhPVJLiPqnl3iPyAD2zlVklijW
         260z+9or9q4vTkYUUvvbyQqlpB203klCwq1F5fZLYIAetS1OYcTNOSZQDTeiLgUYOTTH
         R0kQU5TaXhBnvZIJxNlXwp5FAsCnYjCTwivLqXV/6q1lHdgcCXx8h4WU3ymMaNzb+pwL
         BuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791574659; x=1792179459;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aFY2YO2cb3qpWj8CQZTY+PYX53TlszA01EImDQNtvOc=;
        b=OCcEoenHHTs+KQuagJR3+FV8VITp329hb5yd9LzFeeMVvOFJI4P4XPFGUY1brNbsgZ
         27yWbMYWblfSvgVbcaIadbQXlFGV5dC2TVk1rMqrgvEMbeLUaxNNdhnHCShXb0Hkpiyi
         CFSoP8SXM5O1U4N3bvyO2sj0o+YcvmUZKUrKuTsn2eUUuikgjvLL7fcTIt1Lq/sgQ0dQ
         o1+5+rYsmUplztStORuRyRGjbQUP/p06NbXUi5K0M/YE7FUrQLfsLsXP9OwEGMIA9HJP
         vBo0bNqgE7Sttu/+BTa9fc5nYU0YqnUskMx8MSi/xHo4KtUwmwh02Tm0yxFwzWZTmLGW
         3agw==
X-Gm-Message-State: AFuF++lsKy/0P6wP0BLc+SaJnTMoEHb6sz0KCbumbTLMtFsldqgnNSen
	gNflhmWcVmKOMRRhIFajLB+ERGmv9UTpIOc/2PQ7rUaJH0WFyJc9pJGX
X-Gm-Gg: AYBFou13I9Aq7Ki3hds0ipSTIVcPisxB1Wkb1VNHSNeRhw8g8Zt8Vu4ZurfEwOnJr+F
	/Xt7l+eAjzyArSCChC7BRlUnoVrdcxmO0SUmT7ixvpiC2EX8bmzTiLAH3KQMLnJops7fLdBDFTf
	fguUwrH9oW5A96DvCLv8m3UyboYExqWEZ7/5EjsFpThr65svmdY7GOO84zX2ckMmHVzDHmZY/LX
	5JfvKu0Vbxi7y3jAPqNBcqnLcBz0MfhqZyExYE2E0J+ccEX/t0/fsZvOPniZx3mLE3eLUNHKJBd
	hCQkra7VAv6WJSSHHKaBFW9aemxGVC7O9UU9PVWGQT7tlJ7baI9Cc9Dt/XqPkvUJfdoaQuRb/U0
	EzNq0LbZweZGXfTEEdOe2icjHFX0EpLGi9PTan/DvBdZSl9SIy9r9YgvWT4MUv5GSuBhe+d4Kw3
	ayYM+pHjjutjkmdlLiTZBoWm9vhEk+s8O0Qh1v+AEZT2tBnkIzxx72sN7m29F4fOLNUc50tA+hh
	4yhqtJ0WH5Xru6GVJGasnXUnQtI0wJJMXmNrwLj1VTtkaxNPGFAsThL/Uk1tJ2qMHJIXu8mVYcx
	Hw==
X-Received: by 2002:a05:600c:8209:b0:4a0:2375:dc1a with SMTP id 5b1f17b1804b1-4a18e4cb771mr58738485e9.21.1791574658789;
        Fri, 09 Oct 2026 12:37:38 -0700 (PDT)
Received: from shift.daheim (p200300d5ff07190050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff07:1900:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18ee9bd19sm52018135e9.1.2026.10.09.12.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 12:37:37 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift.daheim with esmtp (Exim 4.100.1)
	(envelope-from <chunkeey@gmail.com>)
	id 1xFGNH-00000001q0Z-2qwe;
	Fri, 09 Oct 2026 21:37:37 +0200
Message-ID: <5771235e-fa91-402a-b5d2-ebb153872c26@gmail.com>
Date: Fri, 9 Oct 2026 21:37:36 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] wifi: carl9170: revert broken devres conversions
 for input and hwrng
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 Christian Lamparter <chunkeey@googlemail.com>, Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261008-carl9170-reverts-v2-0-3ecb12089797@gmail.com>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20261008-carl9170-reverts-v2-0-3ecb12089797@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/26 11:39 AM, Dmitry Torokhov wrote:
> Commits 23de0fa0d2a0 ("carl9170: devres-ing hwrng_register usage") and
> 87ddb2fc29f1 ("carl9170: devres-ing input_allocate_device") converted
> the HWRNG and WPS button input device registrations in carl9170 to
> devres attached to the parent struct usb_device (&ar->udev->dev) and
> removed explicit unregistration from carl9170_unregister().
> 
> In carl9170_usb_disconnect(), the driver calls carl9170_unregister()
> followed immediately by carl9170_free(), which frees struct ar9170
> inside the interface .disconnect() callback before devres_release_all()
> runs. Furthermore, devres on &ar->udev->dev is not released on
> interface unbind or registration failure in carl9170_register().
> As a result, both the WPS input device (whose input->name and
> input->phys point into freed memory) and the embedded struct hwrng
> remain registered after struct ar9170 has been freed, leading to
> use-after-free bugs.

Ok, so you just reworded your patch? Sight...

looking at the WPS input


|        snprintf(ar->wps.name, sizeof(ar->wps.name), "%s WPS Button",
|                 wiphy_name(ar->hw->wiphy));
|
|        snprintf(ar->wps.phys, sizeof(ar->wps.phys),
|                 "ieee80211/%s/input0", wiphy_name(ar->hw->wiphy));
|
|        input->name = ar->wps.name;
|        input->phys = ar->wps.phys;
|        input->id.bustype = BUS_USB;
|        input->dev.parent = &ar->hw->wiphy->dev;
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

the input's dev.parent is set to ar->hw->wiphy->dev and not ar->udev->dev, right?
Does this do anything at all? If not, why? The wiphy gets shutdown by
ieee80211_unregister() and having the "freeing" stick around after the USB device
is gone should not hurt, right?

As for the hwrng, wouldn't it make sense to use the wiphy dev there as well?
So the whole reverting can be sidestepped by simply going with wiphy dev.

Cheers,
Christian
