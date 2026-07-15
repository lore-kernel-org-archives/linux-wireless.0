Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42822446C0F
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 18:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784141217; cv=none; b=uxeVsqNHWJLIoms7Lr2qNim+3t5wN4osSYg1NHL8FHYj2j5KQMwehDYWLYcWaD2wYfSZnxbIDK5/wLkRUkn4NktKtJgYTRiod+Vbmza5i18PZxjKY3AUqH/AdAa8ZyDS88w59jOCAFlhSGUu/CLnPPt4mzNF1YmcrK/vVfywMxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784141217; c=relaxed/simple;
	bh=pSGfxDBu/bTKUCbXwEE12hQsnPigII/3rhV06KMBMj0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7N7fpbIGZKckRj6X+HWeMcDqYwC5R4RvCVssrMJbs/OZeqqH1d3UTuMUveLcpudDsH2R7ApdhKwBtXFDPype24zuJbF9c3RT6gNT5znoBWItNCm2deuRFjyUmFNPOLcvHGvP6a6qYgCMlFVk78Kc/19fnhsNNe8o9U2fFtOi/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=QdZ7x9T+; arc=none smtp.client-ip=209.85.219.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QdZ7x9T+"
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-8efb708b1a0so49570856d6.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 11:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784141209; x=1784746009;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=b+JMc1wO40ou3EWMyWhSvMrcBgYYX5J3x/eL2eHwCT4=;
        b=E0GfdLqxlsiE+opzjOqp55NfQPDdG/412fUS+1DKEuFxic+hCRj6sYvxCCoYmLcZJv
         5tduPop3L5HLYhWg9/Yd2WX7FmrfGi1mwjY4CobrPqfi5Xu8tq3V/9zMF08FYIUJ2I68
         Y9NQRBRecwfw0TzLbXIvCJvy7r39/krQS4lqckqTiE44f8MwMUuw1z2jGOU+pVpOXRpO
         8XsE50ZaZaBY4hetHxidUprj8hpipNbEKhz1hU9qCyPkY01JU+RrJ4B7pMFo8eFQcSL7
         jDQFZPVxpXu0nYOHXp/85u2orPVriajz2xQN3W/Y/1VusPp95ZBxUrIpMlsdODdzqN4K
         X7Tw==
X-Gm-Message-State: AOJu0YwpMesl12OJmXN2/k2MkHnrImoGX1ynJAIvSrN22vox04SRftps
	kj9IjNtuV/T4eUb83wL9URUP3qHiODnkyl6LGEOJgmMdPO+cHH6KYoF0bPQs0NBZLf/MJ1NyFSU
	xwkCfNSosaJ6apLkjIt/whR6+UGOUqPuQeSl5PHbYQfSXMvCiq7dPEFfLj0UA7K4Cb4qw47gruL
	pCOoRcyQSu4LQApV+2npsoVc5Dw/wvKpptg1fUbY9HqI9m9eAAJjO2D8mCXxrGTAIxdfS1U2Jpw
	LA5wkjrU2lIow1rKhy9axOt6lsO
X-Gm-Gg: AfdE7cn6RoRDc9NKw7bveTRaVikFAGvjEbjA0u1TG/4+sslY7VI80VRsZKlqAzgz5+f
	P5NQa6ROJ9/ln7hm/wFP1AVQkzk2d+lt0XfgZKSU8weyDly3LJbtehlJpotCGZK8W5e+JzCOgHj
	83iuvNVPafxooinuemfVJfC1/6RVKGoq2zUtNbylYeac5uGdJsYpjsKho9X8hwRWTbM2mJt6KaU
	aM/vcuPo5stjLmKc7adSZSaXR5H/K7CHAPsUFkqb6yOPXUvHBT2OC/dvv6syEn3aAtU9TsmOxkL
	BwSNJtUmuos/k+mNj1JrGqQVdkI+d32YMfbTlkRYe1t6rJhbmNYCAZmuZd0tgxushcjC4OOSEdf
	jfQDXxfUone2Gh+t6z474LZA7omdm/ol7uX23Z93RP4np37QvtoScLRoGKa7HVSp8RGWIOSI/1Z
	G4tM6whcmCADxly+uOxV/eQC4vOHhWxMLlU4Av5yIzTzU4lwIPPWwA
X-Received: by 2002:a05:6214:3f82:b0:8fd:6e32:1aa4 with SMTP id 6a1803df08f44-9074c894fb7mr88002976d6.62.1784141208985;
        Wed, 15 Jul 2026 11:46:48 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8ffd61b7815sm10827946d6.8.2026.07.15.11.46.48
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2026 11:46:48 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38d7fcd1f66so8504822a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 11:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784141208; x=1784746008; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b+JMc1wO40ou3EWMyWhSvMrcBgYYX5J3x/eL2eHwCT4=;
        b=QdZ7x9T+eYVGU7OlsU5zsw3oas0PuQnclUUBeLkvqu0YGNSN5sO5yxPhkmXBgwNxiR
         FrSGJXNz2bzqa2UN5K5qcy563E5PxtdzS/LNq4EeTK46y4b5C6UJaUu4ztiw78VypWyi
         8jzcOlqtq2pohiEVkJIhMnK8ljoRYHwuE3PTc=
X-Received: by 2002:a17:90b:4cc5:b0:38e:2524:7272 with SMTP id 98e67ed59e1d1-38e25247950mr4460087a91.39.1784141207615;
        Wed, 15 Jul 2026 11:46:47 -0700 (PDT)
X-Received: by 2002:a17:90b:4cc5:b0:38e:2524:7272 with SMTP id 98e67ed59e1d1-38e25247950mr4460056a91.39.1784141206995;
        Wed, 15 Jul 2026 11:46:46 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e538368sm5941438eec.12.2026.07.15.11.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 11:46:46 -0700 (PDT)
Message-ID: <8c4d66db-b7cd-4fdc-90f8-b22e4b571179@broadcom.com>
Date: Wed, 15 Jul 2026 20:46:44 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] wifi: brcmfmac: add DPP support
To: HungTsung Huang <Jason.Huang2@infineon.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org,
 Johannes Berg <johannes@sipsolutions.net>
References: <20260708071230.312836-1-Jason.Huang2@infineon.com>
 <20260712223314.2182929-1-arend.vanspriel@broadcom.com>
 <20260715092229.GA667683@ISCN5CG5251XQT.infineon.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260715092229.GA667683@ISCN5CG5251XQT.infineon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 15/07/2026 11:22, HungTsung Huang wrote:
> Hi Arend,
> 
> Thanks for the clarification.
> 
> Could you please confirm whether it is OK to submit the standalone P2P fix
> to wireless in parallel to wireless-next origin/main? My understanding is
> that the P2P fix does not need to wait for the DPP support patch to be
> accepted, since it fixes pre-existing bugs and the DPP patch no longer
> depends on it.

Yes. You can submit the P2P fix in parallel. I am not sure if 
wireless-next is rebased against wireless in a release cycle. Maybe this 
kind of scenario is a reason to do so.

> The reason I added:
>>> +         p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif &&
>>>            p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->saved_ie.probe_req_ie_len) {
> 
> was that DPP public action frames can be sent through the primary interface
> without a P2P device vif being created. The existing peer channel search path
> assumed the P2P device vif was always available before accessing saved
> Probe Request IEs, which could dereference a NULL vif in that case. However,
> I agree this is a pre-existing P2P bug rather than part of DPP support, so I
> moved it into the standalone P2P fix patch.
Thanks.

Regards,
Arend
