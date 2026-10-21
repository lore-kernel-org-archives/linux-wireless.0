Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792603717;
	b=FSEUbLnF02DF81pfFt3wUNBoD08GOjA6qXLI26K+IccPRkdk/zCgISzII0FGYG1ruFsR
	 eVL5L5C3ycTyobG3p1tse985EG7Njogr/tp7fD1qebbTyLcjxWJc9o7xjvAlQCd4D1xWN
	 w2HMWLR/BWZlLDPad3Ko/1MuU5mvCPW/enSK2fuxr2aoGIWfpkFnsxC8IoGCtEqFG7sCD
	 oWa+UR+wz+rYvTBeYe88PbdHTYyJ/ttzx1L9hmC1PcA325NRHHHY3ui1OoNEW4BOQ9JxX
	 zjT9kMhr+OTS0dtOuCKVbWkgfdjjWnxpXwlwtUBz2VkFmw99hALWqwfeSTW8hLO/0Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792603717;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:CC:Date:Message-ID:In-Reply-To:
	 References:User-Agent:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=yBW5lI4RGoshpEvuEkqFomfPwP4gRy6G1sr7L5RUhY4=;
	b=cRAl49B2mi/9vyyYb0mQHCd8UiA2qILta394/j+qcX+3slCy+EeLXXQplBaxi3tAqqCg
	 XPw5geUxFmqdEPewjO0piJkmIdEwwxVA4NtRAPq+GIR59a/3gx7Ev+rfv3+GTKbC9XXjz
	 I/8UD/f9UZTC02F1aDxycPuTdcDmdpUN+6JIPDdvgLE2XJ29cIlcAVqsMnoohLDEZi3Hy
	 deS+/T5MgTKHtbv2Ivhl2vUNpOshEZE7HqX/3TxJStYBA4QhGCyZYwTHcuQm/IKMwIZN6
	 PyTraxzon2nFfevywJDbYP4zqSnUf3c4b0RR2KEDgJnU8rE8xG7uG9wGOPqbOaEUV8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VZ3oCQg8;
	arc=none smtp.remote-ip=74.125.224.99
Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F305260A380D
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 17:28:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F305260A380D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VZ3oCQg8
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-6798c4b882eso872382d50.0
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792603716; x=1793208516;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yBW5lI4RGoshpEvuEkqFomfPwP4gRy6G1sr7L5RUhY4=;
        b=bnBp9tWPME7Icy2HtkK+5l5LtWGvP8gcvzXSkAyIuL9LZoS2b4/qey2WJqlHYzCjtf
         UripSgWYl/IyxIijMMIraOu0cJSJDXxyXQuO1qeP7VpCEf1guN+dRsZveuXEqx12k3u/
         7ORWFoPYZAYgRMb960QBtsoQnBvQr/G/9XcBLBfSJLVraPtqOIaM30V3JQYFepoxyECA
         keuMHQn47OnNMhNDiOVOSpm+yzyHiPZzPrUPZ89u6sogVd44LTt2qdQV6EKb/ONC2bEd
         qzDFJRMxCRAOD7xrRMWsagqhfduom5cPcGEZXIucytZijlqhbbj82PWFyEvcubxG73kt
         ldXA==
X-Forwarded-Encrypted: i=1; AKwUvBy1w+RO9F9dwM2ktI2s/DPFbDoWd7JcK6AClApc3j3Y2XV0/eyTuyqrvDXcZ65ESswXMTLQayDFTtlJMPN80g==@vger.kernel.org
X-Gm-Message-State: AFq9FYLCsZqDtNqxkonq+coHstMR/z5yDdj/W4yUCGwsmaW+2ODqyZXg
	uASFxWHw5nkVC8KFt2iP3St03+zaPpvtKIndoNxrs+HlZadcKP9yAxKOCdsKZTPskJFegBQdVn/
	p4FpI+hy4j9A82fJXjQ+d2iwI84B/AJD1R3JWEOSbllhuD4QCejXwloAfXxxTSQMAm1qKbgIpFj
	pWwNx831eIQNK3y1Ky0lBVM01bCvWVST9BAF/zcYQ84YnMSoV1H57Sp0yDoAucY3gAUReuTzdro
	4bkddv7Fdb2svdqVHNYRjeP1PoN
X-Gm-Gg: AYBFou3ZuOZnnhzp6B32DqqtmqTWtewhigOi9U1JbKeAjFCIiSeMyFvSQM2q0JnnwOS
	JX3dIGI9izQNgF5VFjTV44WrFDpocCH0UU5Skq+cbsYEuO2PtEh8+A8hwsOMilF6ZmewpGrm/h+
	Hi6pSpgvK3oMzH1COvtIFtQzqLvd/uDUvh2tLjuv2njaT8NzSfoKm5TDJsPIPuckenogffe9isi
	HixK86zmk5X+iE03qD6iu6VSS+ljBlO4lJlTvl1y/exNpUj/WR7s9NfC9jbxkhkMx65LML2M/HK
	5ONwW7jQn6emvCMjbHMcqDNjICZq6Ulkh1Yg6Q8F7VU2jm+X8rDTqkIYXnAK1s5j7Wzx7EDZMu0
	X+PqrgDUf0FFWh6hLPJwVcgOl+T/KPIXp+bvcDn7GLmOYw4Fh1ZTYLchgVS4KtaCiAuG5bL5ovm
	udX3T9L9sDWtBkQb3xPsr5Knu0hHyNpq0JeyM+plSWzA==
X-Received: by 2002:a05:690e:4397:b0:677:d31f:5a7b with SMTP id 956f58d0204a3-67a0e51e0admr855145d50.77.1792603715856;
        Wed, 21 Oct 2026 10:28:35 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-67a0e51e177sm63959d50.34.2026.10.21.10.28.35
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2026 10:28:35 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91c046843f1so29708316d6.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792603715; x=1793208515; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yBW5lI4RGoshpEvuEkqFomfPwP4gRy6G1sr7L5RUhY4=;
        b=VZ3oCQg8H6y+PlnK/6e7qpHsv5U5xqEMWxeu1BvDuQh/yuXUdJ0ECNgq54b8v2MQR4
         CybnSXp8yr7D/QRJlF1wmQpUWE8xdKZp+66VPtKC3TFd0xugr8Af02cjlM9BIF9bXnVK
         mPj0Eel1ncg5Qhbab8Iupuxfd6PuvRYNbGQVY=
X-Forwarded-Encrypted: i=1; AKwUvBxMJTbTe1lsgH3DCy/4uHArWPnQLjROJ+qZk5df5N/AjMGLOVHT6w1QHa0kwHpWjzCqCZZptjsUA74ndws80A==@vger.kernel.org
X-Received: by 2002:ad4:5aad:0:b0:91b:8b10:ce01 with SMTP id 6a1803df08f44-91c12f031b0mr45327956d6.35.1792603715007;
        Wed, 21 Oct 2026 10:28:35 -0700 (PDT)
X-Received: by 2002:ad4:5aad:0:b0:91b:8b10:ce01 with SMTP id 6a1803df08f44-91c12f031b0mr45327506d6.35.1792603714445;
        Wed, 21 Oct 2026 10:28:34 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c5002bsm29465846d6.42.2026.10.21.10.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 10:28:34 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Perlow <jperlow@gmail.com>, Baolu Lu <baolu.lu@linux.intel.com>, Aditya Garg <aditya.garg@linux.dev>, <dwmw2@infradead.org>
CC: <iommu@lists.linux.dev>, Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Date: Wed, 21 Oct 2026 19:28:31 +0200
Message-ID: <1a15f81e618.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <20F90036-F53C-4490-B27A-DFD055DB22E8@gmail.com>
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com>
 <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com>
 <74570358-8085-4767-BF76-D865CA95853E@gmail.com>
 <40118d49-2e79-45c7-8e50-58e05a44d24d@broadcom.com>
 <EDE0E273-27FD-4069-9129-FCBB48D12ABB@gmail.com>
 <1a15f52cf68.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <20F90036-F53C-4490-B27A-DFD055DB22E8@gmail.com>
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

Op 21 oktober 2026 19:04:11 schreef Jason Perlow <jperlow@gmail.com>:

>>
>> I would prefer the above in proper patch, but it's up to Johannes.
>>
>> Regards,
>> Arend
> Patch below.

I don't think patchwork will pick it up like this. At least I didn't see it 
there.

Can you send it as a self contained patch. That would be great.

Regards,
Arend

> -- >8 --
> Subject: [PATCH] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
>
> Commit f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf
> packet IDs") maps the RX packet ID buffers DMA_FROM_DEVICE. The
> BCM4364 firmware also reads posted RX buffers, so with VT-d
> translation enabled every such read faults ("PTE Read access is not
> set") and the firmware crashes and resets in a loop.
>
> ...



