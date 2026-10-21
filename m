Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792600797;
	b=kJueONlYW34UpLsAI8Qk6IEhiox5DXtJbgGiFsldZVzyNJ6lh2dvyRYj+zO//d6M3yTv
	 9PxGkgeROP6j64+TFGd/+183gG/3T6RunrGMDdtKVDDonFn3PSnX0rSdOr6AJyRXygBpn
	 u0xXznABIUU/TpEMAjPPi95pSLXtEISDkr0ErvXAZJWWfEWmNIKt/SCzJl72BaH2giAiA
	 PJLZqpZi/uC9pWlMKl6W8R1wGGcw39MjA44+FV1W9epqhK9ZpzSLyJAXZwDUOdf6tuP49
	 PV75k9+5EhheCTA/q86NmHHKn5CgEC+tqUq7nSkcIu7vq2w1zgOFdNklacvX0/fjYLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792600797;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:CC:Date:Message-ID:In-Reply-To:
	 References:User-Agent:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=8/LkuqpxItTOMcNoVAaFJJp8ILxgErWXgOG+sNgyAtk=;
	b=fPA6ruw/YDbpxkkU0aRtjH9/6l9RYZAec8TdPAQOQgnPpkNuRIpz8+GuZ5cFFYJj7SZU
	 1Ssx1+kG41QKW57hlKHxIyquEpA/BPy92ddOqBsZVmZhWWGJUFaUEPvluzeU+miLdNFq2
	 PmY0bze/Qc/M4yQhtKnJ+imA4zJY0/pMYFrjvBhwrplksLCQGZc9rfd8Bhb7ACWclUX/0
	 5zy+wK0SSRPEpyPYKdo8vPdmM1o4atA19NV1w3wA82Y0CYv5nFpwDvV8nrKYuPglteKoh
	 Hf/3dDMuxlaq4WWKSbdhBzjklx+ag1/vPtGHtcPeyRZ7lxfjhTaJ8JBVz6bx0bf0drw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=gMgdJ8vw;
	arc=none smtp.remote-ip=209.85.219.100
Received: from mail-qv1-f100.google.com (mail-qv1-f100.google.com [209.85.219.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDFB606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:39:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EDFB606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=gMgdJ8vw
Received: by mail-qv1-f100.google.com with SMTP id 6a1803df08f44-917a64f28d0so571636d6.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792600796; x=1793205596;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8/LkuqpxItTOMcNoVAaFJJp8ILxgErWXgOG+sNgyAtk=;
        b=Eh38JIwn1ZajxbdgnUxY7jOTJ3ujnAgvcC2UIriZtaTSEMIUSZ9Ox2+SKj0XpcVVEt
         tCRaXEo+UnI0jQqhAsRaGHZDiJW3cXpP8HVmtEqAUqgUbu6a+XBYTH4GIRM6R8lhC0KK
         Mo8ico/dbl8Hz88aAF0sn9mh11q+wKH5pr5Rjltf0zob8cvk9vVjWM8xpH8eNhQ3lD4I
         3pIW7R9fk/934gSdBRqLnZKl2esCYIb1T/to6kVXxTjLEQIXfBGgHLae7mIQBv9Q2V8t
         lUMnXiLJ81oymV6891tEsZjlawnM0zEXL/GcEs1ygLVzz02W6vePQt3kLRIQUO1Cj6j9
         QFJA==
X-Forwarded-Encrypted: i=1; AKwUvBwSFs+iBNkVZTkLFbcvn7378md2YeoOaNpBAEtr5+Q1A2NaNZUWEw9r52Y/S9mRWCBd59GQiLOGaAjMNDqesw==@vger.kernel.org
X-Gm-Message-State: AFq9FYJZFmgZMUCm+4hinhq2pXy9KAGItXI93N0oezsl1k9uJJ4mi9zS
	s1tFxl5VuFPdkXFpsUnsbLOy1zBdPkiMshLROe50jBgALCx9gzTlxh5WdDyHsjBwGISXZIVeGmt
	ysYW+eQDMh68Mvr6s6LpdPYODqo51Bu/VLnJU+fBCUsKRLL/esiZ8cJF4KrTkw48xC2M34fS/Vw
	IrE5g4NYI5z18ZOJViK2DIbUcgmt2tXG8bXhf3da5pjqg5ruYWA3ogPaJ/j/M01U8Us8cGKJiPt
	Gr0rRMrF98bGdSrHczRBx5/5qVu
X-Gm-Gg: AYBFou1t/JqK9s2Y8tttdMMkqkZiIJhhMnf4Uiqmg0vQ/brQF/vOsVp17HhgLQ6+f5E
	BRimZBw8of523f5gwaNx6WJfVoxlSps4E6DNQ1yh3l2p87z0vcx2HbZ7abyHkFDqnrOTD78Ypz4
	EgVkw5xkSbxFw+GdriVH/NA0f1gtXJU6M57k9imhEi8Ny54yiS6W/rzx9w4aBb16wlgf0WPuNPJ
	wyNy7/DplUmUDbFWgkrhWr3wZ4K0m4uY0JXhfObhAv0irN8EY/PpXFqff1Ul4HWBUtrvqcxdyLB
	wJhUt9nmGFBeGVGCE4IYIj8cUsqsaj6Kr44pl3/gHbClCVaC9+yXc7rQPrsON1RIVw2ZzFRsR4o
	jQk6kM6yRpF7ZFzep7DmUTA6Om55tJ5SXFkKMCqXJI0OSnB/wngyiK1AOx1JqpQqhVc5RUSqBox
	GSF1vCnjF+iK/k2vf/707quREnuUcep04EHS7FctIGBQ==
X-Received: by 2002:a05:620a:28c8:b0:93f:231:9ff with SMTP id af79cd13be357-93f4c785decmr949872385a.27.1792600796166;
        Wed, 21 Oct 2026 09:39:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93f56e0591csm53372785a.16.2026.10.21.09.39.55
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2026 09:39:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e82060977so6097685a.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792600795; x=1793205595; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8/LkuqpxItTOMcNoVAaFJJp8ILxgErWXgOG+sNgyAtk=;
        b=gMgdJ8vwxLa6FoCFemqFvRKoMdQ24qIJyoR323xNWSUS7NCfOtezl+0BaHq+HINqXp
         zb6PfTFmdxVFCeNjJTbB7u5AdfCqPu/WT0yHVW2JFQZyNwyYPHUvmhzITa9nTpcEcI/p
         JViLdGli5A+Jc8PM+9AdinE3vH3Wk/X1VcpmI=
X-Forwarded-Encrypted: i=1; AKwUvBwW7WA7bTvabXDw34HP1UhgsBLxKkSN37Fg9QEwh2dc0eCxW3c7PvxAELrE0H3eHG4F2gklkdIcz0NvjXCLSA==@vger.kernel.org
X-Received: by 2002:a05:620a:1a0d:b0:93e:60b7:eb1c with SMTP id af79cd13be357-93f57f5ebd1mr479092585a.8.1792600795427;
        Wed, 21 Oct 2026 09:39:55 -0700 (PDT)
X-Received: by 2002:a05:620a:1a0d:b0:93e:60b7:eb1c with SMTP id af79cd13be357-93f57f5ebd1mr479088985a.8.1792600794923;
        Wed, 21 Oct 2026 09:39:54 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56dd0022sm297747585a.20.2026.10.21.09.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 09:39:54 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Perlow <jperlow@gmail.com>, Baolu Lu <baolu.lu@linux.intel.com>, Aditya Garg <aditya.garg@linux.dev>, <dwmw2@infradead.org>
CC: <iommu@lists.linux.dev>, Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Date: Wed, 21 Oct 2026 18:39:51 +0200
Message-ID: <1a15f52cf68.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <EDE0E273-27FD-4069-9129-FCBB48D12ABB@gmail.com>
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com>
 <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com>
 <74570358-8085-4767-BF76-D865CA95853E@gmail.com>
 <40118d49-2e79-45c7-8e50-58e05a44d24d@broadcom.com>
 <EDE0E273-27FD-4069-9129-FCBB48D12ABB@gmail.com>
User-Agent: AquaMail/2.7.0 (build: 200700061)
Subject: Re: intel-iommu: DMAR PTE Read fault crash-loops a PCIe wifi device, v7.3-rc7 -> v7.3 final regression, reproduces on one unit out of five tested
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 21 oktober 2026 15:53:56 schreef Jason Perlow <jperlow@gmail.com>:

>> Thanks for the pointer.
>>
>> The only DMA related commit that I could think of was indeed the DMA 
>> direction change. Hope restoring DMA_BIDIRECTIONAL fixes it.
>>
>> Regards,
>> Arend
>
>
> Restoring DMA_BIDIRECTIONAL for the RX pool fixes it.
>
> v7.3 plus the change below, intel_iommu=on (05:00.0 in a DMA-FQ
> domain), MacBookPro16,1 / BCM4364/4: 15 minutes of traffic, 7.25 GB
> received, 899/899 pings, 0 DMAR faults, 0 firmware crashes. Without
> it the faults start within seconds of attach.
>
> - msgbuf->rx_pktids = brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
> -     DMA_FROM_DEVICE);
> + msgbuf->rx_pktids = brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
> +     DMA_BIDIRECTIONAL);
>
> TX stays DMA_TO_DEVICE; no faults on it. I can send this as a proper
> patch with Fixes: f0ba5fd51ff2 and Cc stable, unless you'd rather
> revert the whole commit.

I would prefer the above in proper patch, but it's up to Johannes.

Regards,
Arend



