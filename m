Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEADB4D6C24
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 08:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790672398; cv=none; b=L9gmGiM9KeBkL6h2El5jY6lS590BQstUGBaHjA0xHBMoABCXpOXMuXW0McnDyt8YUvwqwNifc+a32alVfd4F/0zC+qN+VNkIb9SLNZ2k2FcXeYFLR7nGAISPcrMMe4W178fwwW2LVbV+BRUoI7zDkC4YBPxCF7lRsn1tfdii8iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790672398; c=relaxed/simple;
	bh=IyspYJuvnDQiFffor9pIZti6hii3F6jxoMPcS2SzFIU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iZCmkwssnkHyoXZNKO33gFfSwJ7ZdKMEKjo+j9Aaxfb42LnXUCkpxwlp6GnAp9MBZ8srVS+VVj3OJM9U346GwrkuFFf6UxzPqXj4AmzqkdjajqMwq6YjUsaMKXGM/xW2CsWtIkPZpgCMyDE33D8fwHZ/uEtqZJBfEDX+2tnfglM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GAEVk6MU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IZmgmQCe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GAEVk6MU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IZmgmQCe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790672395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Y/oFOa1oxhQ1GdKVJmuNjJ216LwSgeUy79De2Uv5lM=;
	b=GAEVk6MUdaHD+woVWLegCArPhmc6TU7XFHJSFRwb6Sm9MztxdCzguw66O+CnASyOJ/PPGv
	w38SD/4POIKlc0Ew6WLqclG3CTuGFBoJ3Ty5azM15bc3GHjsPAxeJm1u2y+AelZ17Zh+tu
	nHw6cPhRLu2trkcRV3InP5GOKMqat3M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-MqfJnnShNiGcR_6ADyfROA-1; Tue, 29 Sep 2026 04:59:53 -0400
X-MC-Unique: MqfJnnShNiGcR_6ADyfROA-1
X-Mimecast-MFC-AGG-ID: MqfJnnShNiGcR_6ADyfROA_1790672393
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e65ecd557so26321515e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 01:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790672392; x=1791277192; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Y/oFOa1oxhQ1GdKVJmuNjJ216LwSgeUy79De2Uv5lM=;
        b=IZmgmQCeFtm8hBMCzhd1u8jKfG2LubfFaxq+LRmLnOhkoCBczLZtRSn+Gj4YQg4ldv
         umvXBHWjYZFBW7JI5hbjKtgNdUzYYLscPdlAKNfHvLDy8scqAuAg3+SQFKojl7HJ3qOO
         nMVM6bPaXcZrpjQ3xftifPovQixQGVAmPZSj3pulwDC8ckHXd9hxKs1sw39ufmYddTvx
         jmoN5lFt5nuttTXRfzZ9MFdIchuTvpyRO3yUKFvjggXOoOfRkOdV7DDT7LlOnncA+86B
         DqrJD2R5PYDV85JHlYnpootF8/wF2J3ytevTLm+s9HZve+MyzE94d+WBfb3wJCQ4qlCI
         xqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790672392; x=1791277192;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Y/oFOa1oxhQ1GdKVJmuNjJ216LwSgeUy79De2Uv5lM=;
        b=vy05OQxKiT9XdA67KK0zWQDsyNh/ywA3MmYVZcho0SnG6yv4/5V10bj02q1RxSEY36
         BA50ZxXXA4qtjJFQn/uhm6exBdLLBOJSTM9INNF888Xjl4vEAklo0Q68enFSj9++7GEb
         UEoegMKMhUZV4ATZE/0S6ONZgGkOzVy7/uj8uXt4IVr/3HXDYIEeIhZNqF5C+crdnWEg
         Nef+H6oZhfeXBKaEmQXKhL9QSkT91OWlGAJgbIbV5YcgqyNpcna2FaxVA+zDHK0Ft6cy
         K+R3zv0MlPZk9gUf/hPt8aOdm4VkIYpXvJfTEL+qJwo1rJ6dsJmMZ7SdWTAy6mrOc2xw
         CJAw==
X-Forwarded-Encrypted: i=1; AKwUvBwhnpyqzWrP1G+AMtAMW/MT/sDzjYChMCe40zuMnVEgR3kfyoZU7VeRFzfKmSg4pspEm5TQ4NkrhT+T8L7Qgw==@vger.kernel.org
X-Gm-Message-State: AFuF++n7AyXWabYUJdAblBN6Si+68TrkJBaNmVVX+BxK54jpxFMIHre+
	MKZlefnJkF1w7I4CrB4M0PIeieW4pyf0tr/w9gLEecO7ABFvkb5Mu5dNxnyeiKTlGSatuDxuotg
	vl8BQ+754ElL4TexHMgxdVvrvEcaG1aCZRnQNbzQAGyA7lHWsuCT31NsjAhG7x1LnbZhq
X-Gm-Gg: AYBFou0WZaJS56EcNAJUknv01CKYtrGLkNUaY/nReKRZQvEP3qzmtL3GbsWBLJqJlE9
	4JO98JCsjUiFaO4aNgSpRLW0LNiGd7VgLTkSwT+toRvqAVNhamop4lhuSRTJ7sxI1xoSVXnxXQI
	h8mqUvSomWC65BzgN16rQIBFzaXRukyYvta7A+34W/Fnh3XWyQ3VxkSStSqhYmOM7emQv3KSaRJ
	lKbnu4OS2e1eSephjZJW0p2wy9cgCw/maGYniTbv2F3pHjar9sxvLkBOqWufaYwvQQz8nlx+gzS
	s2wsDW6CYFRjgMVom8jS6P53kHZ0kqSl+0SSN3lrX3FtEy1MJJKPLUZDEPzwi5TN3f/64l7+0a8
	scdTc1WWBnJy2KaO5o2jcbD83sH3J+EvgbCD2tP6t8zPq3wRyFNlYQxhEdC3C4DVlPDpi5gGD0Q
	==
X-Received: by 2002:a05:600c:8b33:b0:49f:f9fa:fcfe with SMTP id 5b1f17b1804b1-49ff9fafdccmr148517425e9.13.1790672392628;
        Tue, 29 Sep 2026 01:59:52 -0700 (PDT)
X-Received: by 2002:a05:600c:8b33:b0:49f:f9fa:fcfe with SMTP id 5b1f17b1804b1-49ff9fafdccmr148516975e9.13.1790672392160;
        Tue, 29 Sep 2026 01:59:52 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a00cfec770sm65459555e9.8.2026.09.29.01.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 01:59:51 -0700 (PDT)
Message-ID: <4f03112d-e5c5-486b-8317-1ecc1aeb6636@redhat.com>
Date: Tue, 29 Sep 2026 10:59:50 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/4] net: qrtr: Add support for using identical MHI
 endpoint devices
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 Bjorn Andersson <andersson@kernel.org>,
 Chris Lew <christopher.lew@oss.qualcomm.com>,
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>,
 Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>,
 Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
 Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
References: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260922-qrtr-multi-ep-v3-0-c00831e88957@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/26 15:41, Manivannan Sadhasivam wrote:
> This series reworks the QRTR driver to add support for using identical MHI
> endpoint devices at the same time. Currently, QRTR driver has a limitation on
> using more than one identical MHI endpoint devices like QCS6490 or any Qcom
> Endpoint device making use of QRTR at the same time. Because of the fact that
> these devices will have the identical QRTR node id, they cannot be used at the
> same time, on the same host machine.
> 
> This limitation is a blocker for running upstream kernel on devices like Qcom
> based routers as they often have multiple identical WLAN Endpoint devices
> connected to the Router SoC.
> 
> This series supersedes the following 2 series from Juha:
> https://lore.kernel.org/all/20260915054207.2513877-1-juha-matti.tilli@iki.fi
> https://lore.kernel.org/all/20260915074135.2567411-1-juha-matti.tilli@iki.fi
> 
> Compared to the series from Juha, this series simplifies the multi-endpoint
> support by computing a unique node id for each MHI endpoint and uses it for the
> internal QRTR book keeping. This ensures that even if the MHI endpoint devices
> have same node ids, the host QRTR will always use a unique node id for each one
> of them.
> 
> More details can be found in the individual patches.
> 
> Testing
> =======
> 
> Juha tested this series on multi ath11k/12k setup by backporting this series to
> 6.6 kernel.
> 
> Merge Strategy
> ==============
> 
> Since both QRTR and ath drivers are falling under the networking tree, the whole
> series can be merged through netdev tree.
IMHO doable, with Johannes/Jeff ack.

Anyhow the clashiko provided feedback looks relevant, please have a look.

Also please note you are supposed to react to such feedback proactively.

/P

