Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0098248C8DC
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 06:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392725; cv=none; b=GAL1U34bCugKiuvCF+ehfvRFo3gJ+C8dhKcB8LTUR7t3F6ACyp/vj5TO3Ouy5tlz3x0YPdi4iEH4OrD53DnLLCkZhxcLYGc5/5B4aYGjTYwCOLwP/mRxh/MGT8AjNlghKevFjTw+AarEJFuFk23B/j4y+qCisjZjAaaulo7Nus4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392725; c=relaxed/simple;
	bh=548r1GrKvVSUOSty0zRzACYcahz3k016i7F21JY6aLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBiizihqf1K5Ge+LPv4DLNPgmsH7cd8KefPQKHXQah5nm2w7XMm8KaeQVS9gdn4gxE3VmWgqyT5W2PdEoyVEmI6oGZ7WpVmTH4o6p+xMtnUvU642rTjQFqT7+ji0sbb1+VNvx33BZO6psrKLcgMTxzNXGW+9zoWIv6Z0QRxjimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=JY0LYuNM; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=WncQAeP0; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="JY0LYuNM";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WncQAeP0"
Date: Mon, 19 Oct 2026 08:51:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1792392720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=548r1GrKvVSUOSty0zRzACYcahz3k016i7F21JY6aLM=;
	b=JY0LYuNMQaRD8NV9o/gZfrX38jHmIiwswdgnEigaumTbr7V74BKZTou1ggyG2gyzJErCLR
	dBlDflodUvFWfx3ztxB44Cvmbl+98TU35LoLVyLlj1CWl4OBkJUTSxsSjhCxXDC0m+sn84
	7J4kvj3tiaibBV0b1zI2NtmlIvU/SLZdCy8yi79DFKqFsJc36u32ho33LBd8RJt//wxjhk
	TOqr4z6syOrwp3XWorh2Rh/Ju5stQbake7CYW3pfgdku3f+Irb6XOXbRNqtWkTP63WyUCu
	nxk3Ym7qYAyaDKhhhrNrMQvuWUJuXEim3lB1fuIu6b1vOUCDr9gunHqqa6YR4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1792392720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=548r1GrKvVSUOSty0zRzACYcahz3k016i7F21JY6aLM=;
	b=WncQAeP05ACZwjC8LZGYAcwumhYX49pKJlfdGSP6ri3Pier5CSJGzJ0j41u3jnK78sbxrw
	2BozTKjr+iPB9vAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wil6210: Replace %pK with %p
Message-ID: <20261019065159.RseJdYdR@linutronix.de>
References: <20260918105632.pDhc9gIB@linutronix.de>
 <35e7ac7d-534a-4001-b076-56ca3e12bdb3@oss.qualcomm.com>
 <20260918201145.kQDy1UrD@linutronix.de>
 <8444a9b6-b197-4b64-9afa-d3741c2a85e2@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8444a9b6-b197-4b64-9afa-d3741c2a85e2@oss.qualcomm.com>

On 2026-10-17 09:04:00 [-0700], Jeff Johnson wrote:
> No need to repost to address the nits -- I'll fix them in 'pending'
Thank you.

Sebastian
