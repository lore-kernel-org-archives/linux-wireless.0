Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D148851AEC7
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2026 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789750709; cv=none; b=c3d56gc6Eh6ZZCUaO0TT/ts4t8J7To6KKU8HMixMcfGKcpzyPfPK2H48g8dqegMTjr2Q2ITPa8ZvsH+WpN5SzkwSRvwa76SHm0SFkpGnoPiwTg9P9X4mLUb310UjNnNAzCuwRR+BStR/fvMSO8H2nr8UwvGoXuD70BVzQig5Wig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789750709; c=relaxed/simple;
	bh=PI0fSjfv9RDpwmW37XvxMUN1tTcL28UNyoWnsDlPA/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HapYZel0kMyfN2GfuVdxsUC9GS0Rt0YOkhuqP07CnJ+EjJQQiwfsazKcPXQQoEkwbehg1Q6BrIiJhk+pO+Ned0pttxsjhcX1NvGuhcUetqtTaFpOjdz2JlvexeqteTjJubc/ShiAF51dy8egs3qyvrZeivvvUwzJRVlO2t2W3Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=PipYMFm7; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=y+Ud1zT2; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="PipYMFm7";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="y+Ud1zT2"
Date: Fri, 18 Sep 2026 18:58:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789750697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2MyCQMj8/sklU8ITakuBXIPnwmX1H67oGiTKrAEZqGI=;
	b=PipYMFm7mdV5rcVYwq180sJE3MkKgga2wKLOH/31Eu0LMcabzwef5ToZD25u2nGN2ju1RQ
	bGLHG3JNKb2+6heM5UZh86JPaxRUnSYfFhWEcuqunmGml8xLK3WzVdJRAuNqKQDQDS0+pD
	JSn28etym46Dqkmb3kAIC1zCYDRjy7avC/HCXR0Sd1EzcX8VXX8BkkdN+I8Fcdc13wBi1g
	wz/dKNSQzHsiz5U2Fa2Ket+8htGBmmcOK55wMBdjaI6dOFL5rAxd23C27xL3C2FRT1ZIIN
	4cTgNkS2yFhZig041mbkYCqvc3yDrVciw2Gb7RxcYIzGPiq+Ru8Zmq5YHe0NCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789750697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2MyCQMj8/sklU8ITakuBXIPnwmX1H67oGiTKrAEZqGI=;
	b=y+Ud1zT23ozN0rhMjWyS8xrIie91uzlbRNnMFXZv9rwmBVIQmFYHePrZCPsxBbKjQ/bdjE
	mLIWxJi4am56cCBg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wil6210: Remove %pK and %p
Message-ID: <20260918165816.n5Kt2YkG@linutronix.de>
References: <20260918105632.pDhc9gIB@linutronix.de>
 <35e7ac7d-534a-4001-b076-56ca3e12bdb3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <35e7ac7d-534a-4001-b076-56ca3e12bdb3@oss.qualcomm.com>

On 2026-09-18 08:25:32 [-0700], Jeff Johnson wrote:
> > Remove the %p and %pK line from wil_print_.*() so it does not end in
> > debugfs' output (debugfs is not ABI so removing does not break
> > anything).
> > Replace the skb pointer with yes/ no.
> 
> NAK. debugfs may not be ABI, but it is a human interface, and you should not
> assume that a human debugger doesn't need the information.
> 
> I'm ok with replacing %pK => %p but not ok with removing existing %p[K]

I didn't expect that you need the VA and the skb pointer. If so, let me
update accordingly.

> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
