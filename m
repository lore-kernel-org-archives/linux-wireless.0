Received: from mail-yw1-f228.google.com (mail-yw1-f228.google.com [209.85.128.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA1A380FC1
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 16:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785256799; cv=none; b=YpBQ23x9mWuH9Knecru3tKhoh8koCjpu9Cod683pBaZPT5kYH8254Y3jp39NnKNhzcIVLF3npD6tm4Z4vtU9ydTwkqp2b77nCtp0HuQS5a1S2YP0R/iQ7OQZz8rkT0Dl2S2HR6l7UAJt0/heaJ16VsbN3xuh7Pxi9RkvWtY+A9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785256799; c=relaxed/simple;
	bh=C/LrnnQhrRdDODaNl5ZAxVM0anW7PbqV33hp9JNvKAU=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=q8MCFZnJPQsOlqXWeByrCb5+fc+WUoXf5FRpDvRNtvsKge8DHbhcwWs3IvROsXdc6FlJwcrz16Md6i5UZwsNIiRavMDLQwUA18The8x8nkJpyDZRV5/VeY0KNKJbjZHKzxgUIaz087QQXeRjL/0sQaLb0u5WIpuWH1HYtMzX2Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=XJJA+POq; arc=none smtp.client-ip=209.85.128.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XJJA+POq"
Received: by mail-yw1-f228.google.com with SMTP id 00721157ae682-81e83f1f15aso460917b3.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 09:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785256797; x=1785861597;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C/LrnnQhrRdDODaNl5ZAxVM0anW7PbqV33hp9JNvKAU=;
        b=En69gfR3+BqcEBqWs+2NjE9s81NWILDsH//KbewzQObFuVhmA5/FLdkqn7FpIYv63t
         QGkbgTST3CA28+x3uaCwHPH8A/fzPoRpVNubD18Z7kC3iBXVBXOgFYNgEMTDJGU4aXke
         Ol0wO7mpAK4qwEjX7+UEi35T3FEtp6uT8MUTk4yOp1M6L3p3dI87JkNmE2vE1dGdX/y5
         3QNDVDNdoh+smYlWgAxxG21JkSVQFLRDGslHQNHqmFi1kcVf19IsorlFWJIXj16aBgI8
         YJYVb6p7RJf1Exo5NSGIL1txsgGM3/dk6tZwVmUq2lyMZRC37jWAEGomgrxJ3NuQHTgA
         aHKg==
X-Gm-Message-State: AOJu0YwSwODOsEbRw4eTJQaMoKmrnFhFClbTdI62iZzQnlVVaKPFNfIS
	5Axx8Gxxq6wrBnFuHybYu6RymTM4Ej0Ey3LoorpTdL7LQ64HCrYHq/+rmuSIZz3KCzvdVodIzMY
	fiShhXUMFvvrqVLNpIzl6bP01fNaJX2JDU13n1e9AP1LUQX2U5ESnVWe5uFhLlEt0dxEdWCJQXD
	ihPiiDfyN1lZh1Srw/YRciWOBXf5H5Xv65njLcF/vKceY1T5yrXvZtXkvI+ZiU5az7XMRZQk9WR
	7+hfivGUCQEXV1gbvFXmxOA/D2m
X-Gm-Gg: AR+sD10yd61P44+evqM+aUuL3VJtlVnYDvrFMRRp+Ow7M18GCGBaH5KigGqg3c6ivqw
	T3hpA7mYuqysB44e89RtMWxT6c2KaydlrEmUGv3ASJk/Y3dOnpu1KrHoRCWtqOZLCtdGkqcgp5q
	2CkhRhMsXCS4tEAWVBQfm4/5/1pDy9O+YJjc8M6wBDTCNYsDETT96x7Uv/KrYYIpIMhblO2/Gi1
	EB4TMjBD62IANZRn6hefoyV4KW2Ub+nu1U/Ddr482MTwKULSHOAQZRCJIg0gliOHVrKJvazcbRV
	UbhoMbjWPfhYUtdM8sGY8Cs4FMua7A1uZMsjUk4vSgdNOMDMP19k9QQSnWXoao/lUFw/Mcs1Yo3
	3r+tmtM+mMXHob+BjlARCN5gGoavetuf4BY5OHUQO4FQkczowYFB7nXBTy+HobSRYhJL0BPCxyl
	CiMiHwGf/YUOUMicsO+86XdKHc/R9dB1UCVuaDOWQ=
X-Received: by 2002:a05:690c:a4d4:b0:7fd:5508:b2dd with SMTP id 00721157ae682-81f99382ce9mr10700807b3.22.1785256796405;
        Tue, 28 Jul 2026 09:39:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-81fa293df97sm172307b3.23.2026.07.28.09.39.56
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 09:39:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-69c2f98aa9fso4930292a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 09:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785256795; x=1785861595; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C/LrnnQhrRdDODaNl5ZAxVM0anW7PbqV33hp9JNvKAU=;
        b=XJJA+POqBPmk2243dissk6L9VeI8YLAGzSy5lnkTN3la2ADGdtBGTxqnPBlRjRaQrw
         B4qs2KioYZpQQu6EKPHPPpk1LgyDuGxQlZPafyvJjO5v+hCWDSvGjb9PAeZSaCcAU+sB
         6W7W0bhPmER/J06nOkh+fbx57XsXBOTI+o3+M=
X-Received: by 2002:a05:6402:ea1:b0:69a:57fb:4783 with SMTP id 4fb4d7f45d1cf-6a034a1c0cdmr1646747a12.13.1785256794764;
        Tue, 28 Jul 2026 09:39:54 -0700 (PDT)
X-Received: by 2002:a05:6402:ea1:b0:69a:57fb:4783 with SMTP id 4fb4d7f45d1cf-6a034a1c0cdmr1646734a12.13.1785256794359;
        Tue, 28 Jul 2026 09:39:54 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69fb55439a0sm4275982a12.16.2026.07.28.09.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 09:39:53 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>
Date: Tue, 28 Jul 2026 18:39:52 +0200
Message-ID: <19fa998cfc0.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <03bb72fdab133a4efa84bd57cad966d222fadb73.camel@sipsolutions.net>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
 (sfid-20260728_164608_178238_1CE18783)
 <03bb72fdab133a4efa84bd57cad966d222fadb73.camel@sipsolutions.net>
User-Agent: AquaMail/1.59.0 (build: 105900627)
Subject: Re: [PATCH -next v2 00/12] wifi: cfg80211: consolidate cookie assignment for async ops
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 28 juli 2026 18:18:48 schreef Johannes Berg <johannes@sipsolutions.net>:

> Hmm. Maybe it's not too hard to update the staging driver?
>
> https://netdev-ctrl.bots.linux.dev/logs/build-wireless/1136007/14715755/build_32bit/summary

Dunno. I didn't look in staging. Will dive in.

Gr. AvS
>



