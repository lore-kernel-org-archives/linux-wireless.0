Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792603684;
	b=j19W5TY657aHHOxOgYNaWYmaI/Mi/oWqifZRcOqDJSjsfSTFcv/mx7iPRUyu33DocPD2
	 8gs1nnGIzzDl2xreVJ6Yz5e2BwQ6LpdKrMeq9Zqco5m3KjM8v8xKSViZFa4saU+elQUba
	 VSmpNcX3CMV0nJ5mw48/1OEHtUr61rDxp8DjbAzk31Z5hPWO3sOjAWBjy9I2Txq3CSjDp
	 fDS7SU8GbBVXH/KzHA2/cGRf4RKv0gVwa2GksqjQIFqXru+OLn17vZeU6hjLnZtd7lHcT
	 CePFpuWDlfOJZcj6XG0qPbDio26X5ZhMAS08CNu/KCQffAWZ8qo4vcidHWQtsR4gsuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792603684;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=QyTwK1bJaEhML32mAdjqWfcv9dKI6fIKk2BTqmlpHy0=;
	b=XyGIu/9dTQgVJzn22O4OrF/dM1xmdZuU2N5XrD0KROKxvfLgddNV2fgg5HwZk+KEeV8x
	 goAeDZF1CmToHYpJagIDscG3AKyRHvmfYlcGAenUNS9jrfpYaVqBYyjE4S/3T4r5GACwP
	 Z/9TEIhdYrPhIGdO16n9izphlwiNaUo9aUCrFANTD5J7Y20WNxhsBv4i3Jk/qtGKh4oId
	 ZFo8HpqkWps3/SLJIspC6cPWDtr/XG0vf7pbBMssAIGQT6vnTiKFw3x8L/ylqDtVbWkWP
	 FXnNhXcZbDAX+IDKINGnlbDSooTTTE/XuZnX6IIOqqunayLO5Ieu1Wi4zs2H6bB/GtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m5ijV6sx;
	arc=none smtp.remote-ip=95.215.58.26
Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D366606A324
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 17:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D366606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m5ijV6sx
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ciscCx144xO9gJ+sXlyrNhAmAkKLhcAfZhaVrPjiP4Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792603681; v=1; x=1793208481;
 b=m5ijV6sxWwzADk3TdXJL6HkpQBxXOSz7tACjt212+ZMeh+CYUzKgwqnKyJXhtixFbrMnhwyO
 h//vxx3rvlx8pWRhVOBKm5sdhwLowEWxRAAS33jE7ILQDXXPIXUJwXklaqZcqgtq5cFXoNalbsW
 5tlnBdUKuYLHO2Cs25AJs2Nk=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dbad4ac4184ccfc0;
	Wed, 21 Oct 2026 17:28:01 +0000
X-Mizu-Trace-ID: dbad4ac4184ccfc0
X-Migadu-Flow: FLOW_OUT
Message-ID: <428ba501-e6ce-4be1-b4cd-adaba4c0c12a@linux.dev>
Date: Wed, 21 Oct 2026 22:57:54 +0530
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
To: Jason Perlow <jperlow@gmail.com>,
 Arend van Spriel <arend.vanspriel@broadcom.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, dwmw2@infradead.org
Cc: iommu@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
 linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
 johannes@sipsolutions.net
References: <CABZrw2GfC8SEPiGOUD42um57nKZAghjHz8N1DhMsw8sOC7OAxA@mail.gmail.com>
 <2c840dcf-4292-4579-a62d-f9766b7cb780@linux.intel.com>
 <74570358-8085-4767-BF76-D865CA95853E@gmail.com>
 <40118d49-2e79-45c7-8e50-58e05a44d24d@broadcom.com>
 <EDE0E273-27FD-4069-9129-FCBB48D12ABB@gmail.com>
 <1a15f52cf68.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <20F90036-F53C-4490-B27A-DFD055DB22E8@gmail.com>
Content-Language: en-US
From: Aditya Garg <aditya.garg@linux.dev>
In-Reply-To: <20F90036-F53C-4490-B27A-DFD055DB22E8@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 10/21/26 10:34 PM, Jason Perlow wrote:
> 
> 
> 
>>
>> I would prefer the above in proper patch, but it's up to Johannes.
>>
>> Regards,
>> Arend
>>
>>
>>
> Patch below.
> 
> -- >8 --
> Subject: [PATCH] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
> 
> Commit f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf
> packet IDs") maps the RX packet ID buffers DMA_FROM_DEVICE. The
> BCM4364 firmware also reads posted RX buffers, so with VT-d
> translation enabled every such read faults ("PTE Read access is not
> set") and the firmware crashes and resets in a loop.
> 
> Map the RX pool DMA_BIDIRECTIONAL again, as before that commit. TX
> keeps DMA_TO_DEVICE.
> 
> Fixes: f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf packet IDs")
> Cc: stable@vger.kernel.org
> Tested-by: Jason Perlow <jperlow@gmail.com>
> Signed-off-by: Jason Perlow <jperlow@gmail.com>
> ---
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> index 069ba70..ff47d48 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> @@ -1639,7 +1639,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
> if (!msgbuf->tx_pktids)
> goto fail;
> msgbuf->rx_pktids = brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
> - DMA_FROM_DEVICE);
> + DMA_BIDIRECTIONAL);
> if (!msgbuf->rx_pktids)
> goto fail;
> 

I've submitted this patch properly here: 
https://lore.kernel.org/linux-wireless/20261021172238.10004-1-aditya.garg@linux.dev/T/#u

