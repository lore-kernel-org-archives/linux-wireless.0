Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006176;
	b=OZhA3KE+Tzow6IVTv31fozKmpy5trHoqPq87MfydXYbkjrxxVdPaaiawdksgA8pF332p
	 C3/M764DeTH34QjKvLOSZkIJylHi1xiqwEqeyOnr6KJTP3gVVqfI4pnPHK5ZuIFK6jDwa
	 HpwzMK9T4GFh52KudnKIp7z4CLaYOH1wafaTtlQ0ByMRNEop/59mIv1ncotIoZ0Iaonw5
	 4QM7WHJE3acWoHEDuCAEkSKkZrIP0fyZowKTt18QgN7rmlUAdPnvy9Ao9GTNIlzH7CsmQ
	 Z3hudx/I5AK8JchBhkDR7Aa5w1wne0hFBQNkGxA/O0F4d27LY7uYLHaA7iGBtfnWJaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006176;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type;
	bh=ZYKCe6tYvV59mJ9uXVzTt1y6d+rD/egvFF111uZcSdk=;
	b=4GbgKuhyEvIcfXDnVFUWKnW2gWwnVnGVXOL1WPYyCEnRftJpPkbRDvTscJ25FtOCGr4u
	 rX/jf5H1IT9vMMpN1M8QWxho67bIGI2ImwyXu7Hu8Q92lobKoHAvmJhGiFWVS65qEjaxE
	 PInzK77H9P1HJJ3i2EYOybis4p60/ferzSgGXU3hAsj8+MlTm4nubocuWgs0pBIALFk4u
	 ZtphmAwqTbim9BJAwNvBp44tDp1++LF/tkd9rtgPRIF8nmXvagRCcjHdBrMfJlJ5hojNL
	 2Z4JQIqrIZVa62dGZKkd1/VswhStNdaiXweE6b6XXtRvLbCYuq68alW+ULtEnMdlJLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031D2606A31D;
	Mon, 26 Oct 2026 09:16:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 031D2606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Eduard Zateev <hackerowskiy@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: make sure we stop the wmi tasklet on init
 fail
In-Reply-To: <179297981008.47871.8854747166395230996@gmail.com>
References: <20261021120237.481898-1-toke@toke.dk>
 <179297981008.47871.8854747166395230996@gmail.com>
Date: Mon, 26 Oct 2026 10:16:06 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h5i8q0tl.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Eduard Zateev <hackerowskiy@gmail.com> writes:

> Hi Toke,
>
> I tested this patch with the syzbot C reproducer and KASAN on a 7.3.0
> kernel built from upstream commit 21a7f44fd.
>
> On the baseline kernel, the reproducer hit the reported
> slab-use-after-free in tasklet_action_common during ath9k_htc probe
> failure. With this patch, the same failure path completed without a
> KASAN report. Both kernels were run in QEMU with the syzbot config and
> ath9k firmware extracted from the syzbot rootfs.
>
> Tested-by: Eduard Zateev <hackerowskiy@gmail.com>

Great, thanks for testing! :)

-Toke
