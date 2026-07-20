Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35F131D372
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784573299; cv=none; b=flB2arUQSp7lTzmW3BoMlmB88yGIj+VUW35JoMUIO946DKkfiGz00aUETb4riXOc9IdMESCZKoT58gyUfBdC+aEikhicRwDXKnCBLtVBFjtZjRuLmjnMw3v58FNdlhgBgyT1GMQy8KOtA8AE8/qXpEoYlCIPwvXmh5JxfAszTIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784573299; c=relaxed/simple;
	bh=/r6Y2ugy0XUY1yvAgSIuLLaf292AISI28KxNzjj7EtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VQgOm9jNJIzgXKcskiMMfeEpzUU2O47taPIW8336hCcfPUpkjB5XgpPlTtBJ05lVp1oTl4LfEZv7apMAbtWBIIFEZlJzVNsfpwKbM9TeULgjf7PumeZ1VUmbg+hsC+CAUeh+GGKXSPaXKplv4yb3ZLcak5Vl2+AdXPWvYYedFoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Ol79E/LP; arc=none smtp.client-ip=209.85.219.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ol79E/LP"
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-8f18d92172aso93115546d6.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 11:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784573297; x=1785178097;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=p8t7Xg+RzoNYnR0lY1jTPPZgjUIjAoBXW/16uw7Qbwk=;
        b=TMWHdrKRsM8zyZceL74SRWIIfLSdQcP2d/b5zb5CHO7KDKdqsOrW+m1S90ci1+KIIT
         U4CT4+5x+lAKspr/K142/kt/4towaJl+fAdbSVmYkpQlg+nRGV2tyKmcOD9JUL5LQoNQ
         qRKSPd4MUM65U97CDJ/U+az1T0Wpa5BP5re2KDqwqhc1qF2sqx2U1wSIk4eCFsAesy96
         nchASOPcM0EQxMIfaSC4QwTA59ASFYhyPtbEcffUSGQVPnYNFwtB7EIO7xGAAgQ/G3wh
         R+agknkFeQn9owejK4wBcOgKz3Hq7vpJrMM3Ekeuy57s2jcaTJImBd0kc1q86PUDyYx1
         BOFQ==
X-Gm-Message-State: AOJu0YwRRfCUSypM+CGlHMWeyKNlOd/yjURe5pOJujs86KiI2rk1Ekrd
	yVtKbz0XF+yny3OktIWHuk67yBVxGCOnpt/9EZmubJrFmSP/VhbSAW6J6qwPfAwEDpwsnY2Ptjj
	jV06x3DIuiIxNyBSC4psUrULG4FMaRwDPJv7pMiZAwo0WsOEUCbivJNh1/mfMnkJKUqb2U6vnmP
	JD6hagwIBHRtqdsMwy2izaKAfrdV3f9pn9tKlPJObStuKXA4DLhS98RQYJSSSuq486TbVsIKSKT
	DU89PJKHP33zbgwbhqRlg2Q/w3h
X-Gm-Gg: AR+sD12eOx3KJZUfL2O54Ygfh8QfPt10vtkozaPhDmM0VjdJLo4NhP9mvwU8kVSnR6E
	KHj7EgImeK763ADQxUkfjeRdBg2GpTc/9idRTx5pje/fFLCI8VSbShxs589yZ6hdkLBC7wuf/Oa
	fdpfzC6USMbKfF8BYK8I19CAI/GEsEp+a4ErQvHq/IrSK2Dw/5M4BkBWYY+8bjBO5ctm8vUfpOb
	2/RKBlNVB67tpQr2UZuPWH4FuFJhBOO0FVYe8CgVPmnB1k4allS3xbEfSDwowLOMde/KuVTfyUl
	D4YeiALwgB4jnnZfsp7JhC7bYvnDPOo31/TWw9tuKfQs9Qg5pyJXeJef86hEdvmlTgFAgfFO0O7
	VRUXfYc9Z2gViQ+7gFsAzv5GtUv0pWXpmpUreDKZhy+2FCbnZJ0VATTre5P0w54yF5w2Aqnpvad
	UYVi9wpexe0uGf+Fto1ce32F5u3KsBj0oWHDaG5tM=
X-Received: by 2002:a05:6214:43ca:b0:900:6ec7:19d9 with SMTP id 6a1803df08f44-90778310a8emr168731356d6.3.1784573296470;
        Mon, 20 Jul 2026 11:48:16 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-90778342948sm6010866d6.0.2026.07.20.11.48.15
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 11:48:16 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-381abcccbf4so6677334a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 11:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784573294; x=1785178094; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p8t7Xg+RzoNYnR0lY1jTPPZgjUIjAoBXW/16uw7Qbwk=;
        b=Ol79E/LP/6uNHs3xPihoznVgkebV4qTrw571lW7oRCaJe9TUh0rTRLgqHW1XyeB/6R
         EvzjILlggZAViiv1xRyHiPzELCVNy7dF5QqjMzKjF6MHLh1WqlvnFEGEcGR9Ivtd6SSZ
         n8kNsynmASciil55yX7evHmBnEpxk6eQ6OIQ8=
X-Received: by 2002:a17:90b:2ec6:b0:38e:6a44:671b with SMTP id 98e67ed59e1d1-38e6a446b78mr5818355a91.0.1784573294162;
        Mon, 20 Jul 2026 11:48:14 -0700 (PDT)
X-Received: by 2002:a17:90b:2ec6:b0:38e:6a44:671b with SMTP id 98e67ed59e1d1-38e6a446b78mr5818343a91.0.1784573293687;
        Mon, 20 Jul 2026 11:48:13 -0700 (PDT)
Received: from [10.229.41.154] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29c2c93sm35687096c88.3.2026.07.20.11.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 11:48:13 -0700 (PDT)
Message-ID: <f9bcb849-cf98-4398-aa72-0b32885533fc@broadcom.com>
Date: Mon, 20 Jul 2026 20:48:08 +0200
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
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
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
> I agree this is a pre-existing P2P bug rather than part of DPP support, so I
> moved it into the standalone P2P fix patch.

Hi Jason,

I must have missed the "standalone P2P fix patch". Can you provide a 
reference or submit the patch against the wireless tree if not already 
done so.

Thanks,
Arend
