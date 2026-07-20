Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF7E3AEF3F
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 19:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576953; cv=none; b=e/eibRiPEBCYb8K8uKQt/JilM79KB4QsR8a4KS9uK0Gxjc9hCNUbRZbgpif0XaJNFRXIrLe6gBnj6595JDEjBB8bgEcy9igBWXz1CqSH8YuRt/quDtVwSDTHY8sUFrnUj07Kg2DzHlty9fGBffgqZ+ErdWrvLmDSIIejQpP+v74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576953; c=relaxed/simple;
	bh=UgS0ACQKghCRnTSqEpsCpdjau8U0WER+rFa94nA8F50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNMxzcqjQ+HtlL3GCNYoh6QmL0RYrgbZaU+5PgzaKcVK5XlICjU4HzfyvNSjVclDiMbwJ2y0lW2CoR2MF+/xGFatg1VjPbCrScuCrEVyg8ng0jUSFUtLld1jJLmiHFKrzP6QaWg7a1fvPir5BVFY2uxtWGnjFSyPz/KgcMoGnc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=PK6M1HqP; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="PK6M1HqP"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-38759bcd877so9183643a91.2
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576951; x=1785181751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=myc/a7EGXCgUkCQNczBsGQYFLn7a2lftGxxjNjjCIDA=;
        b=Lk435gIQwG79dhBSpJLVpgS3ljmevmDDxGjd8lbcNNObuWpuL0yRcyrZ2tMsSYn9fP
         9fWveTIHSJ1wbqGQkvzuMtcpJN/KaeFmEDm8qFuO8VnGq0SgR+Vmo3BAaIH8Hl9mJMpT
         eCmcptZlkA2GaW1LfL5yjlWp8LMqHa9YYx5zSlEG9zpHR/2cP9kH9KCTz05tCjTQDCFM
         v1DIKViBAt1DrFP1VW69UWkvfvN4XEs1tObYGLBuQBdwJelwlgjkHrFx96l0J73b/QKm
         B7T9XSFe2QYu3Acp+NCORAss6w3JGSZJEn66rM4zCapUmw/I0hFkk4qzPCVNjLC7u8Zl
         wdTw==
X-Forwarded-Encrypted: i=1; AHgh+RroEZXYaWPZPHC9mCOMrEGz648ZbiGLe5WFWGkcfuhyWM5KRWfB4PKK7Ovm3p0bUKppidbLSY2Wt9pvPon1mg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxQTXYRxO/H4f0QtmZtQ2/M2KeEJyV3iX6wDOQLUU1M4EVLQKg
	azdkg6FtxS4dnpqeHW6/Qun101lto89eg7WznvTIJiXzjm/fbJ3cuzPTNngklpVMOz/nIZkdC/E
	f/xruvm2LFcSq1lTSFhRcr8Cso/F0IldANYf06uIK2J4a5zs6yeLQZjT5/O8oG9Xdnm3GnRA5en
	1JDyDs0XYS0DeTWyTkW2f1Q3BZ8tt8P8vFxVBpGd9qppDHbq5kxaploWDrQQXY9mH8efvUpyMQI
	d4tNCxHNXrlV8oeSkgCRCC7RZLa
X-Gm-Gg: AR+sD11PbxxwoNC4BB4MGUrYoXP77fVMpz7dSeLbTimvtu4ht7t+9kU+oWftrHmRCHx
	AdDkXy1qeSqC7mkBIsYR05RWOYT9z5RqaoR2SOS8YIzY8gFWvJqsEtB/F4OSgEgsUJd623+/zJa
	2oL2evX6hjIgF9bvQdKA08msktngiwzJWUnN2qY5iVdRn3ez0JLhWbcDbhft/NXh5FuVRxQS1/T
	sh2SkA9lcTWysVXL0VzpqeqDYNJ91WS8mhVhAGNceUfV3hWQ/xvkJDMaFoPYX62tO5SYU39+QAZ
	ys4u/meF9arLg/pqpsZjaWN4pBldmcFv00coo3sjyW9vZ6WPoSZFk63ZPQjDWWpPnx4t8qjxR3e
	p0ALvVdcdIgjjmhO7uN9OgimO6J4g+2veP3GedHHnZT0AtTBslAuEEZa/Ycn82vTm3Rl/zNGVku
	cwNOoxXm/oK7b5T1OD52LOFvpw70njtHxS64KCoR8=
X-Received: by 2002:a17:90a:d2cf:b0:37d:f983:7b5 with SMTP id 98e67ed59e1d1-38e4b434e73mr15488772a91.9.1784576950820;
        Mon, 20 Jul 2026 12:49:10 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-12.dlp.protect.broadcom.com. [144.49.247.12])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-38e92151a4bsm43609a91.5.2026.07.20.12.49.08
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 12:49:10 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c15fc5a1b7eso717298666b.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 12:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784576947; x=1785181747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=myc/a7EGXCgUkCQNczBsGQYFLn7a2lftGxxjNjjCIDA=;
        b=PK6M1HqPeTX6W9nkHkHeOWH534CdhBwXK9Bv5JEeRDP9VYxVM9RWer2wMIPfPNvmN3
         NsskOjDwI7qQjSxFl0WiUK0zfGEI9D8qxreQID0VgP0V7uj3FQZdnhT+zuirTECOx7nT
         BguQ7kXwOQBN0Q6XyFLRt0jlzIpfJrN04bT7s=
X-Forwarded-Encrypted: i=1; AHgh+Rr4qyabZrbEU2WjZis+WS6vyz7MJ3G6r1bR2jDoz0Qemg5sGW2yzDldV/z2hHApamiQTqhVZfuCVu0xp9yZ9A==@vger.kernel.org
X-Received: by 2002:a17:907:783:b0:c1b:1315:163e with SMTP id a640c23a62f3a-c1b13151cb9mr21283666b.29.1784576947332;
        Mon, 20 Jul 2026 12:49:07 -0700 (PDT)
X-Received: by 2002:a17:907:783:b0:c1b:1315:163e with SMTP id a640c23a62f3a-c1b13151cb9mr21281366b.29.1784576946853;
        Mon, 20 Jul 2026 12:49:06 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1705912972sm506543066b.14.2026.07.20.12.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:49:05 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Fan Wu <fanwu01@zju.edu.cn>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	kvalo@kernel.org,
	eddiephillips@google.com,
	franky.lin@broadcom.com,
	hante.meuleman@broadcom.com,
	wright.feng@infineon.com,
	SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH v2 2/2] wifi: brcmfmac: drain bus_reset work on device removal
Date: Mon, 20 Jul 2026 21:48:59 +0200
Message-ID: <20260720194900.2356442-4-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260718024353.3147201-3-fanwu01@zju.edu.cn>
References: <20260718024353.3147201-1-fanwu01@zju.edu.cn> <20260718024353.3147201-3-fanwu01@zju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Sat, 18 Jul 2026, Fan Wu wrote:

> [PATCH v2 2/2] wifi: brcmfmac: drain bus_reset work on device removal
>
> brcmf_fw_crashed() and the debugfs "reset" entry both schedule
> drvr->bus_reset, whose callback recovers drvr through container_of()
> and dereferences it.  The removal path frees drvr (brcmf_free ->
> wiphy_free) without draining the work ...
>
>  7 files changed, 77 insertions(+), 4 deletions(-)

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend
