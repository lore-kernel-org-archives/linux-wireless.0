Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4018481FCE
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 10:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784629996; cv=none; b=JFlJh5tvaXrCd5LEuorY+s0e4sB/FziDKOCnBFQSrnJxnnrkGcUur2XEMgnml9l/lQFtFg87fa3z2I4LuXBtFm5pFoDUpD2CfW4AOlR5Ap+TeGPbYyiqokaxkLUD3a3q8v5rMXK3lKFyjsb5y+16Z/PTX4ixySuFqeZtj8B1+7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784629996; c=relaxed/simple;
	bh=WLhgUnpb80hHABXwKCUlxo2YuJadWbvTqwKA3k4yvrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZgu/bkCM8Rpp8a4TEiCPUHs1p09PkuIWofJx3xuDd/Ea/JFeUZ/YZVd/bRF3ujIIci9riG2V+MOqnnCY1jqYEl7sBodM1xg/GSKY7wBhZ2odCIo/8aNS0O/cN/gLp5YkKRMZuHApYEaOmAV8g4Zyy8vcS9+bU/1UiQSGG1EcpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=giHU7HPb; arc=none smtp.client-ip=209.85.215.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="giHU7HPb"
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-c9cf07d2df6so7001034a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 03:33:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784629993; x=1785234793;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=lx+yZrA/ioEyz+RtWWATDgMWOm1Gl+ZtzLYIVgkvKcw=;
        b=XEajxQyjujZ/2wI51yaxufvwGPwBB/mUBXs438V7wSfGclnllw8GhFLTr+a02/lNaM
         4Cgw9rBQTAHYX1JiAmAYhrcM1Kxndbwmuh1WPhmPhsg5YOteC+w8AmzmPe099vAqRrcu
         yAHzyRNQ9OXObQNDoEhZ69O/3CRziOKMxHvf2m9qRLxT71BbmoyAIrMX9XgHDhk8Fwio
         vKnFu1yZlZldusysOTCgUWvCxB1cHYmGGDhBJ9lz+k+QE6v/xtIwYAUn4X7LDDCDx+4q
         ezNy0Fmjya7iaTsfBOi15xljml7sy180igR2vLbGFIZ3BsoRES6wN7Fg3gcuCTPIkeah
         EiHQ==
X-Gm-Message-State: AOJu0Yy2FQGCbRzwkSfph4hVAJzEVDzDBpBb9L4nNrt7Sp7P+Cb5UHkH
	BbIdv2Hq6cO8A92tLVdJtfSZlF8WbbAcXsQeuYQjjDdV6+ua5XbX4rh592q5DqwddFQtYjoCvXI
	jWELEuS+qXw3qzzfE5zZI7PJjOW34OXAVyqmuPVSkzNTt/+xyA7Yiv40uWXOJsJV5meUh+GfEoB
	lbfdpQRvL6w48hLXNFAkWUgjIGtDStwF3RxVHWusGuI6wutgWLfVXIYHfbASDQiIffgks/OTQyg
	DTqPyB2BR7quFDzfvlkjIpROUtd
X-Gm-Gg: AfdE7ckcpwD5O5dYNsB4zSK6Lv0rFwvNYIPd3ygCD78aBbc0JWVaq4pzyDR5+GHpXv2
	tjiG19kYOtAPa0bOYN7Dfu3NdNrKs4mbci6g40iqeeFHdAtZCQTCtXhp0SdRz2WW9oV91ye4Muf
	J27imdcScUFIQjaBu2/wlgz8icPIoA/9XXU8IuN1mPVTnINsqkLYylQwzvWvgBEGBkvskKFlrY7
	o422hdwnKJ20orFXwz8nTzXZJnGodxUlwvUQ+y130PMDuWZooN+3Oy3B9HfFMq4eFF1wN1AyNjf
	gyiK2fCtFBJu/9EGjQ+Ex0J3VywK4euSzJ9SV27eM87OREQ1sAmei8h4puzVRW8MTBxt2Y2RIau
	kK9RX1p5wxVCNdzih4E0YaIwv1E+ihJsSDcj3Qsq9jNzc3cMDfOTYdg5trgLeS6vblJ9C1Afwdi
	1wlmbyyz3iar45Ivv+B3D38WFJI739qZ+MkTyX9JE=
X-Received: by 2002:a05:6a21:103:b0:3c3:9aff:7a67 with SMTP id adf61e73a8af0-3c3ad62a7b9mr19113320637.17.1784629992686;
        Tue, 21 Jul 2026 03:33:12 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-12.dlp.protect.broadcom.com. [144.49.247.12])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-3142a1bb764sm769808eec.14.2026.07.21.03.33.12
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2026 03:33:12 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15fff01a30so55714666b.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 03:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784629990; x=1785234790; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lx+yZrA/ioEyz+RtWWATDgMWOm1Gl+ZtzLYIVgkvKcw=;
        b=giHU7HPbZ32PQzRt6of5eAidv9JTtHeqhMzzzVE/MDZ6pcAAjsk0Tjjsu5D0Jgzbhq
         FSriwzWJ/ibzOAttISfk+Xr4cvYFXMU1UiCVgOQKPYx4MVAIsg8jhzJsvOfjW2Woxo+M
         UHNPgAHibtcil+8COWf8NMXZE7LSA0l8cDWcc=
X-Received: by 2002:a17:907:1c2a:b0:bff:738c:7a64 with SMTP id a640c23a62f3a-c16b487dce6mr675226266b.49.1784629990341;
        Tue, 21 Jul 2026 03:33:10 -0700 (PDT)
X-Received: by 2002:a17:907:1c2a:b0:bff:738c:7a64 with SMTP id a640c23a62f3a-c16b487dce6mr675224666b.49.1784629989860;
        Tue, 21 Jul 2026 03:33:09 -0700 (PDT)
Received: from ?IPV6:2001:1c00:3d88:a000:438:b9fe:24ed:8a4a? (2001-1c00-3d88-a000-0438-b9fe-24ed-8a4a.cable.dynamic.v6.ziggo.nl. [2001:1c00:3d88:a000:438:b9fe:24ed:8a4a])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69e6fee3304sm6165928a12.5.2026.07.21.03.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 03:33:08 -0700 (PDT)
Message-ID: <110674ff-586b-4a28-97d1-2bc0179caaec@broadcom.com>
Date: Tue, 21 Jul 2026 12:33:11 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: brcmfmac: cyw: clean up PMKID and cookie code
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260714150423.53960-1-bogdan.nicolae@gmail.com>
 <20260720194900.2356442-2-arend.vanspriel@broadcom.com>
 <CA+ORkNQcUjZ7ufoR5ULN8UDTzxXccFcmD8=rYe=UWVV3-M15Ug@mail.gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <CA+ORkNQcUjZ7ufoR5ULN8UDTzxXccFcmD8=rYe=UWVV3-M15Ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 20/07/2026 23:30, Bogdan Nicolae wrote:
> Arend,
> 
> Sounds good. Do you prefer two patches in a single email or two separate emails?

Way easier to deal with separate emails as we use patchwork to track them.

Regards,
Arend
