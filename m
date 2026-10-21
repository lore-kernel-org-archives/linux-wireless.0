Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571956;
	b=2lkl4sZgePlVNQwRsgiL0JagXmZqPL2oQWgnE27XWBG0Dfb2wztq1GrXPVTgNoOFWGKL
	 VHRxbah/fpe269iHkX10OpYiZVmjmMM0f4Nx11w+9sgriVSG1JDDbNg/+Nq3EGUZTx7CB
	 ePtyrfXyBPxNqC9whcGYkJCQe4jN0OnmTmvldYlq0tumm2I0ekBfbE62Y8ffsCAeIl3QN
	 C76JaaitLi7ykAoiHPh4DnEKi5HxG+djFo3YB6vYHLjQbsa00eLjQ/Lqgp3CFZzi+t69x
	 9g8bq8eHo1e03mBte13uD3Jhwnj9nLSmvEjIOsN0EpbZYcvS1xwfVaT5dlOawmsl+Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571956;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=YRXwFSRhdWp/W2rW9Y/SDS5xAnZEmQtLtB30oGZWhEw=;
	b=JXMwEa+Zq+PZmBZ4x/E7hZO3RtNCHEmeE1pPqta8PVvp6WwtoqrN7g3pCQaWf+7z/VrI
	 QnL80Wpb+69mEH+sKm9TehoCt44CB9Yxu5grH+KyuFWhVI0ddtsdu/E9PsDmGJ01Jzh6l
	 w9pKLAsGS2akK2z/XECmF3KSmA9LtJDblmILb3YICPV6jk8twDLDDP7A/Tqm/dWwxGZoh
	 B8J3ALmBCyeC/h6ItA9r36FBLMl8/ZhSUy+PSL1XZ/Tg7ld225cZSQPfo8YLqJZkYabWr
	 ro37IRRXePbUjwLqiMwSUMCnxymRxH5uM8PWZegG1teEFgde9b/Q9iluTOFl73RduYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=IDbwaxDQ;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1D4606A31B
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 08:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF1D4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=IDbwaxDQ
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cc4ca696de6so224837a12.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 01:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571955; x=1793176755;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=YRXwFSRhdWp/W2rW9Y/SDS5xAnZEmQtLtB30oGZWhEw=;
        b=17QFGb9NZD+/1aA+zXY20q+Fw0cfGdqbWMCuhfxVn8WruMyRTmuoiJVbqrqRRrNSGR
         UcokerZPC29D0NdLOMIuJxd+7MPrFNGV4yDR+I+Y6fFgM98ORY0mZEjchCrSYcXBINSI
         z9wJl0pGlN0GbHKzAjZhm1rbiguSQDY4ehJ6fklHBJYl2nJyHzWe9CtuoyPfLgfQoQTc
         BPOGV3d0h/xEQYacL1BeYx4fwgXVS390FgFK+fp/Iaw9a36MkdXTxDh5jtUFclzEhzUA
         1t+etTpaK4solZ7P6wO+66sUoT/hKI9vDUCEmHrnsNyhJ7sSoQQVehkgLZKOcPlZ8usp
         t93w==
X-Forwarded-Encrypted: i=1; AKwUvBzi2XtK1adnrscizJDxbPW9XqHrVxbqB6XoO1VE5xjOP0ErsGxHXMUu3zNqUaG1B/QDBZw4r+pJotBFCJai/A==@vger.kernel.org
X-Gm-Message-State: AFq9FYK8mR6z7kCPycnlGUcNPYgoxvmNAmSWKljpROUG3LqanDeY2U53
	SGyZ1Kg7GP0xS35eme6w+Imsrd2E67065ITFR0jR++/vsqtMSuFFsg1dDP/BPB2Z3vrr7GQDcCu
	hyHvzx7Ys5M0Wq5aHxn56KMnaJ4CexVT2aW/qeRJkEXf+9j4AZ+8X+YfS7obYCKH3arDfmB0P7e
	1eV9u9vt13oZkLSgIwGJ10CtXQG4uTX4v4/ebhv01jHp3cNK586FWjhlrAG04PT+rH3wpMIjo/y
	18dptajkpe01hLjwNzGG/9yGtlK
X-Gm-Gg: AYBFou0EEcNvly81/MmQd9OXbJf/AMuh/B4OZ4VWcIMG+Gkzv3oYwadpUDH7mKgSfj3
	UN6dLKdEahyHwrjKQjwG+00RMVyXElaIL6tIDKLPmZnqyj2apMcoHtm4QB5IDIgI8TKo1hX2b3V
	MQfBf4s8p9GZb7Z08KhIYh1HJD8qZ/eqb4REMcMqiPr4YeP0lueQEJpY7IOA1R6uS8yzYo2EaUV
	yV6clPo7NE0WI+AHUxHdPWw/5OBvGazim7n+5HyRmXFo8FTMuZDE/PHhGiczc48J0VR299Mzwrd
	EYADzJgnj4124PtBg+Ca8KXFyUiaBW4+UAuvjUKrQW1s1AJzgehtMUhRh73QrYlX9prQ5eQClt9
	IYJMXLgrLD0UdouvythsZc/rYIFmtDuvUTKHiIax9R6V+HYCUTy5hKoH6kj5JIfDlsuzZ7Mjiwo
	zuXJPPSLGKY9ETkgIZRlrWHojAumIIvEUBf++TLik=
X-Received: by 2002:a17:90b:2791:b0:3ac:9e5e:d1a9 with SMTP id 98e67ed59e1d1-3ad86ee2d4cmr1131311a91.20.1792571955224;
        Wed, 21 Oct 2026 01:39:15 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-17.dlp.protect.broadcom.com. [144.49.247.17])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ad81f6dae6sm1459855a91.4.2026.10.21.01.39.14
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Oct 2026 01:39:15 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93caf7856ffso125876485a.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 01:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792571954; x=1793176754; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YRXwFSRhdWp/W2rW9Y/SDS5xAnZEmQtLtB30oGZWhEw=;
        b=IDbwaxDQK/xijGs3wHKjtx63yFMOgLpP0oEegSaDQt1Y11QhUD2o1IwfD3FoJsoJZr
         Wr423BpDVZ3TxOtwBzHa1Z2LwXSGMLSsQskc/lg3hoNHzKvWCzaStKXAy12zxVKrCxZm
         u9qIlKjKVepva2GATkkmtTZnE8F5dtGgB55jA=
X-Forwarded-Encrypted: i=1; AKwUvBxcqNX+9Bl75XwsIpJf7ttx5CbFZ14OXnRJlSX352h0ssqxZlphvX0YNju0CtahmdS0tFGEKlhXHl7f+Ctpaw==@vger.kernel.org
X-Received: by 2002:a05:620a:31a9:b0:93f:25c7:a4e1 with SMTP id af79cd13be357-93f57f707e5mr288326485a.26.1792571953673;
        Wed, 21 Oct 2026 01:39:13 -0700 (PDT)
X-Received: by 2002:a05:620a:31a9:b0:93f:25c7:a4e1 with SMTP id af79cd13be357-93f57f707e5mr288323885a.26.1792571953265;
        Wed, 21 Oct 2026 01:39:13 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d9af50sm195498585a.8.2026.10.21.01.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 01:39:12 -0700 (PDT)
Message-ID: <40118d49-2e79-45c7-8e50-58e05a44d24d@broadcom.com>
Date: Wed, 21 Oct 2026 10:39:06 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: intel-iommu: DMAR PTE Read fault crash-loops a PCIe wifi device,
 v7.3-rc7 -> v7.3 final regression, reproduces on one unit out of five tested
To: Jason Perlow <jperlow@gmail.com>, Baolu Lu <baolu.lu@linux.intel.com>,
 Aditya Garg <aditya.garg@linux.dev>, dwmw2@infradead.org
Cc: iommu@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
 linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com>
 <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com>
 <74570358-8085-4767-BF76-D865CA95853E@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <74570358-8085-4767-BF76-D865CA95853E@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Please respond inline. No top posting.

On 21/10/2026 09:33, Jason Perlow wrote:
> Yes, done. rc7 with intel_iommu=on on the same MacBookPro16,1 shows
> the same fault: 95 DMAR faults, each followed by brcmf_fw_crashed, in
> one boot. So no rc7 -> final regression in the IOMMU code.
> 
> It is a v7.2 -> v7.3-rc1 regression in brcmfmac, from f0ba5fd51ff2
> ("wifi: brcmfmac: Set DMA direction for msgbuf packet IDs"). RX
> buffers are now mapped DMA_FROM_DEVICE (prot 0x6, no IOMMU_READ) and
> the BCM4364 firmware reads them:
> 
>    36.512689 map   iova=0xffeff2c0 size=2048 prot=0x6 (brcmf_msgbuf_rxbuf_data_post)
>    41.110125 DMAR: [DMA Read NO_PASID] Request device [0000:05:00.0] fault addr 0xffeff000 [fault reason 0x06] PTE Read access is not set
>    41.139317 brcmf_fw_crashed: Firmware has halted or crashed
> 
> The fault comes before the crash. Before that commit the direction
> stayed 0 (DMA_BIDIRECTIONAL).
> 
> Thanks for the pointer.

The only DMA related commit that I could think of was indeed the DMA 
direction change. Hope restoring DMA_BIDIRECTIONAL fixes it.

Regards,
Arend
