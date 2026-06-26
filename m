Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E34A401494
	for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782493564; cv=none; b=q2RIjH6HKNLPWsPy+YtBDw7KGE+HAiQOlOHqldIUu8IACtbHAT/pfbfLfc2XM+B5eiI5cwxUaO+hRrVTXZj5b7WzsXrHeEuHLI+7y/EufAXt2uyqvdvB+3GSzu0hECzPjfHCLcH7lcUgxL95fFHZe6d42TzFkOZERqhk6VFY79g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782493564; c=relaxed/simple;
	bh=GQKFAfjK37kURb8eXgj/bP3eu1MfUrZ2X80i3UfUWBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2y1jZT6v8sta7bvJeMfIjhkk+jNtV9jgPNLgXIKqs88ApRCVEPJuSRe79hQTusrGBcpU4nvHTKVAoR8g38kygzgOL0VuevjfqMIQrWr7DCp2n+477jv/sPw0CeHOCI2EZykM3qa6uSIa47C596tsQI3MwXSwPtvxdM3vZD6hRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PfGGy3dD; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PfGGy3dD"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4926046fbc5so13851535e9.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2026 10:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782493559; x=1783098359; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ctcxDsWWE5CsrZTwx1xGnbf39A7pUyPEOclo5R2hslQ=;
        b=PfGGy3dDJntvUAhwdN74MoQyZ7Kb76WVRvfiYiz1r1uk3V/wjmc0ccylG8JVhL0+aO
         9WSY+r+SENhfxJL8CUeOB1pmR59D9qbmsIm0QL0geqEQ3IJNFp5Fq7qrY/5fyGWdsqG0
         nIyYMLaVYge3kigQjmdxvMGDVbUqMNI+4R/I6uQ1sMOrczr5lwCRWg+mi2S0BVuQYDKL
         dDgqcqfyH8rsZo98a4Dkff0WHyw9Af1jwt2qhjUEWTtw3ws3bdrW5rBD3IoBPhrQQzZE
         8/ce3DSxR7gM6HlnWvwnjDorWuEU3FMzRK5nbfmPEGSUPopV0SrDeRoc0yqUq7qQ+8gO
         PhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782493559; x=1783098359;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ctcxDsWWE5CsrZTwx1xGnbf39A7pUyPEOclo5R2hslQ=;
        b=QUlF+Hz54IhBdc3SCU6h0TJIZMvD+lyj17HiScT/tTaTXu/zAnFr53gr7aUDhceZfM
         ybJJtMl1ippxuz3NnXaXRviKLEKAWhxLZ0ZRrEd+MNuWsIR0EmMuqfzTauTGRClt2IM+
         0hl5h/4U+F7TJ8SRSIyC6h3ZntxsmgofS6UYakG0HwWL5dY7VbHbybwYTc2sU8rOTEhV
         MnqITA2jzdn7vVLSYrRa2CM1eocWsrIgHNxCqlDsam65cXqDk+Y/jK2eg8KdtuxY3mtf
         CKfhCFzo8YXMkZrDzmvnUF2F0FsbNxvjQBK/Vgg/VEQE4AcAcd2V9w610Uo6dfCzCshr
         RIFA==
X-Forwarded-Encrypted: i=1; AFNElJ8NNhVtOgUojQC615XJ5OgBx7dkm38WS7obo3KcjZZrb8gtPF6ZbZUTwdSc2JOEBlu/fKM++0rRGsAuiEeLzw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkqvPyDAsQBEqcIuBPUfnrm5YYuDI477yJfFTTwQRIIvTlKgr8
	ZTEBHM8mMBxaDgVGPEzHNh5iA8PlzTDdEVNU7vzVZCBygVN2ortbLgiQ
X-Gm-Gg: AfdE7ckevCKxDZAcqYGTiLqbXqQZI5evFk8o1cTEp8tObfoF+wCmpxCkgWUWDIyWmE+
	EIY1FR7DQzzOiDQbXE5+OASjceOoNAt7HvRElHxFdDijbQTayWi2l+mtlID0HY+svRWvBUMO86i
	M+9X5bCgol/VlWlzNrk5KtntyyuTwqObiNjirQvi2dBgZWsl3hF5KeKV1dkDYS6Q1rj6slD4gVx
	vast+u4dYqUUTOi+YnE1eGYe+AwJ12StC5KwR+EhrJWGqyuoCw/HO2hakc+Ujguv1jtVaLO3Q4G
	Xep8CDjG+7FB09yv5uVlGAl7OmgXGJlflQEvDT5BFPdejkTY0NP1BQKSM1hOitEaZ8f3Tqbo07T
	BXBgZNmrfDmF3MltQUi59CE7Oq+efdVY6bcAwUqB609h6o7ConAFeoBLDSetByvjzMyJCP6Ax5N
	HMILkvO3946DgHSpu2o5WCahAL9J6UaEPMc0UJkEJHB1qQq68QrYZ5fwmiCDnldW6Nz6PAOoORe
	B0L40kv
X-Received: by 2002:a05:600d:864a:20b0:492:5bf9:d149 with SMTP id 5b1f17b1804b1-4925bf9d18amr186215685e9.5.1782493559068;
        Fri, 26 Jun 2026 10:05:59 -0700 (PDT)
Received: from [10.128.11.240] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46fe25429d5sm1694876f8f.7.2026.06.26.10.05.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 10:05:57 -0700 (PDT)
Sender: Julian Braha <julian.braha@gmail.com>
Message-ID: <ac8c92cb-21f2-4274-8fe6-f771fe48eec7@gmail.com>
Date: Fri, 26 Jun 2026 18:05:54 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/14] firmware: qcom_scm: Migrate to generic PAS
 service
To: Sumit Garg <sumit.garg@kernel.org>, andersson@kernel.org
Cc: linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, linux-media@vger.kernel.org,
 netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath12k@lists.infradead.org, linux-remoteproc@vger.kernel.org,
 konradybcio@kernel.org, robh@kernel.org, krzk+dt@kernel.org,
 conor+dt@kernel.org, robin.clark@oss.qualcomm.com, sean@poorly.run,
 akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
 jesszhan0024@gmail.com, marijn.suijten@somainline.org, airlied@gmail.com,
 simona@ffwll.ch, vikash.garodia@oss.qualcomm.com, bod@kernel.org,
 mchehab@kernel.org, elder@kernel.org, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, jjohnson@kernel.org, mathieu.poirier@linaro.org,
 trilokkumar.soni@oss.qualcomm.com, mukesh.ojha@oss.qualcomm.com,
 pavan.kondeti@oss.qualcomm.com, jorge.ramirez@oss.qualcomm.com,
 tonyh@qti.qualcomm.com, vignesh.viswanathan@oss.qualcomm.com,
 srinivas.kandagatla@oss.qualcomm.com, amirreza.zarrabi@oss.qualcomm.com,
 jens.wiklander@linaro.org, op-tee@lists.trustedfirmware.org,
 apurupa@qti.qualcomm.com, skare@qti.qualcomm.com,
 linux-kernel@vger.kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 Harshal Dev <harshal.dev@oss.qualcomm.com>
References: <20260626133440.692849-1-sumit.garg@kernel.org>
 <20260626133440.692849-3-sumit.garg@kernel.org>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260626133440.692849-3-sumit.garg@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Sumit,

On 6/26/26 14:34, Sumit Garg wrote:

>  config QCOM_SCM
> +	tristate "Qualcomm PAS SCM interface driver"
> +	select QCOM_PAS
>  	select QCOM_TZMEM
> -	tristate
I think QCOM_SCM is missing a 'select IRQ_DOMAIN'. Right now I get a
build error without it:

drivers/firmware/qcom/qcom_scm.c: In function ‘qcom_scm_get_waitq_irq’:
  drivers/firmware/qcom/qcom_scm.c:2512:16: error: implicit declaration
of function ‘irq_create_fwspec_mapping’; did you mean
‘irq_create_of_mapping’? [-Wimplicit-function-declaration]
   2512 |         return irq_create_fwspec_mapping(&fwspec);
        |                ^~~~~~~~~~~~~~~~~~~~~~~~~
        |                irq_create_of_mapping

- Julian Braha
