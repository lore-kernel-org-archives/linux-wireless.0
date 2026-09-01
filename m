Received: from mail-pf1-f228.google.com (mail-pf1-f228.google.com [209.85.210.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54C12F7F1F
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 08:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788252973; cv=none; b=AcAMVS9/yz79HNmReHYIeVeU2lLsOAqsxPT4UseHT55JKhDwYAxDpdDpdBJ/MBQ5l59ER1aTmV01toFUmevBfhh+nY5KJH81fNoeHsf4ODoIb9Ef7ygrL64RMUXztrUNEDUOlK0ds1my10fraqKTgnaVzacRDVklwV86jrlw/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788252973; c=relaxed/simple;
	bh=HKyQHdR5ynNMus3ZIXulcMT4jzgy3T8hMGmMkl2nc8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U0CW3F+8nnOk2O/29MpzgRiHD/gZTqUXBUHFvwzRpyT8TD7FR5iFpY0FxJXmnwn+wJEfd75u4rrkO0fBO5Frz2egZrFas/oY6at0CI5MD+DPYNFBFsoZ8ugfXbjgcL7MjsDccwZFpTaEKdgkQBOrvZBF7Zg6X1aalrX5xFJ+jx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eOr3c9ob; arc=none smtp.client-ip=209.85.210.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eOr3c9ob"
Received: by mail-pf1-f228.google.com with SMTP id d2e1a72fcca58-84864086bfeso4753229b3a.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:56:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788252971; x=1788857771;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=E+KYz0np7Sxg5cuxvo6xZsJdgBW3ZsGYJ2wUIRvt5rQ=;
        b=KqLz3Ok5EIfjAJRYlgirJZME4+iWbRY5l84UKT+cia+X69aYeMR6YCCzmNRzusmJ56
         mycFdZGkPsNB6OrAoMlcjiPK4eJA9mOLn2qAzM7Mn/qPq3XASiG7vuTiCdGawUSO7omU
         w4lweC5SlCwq4zhcVDmK/xmAOzIiXtBYbnn6cSMoLAqbRA6i3zhM0wZxUXciR3COprgY
         uZU257103sssKxErGxeAhsyNL9COj2CsT1/wKHYZLCaYKxvvqSY2Bt0UTRMb00hy435N
         ZGo+SIY6IxAn12+DsRrYkMA1WqqI6SgJLTfR+RwPAznQMhxcG2Yd+ucUfiesuAZq8T91
         5bjg==
X-Gm-Message-State: AFuF++k4DN44/77+/0/BfC/yvByDJzVCIxdA866GOi+0jBKnB5ot5Ken
	U89DAbaxKtPSreNyvvUA5ksWkMWsNTYX80QIjzM2Yx98yPAA1890G6qa6CXS+bfMpp8szSwxc2T
	BgLXzj8G+SvEIWmeh1RpvxaSKFJluQTuqSNQ1KO2efj7kBlrDMmvHFaBMGjcjeWOOO9vw6rluq7
	h8EHTquHaCXUZ9tkVlRIUUZ30566nXMd39nVClS9DHa2bavTdDumrdsgls5JChmMFRoHQCcRNbu
	SUwdENdINUcNorlPxnKrmaqQwiw
X-Gm-Gg: AR+sD12Iq/kf51sH2/kXNT6eZzMkUu2DmrqnAx4XGpKN8WThJpYpgn/0OcIwLJPtkZ7
	87wo0auERso7VjeMjQWFlYdriXgh7q0xZRPU3ecwCNPEXykjAWr83gQmMexOY6RSgjraycbj+Ku
	9aMhNloTybp2vIxBs6ErXw5aGeo3/OfDn/ASpp2sMewPlPwR39AGK3mNcQ/I25NmjjV+kkX8AYK
	VxU945710d94X970/dt4/2iGGMy4FwaW+QWapN6TVGvkIAdBlJ2k6EzkF0N1JblX7A17htcgLcP
	1OnMtCc6z48k06rapCbkw25ea4WFDjmDVjUfHdqsJaNcsOWtKeRalPluZmVYeN3yQCwa6c9PONp
	26LIAt3Kuuj36GwHT8GNFLQWblUj0703kidkxJfkCKMRfWR4jkIYEl83C3EgiNuhuWfDbJshx5q
	3zN7zajYLHMwZW3VSo8x0XTkbnMNTdq0N20YriJvE=
X-Received: by 2002:a05:6a00:174c:b0:852:355b:2430 with SMTP id d2e1a72fcca58-85b59c6e5ebmr8740887b3a.10.1788252970912;
        Tue, 01 Sep 2026 01:56:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-20.dlp.protect.broadcom.com. [144.49.247.20])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-85be6379d49sm454462b3a.1.2026.09.01.01.56.10
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2026 01:56:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90e9bc1fb67so984906d6.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 01:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1788252969; x=1788857769; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E+KYz0np7Sxg5cuxvo6xZsJdgBW3ZsGYJ2wUIRvt5rQ=;
        b=eOr3c9obqgK08XzVH8UoY0XUHdLFBh8SbFPxf7mVeWj/JFJlWviUV6ByYjh7Tq3c00
         4P9y1K103fRMOMPIjEE4vA22LtEoOMGS+OapTU/kEHorf4QV2csx/iHJYQHqfQDSNH6W
         Tgef48+5PwqbefxQEqnPK/rkiUx9MlT/lcH04=
X-Received: by 2002:ac8:5cd1:0:b0:528:3471:937f with SMTP id d75a77b69052e-53021ce5310mr90233271cf.29.1788252969518;
        Tue, 01 Sep 2026 01:56:09 -0700 (PDT)
X-Received: by 2002:ac8:5cd1:0:b0:528:3471:937f with SMTP id d75a77b69052e-53021ce5310mr90232781cf.29.1788252968989;
        Tue, 01 Sep 2026 01:56:08 -0700 (PDT)
Received: from [10.176.5.153] ([192.19.176.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52ff6f363fasm74787291cf.16.2026.09.01.01.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 01:56:08 -0700 (PDT)
Message-ID: <02c6f660-68f7-488b-a600-279e3a7f272e@broadcom.com>
Date: Tue, 1 Sep 2026 10:56:05 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] wifi: nl80211: add roam offload extended feature
To: HungTsung Huang <Jason.Huang2@infineon.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
 johannes@sipsolutions.net, hsin-hung.li@cypress.com,
 linux-kernel@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, wlan-kernel-dev-list@infineon.com,
 jeff.johnson@oss.qualcomm.com, Carella Chen <carella.chen@infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
 <382c3dbb-ff32-4e62-9b79-c6e4cc6273ef@broadcom.com>
 <8a866e2b-8802-4a8e-8421-2732da5f5c8f@broadcom.com>
 <20260901071424.GA1876155@ISCN5CG5251XQT.infineon.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260901071424.GA1876155@ISCN5CG5251XQT.infineon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 01/09/2026 09:14, HungTsung Huang wrote:
> Hi Arend,
> 
>> Actually there is a checkpatch warning that line with the STA_1X check
>> is 82 characters. So my suggestion please make it FAST_ROAMING instead
>> of ROAM_OFFLOAD and swap the two checks to fix the checkpatch warning.
>>
> Thank you for your suggestion. We will rename it to NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD.
> The name reflects that userspace offloads fast-roaming handling to the driver/firmware,
> and it covers both FT and OKC. We will also reorder the checks to avoid the line-length warning.
As this is indicating a driver feature the "_OFFLOAD" part is implied. 
At least that is how I look at it. With the 80 char limit the long name 
can be a drag in places.

Regards,
Arend
