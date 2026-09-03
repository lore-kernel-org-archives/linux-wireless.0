Received: from mail01.salmtek.com (mail01.salmtek.com [65.108.149.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC80B4BB5D5;
	Thu,  3 Sep 2026 15:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.108.149.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788447635; cv=none; b=ZwXyzKAiLqOwzHnf79ylCw4iG6zTgugKgaGMi90pQMIIJU8J0zXh2lvcRs6UZD7Ydcb0XhbwmO7/Q2AE+vC5Iz17fFzD0hSYljtIjQ8OSTbVEANrUI/1/NeQ8QFFXMAunNp86vTG7+R+aOd15nLhnKFOUO3rew1nSTZMEYUwF7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788447635; c=relaxed/simple;
	bh=Knp04GX35Uv1sDTbNkONfQcmM0uAfalH2x++UFeVV8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fALriX5FfrOByVok4yfTFvR6Ie/h1oSDEXxuMUVWM027EgaqaEuMO/NRu4jbAIm2kLg6VqZxbKWg0mTUwEHNynfX9L/1LAdOsedIrcjlx0fBbPiYGP5FSB+jo7/DQpQVjYKvZsojZSl0I/SWn4GFGbSRFia+foc9UcuumcwGAKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salmtek.com; spf=none smtp.mailfrom=salmtek.com; dkim=pass (2048-bit key) header.d=salmtek.com header.i=@salmtek.com header.b=dfD8eQ8R; arc=none smtp.client-ip=65.108.149.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salmtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=salmtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salmtek.com header.i=@salmtek.com header.b="dfD8eQ8R"
Received: from mail01.salmtek.com (localhost.localdomain [127.0.0.1])
	by mail01.salmtek.com (Proxmox) with ESMTP id D6AE440925;
	Thu, 03 Sep 2026 12:00:25 -0300 (-03)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salmtek.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=selector01; bh=1J5YWfIaliRnkR
	MI/8B08F7xEXXPvDk24J81082ruWw=; b=dfD8eQ8R+x6IFOQsNEcMAqLNcfmXOi
	R3ytSap652IMxEmJeV1bWZP4vJl1t56v4qomSiW6l/+t2+S8R76McKYmUVn++4yR
	iz8GRMGmxjDF/J3ambzLBMf10OtBVaAR174wt/M17OZG3Dbpn/StvFHjk/a2K0uR
	1FnrKg9Tb/bnaezI+YhljPphQHRPBMk8mWLw998HDKz4xXI411n1AKcO8ZJu3Cv5
	Pdo0shEpU4HPOcRd+5OlAOFIwwBKFCOzfbL0pISjZT0nw8wsq+QYDJa+EoCnBhlx
	uMgnbj5EjGUUO1d+itkpVVfx+zVMGIKb7ywUTfxBSpEbjcA0pd/EHr/A==
Message-ID: <376dbf6f-ecda-49ca-a7c0-af2a4077e945@salmtek.com>
Date: Thu, 3 Sep 2026 12:00:06 -0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: ath12k: flush REO queue extension descriptors
 before freeing the qdesc
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, jjohnson@kernel.org
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260831151011.2336305-1-sebastian.salmhofer@salmtek.com>
 <265ee3ce-b953-4cef-a34e-c2f51a86ec26@oss.qualcomm.com>
Content-Language: en-US
From: Sebastian Salmhofer <sebastian.salmhofer@salmtek.com>
Organization: SalmTek LLC
In-Reply-To: <265ee3ce-b953-4cef-a34e-c2f51a86ec26@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/3/2026 5:07 AM, Baochen Qiang wrote:
 >> The faulting addresses always fall at offsets 0x100..0x580 of a
 >> retired qdesc and never at 0x000 or 0x080, i.e. exactly the ten
 >> extension descriptors and never the queue descriptor or the 1K bitmap
 >
 > the queue desc offset should be 0x000, and the offset of the first 
extension descriptor
 > should at 0x080. However the IOMMU warning starts at 0x100, which 
does not make sense ...

You are right that under the driver's struct layout ext_desc[0] sits at
0x080, so that sentence of the commit message was an interpretation on
my part, not an observed fact. The observed facts, across about ten
days of logs and more than a dozen retired qdescs, are:

- every fault falls at an offset in 0x100..0x580 of a retired
   1536-byte qdesc (bases are 2KB-aligned from kmalloc-2k, so the
   offsets are unambiguous),
- no fault was ever seen at 0x000 or 0x080,
- within one qdesc the faulting lines are 0x80-strided runs, sometimes
   the full 0x100..0x580 sweep, sometimes a subset, and lines of one
   qdesc can be written back in separate bursts minutes apart.

Two explanations would fit that pattern: either the hardware expects
the 1K bitmap descriptor directly after the base queue structure (so
extension descriptors effectively start at 0x100 from the hardware's
point of view), or FLUSH_QUEUE_1K_DESC covers the first 256 bytes of
the queue as one object. I don't have documentation for the REO cache
controller, so I can only report that on QCN9274 hw2.0 with
WLAN.WBE.1.6-01243 the single 1K flush demonstrably leaves everything
from 0x100 upward dirty. Could you check internally what the 1K flush
actually covers on this target, and where the hardware expects the 1K
bitmap? I will reword the commit message to stay purely with the
observed offsets in v2.

 >> The writes are triggered by later REO activity, typically
 >> a new station association, so they can occur minutes or hours after the
 >> memory was freed, and the blocked transactions stall the data path for
 >> several seconds.
 >
 > then what happens? the new sta association succeeds?

Yes, the association succeeds. The IOMMU blocks the writes, so nothing
is corrupted; the user-visible symptom is that the data path stalls
for several seconds around each fault burst, for all connected
stations, which is how this was noticed (periodic freezes of
latency-sensitive traffic). With the fix applied the stalls are gone
along with the faults. Without an IOMMU the same writes would land in
freed memory. I will make that explicit in v2.

 >> +    while (off > HAL_LINK_DESC_ALIGN) {
 >> +        off -= HAL_LINK_DESC_ALIGN;
 >> +        memset(&cmd, 0, sizeof(cmd));
 >
 > unnecessary cleanup since all required fields are refilled in each 
iteration.

Right, and the same for the one before the base flush - cmd is
zero-initialized and both sites set every field the flush-cache
command reads. Will drop both in v2.

 >> +    if (rx_tid->tid != HAL_DESC_REO_NON_QOS_TID)
 >> +        cmd.flag |= HAL_REO_CMD_FLG_FLUSH_QUEUE_1K_DESC;
 >
 > HAL_REO_CMD_FLG_FLUSH_QUEUE_1K_DESC is used to flush all in a single 
cmd. since we switch
 > back to the per segment flush, do we still need it?

I kept it deliberately. The per-segment loop covers every 128-byte
line from 0x080 upward, and the flag makes the final base flush cover
whatever the "1K descriptor" object is, so the sequence is correct
under either interpretation above, at no extra cost. Dropping the flag
would restore the exact pre-b706fb4e580b sequence; that may well be
sufficient, but if the 1K-window queue is cached as an object larger
than 128 bytes on this target, a plain flush of the base address might
not cover its tail, and I cannot rule that out from here. If you can
confirm that plain 128-byte flushes fully cover a 1K-window queue
descriptor, I am happy to drop the flag in v2.

I will send v2 with the memsets removed and the commit message
clarified once the 1K flush semantics are settled.

Thanks for the review,
Sebastian

