Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793641320;
	b=adaK7cU6UeWAqDeXTrP13D3p11QUzL/RYufpsEj5uCWMshpc7bDY1zQxHJg90j2j1Y8a
	 t4JWT+Watg2ANeR2hm39B5BmdK4rP3D3nlYmpakFbh98rEqC0sdBpVpHzVYpRqAW5mILM
	 KDhB7jXCCA1VfKrOsHv2ITOTojbk04vU29ZrK0JrHw4o3AWY1LRxHLFdYnWKSpH4iZpLs
	 Jwg8VeOm4fTIrHBWjQ9RsarxjBNlrTKuOOSbuurN2KU3QGfKtYrIo73jscKqsIZCFJnsk
	 /LmLBKWjk04fbWN7djF7dpQoVAntylSI6PgBr1eUwlEyi8KGFOSXjchdWHZBPZiEndA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793641320;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P7U+PpugZaoiRZ3RSWfO6SRjEMCP3t2/Q0growSjEko=;
	b=AblYhYAPlHNUNvk4zCPzIUcgyRCUUuI9lXmLk73D16eAT7K/xeO1h8vYvoVMqc37CSlo
	 Jb+WUL5tGSkE0BBstPLxZbLm9d5MWHFxeMduhGMlJzov/gMvETmi6v0AFWgEnLSNf9m9M
	 sdamrLB0BTQOxvq1KZ7o82SYLAvkssgxxdbWU4a1bAFmc+UFCyoJvNzKCeAtF60CzfoCX
	 uaKFVLobmZcD99qXfU7HsmyAgqxGXA5U/MI/kl9HX0ZrUXz9y8vX+sAeG4nCAWiJACsQA
	 DgVNv66dfiaj/UydvlP24o+tpq1y/mDhoH+CHXlRf1+dxGM13SzDqcbdgAslKjuPgjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gUohjNZo;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D51608440C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 17:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58D51608440C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gUohjNZo
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso2957972f8f.2
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 09:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793641319; x=1794246119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P7U+PpugZaoiRZ3RSWfO6SRjEMCP3t2/Q0growSjEko=;
        b=gUohjNZoEFog5+xCBv3q8ptD9jvH7QkhKGOlPFKzFA8vBZfyzKz801dxmzOJqOZYhA
         W5iyJW/oRg6yJryHayX5kZAf0D7BpNGtzYzJRHcVn9c4E/YvaTCSW2AxklQaIB7CeLT0
         7O2RC6Y35QjCveEW1ouAMjLUSm5N1mZV28evOAHVCOcTRiJVBASe3N+ensrtF2Ygk4ac
         WBSBZKwCyJtXSns1w2xD/mihpyOGTwby4fGU5Kl0yT4gBEaNJ7Cy6rZTlyON8aD5S3/9
         J5zcjsoppeUh01mu27rt/Gh6tFrjIQtkeKeQ4YxfhdkLqz0NXHzwL4olWSMRo6Vrj1Nu
         V/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793641319; x=1794246119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=P7U+PpugZaoiRZ3RSWfO6SRjEMCP3t2/Q0growSjEko=;
        b=BFy4Ri0z00WSVgGyiHnYfmJFS5Qt3xSamXkZt+kaUS9i+1rUvfmi5BbytZt7k42vS3
         wVPtf0OEHaBeadHOVSsXA3KE6ppHZ+u2acM5DjnTgtsDI34z1VxwzFBEjsIn4dVT5Xx4
         uyG9Cxv4PNtJx84is01JksXStw244YLHq+wNaS1eaPNRG0/2I7UIv90+9FfT/cv8U9Av
         YUjoYyXaIwQaIkVzuyvRyCuUHFu2pu7NWJwcNq+HgEML/HdVb3PVqHaAMU4d9V+JYvvW
         qAPUErz65BZEtOFrDPieJKI0xMy9K+yz0kGwMq+G+Q25A372gY92E+dwHDZ4CzPNOfGJ
         aAlQ==
X-Forwarded-Encrypted: i=1; AKwUvBwsPsFhwh1NuetLzuNpBIOWxu7+Ra8wlM/GiNkWQZcc/rrngC3wyukMSVFLU9pLdF97nOuPLOJ8BYofixbToQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z+2DUVlHaKjxmSCoH3x9xDmp2Ll/qmpiO9pZIPFpYISJ3RaTS+W
	1PlgqHdG209IXTbgSxWOZIknWyIKctTeTMnUOV0YtQXn5zppZtFugH7f
X-Gm-Gg: AYBFou0iLyarfp4WrsGlM/M5suyDZpwBKKt+ASuEsQ0xkJGT/ZTpk+3XXpuSGGxHhmb
	BJYd4VNvkYHPOkHY62CfxkwdAZmCRTUO/UaJe0DLJomoN3SXtVVuI1RhL0YBUaq6+svXdwhuNpk
	qruh/YwMPm9/88ync5YqHjXWaRO3WgodM6SaNZ5QCpBvzxR3KVXcKhkrKO9KYe/yBTPNcIYZbsY
	7mf14zfvxW4gUB0Fdm+IU102gY7Rhz1asgnPnHjE945N6XAqG9GGWScc7lMO+NUm3GppJJBs5xL
	bFdu8h6BA37dRX/B2cZjzKwH/dDp/0PlBxtA+PmaNMzmxbn32nvslBgOCGxEZAJvIveM8nA1gxC
	IqrjzJHpGk2KqKW1ztcpFgOKAW1pKk3WZ9lKr2flprfaYWBXpJzCYaaXqY6FuTB/6Esi94wR8do
	4h8SHeFFbOH3fiKZBsga6EGcZalcvjfA9b+kP7tzqqYPOQEhzr7EJ+SZlsq1I+TROpCnQRXzQQ4
	hzMNCCqzRGwsoPVOQlIpEPZ79WZ+xxeM21Zfpzu2da/rtdGjW8/IwFUkfBRGMeZgWqRQH29Twu7
	MdC+5u+BJ5dSvnxY3adCnYT06x0cB82YtON4lH+HiUsnbnmCpZehm77wl1e734+g37C6geGPkaI
	9guWhmXtCKaILEB9fOxlISuKPWhflKmDFIYji2M2/lq57ZVqxnAgcKxDaVzd+OEYVjzmAXc0vxr
	H3qpyoYOWxt1YlCJeaE8s9loGviPsVsHTb
X-Received: by 2002:a5d:5e90:0:b0:48e:2bf4:e7f1 with SMTP id ffacd0b85a97d-48e6e518492mr24296986f8f.39.1793641318418;
        Mon, 02 Nov 2026 09:41:58 -0800 (PST)
Received: from ADM-D9YH122JTV.home.lan (158-199.dsl.iskon.hr. [89.164.158.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3cesm23534081f8f.7.2026.11.02.09.41.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 09:41:57 -0800 (PST)
From: Goran Sustek <gsustek@gmail.com>
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH ath-next 1/3] wifi: ath12k: allocate the AFC memory region requested by firmware
Date: Mon,  2 Nov 2026 18:41:36 +0100
Message-ID: <20261102174136.37406-1-gsustek@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <98f13907-fe0a-4a8c-8ac9-3be40edcaff5@oss.qualcomm.com>
References: <20261030220824.915760-1-gsustek@gmail.com> <20261030220824.915760-2-gsustek@gmail.com> <98f13907-fe0a-4a8c-8ac9-3be40edcaff5@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 11/2/2026 4:06 PM, Rameshkumar Sundaram wrote:
> In that case, shouldn't chunk->size be cleared when no memory is
> allocated, or should the response only contain the chunks that were
> actually allocated and assigned by host ? (see
> ath12k_qmi_assign_target_mem_chunk() which updates ab->qmi.mem_seg_count)
>
> Allocating AFC_REGION_TYPE while AFC itself is not supported by the host
> looks wrong to me.

Agreed, thanks. The comment above the switch already says that the host
does not allocate memory for regions it does not support, and v1 went
against that.

v2 will not allocate the region. It names the type, answers it with
address 0 and size 0, so the firmware no longer holds an AFC region at
bus address 0, and logs this at debug level instead of warning.

I prefer clearing the size over leaving the segment out, for three
reasons:

- The firmware already treats a region with size 0 as not provided, so
  the answer has a defined meaning. A response with fewer segments than
  requested is not something I could verify for the PCI firmware.
- It stays a local change in the existing switch case.
- Compacting target_mem[] in the PCI path would shift the indices that
  ath12k_qmi_alloc_chunk() uses to reuse memory after firmware recovery
  (prev_type/prev_size), and the free path walks mem_seg_count. That
  needs extra care to avoid stale or doubly freed entries.

Tested with WLAN.WBE.1.6-01243 on two QCN9274 boards: the firmware sends
the memory ready indication right after the response, reaches firmware
ready, and both radios come up and serve clients, with no firmware
crash. The AHB path already drops unknown types instead, so if you want
both paths to behave the same way, I can follow that in the PCI path.

v2 changes only type 10. The default branch for other unsupported types
stays as it is, because this firmware requests no other one.

Goran
